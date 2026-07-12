create or replace function public.retry_coop_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_status text;
begin
  if auth.uid() is null or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = auth.uid()
  ) then raise exception 'Room access denied'; end if;

  select status into current_status
  from public.coop_rooms where id = p_room_id for update;

  if current_status = 'ended' then
    update public.coop_rooms
    set status = 'playing',
        status_before_vote = null,
        leave_requested_by = null,
        score = 0,
        seed = floor(random() * 2147483646)::integer,
        attempt_number = attempt_number + 1,
        started_at = now(),
        ended_at = null,
        expires_at = now() + interval '2 hours'
    where id = p_room_id;
    update public.coop_room_members set ready = true where room_id = p_room_id;
  elsif current_status <> 'playing' then
    raise exception 'The room is not ready to retry';
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;
