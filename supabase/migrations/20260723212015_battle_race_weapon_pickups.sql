alter table public.race_pickup_claims
  drop constraint if exists race_pickup_claims_pickup_type_check;
alter table public.race_pickup_claims
  add constraint race_pickup_claims_pickup_type_check check (
    pickup_type in (
      'star', 'heart', 'magnet', 'multi_ball', 'shield', 'coin',
      'shooter_helper', 'battle_rocket', 'battle_bomb', 'battle_nails',
      'battle_shield', 'battle_turbo'
    )
  );

alter table public.battle_race_actions
  drop constraint if exists battle_race_actions_action_type_check;
alter table public.battle_race_actions
  add constraint battle_race_actions_action_type_check check (
    action_type in (
      'shock_pulse', 'heat_wave', 'battle_rocket', 'battle_bomb',
      'battle_nails'
    )
  );

create or replace function public.claim_battle_race_pickup(
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
  pickup_index integer;
  pickup_count integer;
  owner_id uuid;
  owner_name text;
  owner_type text;
  owner_time timestamptz;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_pickup_type not in (
    'battle_rocket', 'battle_bomb', 'battle_nails',
    'battle_shield', 'battle_turbo'
  ) or p_pickup_key !~ ('^' || p_pickup_type || ':[0-9]+$') then
    raise exception 'Invalid Battle Race pickup';
  end if;

  select * into target
  from public.coop_rooms
  where id = p_room_id
  for share;

  if target.id is null
      or target.mode <> 'race'
      or not target.is_battle_race
      or target.status <> 'playing'
      or target.winner_id is not null
      or target.attempt_number <> p_attempt_number
      or target.race_level <> p_race_level then
    raise exception 'Battle Race pickup is not available';
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

  pickup_index := split_part(p_pickup_key, ':', 2)::integer;
  pickup_count := case p_pickup_type
    when 'battle_rocket' then 2
    when 'battle_bomb' then 2
    when 'battle_nails' then 2
    when 'battle_shield' then 1
    when 'battle_turbo' then 1
    else 0
  end;
  if pickup_index < 0 or pickup_index >= pickup_count then
    raise exception 'Battle Race pickup does not exist';
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
exception
  when invalid_text_representation then
    raise exception 'Invalid Battle Race pickup';
end;
$$;

revoke all on function public.claim_battle_race_pickup(
  uuid, integer, integer, text, text
) from public, anon, authenticated;
grant execute on function public.claim_battle_race_pickup(
  uuid, integer, integer, text, text
) to authenticated;

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
  pickup_key text;
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

  select action.action_type, action.created_at
  into last_action_type, last_action_at
  from public.battle_race_actions action
  where action.room_id = p_room_id
    and action.attempt_number = p_attempt_number
    and action.user_id = player_id
  order by action.created_at desc
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
    pickup_key := p_payload ->> 'pickup_key';
    if pickup_key is null or not exists (
      select 1
      from public.race_pickup_claims claim
      where claim.room_id = p_room_id
        and claim.attempt_number = p_attempt_number
        and claim.race_level = room.race_level
        and claim.pickup_key = pickup_key
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
        and used_action.payload ->> 'pickup_key' = pickup_key
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

comment on function public.claim_battle_race_pickup(
  uuid, integer, integer, text, text
) is 'Atomically awards deterministic Battle Race weapon and utility pickups.';
comment on function public.submit_battle_race_action(
  uuid, integer, text, bigint, jsonb
) is 'Validates Battle Race cooldowns and consumes collected one-use weapons.';

notify pgrst, 'reload schema';
