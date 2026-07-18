create or replace function public.draw_race(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
begin
  if player_id is null or not exists (
    select 1
    from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.mode <> 'race' then
    raise exception 'This is not a race room';
  end if;
  if room.status not in ('playing', 'paused') or room.winner_id is not null then
    return public.get_coop_room_state(p_room_id);
  end if;

  update public.coop_rooms
  set status = 'ended',
      ended_at = clock_timestamp(),
      race_end_kind = 'draw',
      winner_id = null
  where id = p_room_id;

  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on function public.draw_race(uuid) from public, anon;
grant execute on function public.draw_race(uuid) to authenticated;
