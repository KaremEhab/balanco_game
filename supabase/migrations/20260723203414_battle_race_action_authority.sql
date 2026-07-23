alter table public.coop_rooms
  add column if not exists is_battle_race boolean not null default false;

create table if not exists public.battle_race_actions (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.coop_rooms(id) on delete cascade,
  attempt_number integer not null check (attempt_number > 0),
  user_id uuid not null references auth.users(id) on delete cascade,
  action_type text not null check (action_type in ('shock_pulse')),
  client_sequence bigint not null check (client_sequence > 0),
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default clock_timestamp(),
  unique (room_id, attempt_number, user_id, client_sequence)
);

create index if not exists battle_race_actions_cooldown_idx
  on public.battle_race_actions (
    room_id,
    attempt_number,
    user_id,
    action_type,
    created_at desc
  );

alter table public.battle_race_actions enable row level security;

revoke all on table public.battle_race_actions
from public, anon, authenticated;

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
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_action_type <> 'shock_pulse' then
    raise exception 'Unsupported battle action';
  end if;
  if p_client_sequence < 1 then
    raise exception 'Invalid battle action sequence';
  end if;
  if octet_length(p_payload::text) > 512 then
    raise exception 'Battle action payload is too large';
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
    raise exception 'Invalid Shock Pulse origin';
  end if;

  if exists (
    select 1
    from public.battle_race_actions action
    where action.room_id = p_room_id
      and action.attempt_number = p_attempt_number
      and action.user_id = player_id
      and action.action_type = p_action_type
      and action.created_at > accepted_at - interval '6 seconds'
  ) then
    raise exception 'Shock Pulse is cooling down';
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
    raise exception 'Invalid Shock Pulse origin';
end;
$$;

revoke all on function public.submit_battle_race_action(
  uuid,
  integer,
  text,
  bigint,
  jsonb
) from public, anon, authenticated;

grant execute on function public.submit_battle_race_action(
  uuid,
  integer,
  text,
  bigint,
  jsonb
) to authenticated;

create or replace function public.get_battle_race_action(
  p_room_id uuid,
  p_action_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  action public.battle_race_actions%rowtype;
begin
  if player_id is null or not exists (
    select 1
    from public.coop_room_members member
    join public.coop_rooms room on room.id = member.room_id
    where member.room_id = p_room_id
      and member.user_id = player_id
      and member.left_at is null
      and room.mode = 'race'
      and room.is_battle_race
  ) then
    raise exception 'Room access denied';
  end if;

  select * into action
  from public.battle_race_actions stored_action
  where stored_action.id = p_action_id
    and stored_action.room_id = p_room_id
    and stored_action.created_at > clock_timestamp() - interval '5 seconds';

  if action.id is null then
    raise exception 'Battle Race action not found';
  end if;

  return jsonb_build_object(
    'action_id', action.id,
    'attempt_number', action.attempt_number,
    'user_id', action.user_id,
    'action_type', action.action_type,
    'payload', action.payload,
    'server_at', action.created_at
  );
end;
$$;

revoke all on function public.get_battle_race_action(uuid, uuid)
from public, anon, authenticated;

grant execute on function public.get_battle_race_action(uuid, uuid)
to authenticated;
