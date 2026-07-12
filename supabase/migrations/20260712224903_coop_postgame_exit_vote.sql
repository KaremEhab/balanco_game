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
begin
  if player_id is null or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then raise exception 'Room access denied'; end if;

  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.status <> 'ended' or room.end_reason <> 'completed' then
    raise exception 'Post-game exit is not available';
  end if;

  if room.leave_requested_by is null then
    update public.coop_rooms set leave_requested_by = player_id
    where id = p_room_id;
  elsif room.leave_requested_by <> player_id then
    if p_approve then
      update public.coop_rooms
      set end_reason = 'leave', leave_requested_by = null
      where id = p_room_id;
    else
      update public.coop_rooms set leave_requested_by = null
      where id = p_room_id;
    end if;
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on function public.vote_coop_postgame_exit(uuid, boolean)
from public, anon;
grant execute on function public.vote_coop_postgame_exit(uuid, boolean)
to authenticated;
