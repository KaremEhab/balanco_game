alter table public.coop_rooms
  add column if not exists end_reason text
  check (end_reason in ('completed', 'leave'));

update public.coop_rooms r
set end_reason = case
  when exists (select 1 from public.coop_runs cr where cr.room_id = r.id)
    then 'completed'
  else 'leave'
end
where r.status = 'ended' and r.end_reason is null;

create or replace function public.mark_coop_run_completed()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.coop_rooms set end_reason = 'completed' where id = new.room_id;
  return new;
end;
$$;

drop trigger if exists mark_coop_run_completed_after_insert on public.coop_runs;
create trigger mark_coop_run_completed_after_insert
after insert on public.coop_runs
for each row execute function public.mark_coop_run_completed();

create or replace function public.clear_coop_end_reason_on_play()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.status = 'playing' then new.end_reason := null; end if;
  return new;
end;
$$;

drop trigger if exists clear_coop_end_reason_before_update on public.coop_rooms;
create trigger clear_coop_end_reason_before_update
before update of status on public.coop_rooms
for each row execute function public.clear_coop_end_reason_on_play();

create or replace function public.vote_coop_leave(
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
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then raise exception 'Room access denied'; end if;

  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.status in ('playing', 'paused') then
    update public.coop_rooms
    set status_before_vote = room.status,
        status = 'leave_vote',
        leave_requested_by = player_id
    where id = p_room_id;
  elsif room.status = 'leave_vote' and room.leave_requested_by <> player_id then
    if p_approve then
      update public.coop_rooms
      set status = 'ended', end_reason = 'leave', ended_at = now()
      where id = p_room_id;
    else
      update public.coop_rooms
      set status = coalesce(status_before_vote, 'playing'),
          status_before_vote = null,
          leave_requested_by = null
      where id = p_room_id;
    end if;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;
