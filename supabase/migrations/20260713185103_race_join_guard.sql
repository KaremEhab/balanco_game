create or replace function public.join_race_room(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  target public.coop_rooms%rowtype;
begin
  if player_id is null then raise exception 'Authentication required'; end if;

  select * into target from public.coop_rooms
  where room_code = upper(trim(p_code))
    and mode = 'race'
    and status = 'waiting'
    and expires_at > now()
  for update;
  if target.id is null then raise exception 'Race room not found or expired'; end if;
  if target.host_id = player_id then
    return public.get_coop_room_state(target.id);
  end if;
  if (select count(*) from public.coop_room_members where room_id = target.id) >= 2 then
    raise exception 'Race room is full';
  end if;

  insert into public.coop_room_members(room_id, user_id, side)
  values (target.id, player_id, 'right')
  on conflict (room_id, user_id) do nothing;
  return public.get_coop_room_state(target.id);
end;
$$;

revoke all on function public.join_race_room(text) from public, anon;
grant execute on function public.join_race_room(text) to authenticated;
