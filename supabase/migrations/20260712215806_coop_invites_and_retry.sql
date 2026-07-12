alter table public.coop_rooms
  add column if not exists attempt_number integer not null default 1
  check (attempt_number > 0);

alter table public.coop_runs
  add column if not exists attempt_number integer not null default 1
  check (attempt_number > 0);

alter table public.coop_runs drop constraint if exists coop_runs_room_id_key;
create unique index if not exists coop_runs_room_attempt_key
  on public.coop_runs(room_id, attempt_number);

create table if not exists public.coop_invites (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.coop_rooms(id) on delete cascade,
  inviter_id uuid not null references public.profiles(id) on delete cascade,
  invitee_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending'
    check (status in ('pending', 'accepted', 'declined', 'cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  expires_at timestamptz not null default (now() + interval '2 hours'),
  check (inviter_id <> invitee_id),
  unique (room_id, invitee_id)
);

create index if not exists coop_invites_invitee_pending_idx
  on public.coop_invites(invitee_id, created_at desc)
  where status = 'pending';
create index if not exists coop_invites_inviter_idx
  on public.coop_invites(inviter_id, created_at desc);

alter table public.coop_invites enable row level security;

drop policy if exists "players read their coop invites" on public.coop_invites;
create policy "players read their coop invites" on public.coop_invites
for select to authenticated using (
  (select auth.uid()) in (inviter_id, invitee_id)
);

grant select on public.coop_invites to authenticated;

create or replace function public.invite_friend_to_coop(
  p_friend_code text,
  p_side text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  friend_id uuid;
  new_room_id uuid;
  candidate text;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_side not in ('left', 'right') then raise exception 'Invalid side'; end if;

  select id into friend_id
  from public.profiles
  where player_code = upper(trim(p_friend_code)) and id <> player_id;

  if friend_id is null or not exists (
    select 1 from public.friendships
    where status = 'accepted'
      and ((requester_id = player_id and addressee_id = friend_id)
        or (requester_id = friend_id and addressee_id = player_id))
  ) then
    raise exception 'Only accepted friends can be invited';
  end if;

  update public.coop_rooms
  set status = 'ended', ended_at = now()
  where host_id = player_id and status = 'waiting';

  update public.coop_invites
  set status = 'cancelled', updated_at = now()
  where inviter_id = player_id and status = 'pending';

  loop
    candidate := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (
      select 1 from public.coop_rooms
      where room_code = candidate and expires_at > now()
    );
  end loop;

  insert into public.coop_rooms(room_code, host_id, host_side, seed)
  values (candidate, player_id, p_side, floor(random() * 2147483646)::integer)
  returning id into new_room_id;

  insert into public.coop_room_members(room_id, user_id, side)
  values (new_room_id, player_id, p_side);

  insert into public.coop_invites(room_id, inviter_id, invitee_id)
  values (new_room_id, player_id, friend_id);

  return public.get_coop_room_state(new_room_id);
end;
$$;

create or replace function public.respond_coop_invite(
  p_invite_id uuid,
  p_accept boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  invitation public.coop_invites%rowtype;
  target public.coop_rooms%rowtype;
  guest_side text;
begin
  if player_id is null then raise exception 'Authentication required'; end if;

  select * into invitation from public.coop_invites
  where id = p_invite_id and invitee_id = player_id and status = 'pending'
  for update;

  if invitation.id is null then raise exception 'Invitation not found'; end if;

  if not p_accept then
    update public.coop_invites set status = 'declined', updated_at = now()
    where id = invitation.id;
    return null;
  end if;

  select * into target from public.coop_rooms
  where id = invitation.room_id and status = 'waiting' and expires_at > now()
  for update;

  if target.id is null then
    update public.coop_invites set status = 'cancelled', updated_at = now()
    where id = invitation.id;
    raise exception 'This invitation has expired';
  end if;

  if (select count(*) from public.coop_room_members where room_id = target.id) >= 2 then
    raise exception 'Room is full';
  end if;

  guest_side := case target.host_side when 'left' then 'right' else 'left' end;
  insert into public.coop_room_members(room_id, user_id, side)
  values (target.id, player_id, guest_side)
  on conflict (room_id, user_id) do nothing;

  update public.coop_invites set status = 'accepted', updated_at = now()
  where id = invitation.id;
  update public.coop_invites set status = 'cancelled', updated_at = now()
  where invitee_id = player_id and id <> invitation.id and status = 'pending';

  return public.get_coop_room_state(target.id);
end;
$$;

create or replace function public.retry_coop_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = auth.uid()
  ) then raise exception 'Room access denied'; end if;

  update public.coop_rooms
  set status = 'playing',
      status_before_vote = null,
      leave_requested_by = null,
      score = 0,
      seed = floor(random() * 2147483646)::integer,
      attempt_number = attempt_number + 1,
      started_at = now(),
      ended_at = null,
      expires_at = now() + interval '2 hours'
  where id = p_room_id and status = 'ended';

  if not found then raise exception 'The room is not ready to retry'; end if;
  update public.coop_room_members set ready = true where room_id = p_room_id;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.complete_coop_run(
  p_room_id uuid,
  p_score integer,
  p_coins integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  member record;
  new_balance bigint;
  run_id uuid;
  current_attempt integer;
begin
  if p_score < 0 or p_coins < 0 then raise exception 'Invalid co-op result'; end if;
  select attempt_number into current_attempt from public.coop_rooms
  where id = p_room_id and host_id = auth.uid();
  if current_attempt is null then raise exception 'Only the host can complete the run'; end if;

  insert into public.coop_runs(room_id, attempt_number, score, coins)
  values (p_room_id, current_attempt, p_score, p_coins)
  on conflict (room_id, attempt_number) do nothing
  returning id into run_id;

  if run_id is not null then
    update public.coop_rooms
    set status = 'ended', score = p_score, ended_at = now()
    where id = p_room_id;
    for member in select user_id from public.coop_room_members where room_id = p_room_id loop
      update public.player_progress
      set infinity_high_score = greatest(infinity_high_score, p_score),
          total_points = total_points + p_score,
          updated_at = now()
      where user_id = member.user_id;
      update public.player_wallets
      set coins = coins + p_coins, updated_at = now()
      where user_id = member.user_id returning coins into new_balance;
      if p_coins > 0 then
        insert into public.wallet_transactions(
          user_id, currency, amount, balance_after, reason, reference_id
        ) values (
          member.user_id, 'coins', p_coins, new_balance,
          'coop_infinity_run',
          'coop:' || p_room_id::text || ':' || current_attempt::text
        );
      end if;
    end loop;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.list_my_friends()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
begin
  return jsonb_build_object(
    'requests', coalesce((
      select jsonb_agg(jsonb_build_object(
        'request_id', f.id,
        'display_name', p.display_name,
        'player_code', p.player_code
      ) order by f.created_at desc)
      from public.friendships f
      join public.profiles p on p.id = f.requester_id
      where f.addressee_id = auth.uid() and f.status = 'pending'
    ), '[]'::jsonb),
    'friends', coalesce((
      select jsonb_agg(jsonb_build_object(
        'user_id', p.id,
        'display_name', p.display_name,
        'player_code', p.player_code
      ) order by p.display_name)
      from public.friendships f
      join public.profiles p
        on p.id = case when f.requester_id = auth.uid()
          then f.addressee_id else f.requester_id end
      where auth.uid() in (f.requester_id, f.addressee_id)
        and f.status = 'accepted'
    ), '[]'::jsonb),
    'invites', coalesce((
      select jsonb_agg(jsonb_build_object(
        'invite_id', i.id,
        'room_id', i.room_id,
        'display_name', p.display_name,
        'player_code', p.player_code,
        'side', r.host_side,
        'expires_at', i.expires_at
      ) order by i.created_at desc)
      from public.coop_invites i
      join public.profiles p on p.id = i.inviter_id
      join public.coop_rooms r on r.id = i.room_id
      where i.invitee_id = auth.uid()
        and i.status = 'pending'
        and i.expires_at > now()
        and r.status = 'waiting'
    ), '[]'::jsonb)
  );
end;
$$;

revoke all on function public.invite_friend_to_coop(text, text) from public, anon;
revoke all on function public.respond_coop_invite(uuid, boolean) from public, anon;
revoke all on function public.retry_coop_room(uuid) from public, anon;
grant execute on function public.invite_friend_to_coop(text, text) to authenticated;
grant execute on function public.respond_coop_invite(uuid, boolean) to authenticated;
grant execute on function public.retry_coop_room(uuid) to authenticated;
