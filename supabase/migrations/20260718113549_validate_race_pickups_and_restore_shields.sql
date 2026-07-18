alter table public.race_pickup_claims
  drop constraint if exists race_pickup_claims_pickup_type_check;
alter table public.race_pickup_claims
  add constraint race_pickup_claims_pickup_type_check check (
    pickup_type in (
      'star', 'heart', 'magnet', 'multi_ball', 'shield', 'coin',
      'shooter_helper'
    )
  );

create or replace function private.race_level_pickup_count(
  p_definition_format text,
  p_definition jsonb,
  p_level_id integer,
  p_pickup_type text
)
returns integer
language plpgsql
immutable
set search_path = ''
as $$
declare
  items jsonb;
  campaign_type text;
  result integer;
begin
  if p_definition_format = 'level_data_v1' then
    items := case p_pickup_type
      when 'star' then p_definition -> 'stars'
      when 'heart' then p_definition -> 'hearts'
      when 'magnet' then p_definition -> 'magnets'
      when 'multi_ball' then p_definition -> 'multiBalls'
      when 'shield' then p_definition -> 'shields'
      when 'shooter_helper' then p_definition -> 'shooterHelpers'
      when 'coin' then p_definition -> 'coins'
      else null
    end;
    if jsonb_typeof(items) <> 'array' then return 0; end if;
    return jsonb_array_length(items);
  end if;

  if p_definition_format = 'campaign_v1' then
    -- Boss helpers are derived by the client adapter and therefore are not
    -- present in the authored pickup array.
    if p_pickup_type = 'shooter_helper' then
      return case when p_level_id = 50 or p_level_id % 100 = 0
        then 1 else 0 end;
    end if;
    campaign_type := case p_pickup_type
      when 'star' then 'star'
      when 'heart' then 'heart'
      when 'magnet' then 'magnet'
      when 'multi_ball' then 'extraBall'
      when 'shield' then 'shield'
      else null
    end;
    if campaign_type is null
        or jsonb_typeof(p_definition -> 'pickups') <> 'array' then
      return 0;
    end if;
    select count(*)::integer into result
    from jsonb_array_elements(p_definition -> 'pickups') item
    where item ->> 'type' = campaign_type;
    return coalesce(result, 0);
  end if;

  return 0;
end;
$$;

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
  level_format text;
  level_definition jsonb;
  pickup_index integer;
  pickup_count integer;
  owner_id uuid;
  owner_name text;
  owner_type text;
  owner_time timestamptz;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_pickup_type not in (
    'star', 'heart', 'magnet', 'multi_ball', 'shield', 'coin',
    'shooter_helper'
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

  if target.race_level_version is null then
    select definition_format, definition
    into level_format, level_definition
    from public.game_levels
    where level_id = target.race_level;
  else
    select definition_format, definition
    into level_format, level_definition
    from public.game_level_versions
    where level_id = target.race_level
      and version = target.race_level_version;
  end if;
  if level_definition is null then
    raise exception 'Pinned race level is unavailable';
  end if;

  pickup_index := split_part(p_pickup_key, ':', 2)::integer;
  pickup_count := private.race_level_pickup_count(
    level_format, level_definition, target.race_level, p_pickup_type
  );
  if pickup_index < 0 or pickup_index >= pickup_count then
    raise exception 'Race pickup does not exist in this level';
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

comment on function private.race_level_pickup_count(text, jsonb, integer, text)
  is 'Counts claimable Race pickups from the exact immutable level version.';
comment on function public.claim_race_pickup(uuid, integer, integer, text, text)
  is 'Atomically awards only pickups that exist in the room-pinned Race level.';

revoke all on function private.race_level_pickup_count(
  text, jsonb, integer, text
) from public, anon, authenticated;
revoke all on function public.claim_race_pickup(
  uuid, integer, integer, text, text
) from public, anon, authenticated;
grant execute on function public.claim_race_pickup(
  uuid, integer, integer, text, text
) to authenticated;
