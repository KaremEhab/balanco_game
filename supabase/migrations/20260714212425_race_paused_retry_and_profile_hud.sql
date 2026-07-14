create or replace function public.get_coop_room_state(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  result jsonb;
begin
  if player_id is null or not exists (
    select 1
    from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  select jsonb_build_object(
    'room', to_jsonb(r),
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
        'is_host', m.user_id = r.host_id
      ) order by m.side)
      from public.coop_room_members m
      join public.profiles p on p.id = m.user_id
      where m.room_id = r.id
    ), '[]'::jsonb)
  )
  into result
  from public.coop_rooms r
  where r.id = p_room_id;

  return result;
end;
$$;

create or replace function public.vote_race_restart(
  p_room_id uuid,
  p_kind text
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
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_kind not in ('retry', 'continue') then
    raise exception 'Invalid race restart choice';
  end if;
  if not exists (
    select 1
    from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  select *
  into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race' or not (
    (room.status = 'ended' and room.end_reason = 'completed')
    or (room.status = 'paused' and p_kind = 'retry')
  ) then
    raise exception 'The race is not ready to restart';
  end if;

  if room.rematch_requested_by is null then
    update public.coop_rooms
    set rematch_requested_by = player_id,
        race_restart_kind = p_kind
    where id = p_room_id;
  elsif room.rematch_requested_by = player_id then
    update public.coop_rooms
    set race_restart_kind = p_kind
    where id = p_room_id;
  else
    if room.race_restart_kind is distinct from p_kind then
      raise exception 'The players selected different restart choices';
    end if;

    update public.coop_rooms
    set status = 'playing',
        status_before_vote = null,
        leave_requested_by = null,
        rematch_requested_by = null,
        race_restart_kind = null,
        end_reason = null,
        ended_at = null,
        winner_id = null,
        winner_finished_at = null,
        winner_elapsed_ms = null,
        winner_hearts = null,
        winner_stars = null,
        race_end_kind = null,
        race_level = case
          when p_kind = 'continue' then least(race_level + 1, 500)
          else race_level
        end,
        seed = floor(random() * 2147483646)::integer,
        attempt_number = attempt_number + 1,
        started_at = clock_timestamp(),
        expires_at = now() + interval '2 hours'
    where id = p_room_id;

    update public.coop_room_members
    set ready = true
    where room_id = p_room_id;
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;
