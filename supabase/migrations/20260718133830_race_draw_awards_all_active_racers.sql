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
    where room_id = p_room_id
      and user_id = player_id
      and left_at is null
  ) then
    raise exception 'Room access denied';
  end if;

  select *
  into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null then
    raise exception 'Room not found';
  end if;
  if room.mode <> 'race' then
    raise exception 'This is not a race room';
  end if;

  -- Only the first timeout submission can settle and reward the draw. Other
  -- devices wait on the room lock, then receive the settled room unchanged.
  if room.status not in ('playing', 'paused') or room.winner_id is not null then
    return public.get_coop_room_state(p_room_id);
  end if;

  update public.coop_room_members
  set session_wins = session_wins + 1
  where room_id = p_room_id
    and left_at is null
    and eliminated_at is null;

  update public.coop_rooms
  set status = 'ended',
      ended_at = clock_timestamp(),
      end_reason = 'completed',
      race_end_kind = 'draw',
      winner_id = null,
      winner_finished_at = null,
      winner_elapsed_ms = null,
      winner_hearts = null,
      winner_stars = null,
      status_before_vote = null,
      leave_requested_by = null
  where id = p_room_id;

  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on function public.draw_race(uuid) from public;
revoke all on function public.draw_race(uuid) from anon;
grant execute on function public.draw_race(uuid) to authenticated;
