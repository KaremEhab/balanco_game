create or replace function public.get_my_active_game_room()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  active_room_id uuid;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  select room.id into active_room_id
  from public.coop_room_members member
  join public.coop_rooms room on room.id = member.room_id
  where member.user_id = player_id
    and room.status in ('waiting', 'playing', 'paused', 'leave_vote')
    and (room.status <> 'waiting' or room.expires_at > clock_timestamp())
    and (room.mode <> 'race' or member.eliminated_at is null)
  order by
    case room.status
      when 'playing' then 1
      when 'paused' then 2
      when 'leave_vote' then 3
      else 4
    end,
    coalesce(room.started_at, room.created_at) desc
  limit 1;

  if active_room_id is null then
    return null;
  end if;

  return public.get_coop_room_state(active_room_id);
end;
$$;

comment on function public.get_my_active_game_room() is
  'Returns the authenticated player''s newest recoverable CO-OP or Race room without exposing another player''s membership.';

revoke all on function public.get_my_active_game_room()
  from public, anon, authenticated;
grant execute on function public.get_my_active_game_room() to authenticated;
