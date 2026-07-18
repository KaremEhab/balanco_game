alter table public.coop_room_members
  add column if not exists left_at timestamptz;

create table if not exists public.race_pickup_claims (
  room_id uuid not null references public.coop_rooms(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  race_level integer not null check (race_level > 0),
  pickup_key text not null,
  pickup_type text not null check (
    pickup_type in (
      'star', 'heart', 'magnet', 'multi_ball', 'coin', 'shooter_helper'
    )
  ),
  claimant_id uuid not null references public.profiles(id) on delete cascade,
  claimed_at timestamptz not null default clock_timestamp(),
  primary key (room_id, attempt_number, pickup_key),
  check (char_length(pickup_key) between 3 and 80)
);

create index if not exists race_pickup_claims_claimant_attempt_idx
  on public.race_pickup_claims(claimant_id, room_id, attempt_number);

alter table public.race_pickup_claims enable row level security;

drop policy if exists race_members_read_pickup_claims
  on public.race_pickup_claims;
create policy race_members_read_pickup_claims
on public.race_pickup_claims
for select
to authenticated
using (
  exists (
    select 1
    from public.coop_room_members member
    where member.room_id = race_pickup_claims.room_id
      and member.user_id = (select auth.uid())
  )
);

create or replace function public.claim_race_pickup(
  p_room_id uuid,
  p_attempt_number integer,
  p_race_level integer,
  p_pickup_key text,
  p_pickup_type text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  target public.coop_rooms%rowtype;
  owner_id uuid;
  owner_name text;
  owner_type text;
  owner_time timestamptz;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_pickup_type not in (
    'star', 'heart', 'magnet', 'multi_ball', 'coin', 'shooter_helper'
  ) or p_pickup_key !~ ('^' || p_pickup_type || ':[0-9]+$') then
    raise exception 'Invalid race pickup';
  end if;

  select * into target
  from public.coop_rooms
  where id = p_room_id
  for share;

  if target.id is null
      or target.mode <> 'race'
      or target.status <> 'playing'
      or target.attempt_number <> p_attempt_number
      or target.race_level <> p_race_level then
    raise exception 'Race pickup is not available';
  end if;
  if not exists (
    select 1
    from public.coop_room_members member
    where member.room_id = p_room_id
      and member.user_id = player_id
      and member.eliminated_at is null
      and member.left_at is null
  ) then
    raise exception 'Room access denied';
  end if;

  insert into public.race_pickup_claims(
    room_id, attempt_number, race_level, pickup_key, pickup_type, claimant_id
  ) values (
    p_room_id, p_attempt_number, p_race_level,
    p_pickup_key, p_pickup_type, player_id
  )
  on conflict (room_id, attempt_number, pickup_key) do nothing;

  select claim.claimant_id, claim.pickup_type, claim.claimed_at,
         profile.display_name
  into owner_id, owner_type, owner_time, owner_name
  from public.race_pickup_claims claim
  join public.profiles profile on profile.id = claim.claimant_id
  where claim.room_id = p_room_id
    and claim.attempt_number = p_attempt_number
    and claim.pickup_key = p_pickup_key;

  return jsonb_build_object(
    'pickup_key', p_pickup_key,
    'pickup_type', owner_type,
    'claimant_id', owner_id,
    'claimant_name', owner_name,
    'claimed_at', owner_time
  );
end;
$$;

create or replace function public.get_coop_room_state(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  checked_at timestamptz := clock_timestamp();
  result jsonb;
begin
  if player_id is null or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  update public.coop_room_members member
  set last_seen_at = checked_at
  where member.room_id = p_room_id
    and member.user_id = player_id
    and member.left_at is null
    and exists (
      select 1 from public.coop_rooms room
      where room.id = p_room_id
        and room.status in ('waiting', 'playing', 'paused', 'leave_vote')
    );

  select jsonb_build_object(
    'room', to_jsonb(r) || jsonb_build_object(
      'restart_vote_count', (
        select count(*) from public.coop_room_action_votes vote
        where vote.room_id = r.id
          and vote.attempt_number = r.attempt_number
          and vote.action = r.race_restart_kind
      ),
      'leave_vote_count', (
        select count(*) from public.coop_room_action_votes vote
        where vote.room_id = r.id
          and vote.attempt_number = r.attempt_number
          and vote.action in ('leave', 'postgame_exit')
      )
    ),
    'members', coalesce((
      select jsonb_agg(jsonb_build_object(
        'user_id', member.user_id,
        'side', member.side,
        'ready', member.ready,
        'mic_muted', member.mic_muted,
        'display_name', profile.display_name,
        'player_code', profile.player_code,
        'avatar_url', profile.avatar_url,
        'avatar_shape', coalesce(profile.avatar_shape, 'circle'),
        'race_wins', coalesce(progress.race_wins, 0),
        'session_wins', member.session_wins,
        'eliminated_at', member.eliminated_at,
        'left_at', member.left_at,
        'last_seen_at', member.last_seen_at,
        'is_online', member.left_at is null and
          coalesce(member.last_seen_at, member.joined_at)
            >= checked_at - interval '2 minutes',
        'is_host', member.user_id = r.host_id
      ) order by case member.side
        when 'left' then 1 when 'slot1' then 1
        when 'right' then 2 when 'slot2' then 2
        when 'slot3' then 3 else 4 end)
      from public.coop_room_members member
      join public.profiles profile on profile.id = member.user_id
      left join public.player_progress progress on progress.user_id = member.user_id
      where member.room_id = r.id
    ), '[]'::jsonb),
    'race_pickup_claims', coalesce((
      select jsonb_agg(jsonb_build_object(
        'pickup_key', claim.pickup_key,
        'pickup_type', claim.pickup_type,
        'claimant_id', claim.claimant_id,
        'claimant_name', profile.display_name,
        'claimed_at', claim.claimed_at
      ) order by claim.claimed_at, claim.pickup_key)
      from public.race_pickup_claims claim
      join public.profiles profile on profile.id = claim.claimant_id
      where claim.room_id = r.id
        and claim.attempt_number = r.attempt_number
        and claim.race_level = r.race_level
    ), '[]'::jsonb)
  ) into result
  from public.coop_rooms r
  where r.id = p_room_id;

  return result;
end;
$$;

create or replace function public.leave_race_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  survivor_id uuid;
  next_host_id uuid;
  remaining_members integer;
  active_racers integer;
  elapsed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.id is null or room.mode <> 'race' then
    raise exception 'Race room not found';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id and left_at is null
  ) then raise exception 'Room access denied'; end if;

  delete from public.coop_room_action_votes
  where room_id = p_room_id and user_id = player_id;

  if room.status = 'waiting' then
    delete from public.coop_room_members
    where room_id = p_room_id and user_id = player_id;
  else
    update public.coop_room_members
    set left_at = clock_timestamp(),
        eliminated_at = coalesce(eliminated_at, clock_timestamp()),
        last_seen_at = clock_timestamp(),
        ready = false
    where room_id = p_room_id and user_id = player_id;
  end if;

  select count(*) into remaining_members
  from public.coop_room_members
  where room_id = p_room_id and left_at is null;
  select count(*) into active_racers
  from public.coop_room_members
  where room_id = p_room_id and left_at is null and eliminated_at is null;

  if room.host_id = player_id and remaining_members > 0 then
    select user_id into next_host_id
    from public.coop_room_members
    where room_id = p_room_id and left_at is null
    order by joined_at, user_id limit 1;
    update public.coop_rooms set host_id = next_host_id where id = p_room_id;
  end if;

  if remaining_members = 0 then
    update public.coop_rooms set
      status = 'ended', status_before_vote = null,
      leave_requested_by = null, end_reason = 'leave',
      ended_at = clock_timestamp(), race_end_kind = null,
      rematch_requested_by = null, race_restart_kind = null
    where id = p_room_id;
  elsif room.status = 'waiting' then
    update public.coop_rooms set leave_requested_by = null where id = p_room_id;
  elsif room.status in ('playing', 'paused', 'leave_vote')
      and room.winner_id is null then
    if active_racers = 1 then
      select user_id into survivor_id
      from public.coop_room_members
      where room_id = p_room_id and left_at is null and eliminated_at is null
      limit 1;
      elapsed := greatest(0, floor(extract(epoch from (
        clock_timestamp() - coalesce(room.started_at, clock_timestamp())
        - interval '4 seconds'
      )) * 1000)::integer);
      update public.coop_rooms set
        status = 'ended', status_before_vote = null,
        leave_requested_by = null, end_reason = 'completed',
        ended_at = clock_timestamp(), winner_id = survivor_id,
        winner_finished_at = clock_timestamp(), winner_elapsed_ms = elapsed,
        winner_hearts = null, winner_stars = (
          select count(*)::integer from public.race_pickup_claims claim
          where claim.room_id = p_room_id
            and claim.attempt_number = room.attempt_number
            and claim.pickup_type = 'star'
            and claim.claimant_id = survivor_id
        ),
        race_end_kind = 'surrender', rematch_requested_by = null,
        race_restart_kind = null
      where id = p_room_id;
      update public.coop_room_members set session_wins = session_wins + 1
      where room_id = p_room_id and user_id = survivor_id;
    elsif active_racers = 0 then
      update public.coop_rooms set
        status = 'ended', status_before_vote = null,
        leave_requested_by = null, end_reason = 'leave',
        ended_at = clock_timestamp(), race_end_kind = null,
        rematch_requested_by = null, race_restart_kind = null
      where id = p_room_id;
    elsif room.status = 'leave_vote' then
      update public.coop_rooms set
        status = coalesce(status_before_vote, 'playing'),
        status_before_vote = null, leave_requested_by = null
      where id = p_room_id;
    end if;
  end if;

  return jsonb_build_object(
    'left', true, 'room_id', p_room_id,
    'remaining_players', remaining_members,
    'race_ended', (
      select status = 'ended' from public.coop_rooms where id = p_room_id
    )
  );
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
  if p_kind not in ('retry', 'continue') then
    raise exception 'Invalid race restart choice';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id and left_at is null
  ) then raise exception 'Room access denied'; end if;
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

  select count(*) into vote_count from public.coop_room_action_votes vote
  where vote.room_id = p_room_id and vote.attempt_number = room.attempt_number
    and vote.action = p_kind
    and exists (
      select 1 from public.coop_room_members member
      where member.room_id = vote.room_id and member.user_id = vote.user_id
        and member.left_at is null
    );
  select count(*) into member_count from public.coop_room_members
  where room_id = p_room_id and left_at is null;

  if vote_count = member_count then
    next_level := case when p_kind = 'continue'
      then least(room.race_level + 1, 500) else room.race_level end;
    if p_kind = 'continue' then
      select published_version into next_version
      from public.game_levels where level_id = next_level;
    else
      next_version := room.race_level_version;
    end if;
    delete from public.coop_room_members
    where room_id = p_room_id and left_at is not null;
    update public.coop_rooms set
      status = 'playing', status_before_vote = null,
      leave_requested_by = null, rematch_requested_by = null,
      race_restart_kind = null, end_reason = null, ended_at = null,
      winner_id = null, winner_finished_at = null,
      winner_elapsed_ms = null, winner_hearts = null, winner_stars = null,
      race_end_kind = null, race_level = next_level,
      race_level_version = next_version,
      seed = floor(random() * 2147483646)::integer,
      attempt_number = attempt_number + 1,
      started_at = clock_timestamp(), expires_at = now() + interval '2 hours'
    where id = p_room_id;
    update public.coop_room_members set
      ready = true, eliminated_at = null, left_at = null,
      last_seen_at = clock_timestamp()
    where room_id = p_room_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

-- A winner's Race star score comes from the atomic room claims rather than a
-- value supplied by a client snapshot.
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
  authoritative_stars integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_progress < 0.98 or p_progress > 1.001 then
    raise exception 'Finish position is not valid';
  end if;
  if p_hearts < 0 or p_hearts > 20 then
    raise exception 'Race result is not valid';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
      and eliminated_at is null and left_at is null
  ) then raise exception 'Room access denied'; end if;

  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.mode <> 'race' then raise exception 'This is not a race room'; end if;
  select count(*)::integer into authoritative_stars
  from public.race_pickup_claims claim
  where claim.room_id = p_room_id
    and claim.attempt_number = room.attempt_number
    and claim.race_level = room.race_level
    and claim.pickup_type = 'star'
    and claim.claimant_id = player_id;

  if room.status = 'playing' and room.winner_id is null then
    elapsed := greatest(0, floor(extract(epoch from (
      clock_timestamp() - room.started_at - interval '4 seconds'
    )) * 1000)::integer);
    update public.coop_rooms set
      status = 'ended', end_reason = 'completed', ended_at = clock_timestamp(),
      winner_id = player_id, winner_finished_at = clock_timestamp(),
      winner_elapsed_ms = elapsed, winner_hearts = p_hearts,
      winner_stars = authoritative_stars, race_end_kind = 'finish'
    where id = p_room_id;
    update public.coop_room_members set session_wins = session_wins + 1
    where room_id = p_room_id and user_id = player_id;

    insert into public.player_race_level_wins(
      user_id, level_id, first_won_at, best_time_ms, best_hearts, best_stars
    ) values (
      player_id, room.race_level, now(), elapsed, p_hearts, authoritative_stars
    )
    on conflict (user_id, level_id) do update set
      best_time_ms = case
        when public.player_race_level_wins.best_time_ms is null
          then excluded.best_time_ms
        else least(
          public.player_race_level_wins.best_time_ms, excluded.best_time_ms
        ) end,
      best_hearts = greatest(
        public.player_race_level_wins.best_hearts, excluded.best_hearts
      ),
      best_stars = greatest(
        public.player_race_level_wins.best_stars, excluded.best_stars
      );
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

comment on table public.race_pickup_claims is
  'Atomic room-wide ownership ledger for Race collectibles.';
comment on function public.claim_race_pickup(uuid, integer, integer, text, text) is
  'Atomically awards a Race pickup to the first active room member that claims it.';

revoke all on table public.race_pickup_claims
  from public, anon, authenticated;
grant select on table public.race_pickup_claims to authenticated;

revoke all on function public.claim_race_pickup(uuid, integer, integer, text, text)
  from public, anon, authenticated;
revoke all on function public.get_coop_room_state(uuid)
  from public, anon, authenticated;
revoke all on function public.leave_race_room(uuid)
  from public, anon, authenticated;
revoke all on function public.vote_race_restart(uuid, text)
  from public, anon, authenticated;
revoke all on function public.finish_race(uuid, double precision, integer, integer)
  from public, anon, authenticated;

grant execute on function public.claim_race_pickup(uuid, integer, integer, text, text)
  to authenticated;
grant execute on function public.get_coop_room_state(uuid) to authenticated;
grant execute on function public.leave_race_room(uuid) to authenticated;
grant execute on function public.vote_race_restart(uuid, text) to authenticated;
grant execute on function public.finish_race(uuid, double precision, integer, integer)
  to authenticated;
