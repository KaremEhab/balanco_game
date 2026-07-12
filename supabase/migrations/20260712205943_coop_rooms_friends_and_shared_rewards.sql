alter table public.profiles add column if not exists player_code text;
create unique index if not exists profiles_player_code_key
  on public.profiles (player_code) where player_code is not null;

create or replace function public.make_player_code(p_name text, p_age smallint, p_id uuid)
returns text
language sql
volatile
set search_path = ''
as $$
  select upper(substr(regexp_replace(coalesce(p_name, 'PX'), '[^A-Za-z]', '', 'g') || 'PX', 1, 2))
    || p_age::text || '-'
    || upper(substr(md5(random()::text || p_id::text || clock_timestamp()::text), 1, 5));
$$;

create or replace function public.assign_player_code()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare candidate text;
begin
  if new.player_code is not null then return new; end if;
  loop
    candidate := public.make_player_code(new.display_name, new.age, new.id);
    exit when not exists (select 1 from public.profiles where player_code = candidate);
  end loop;
  new.player_code := candidate;
  return new;
end;
$$;

drop trigger if exists assign_player_code_before_insert on public.profiles;
create trigger assign_player_code_before_insert
  before insert on public.profiles
  for each row execute function public.assign_player_code();

do $$
declare player public.profiles%rowtype; candidate text;
begin
  for player in select * from public.profiles where player_code is null loop
    loop
      candidate := public.make_player_code(player.display_name, player.age, player.id);
      exit when not exists (select 1 from public.profiles where player_code = candidate);
    end loop;
    update public.profiles set player_code = candidate where id = player.id;
  end loop;
end $$;

alter table public.profiles alter column player_code set not null;

create table public.coop_rooms (
  id uuid primary key default gen_random_uuid(),
  room_code text not null unique check (room_code ~ '^[A-Z0-9]{6}$'),
  host_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'waiting'
    check (status in ('waiting', 'playing', 'paused', 'leave_vote', 'ended')),
  status_before_vote text check (status_before_vote in ('playing', 'paused')),
  host_side text not null check (host_side in ('left', 'right')),
  seed integer not null,
  score integer not null default 0 check (score >= 0),
  leave_requested_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  started_at timestamptz,
  ended_at timestamptz,
  expires_at timestamptz not null default (now() + interval '2 hours')
);

create table public.coop_room_members (
  room_id uuid not null references public.coop_rooms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  side text not null check (side in ('left', 'right')),
  ready boolean not null default false,
  mic_muted boolean not null default false,
  joined_at timestamptz not null default now(),
  primary key (room_id, user_id),
  constraint coop_room_members_room_side_key
    unique (room_id, side) deferrable initially deferred
);

create table public.coop_runs (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null unique references public.coop_rooms(id) on delete cascade,
  score integer not null check (score >= 0),
  coins integer not null check (coins >= 0),
  completed_at timestamptz not null default now()
);

create table public.friendships (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references public.profiles(id) on delete cascade,
  addressee_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'accepted', 'declined')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (requester_id <> addressee_id),
  unique (requester_id, addressee_id)
);

create index coop_rooms_host_status_idx on public.coop_rooms(host_id, status);
create index coop_room_members_user_idx on public.coop_room_members(user_id, room_id);
create index friendships_addressee_status_idx on public.friendships(addressee_id, status);

alter table public.coop_rooms enable row level security;
alter table public.coop_room_members enable row level security;
alter table public.coop_runs enable row level security;
alter table public.friendships enable row level security;

create or replace function public.is_coop_member(p_room_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = auth.uid()
  );
$$;
revoke all on function public.is_coop_member(uuid) from public, anon, authenticated;
grant execute on function public.is_coop_member(uuid) to authenticated;

create policy "members read their coop rooms" on public.coop_rooms
for select to authenticated using (public.is_coop_member(id));
create policy "members read room roster" on public.coop_room_members
for select to authenticated using (public.is_coop_member(room_id));
create policy "members read coop results" on public.coop_runs
for select to authenticated using (public.is_coop_member(room_id));
create policy "players read their friendships" on public.friendships
for select to authenticated using (
  (select auth.uid()) in (requester_id, addressee_id)
);

grant select on public.coop_rooms, public.coop_room_members, public.coop_runs, public.friendships to authenticated;

create policy "coop members receive realtime" on realtime.messages
for select to authenticated using (
  realtime.messages.extension in ('broadcast', 'presence')
  and public.is_coop_member(replace((select realtime.topic()), 'coop:', '')::uuid)
);
create policy "coop members send realtime" on realtime.messages
for insert to authenticated with check (
  realtime.messages.extension in ('broadcast', 'presence')
  and public.is_coop_member(replace((select realtime.topic()), 'coop:', '')::uuid)
);

create or replace function public.get_coop_room_state(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare player_id uuid := auth.uid(); result jsonb;
begin
  if player_id is null or not exists (
    select 1 from public.coop_room_members where room_id = p_room_id and user_id = player_id
  ) then raise exception 'Room access denied'; end if;

  select jsonb_build_object(
    'room', to_jsonb(r),
    'members', coalesce((select jsonb_agg(jsonb_build_object(
      'user_id', m.user_id,
      'side', m.side,
      'ready', m.ready,
      'mic_muted', m.mic_muted,
      'display_name', p.display_name,
      'player_code', p.player_code,
      'is_host', m.user_id = r.host_id
    ) order by m.side) from public.coop_room_members m
      join public.profiles p on p.id = m.user_id where m.room_id = r.id), '[]'::jsonb)
  ) into result from public.coop_rooms r where r.id = p_room_id;
  return result;
end;
$$;

create or replace function public.create_coop_room(p_side text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare player_id uuid := auth.uid(); new_room_id uuid; candidate text;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_side not in ('left', 'right') then raise exception 'Invalid side'; end if;
  update public.coop_rooms set status = 'ended', ended_at = now()
    where host_id = player_id and status = 'waiting';
  loop
    candidate := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (select 1 from public.coop_rooms where room_code = candidate and expires_at > now());
  end loop;
  insert into public.coop_rooms(room_code, host_id, host_side, seed)
  values (candidate, player_id, p_side, floor(random() * 2147483646)::integer)
  returning id into new_room_id;
  insert into public.coop_room_members(room_id, user_id, side)
  values (new_room_id, player_id, p_side);
  return public.get_coop_room_state(new_room_id);
end;
$$;

create or replace function public.join_coop_room(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare player_id uuid := auth.uid(); target public.coop_rooms%rowtype; guest_side text;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into target from public.coop_rooms
    where room_code = upper(trim(p_code)) and status = 'waiting' and expires_at > now()
    for update;
  if target.id is null then raise exception 'Room not found or expired'; end if;
  if target.host_id = player_id then return public.get_coop_room_state(target.id); end if;
  if (select count(*) from public.coop_room_members where room_id = target.id) >= 2 then
    raise exception 'Room is full';
  end if;
  guest_side := case target.host_side when 'left' then 'right' else 'left' end;
  insert into public.coop_room_members(room_id, user_id, side)
  values (target.id, player_id, guest_side)
  on conflict (room_id, user_id) do nothing;
  return public.get_coop_room_state(target.id);
end;
$$;

create or replace function public.set_coop_ready(p_room_id uuid, p_ready boolean)
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  update public.coop_room_members set ready = p_ready
    where room_id = p_room_id and user_id = auth.uid();
  if not found then raise exception 'Room access denied'; end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.swap_coop_sides(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.coop_rooms where id = p_room_id and host_id = auth.uid() and status = 'waiting')
    then raise exception 'Only the host can swap sides while waiting'; end if;
  update public.coop_room_members set
    side = case side when 'left' then 'right' else 'left' end,
    ready = false
  where room_id = p_room_id;
  update public.coop_rooms set host_side = case host_side when 'left' then 'right' else 'left' end
    where id = p_room_id;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.start_coop_room(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.coop_rooms where id = p_room_id and host_id = auth.uid() and status = 'waiting')
    then raise exception 'Only the host can start'; end if;
  if (select count(*) from public.coop_room_members where room_id = p_room_id) <> 2
    or exists (select 1 from public.coop_room_members where room_id = p_room_id and not ready)
    then raise exception 'Both players must be present and ready'; end if;
  update public.coop_rooms set status = 'playing', started_at = now() where id = p_room_id;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.set_coop_pause(p_room_id uuid, p_paused boolean)
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.coop_room_members where room_id = p_room_id and user_id = auth.uid())
    then raise exception 'Room access denied'; end if;
  update public.coop_rooms set status = case when p_paused then 'paused' else 'playing' end
    where id = p_room_id and status in ('playing', 'paused');
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.vote_coop_leave(p_room_id uuid, p_approve boolean)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare player_id uuid := auth.uid(); room public.coop_rooms%rowtype;
begin
  if not exists (select 1 from public.coop_room_members where room_id = p_room_id and user_id = player_id)
    then raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.status in ('playing', 'paused') then
    update public.coop_rooms set status_before_vote = room.status, status = 'leave_vote', leave_requested_by = player_id
      where id = p_room_id;
  elsif room.status = 'leave_vote' and room.leave_requested_by <> player_id then
    if p_approve then
      update public.coop_rooms set status = 'ended', ended_at = now() where id = p_room_id;
    else
      update public.coop_rooms set status = coalesce(status_before_vote, 'playing'),
        status_before_vote = null, leave_requested_by = null where id = p_room_id;
    end if;
  end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.complete_coop_run(p_room_id uuid, p_score integer, p_coins integer)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare member record; new_balance bigint; run_id uuid;
begin
  if p_score < 0 or p_coins < 0 then raise exception 'Invalid co-op result'; end if;
  if not exists (select 1 from public.coop_rooms where id = p_room_id and host_id = auth.uid())
    then raise exception 'Only the host can complete the run'; end if;
  insert into public.coop_runs(room_id, score, coins) values (p_room_id, p_score, p_coins)
    on conflict (room_id) do nothing returning id into run_id;
  if run_id is not null then
    update public.coop_rooms set status = 'ended', score = p_score, ended_at = now() where id = p_room_id;
    for member in select user_id from public.coop_room_members where room_id = p_room_id loop
      update public.player_progress set infinity_high_score = greatest(infinity_high_score, p_score),
        total_points = total_points + p_score, updated_at = now() where user_id = member.user_id;
      update public.player_wallets set coins = coins + p_coins, updated_at = now()
        where user_id = member.user_id returning coins into new_balance;
      if p_coins > 0 then
        insert into public.wallet_transactions(user_id, currency, amount, balance_after, reason, reference_id)
        values(member.user_id, 'coins', p_coins, new_balance, 'coop_infinity_run', 'coop:' || p_room_id::text);
      end if;
    end loop;
  end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.find_player_by_code(p_code text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare result jsonb;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select jsonb_build_object('id', id, 'display_name', display_name, 'player_code', player_code)
    into result from public.profiles where player_code = upper(trim(p_code)) and id <> auth.uid();
  return result;
end; $$;

create or replace function public.send_friend_request(p_player_code text)
returns void language plpgsql security definer set search_path = '' as $$
declare target_id uuid;
begin
  select id into target_id from public.profiles where player_code = upper(trim(p_player_code));
  if target_id is null or target_id = auth.uid() then raise exception 'Player not found'; end if;
  if exists (select 1 from public.friendships where requester_id = target_id and addressee_id = auth.uid()) then
    update public.friendships set status = 'accepted', updated_at = now()
      where requester_id = target_id and addressee_id = auth.uid();
  else
    insert into public.friendships(requester_id, addressee_id)
      values(auth.uid(), target_id)
      on conflict (requester_id, addressee_id) do update set status = 'pending', updated_at = now();
  end if;
end; $$;

create or replace function public.respond_friend_request(p_request_id uuid, p_accept boolean)
returns void language plpgsql security definer set search_path = '' as $$
begin
  update public.friendships set status = case when p_accept then 'accepted' else 'declined' end,
    updated_at = now() where id = p_request_id and addressee_id = auth.uid() and status = 'pending';
  if not found then raise exception 'Friend request not found'; end if;
end; $$;

create or replace function public.list_my_friends()
returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  return jsonb_build_object(
    'requests', coalesce((select jsonb_agg(jsonb_build_object('request_id', f.id, 'display_name', p.display_name, 'player_code', p.player_code))
      from public.friendships f join public.profiles p on p.id = f.requester_id
      where f.addressee_id = auth.uid() and f.status = 'pending'), '[]'::jsonb),
    'friends', coalesce((select jsonb_agg(jsonb_build_object('display_name', p.display_name, 'player_code', p.player_code))
      from public.friendships f join public.profiles p on p.id = case when f.requester_id = auth.uid() then f.addressee_id else f.requester_id end
      where auth.uid() in (f.requester_id, f.addressee_id) and f.status = 'accepted'), '[]'::jsonb)
  );
end; $$;

revoke all on function public.make_player_code(text, smallint, uuid) from public, anon, authenticated;
revoke all on function public.assign_player_code() from public, anon, authenticated;
revoke all on function public.get_coop_room_state(uuid) from public, anon;
revoke all on function public.create_coop_room(text) from public, anon;
revoke all on function public.join_coop_room(text) from public, anon;
revoke all on function public.set_coop_ready(uuid, boolean) from public, anon;
revoke all on function public.swap_coop_sides(uuid) from public, anon;
revoke all on function public.start_coop_room(uuid) from public, anon;
revoke all on function public.set_coop_pause(uuid, boolean) from public, anon;
revoke all on function public.vote_coop_leave(uuid, boolean) from public, anon;
revoke all on function public.complete_coop_run(uuid, integer, integer) from public, anon;
revoke all on function public.find_player_by_code(text) from public, anon;
revoke all on function public.send_friend_request(text) from public, anon;
revoke all on function public.respond_friend_request(uuid, boolean) from public, anon;
revoke all on function public.list_my_friends() from public, anon;

grant execute on function public.get_coop_room_state(uuid), public.create_coop_room(text),
  public.join_coop_room(text), public.set_coop_ready(uuid, boolean), public.swap_coop_sides(uuid),
  public.start_coop_room(uuid), public.set_coop_pause(uuid, boolean), public.vote_coop_leave(uuid, boolean),
  public.complete_coop_run(uuid, integer, integer), public.find_player_by_code(text),
  public.send_friend_request(text), public.respond_friend_request(uuid, boolean), public.list_my_friends()
to authenticated;
