create or replace function public.get_realtime_load_hint()
returns jsonb
language plpgsql
security definer
set search_path = ''
stable
as $$
declare
  player_id uuid := auth.uid();
  active_rooms integer;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  select count(*)::integer
  into active_rooms
  from public.coop_rooms room
  where room.status = 'playing'
    and room.started_at is not null
    and room.expires_at > now();

  return jsonb_build_object(
    'active_rooms', greatest(1, active_rooms),
    'project_event_budget', 55,
    'sampled_at', clock_timestamp()
  );
end;
$$;

revoke all on function public.get_realtime_load_hint()
from public, anon, authenticated;
grant execute on function public.get_realtime_load_hint()
to authenticated;

comment on function public.get_realtime_load_hint()
  is 'Returns a bounded project-wide gameplay load hint for adaptive Realtime traffic.';

notify pgrst, 'reload schema';
