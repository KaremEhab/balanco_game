alter table public.coop_rooms
  add column if not exists is_battle_race boolean not null default false;

create or replace function public.create_battle_race_room()
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

  room_state := public.create_race_room(2);
  new_room_id := (room_state -> 'room' ->> 'id')::uuid;

  update public.coop_rooms
  set is_battle_race = true,
      max_players = 2
  where id = new_room_id
    and host_id = player_id;

  if not found then
    raise exception 'Could not create Battle Race room';
  end if;

  return public.get_coop_room_state(new_room_id);
end;
$$;

revoke all on function public.create_battle_race_room()
from public, anon, authenticated;

grant execute on function public.create_battle_race_room()
to authenticated;

create or replace function public.join_race_room_variant(
  p_code text,
  p_battle boolean default false
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  target public.coop_rooms%rowtype;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  select * into target
  from public.coop_rooms
  where room_code = upper(trim(p_code))
    and mode = 'race'
    and status = 'waiting'
    and expires_at > now()
  for update;

  if target.id is null then
    raise exception 'Race room not found or expired';
  end if;

  if target.is_battle_race <> p_battle then
    if target.is_battle_race then
      raise exception 'That code belongs to a Battle Race';
    end if;
    raise exception 'That code belongs to a regular Online Race';
  end if;

  return public.join_race_room(p_code);
end;
$$;

revoke all on function public.join_race_room_variant(text, boolean)
from public, anon, authenticated;

grant execute on function public.join_race_room_variant(text, boolean)
to authenticated;
