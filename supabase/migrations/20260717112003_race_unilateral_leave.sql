create or replace function public.leave_race_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  survivor_id uuid;
  next_host_id uuid;
  remaining_members integer;
  active_racers integer;
  elapsed integer;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race' then
    raise exception 'Race room not found';
  end if;

  if not exists (
    select 1
    from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  delete from public.coop_room_action_votes
  where room_id = p_room_id and user_id = player_id;

  delete from public.coop_room_members
  where room_id = p_room_id and user_id = player_id;

  select count(*) into remaining_members
  from public.coop_room_members
  where room_id = p_room_id;

  select count(*) into active_racers
  from public.coop_room_members
  where room_id = p_room_id and eliminated_at is null;

  if room.host_id = player_id and remaining_members > 0 then
    select user_id into next_host_id
    from public.coop_room_members
    where room_id = p_room_id
    order by joined_at, user_id
    limit 1;

    update public.coop_rooms
    set host_id = next_host_id
    where id = p_room_id;
  end if;

  if remaining_members = 0 then
    update public.coop_rooms
    set status = 'ended',
        status_before_vote = null,
        leave_requested_by = null,
        end_reason = 'leave',
        ended_at = clock_timestamp(),
        race_end_kind = null,
        rematch_requested_by = null,
        race_restart_kind = null
    where id = p_room_id;
  elsif room.status = 'waiting' then
    update public.coop_rooms
    set leave_requested_by = null
    where id = p_room_id;
  elsif room.status in ('playing', 'paused', 'leave_vote')
      and room.winner_id is null then
    if active_racers = 1 then
      select user_id into survivor_id
      from public.coop_room_members
      where room_id = p_room_id and eliminated_at is null
      limit 1;

      elapsed := greatest(
        0,
        floor(
          extract(epoch from (
            clock_timestamp()
            - coalesce(room.started_at, clock_timestamp())
            - interval '4 seconds'
          )) * 1000
        )::integer
      );

      update public.coop_rooms
      set status = 'ended',
          status_before_vote = null,
          leave_requested_by = null,
          end_reason = 'completed',
          ended_at = clock_timestamp(),
          winner_id = survivor_id,
          winner_finished_at = clock_timestamp(),
          winner_elapsed_ms = elapsed,
          winner_hearts = null,
          winner_stars = null,
          race_end_kind = 'surrender',
          rematch_requested_by = null,
          race_restart_kind = null
      where id = p_room_id;

      update public.coop_room_members
      set session_wins = session_wins + 1
      where room_id = p_room_id and user_id = survivor_id;
    elsif active_racers = 0 then
      update public.coop_rooms
      set status = 'ended',
          status_before_vote = null,
          leave_requested_by = null,
          end_reason = 'leave',
          ended_at = clock_timestamp(),
          race_end_kind = null,
          rematch_requested_by = null,
          race_restart_kind = null
      where id = p_room_id;
    elsif room.status = 'leave_vote' then
      update public.coop_rooms
      set status = coalesce(room.status_before_vote, 'playing'),
          status_before_vote = null,
          leave_requested_by = null
      where id = p_room_id;
    end if;
  end if;

  return jsonb_build_object(
    'left', true,
    'room_id', p_room_id,
    'remaining_players', remaining_members,
    'race_ended', (
      select status = 'ended' from public.coop_rooms where id = p_room_id
    )
  );
end;
$$;

comment on function public.leave_race_room(uuid) is
  'Immediately removes the authenticated player from a Race room. CO-OP leave voting is intentionally unchanged.';

revoke all on function public.leave_race_room(uuid)
  from public, anon, authenticated;
grant execute on function public.leave_race_room(uuid) to authenticated;
