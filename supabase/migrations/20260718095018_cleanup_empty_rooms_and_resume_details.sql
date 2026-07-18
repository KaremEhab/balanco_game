-- Room membership is durable so a player can recover from a short network or
-- app interruption. A room is considered empty only when every member has
-- missed the server heartbeat for two minutes.

create or replace function public.get_coop_room_state(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  checked_at timestamptz := clock_timestamp();
  result jsonb;
begin
  if player_id is null or not exists (
    select 1
    from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  -- Waiting rooms and both gameplay coordinators already poll this RPC. Keep
  -- one authoritative heartbeat for CO-OP and Race instead of trusting a
  -- client-only Realtime presence count.
  update public.coop_room_members member
  set last_seen_at = checked_at
  where member.room_id = p_room_id
    and member.user_id = player_id
    and exists (
      select 1
      from public.coop_rooms room
      where room.id = p_room_id
        and room.status in ('waiting', 'playing', 'paused', 'leave_vote')
    );

  select jsonb_build_object(
    'room', to_jsonb(r) || jsonb_build_object(
      'restart_vote_count', (
        select count(*)
        from public.coop_room_action_votes v
        where v.room_id = r.id
          and v.attempt_number = r.attempt_number
          and v.action = r.race_restart_kind
      ),
      'leave_vote_count', (
        select count(*)
        from public.coop_room_action_votes v
        where v.room_id = r.id
          and v.attempt_number = r.attempt_number
          and v.action in ('leave', 'postgame_exit')
      )
    ),
    'members', coalesce((
      select jsonb_agg(jsonb_build_object(
        'user_id', m.user_id,
        'side', m.side,
        'ready', m.ready,
        'mic_muted', m.mic_muted,
        'display_name', p.display_name,
        'player_code', p.player_code,
        'avatar_url', p.avatar_url,
        'avatar_shape', coalesce(p.avatar_shape, 'circle'),
        'race_wins', coalesce(pp.race_wins, 0),
        'session_wins', m.session_wins,
        'eliminated_at', m.eliminated_at,
        'last_seen_at', m.last_seen_at,
        'is_online', coalesce(m.last_seen_at, m.joined_at)
          >= checked_at - interval '2 minutes',
        'is_host', m.user_id = r.host_id
      ) order by case m.side
        when 'left' then 1
        when 'slot1' then 1
        when 'right' then 2
        when 'slot2' then 2
        when 'slot3' then 3
        else 4
      end)
      from public.coop_room_members m
      join public.profiles p on p.id = m.user_id
      left join public.player_progress pp on pp.user_id = m.user_id
      where m.room_id = r.id
    ), '[]'::jsonb)
  ) into result
  from public.coop_rooms r
  where r.id = p_room_id;

  return result;
end;
$$;

create or replace function public.get_my_active_game_room()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  checked_at timestamptz := clock_timestamp();
  active_room_id uuid;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  -- Clean every abandoned room while Home performs its lightweight active
  -- room lookup. This also repairs rooms left behind by older app versions.
  update public.coop_rooms room
  set status = 'ended',
      status_before_vote = null,
      leave_requested_by = null,
      end_reason = 'leave',
      ended_at = checked_at,
      race_end_kind = null,
      rematch_requested_by = null,
      race_restart_kind = null
  where room.status in ('waiting', 'playing', 'paused', 'leave_vote')
    and (
      (room.status = 'waiting' and room.expires_at <= checked_at)
      or not exists (
        select 1
        from public.coop_room_members member
        where member.room_id = room.id
          and coalesce(member.last_seen_at, member.joined_at, room.created_at)
            >= checked_at - interval '2 minutes'
      )
    );

  select room.id into active_room_id
  from public.coop_room_members member
  join public.coop_rooms room on room.id = member.room_id
  where member.user_id = player_id
    and room.status in ('waiting', 'playing', 'paused', 'leave_vote')
    and (room.status <> 'waiting' or room.expires_at > checked_at)
    and (room.mode <> 'race' or member.eliminated_at is null)
    and exists (
      select 1
      from public.coop_room_members active_member
      where active_member.room_id = room.id
        and coalesce(
          active_member.last_seen_at,
          active_member.joined_at,
          room.created_at
        ) >= checked_at - interval '2 minutes'
    )
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

create or replace function public.discard_active_game_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or not exists (
    select 1
    from public.coop_room_members member
    where member.room_id = p_room_id and member.user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  if room.mode = 'race' then
    -- Race already has correct host transfer, winner, and final-player rules.
    return public.leave_race_room(p_room_id);
  end if;

  -- A two-player CO-OP run cannot continue after one player explicitly
  -- discards it from Home, so close the shared room for both players.
  delete from public.coop_room_action_votes
  where room_id = p_room_id;

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

  return jsonb_build_object(
    'discarded', true,
    'room_id', p_room_id,
    'mode', room.mode
  );
end;
$$;

comment on function public.get_my_active_game_room() is
  'Cleans abandoned rooms, then returns the authenticated player''s newest recoverable active room.';
comment on function public.discard_active_game_room(uuid) is
  'Explicitly removes the authenticated player''s recoverable room from Home; Race uses unilateral leave and CO-OP closes the shared run.';

revoke all on function public.get_coop_room_state(uuid)
  from public, anon, authenticated;
revoke all on function public.get_my_active_game_room()
  from public, anon, authenticated;
revoke all on function public.discard_active_game_room(uuid)
  from public, anon, authenticated;

grant execute on function public.get_coop_room_state(uuid) to authenticated;
grant execute on function public.get_my_active_game_room() to authenticated;
grant execute on function public.discard_active_game_room(uuid) to authenticated;

-- Repair abandoned rooms that predate this migration immediately.
update public.coop_rooms room
set status = 'ended',
    status_before_vote = null,
    leave_requested_by = null,
    end_reason = 'leave',
    ended_at = clock_timestamp(),
    race_end_kind = null,
    rematch_requested_by = null,
    race_restart_kind = null
where room.status in ('waiting', 'playing', 'paused', 'leave_vote')
  and (
    (room.status = 'waiting' and room.expires_at <= clock_timestamp())
    or not exists (
      select 1
      from public.coop_room_members member
      where member.room_id = room.id
        and coalesce(member.last_seen_at, member.joined_at, room.created_at)
          >= clock_timestamp() - interval '2 minutes'
    )
  );
