-- Race rooms can contain 2-4 players. Co-op rooms remain exactly two-player.
alter table public.coop_rooms
  add column if not exists max_players integer not null default 2
  check (max_players between 2 and 4);

alter table public.coop_room_members
  add column if not exists session_wins integer not null default 0
    check (session_wins >= 0),
  add column if not exists eliminated_at timestamptz;

alter table public.coop_room_members
  drop constraint if exists coop_room_members_room_side_key;
alter table public.coop_room_members
  drop constraint if exists coop_room_members_side_check;
alter table public.coop_room_members
  add constraint coop_room_members_side_check
  check (side in ('left', 'right', 'slot1', 'slot2', 'slot3', 'slot4'));
create unique index if not exists coop_room_members_room_side_key
  on public.coop_room_members(room_id, side);

create table if not exists public.coop_room_action_votes (
  room_id uuid not null references public.coop_rooms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  action text not null check (action in ('leave', 'postgame_exit', 'retry', 'continue')),
  created_at timestamptz not null default now(),
  primary key (room_id, user_id, attempt_number, action)
);
alter table public.coop_room_action_votes enable row level security;

create or replace function public.get_coop_room_state(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  result jsonb;
begin
  if player_id is null or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  select jsonb_build_object(
    'room', to_jsonb(r) || jsonb_build_object(
      'restart_vote_count', (
        select count(*) from public.coop_room_action_votes v
        where v.room_id = r.id
          and v.attempt_number = r.attempt_number
          and v.action = r.race_restart_kind
      ),
      'leave_vote_count', (
        select count(*) from public.coop_room_action_votes v
        where v.room_id = r.id
          and v.attempt_number = r.attempt_number
          and v.action in ('leave', 'postgame_exit')
      )
    ),
    'members', coalesce((
      select jsonb_agg(jsonb_build_object(
        'user_id', m.user_id,
        'side', m.side,
        'ready', m.ready,
        'mic_muted', m.mic_muted,
        'display_name', p.display_name,
        'player_code', p.player_code,
        'avatar_url', p.avatar_url,
        'avatar_shape', coalesce(p.avatar_shape, 'circle'),
        'race_wins', coalesce(pp.race_wins, 0),
        'session_wins', m.session_wins,
        'eliminated_at', m.eliminated_at,
        'is_host', m.user_id = r.host_id
      ) order by case m.side
        when 'left' then 1 when 'slot1' then 1
        when 'right' then 2 when 'slot2' then 2
        when 'slot3' then 3 else 4 end)
      from public.coop_room_members m
      join public.profiles p on p.id = m.user_id
      left join public.player_progress pp on pp.user_id = m.user_id
      where m.room_id = r.id
    ), '[]'::jsonb)
  ) into result
  from public.coop_rooms r
  where r.id = p_room_id;

  return result;
end;
$$;

drop function if exists public.create_race_room();
create or replace function public.create_race_room(p_max_players integer default 2)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  new_room_id uuid;
  candidate text;
  level_version integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_max_players not between 2 and 4 then
    raise exception 'Race rooms support 2 to 4 players';
  end if;

  update public.coop_rooms
  set status = 'ended', end_reason = 'leave', ended_at = now()
  where host_id = player_id and status = 'waiting';

  loop
    candidate := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (
      select 1 from public.coop_rooms
      where room_code = candidate and expires_at > now()
    );
  end loop;

  select published_version into level_version
  from public.game_levels where level_id = 1;

  insert into public.coop_rooms(
    room_code, host_id, host_side, seed, mode, race_level,
    race_level_version, max_players
  ) values (
    candidate, player_id, 'left', floor(random() * 2147483646)::integer,
    'race', 1, level_version, p_max_players
  ) returning id into new_room_id;

  insert into public.coop_room_members(room_id, user_id, side)
  values (new_room_id, player_id, 'slot1');

  return public.get_coop_room_state(new_room_id);
end;
$$;

create or replace function public.join_race_room(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  target public.coop_rooms%rowtype;
  assigned_slot text;
begin
  if player_id is null then raise exception 'Authentication required'; end if;

  select * into target from public.coop_rooms
  where room_code = upper(trim(p_code))
    and mode = 'race' and status = 'waiting' and expires_at > now()
  for update;
  if target.id is null then raise exception 'Race room not found or expired'; end if;
  if exists (
    select 1 from public.coop_room_members
    where room_id = target.id and user_id = player_id
  ) then return public.get_coop_room_state(target.id); end if;
  if (select count(*) from public.coop_room_members where room_id = target.id)
      >= target.max_players then
    raise exception 'Race room is full';
  end if;

  select slot into assigned_slot
  from unnest(array['slot1','slot2','slot3','slot4']) with ordinality s(slot, n)
  where n <= target.max_players
    and not exists (
      select 1 from public.coop_room_members m
      where m.room_id = target.id and m.side = slot
    )
  order by n limit 1;

  insert into public.coop_room_members(room_id, user_id, side)
  values (target.id, player_id, assigned_slot)
  on conflict (room_id, user_id) do nothing;
  return public.get_coop_room_state(target.id);
end;
$$;

create or replace function public.start_coop_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  target public.coop_rooms%rowtype;
  member_count integer;
begin
  select * into target from public.coop_rooms
  where id = p_room_id for update;
  if target.id is null or target.host_id <> auth.uid() or target.status <> 'waiting' then
    raise exception 'Only the host can start';
  end if;
  select count(*) into member_count
  from public.coop_room_members where room_id = p_room_id;
  if (target.mode = 'coop' and member_count <> 2)
      or (target.mode = 'race' and member_count <> target.max_players)
      or exists (
        select 1 from public.coop_room_members
        where room_id = p_room_id and not ready
      ) then
    raise exception 'Every selected player must be present and ready';
  end if;
  update public.coop_rooms
  set status = 'playing', started_at = clock_timestamp()
  where id = p_room_id;
  update public.coop_room_members
  set last_seen_at = clock_timestamp(), eliminated_at = null
  where room_id = p_room_id;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.invite_friend_to_game(
  p_friend_code text,
  p_mode text,
  p_max_players integer default 2,
  p_room_id uuid default null,
  p_side text default 'left'
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  friend_id uuid;
  room_state jsonb;
  target_id uuid;
  target public.coop_rooms%rowtype;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_mode not in ('coop', 'race') then raise exception 'Invalid game mode'; end if;
  if p_mode = 'coop' then p_max_players := 2; end if;
  if p_max_players not between 2 and 4 then raise exception 'Invalid room size'; end if;

  select id into friend_id from public.profiles
  where player_code = upper(trim(p_friend_code)) and id <> player_id;
  if friend_id is null then raise exception 'Player not found'; end if;

  if p_room_id is null then
    if p_mode = 'race' then
      room_state := public.create_race_room(p_max_players);
    else
      room_state := public.create_coop_room(p_side);
    end if;
    target_id := (room_state -> 'room' ->> 'id')::uuid;
  else
    select * into target from public.coop_rooms where id = p_room_id for update;
    if target.id is null or target.host_id <> player_id
        or target.status <> 'waiting' or target.mode <> p_mode then
      raise exception 'Only the waiting room host can invite players';
    end if;
    if (select count(*) from public.coop_room_members where room_id = target.id)
        >= target.max_players then raise exception 'Room is full'; end if;
    target_id := target.id;
  end if;

  insert into public.coop_invites(room_id, inviter_id, invitee_id)
  values (target_id, player_id, friend_id)
  on conflict (room_id, invitee_id) do update
  set status = 'pending', inviter_id = excluded.inviter_id,
      updated_at = now(), expires_at = now() + interval '2 hours';

  return public.get_coop_room_state(target_id);
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
  assigned_side text;
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
  if target.id is null then raise exception 'This invitation has expired'; end if;
  if (select count(*) from public.coop_room_members where room_id = target.id)
      >= target.max_players then raise exception 'Room is full'; end if;

  if target.mode = 'coop' then
    assigned_side := case target.host_side when 'left' then 'right' else 'left' end;
  else
    select slot into assigned_side
    from unnest(array['slot1','slot2','slot3','slot4']) with ordinality s(slot, n)
    where n <= target.max_players and not exists (
      select 1 from public.coop_room_members m
      where m.room_id = target.id and m.side = slot
    ) order by n limit 1;
  end if;

  insert into public.coop_room_members(room_id, user_id, side)
  values (target.id, player_id, assigned_side)
  on conflict (room_id, user_id) do nothing;
  update public.coop_invites set status = 'accepted', updated_at = now()
  where id = invitation.id;
  update public.coop_invites set status = 'cancelled', updated_at = now()
  where invitee_id = player_id and id <> invitation.id and status = 'pending';
  return public.get_coop_room_state(target.id);
end;
$$;

create or replace function public.list_my_friends()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  pending_requests jsonb;
begin
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id,
    'request_id', f.id,
    'receiver_id', f.addressee_id,
    'sender', jsonb_build_object(
      'id', p.id, 'display_name', p.display_name, 'player_code', p.player_code
    )
  ) order by f.created_at desc), '[]'::jsonb)
  into pending_requests
  from public.friendships f
  join public.profiles p on p.id = f.requester_id
  where f.addressee_id = auth.uid() and f.status = 'pending';

  return jsonb_build_object(
    'profile', (
      select jsonb_build_object(
        'id', p.id, 'display_name', p.display_name,
        'player_code', p.player_code, 'avatar_url', p.avatar_url,
        'avatar_shape', coalesce(p.avatar_shape, 'circle')
      ) from public.profiles p where p.id = auth.uid()
    ),
    'friend_requests', pending_requests,
    'requests', pending_requests,
    'friends', coalesce((
      select jsonb_agg(jsonb_build_object(
        'user_id', p.id, 'display_name', p.display_name,
        'player_code', p.player_code, 'avatar_url', p.avatar_url,
        'avatar_shape', coalesce(p.avatar_shape, 'circle')
      ) order by p.display_name)
      from public.friendships f
      join public.profiles p on p.id = case when f.requester_id = auth.uid()
        then f.addressee_id else f.requester_id end
      where auth.uid() in (f.requester_id, f.addressee_id)
        and f.status = 'accepted'
    ), '[]'::jsonb),
    'invites', coalesce((
      select jsonb_agg(jsonb_build_object(
        'invite_id', i.id, 'room_id', i.room_id,
        'display_name', p.display_name, 'player_code', p.player_code,
        'mode', r.mode, 'max_players', r.max_players,
        'side', r.host_side, 'expires_at', i.expires_at
      ) order by i.created_at desc)
      from public.coop_invites i
      join public.profiles p on p.id = i.inviter_id
      join public.coop_rooms r on r.id = i.room_id
      where i.invitee_id = auth.uid() and i.status = 'pending'
        and i.expires_at > now() and r.status = 'waiting'
    ), '[]'::jsonb),
    'recent_players', coalesce((
      select jsonb_agg(to_jsonb(recent) order by recent.played_at desc)
      from (
        select distinct on (other.user_id)
          other.user_id,
          p.display_name,
          p.player_code,
          p.avatar_url,
          coalesce(p.avatar_shape, 'circle') as avatar_shape,
          coalesce(room.ended_at, room.started_at, room.created_at) as played_at
        from public.coop_room_members mine
        join public.coop_rooms room on room.id = mine.room_id
        join public.coop_room_members other
          on other.room_id = mine.room_id and other.user_id <> mine.user_id
        join public.profiles p on p.id = other.user_id
        where mine.user_id = auth.uid() and room.started_at is not null
        order by other.user_id,
          coalesce(room.ended_at, room.started_at, room.created_at) desc
        limit 12
      ) recent
    ), '[]'::jsonb)
  );
end;
$$;

create or replace function public.finish_race(
  p_room_id uuid,
  p_progress double precision,
  p_hearts integer,
  p_stars integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  elapsed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_progress < 0.98 or p_progress > 1.001 then
    raise exception 'Finish position is not valid';
  end if;
  if p_hearts < 0 or p_hearts > 20 or p_stars < 0 or p_stars > 100 then
    raise exception 'Race result is not valid';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id and eliminated_at is null
  ) then raise exception 'Room access denied'; end if;

  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.mode <> 'race' then raise exception 'This is not a race room'; end if;
  if room.status = 'playing' and room.winner_id is null then
    elapsed := greatest(0, floor(extract(epoch from (
      clock_timestamp() - room.started_at - interval '4 seconds'
    )) * 1000)::integer);
    update public.coop_rooms set
      status = 'ended', end_reason = 'completed', ended_at = clock_timestamp(),
      winner_id = player_id, winner_finished_at = clock_timestamp(),
      winner_elapsed_ms = elapsed, winner_hearts = p_hearts,
      winner_stars = p_stars, race_end_kind = 'finish'
    where id = p_room_id;
    update public.coop_room_members
    set session_wins = session_wins + 1
    where room_id = p_room_id and user_id = player_id;

    insert into public.player_race_level_wins(
      user_id, level_id, first_won_at, best_time_ms, best_hearts, best_stars
    ) values (player_id, room.race_level, now(), elapsed, p_hearts, p_stars)
    on conflict (user_id, level_id) do update set
      best_time_ms = case
        when public.player_race_level_wins.best_time_ms is null then excluded.best_time_ms
        else least(public.player_race_level_wins.best_time_ms, excluded.best_time_ms) end,
      best_hearts = greatest(public.player_race_level_wins.best_hearts, excluded.best_hearts),
      best_stars = greatest(public.player_race_level_wins.best_stars, excluded.best_stars);
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.vote_race_restart(p_room_id uuid, p_kind text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  next_level integer;
  next_version integer;
  vote_count integer;
  member_count integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_kind not in ('retry', 'continue') then raise exception 'Invalid race restart choice'; end if;
  if not exists (select 1 from public.coop_room_members
      where room_id = p_room_id and user_id = player_id) then
    raise exception 'Room access denied';
  end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.id is null or room.mode <> 'race' or not (
    (room.status = 'ended' and room.end_reason = 'completed')
    or (room.status = 'paused' and p_kind = 'retry')
  ) then raise exception 'The race is not ready to restart'; end if;

  delete from public.coop_room_action_votes
  where room_id = p_room_id and user_id = player_id
    and attempt_number = room.attempt_number and action in ('retry', 'continue');
  insert into public.coop_room_action_votes(room_id, user_id, attempt_number, action)
  values (p_room_id, player_id, room.attempt_number, p_kind);
  update public.coop_rooms set
    rematch_requested_by = coalesce(rematch_requested_by, player_id),
    race_restart_kind = p_kind
  where id = p_room_id;

  select count(*) into vote_count from public.coop_room_action_votes
  where room_id = p_room_id and attempt_number = room.attempt_number
    and action = p_kind;
  select count(*) into member_count from public.coop_room_members
  where room_id = p_room_id;

  if vote_count = member_count then
    next_level := case when p_kind = 'continue'
      then least(room.race_level + 1, 500) else room.race_level end;
    if p_kind = 'continue' then
      select published_version into next_version
      from public.game_levels where level_id = next_level;
    else next_version := room.race_level_version; end if;
    update public.coop_rooms set
      status = 'playing', status_before_vote = null, leave_requested_by = null,
      rematch_requested_by = null, race_restart_kind = null, end_reason = null,
      ended_at = null, winner_id = null, winner_finished_at = null,
      winner_elapsed_ms = null, winner_hearts = null, winner_stars = null,
      race_end_kind = null, race_level = next_level,
      race_level_version = next_version,
      seed = floor(random() * 2147483646)::integer,
      attempt_number = attempt_number + 1,
      started_at = clock_timestamp(), expires_at = now() + interval '2 hours'
    where id = p_room_id;
    update public.coop_room_members set
      ready = true, eliminated_at = null, last_seen_at = clock_timestamp()
    where room_id = p_room_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.vote_coop_leave(p_room_id uuid, p_approve boolean)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  vote_count integer;
  member_count integer;
begin
  if not exists (select 1 from public.coop_room_members
      where room_id = p_room_id and user_id = player_id) then
    raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.status in ('playing', 'paused') then
    update public.coop_rooms set status_before_vote = room.status,
      status = 'leave_vote', leave_requested_by = player_id where id = p_room_id;
    insert into public.coop_room_action_votes(room_id, user_id, attempt_number, action)
    values (p_room_id, player_id, room.attempt_number, 'leave')
    on conflict do nothing;
  elsif room.status = 'leave_vote' then
    if not p_approve then
      delete from public.coop_room_action_votes where room_id = p_room_id
        and attempt_number = room.attempt_number and action = 'leave';
      update public.coop_rooms set status = coalesce(status_before_vote, 'playing'),
        status_before_vote = null, leave_requested_by = null where id = p_room_id;
      return public.get_coop_room_state(p_room_id);
    end if;
    insert into public.coop_room_action_votes(room_id, user_id, attempt_number, action)
    values (p_room_id, player_id, room.attempt_number, 'leave')
    on conflict do nothing;
  end if;
  select count(*) into vote_count from public.coop_room_action_votes
  where room_id = p_room_id and attempt_number = room.attempt_number and action = 'leave';
  select count(*) into member_count from public.coop_room_members where room_id = p_room_id;
  if vote_count = member_count then
    update public.coop_rooms set status = 'ended', end_reason = 'leave',
      ended_at = now(), status_before_vote = null where id = p_room_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.vote_coop_postgame_exit(
  p_room_id uuid,
  p_approve boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  vote_count integer;
  member_count integer;
begin
  if player_id is null or not exists (select 1 from public.coop_room_members
      where room_id = p_room_id and user_id = player_id) then
    raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.status <> 'ended' or room.end_reason <> 'completed' then
    raise exception 'Post-game exit is not available'; end if;
  if room.leave_requested_by is null then
    update public.coop_rooms set leave_requested_by = player_id where id = p_room_id;
    insert into public.coop_room_action_votes(room_id, user_id, attempt_number, action)
    values (p_room_id, player_id, room.attempt_number, 'postgame_exit')
    on conflict do nothing;
  elsif not p_approve then
    delete from public.coop_room_action_votes where room_id = p_room_id
      and attempt_number = room.attempt_number and action = 'postgame_exit';
    update public.coop_rooms set leave_requested_by = null where id = p_room_id;
    return public.get_coop_room_state(p_room_id);
  else
    insert into public.coop_room_action_votes(room_id, user_id, attempt_number, action)
    values (p_room_id, player_id, room.attempt_number, 'postgame_exit')
    on conflict do nothing;
  end if;
  select count(*) into vote_count from public.coop_room_action_votes
  where room_id = p_room_id and attempt_number = room.attempt_number
    and action = 'postgame_exit';
  select count(*) into member_count from public.coop_room_members where room_id = p_room_id;
  if vote_count = member_count then
    update public.coop_rooms set end_reason = 'leave', leave_requested_by = null
    where id = p_room_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.surrender_race(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  survivor_id uuid;
  survivor_count integer;
  elapsed integer;
begin
  if player_id is null or not exists (select 1 from public.coop_room_members
      where room_id = p_room_id and user_id = player_id) then
    raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.mode <> 'race' then raise exception 'This is not a race room'; end if;
  if room.status not in ('playing', 'paused') or room.winner_id is not null then
    return public.get_coop_room_state(p_room_id); end if;
  update public.coop_room_members set eliminated_at = clock_timestamp()
  where room_id = p_room_id and user_id = player_id and eliminated_at is null;
  select count(*) into survivor_count from public.coop_room_members
  where room_id = p_room_id and eliminated_at is null;
  select user_id into survivor_id from public.coop_room_members
  where room_id = p_room_id and eliminated_at is null limit 1;
  if survivor_count = 1 then
    elapsed := greatest(0, floor(extract(epoch from (
      clock_timestamp() - room.started_at - interval '4 seconds'
    )) * 1000)::integer);
    update public.coop_rooms set status = 'ended', end_reason = 'completed',
      ended_at = clock_timestamp(), winner_id = survivor_id,
      winner_finished_at = clock_timestamp(), winner_elapsed_ms = elapsed,
      race_end_kind = 'surrender' where id = p_room_id;
    update public.coop_room_members set session_wins = session_wins + 1
    where room_id = p_room_id and user_id = survivor_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.maintain_race_presence(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  checked_at timestamptz := clock_timestamp();
  room public.coop_rooms%rowtype;
  previous_seen timestamptz;
  survivor_id uuid;
  survivor_count integer;
  eliminated_count integer;
  elapsed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.id is null or room.mode <> 'race' then raise exception 'Race room not found'; end if;
  select last_seen_at into previous_seen from public.coop_room_members
  where room_id = p_room_id and user_id = player_id;
  if not found then raise exception 'Room access denied'; end if;
  update public.coop_room_members set last_seen_at = checked_at
  where room_id = p_room_id and user_id = player_id;

  if room.status in ('playing', 'paused', 'leave_vote')
      and room.started_at is not null and previous_seen is not null
      and previous_seen >= checked_at - interval '45 seconds' then
    with eliminated as (
      update public.coop_room_members member set eliminated_at = checked_at
      where member.room_id = p_room_id and member.user_id <> player_id
        and member.eliminated_at is null
        and coalesce(member.last_seen_at, greatest(member.joined_at, room.started_at))
          < checked_at - interval '2 minutes'
      returning 1
    ) select count(*) into eliminated_count from eliminated;

    if eliminated_count > 0 then
      select count(*) into survivor_count from public.coop_room_members
      where room_id = p_room_id and eliminated_at is null;
      select user_id into survivor_id from public.coop_room_members
      where room_id = p_room_id and eliminated_at is null limit 1;
      if survivor_count = 1 then
        elapsed := greatest(0, floor(extract(epoch from (
          checked_at - room.started_at - interval '4 seconds'
        )) * 1000)::integer);
        update public.coop_rooms set status = 'ended', status_before_vote = null,
          leave_requested_by = null, end_reason = 'forfeit', ended_at = checked_at,
          winner_id = survivor_id, winner_finished_at = checked_at,
          winner_elapsed_ms = elapsed, winner_hearts = null, winner_stars = null,
          race_end_kind = 'disconnect', rematch_requested_by = null,
          race_restart_kind = null where id = p_room_id;
        update public.coop_room_members set session_wins = session_wins + 1
        where room_id = p_room_id and user_id = survivor_id;
      end if;
    end if;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on table public.coop_room_action_votes from public, anon, authenticated;
revoke all on function public.create_race_room(integer) from public, anon;
revoke all on function public.invite_friend_to_game(text, text, integer, uuid, text)
  from public, anon;
revoke all on function public.join_race_room(text) from public, anon;
revoke all on function public.start_coop_room(uuid) from public, anon;
revoke all on function public.get_coop_room_state(uuid) from public, anon;
revoke all on function public.respond_coop_invite(uuid, boolean) from public, anon;
revoke all on function public.list_my_friends() from public, anon;
revoke all on function public.finish_race(uuid, double precision, integer, integer)
  from public, anon;
revoke all on function public.vote_race_restart(uuid, text) from public, anon;
revoke all on function public.vote_coop_leave(uuid, boolean) from public, anon;
revoke all on function public.vote_coop_postgame_exit(uuid, boolean)
  from public, anon;
revoke all on function public.surrender_race(uuid) from public, anon;
revoke all on function public.maintain_race_presence(uuid) from public, anon;

grant execute on function public.create_race_room(integer) to authenticated;
grant execute on function public.invite_friend_to_game(text, text, integer, uuid, text)
  to authenticated;
grant execute on function public.join_race_room(text) to authenticated;
grant execute on function public.start_coop_room(uuid) to authenticated;
grant execute on function public.get_coop_room_state(uuid) to authenticated;
grant execute on function public.respond_coop_invite(uuid, boolean) to authenticated;
grant execute on function public.list_my_friends() to authenticated;
grant execute on function public.finish_race(uuid, double precision, integer, integer)
  to authenticated;
grant execute on function public.vote_race_restart(uuid, text) to authenticated;
grant execute on function public.vote_coop_leave(uuid, boolean) to authenticated;
grant execute on function public.vote_coop_postgame_exit(uuid, boolean)
  to authenticated;
grant execute on function public.surrender_race(uuid) to authenticated;
grant execute on function public.maintain_race_presence(uuid) to authenticated;
