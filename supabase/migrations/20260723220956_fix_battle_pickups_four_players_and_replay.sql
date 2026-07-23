alter table public.coop_rooms
  drop constraint if exists coop_rooms_race_restart_kind_check;
alter table public.coop_rooms
  add constraint coop_rooms_race_restart_kind_check check (
    race_restart_kind is null
    or race_restart_kind in ('retry', 'continue', 'series_replay')
  );

alter table public.coop_room_action_votes
  drop constraint if exists coop_room_action_votes_action_check;
alter table public.coop_room_action_votes
  add constraint coop_room_action_votes_action_check check (
    action in (
      'leave', 'postgame_exit', 'retry', 'continue', 'series_replay'
    )
  );

create or replace function public.enforce_consistent_race_restart_vote()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.action in ('retry', 'continue', 'series_replay') and exists (
    select 1
    from public.coop_room_action_votes vote
    where vote.room_id = new.room_id
      and vote.attempt_number = new.attempt_number
      and vote.action in ('retry', 'continue', 'series_replay')
      and vote.action <> new.action
  ) then
    raise exception 'The players selected different restart choices';
  end if;
  return new;
end;
$$;

drop function if exists public.create_battle_race_room();
create or replace function public.create_battle_race_room(
  p_max_players integer default 2
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room_state jsonb;
  new_room_id uuid;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_max_players not between 2 and 4 then
    raise exception 'Battle Race rooms support 2 to 4 players';
  end if;

  room_state := public.create_race_room(p_max_players);
  new_room_id := (room_state -> 'room' ->> 'id')::uuid;

  update public.coop_rooms
  set is_battle_race = true,
      max_players = p_max_players
  where id = new_room_id
    and host_id = player_id;

  if not found then
    raise exception 'Could not create Battle Race room';
  end if;

  return public.get_coop_room_state(new_room_id);
end;
$$;

revoke all on function public.create_battle_race_room(integer)
from public, anon, authenticated;
grant execute on function public.create_battle_race_room(integer)
to authenticated;

create or replace function public.submit_battle_race_action(
  p_room_id uuid,
  p_attempt_number integer,
  p_action_type text,
  p_client_sequence bigint,
  p_payload jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  action_id uuid;
  accepted_at timestamptz := clock_timestamp();
  source_x double precision;
  source_y double precision;
  weapon_pickup_key text;
  last_action_type text;
  last_action_at timestamptz;
  cooldown_seconds double precision;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_action_type not in (
    'shock_pulse', 'heat_wave', 'battle_rocket', 'battle_bomb',
    'battle_nails'
  ) then
    raise exception 'Unsupported Battle Race action';
  end if;
  if p_client_sequence < 1 then
    raise exception 'Invalid Battle Race action sequence';
  end if;
  if octet_length(p_payload::text) > 512 then
    raise exception 'Battle Race action payload is too large';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race' or not room.is_battle_race then
    raise exception 'Battle Race room not found';
  end if;
  if room.status <> 'playing' or room.winner_id is not null then
    raise exception 'Battle Race is not active';
  end if;
  if room.started_at is null
      or accepted_at < room.started_at + interval '4 seconds' then
    raise exception 'Battle Race countdown is active';
  end if;
  if room.attempt_number <> p_attempt_number then
    raise exception 'Stale Battle Race action';
  end if;
  if not exists (
    select 1
    from public.coop_room_members member
    where member.room_id = p_room_id
      and member.user_id = player_id
      and member.left_at is null
      and member.eliminated_at is null
  ) then
    raise exception 'Room access denied';
  end if;

  source_x := (p_payload ->> 'source_x')::double precision;
  source_y := (p_payload ->> 'source_y')::double precision;
  if source_x is null or source_x < 0 or source_x > 1
      or source_y is null or source_y < 0 or source_y > 1 then
    raise exception 'Invalid Battle Race action origin';
  end if;

  select stored_action.action_type, stored_action.created_at
  into last_action_type, last_action_at
  from public.battle_race_actions stored_action
  where stored_action.room_id = p_room_id
    and stored_action.attempt_number = p_attempt_number
    and stored_action.user_id = player_id
  order by stored_action.created_at desc
  limit 1;
  cooldown_seconds := case last_action_type
    when 'shock_pulse' then 6.0
    when 'heat_wave' then 6.0
    when 'battle_rocket' then 1.1
    when 'battle_bomb' then 1.5
    when 'battle_nails' then 0.9
    else 0.0
  end;
  if last_action_at is not null
      and accepted_at < last_action_at + make_interval(secs => cooldown_seconds)
  then
    raise exception 'Battle weapon is cooling down';
  end if;

  if p_action_type in ('battle_rocket', 'battle_bomb', 'battle_nails') then
    weapon_pickup_key := p_payload ->> 'pickup_key';
    if weapon_pickup_key is null or not exists (
      select 1
      from public.race_pickup_claims claim
      where claim.room_id = p_room_id
        and claim.attempt_number = p_attempt_number
        and claim.race_level = room.race_level
        and claim.pickup_key = weapon_pickup_key
        and claim.pickup_type = p_action_type
        and claim.claimant_id = player_id
    ) then
      raise exception 'Battle weapon was not collected';
    end if;
    if exists (
      select 1
      from public.battle_race_actions used_action
      where used_action.room_id = p_room_id
        and used_action.attempt_number = p_attempt_number
        and used_action.user_id = player_id
        and used_action.payload ->> 'pickup_key' = weapon_pickup_key
    ) then
      raise exception 'Battle weapon was already used';
    end if;
  end if;

  insert into public.battle_race_actions (
    room_id,
    attempt_number,
    user_id,
    action_type,
    client_sequence,
    payload,
    created_at
  ) values (
    p_room_id,
    p_attempt_number,
    player_id,
    p_action_type,
    p_client_sequence,
    p_payload,
    accepted_at
  )
  returning id into action_id;

  return jsonb_build_object(
    'accepted', true,
    'action_id', action_id,
    'server_at', accepted_at
  );
exception
  when unique_violation then
    raise exception 'Duplicate Battle Race action';
  when invalid_text_representation then
    raise exception 'Invalid Battle Race action origin';
end;
$$;

revoke all on function public.submit_battle_race_action(
  uuid, integer, text, bigint, jsonb
) from public, anon, authenticated;
grant execute on function public.submit_battle_race_action(
  uuid, integer, text, bigint, jsonb
) to authenticated;

create or replace function public.vote_race_restart(
  p_room_id uuid,
  p_kind text
)
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
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_kind not in ('retry', 'continue', 'series_replay') then
    raise exception 'Invalid race restart choice';
  end if;
  if not exists (
    select 1
    from public.coop_room_members member
    where member.room_id = p_room_id
      and member.user_id = player_id
      and member.left_at is null
  ) then
    raise exception 'Room access denied';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race' or not (
    (
      p_kind = 'series_replay'
      and room.status = 'ended'
      and room.series_finished_at is not null
    )
    or (
      p_kind = 'continue'
      and room.status = 'ended'
      and room.end_reason = 'completed'
      and room.series_finished_at is null
      and room.race_level < room.race_end_level
    )
    or (
      p_kind = 'retry'
      and room.status = 'paused'
      and room.series_finished_at is null
    )
  ) then
    raise exception 'The race is not ready for that restart or series replay';
  end if;

  delete from public.coop_room_action_votes
  where room_id = p_room_id
    and user_id = player_id
    and attempt_number = room.attempt_number
    and action in ('retry', 'continue', 'series_replay');
  insert into public.coop_room_action_votes(
    room_id, user_id, attempt_number, action
  ) values (
    p_room_id, player_id, room.attempt_number, p_kind
  );
  update public.coop_rooms
  set rematch_requested_by = coalesce(rematch_requested_by, player_id),
      race_restart_kind = p_kind
  where id = p_room_id;

  select count(*) into vote_count
  from public.coop_room_action_votes vote
  where vote.room_id = p_room_id
    and vote.attempt_number = room.attempt_number
    and vote.action = p_kind
    and exists (
      select 1
      from public.coop_room_members member
      where member.room_id = vote.room_id
        and member.user_id = vote.user_id
        and member.left_at is null
    );
  select count(*) into member_count
  from public.coop_room_members
  where room_id = p_room_id
    and left_at is null;

  if vote_count = member_count then
    next_level := case
      when p_kind = 'continue' then room.race_level + 1
      when p_kind = 'series_replay' then room.race_start_level
      else room.race_level
    end;
    select published_version into next_version
    from public.game_levels
    where level_id = next_level;
    if next_version is null then
      raise exception 'The selected replay level is unavailable';
    end if;

    delete from public.coop_room_action_votes
    where room_id = p_room_id;
    delete from public.coop_room_members
    where room_id = p_room_id
      and left_at is not null;

    update public.coop_rooms
    set status = 'playing',
        status_before_vote = null,
        leave_requested_by = null,
        rematch_requested_by = null,
        race_restart_kind = null,
        end_reason = null,
        ended_at = null,
        winner_id = null,
        winner_finished_at = null,
        winner_elapsed_ms = null,
        winner_hearts = null,
        winner_stars = null,
        race_end_kind = null,
        race_level = next_level,
        race_level_version = next_version,
        series_winner_id = case
          when p_kind = 'series_replay' then null
          else series_winner_id
        end,
        series_end_kind = case
          when p_kind = 'series_replay' then null
          else series_end_kind
        end,
        series_finished_at = case
          when p_kind = 'series_replay' then null
          else series_finished_at
        end,
        series_scored_attempt = case
          when p_kind = 'series_replay' then 0
          else series_scored_attempt
        end,
        seed = floor(random() * 2147483646)::integer,
        attempt_number = attempt_number + 1,
        started_at = clock_timestamp(),
        expires_at = now() + interval '2 hours'
    where id = p_room_id;

    update public.coop_room_members
    set ready = true,
        eliminated_at = null,
        left_at = null,
        last_seen_at = clock_timestamp(),
        session_wins = case
          when p_kind = 'series_replay' then 0
          else session_wins
        end,
        series_stars = case
          when p_kind = 'series_replay' then 0
          else series_stars
        end
    where room_id = p_room_id;
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on function public.vote_race_restart(uuid, text)
from public, anon, authenticated;
grant execute on function public.vote_race_restart(uuid, text)
to authenticated;

comment on function public.create_battle_race_room(integer)
  is 'Creates a two-to-four-player Battle Race room.';
comment on function public.submit_battle_race_action(
  uuid, integer, text, bigint, jsonb
) is 'Validates Battle Race actions and consumes one globally claimed weapon.';
comment on function public.vote_race_restart(uuid, text)
  is 'Coordinates retry, continue, and same-level-range series replay votes.';

notify pgrst, 'reload schema';
