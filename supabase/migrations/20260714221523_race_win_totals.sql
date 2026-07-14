alter table public.player_progress
  add column if not exists race_wins bigint not null default 0
  check (race_wins >= 0);

with historical_wins as (
  select winner_id as user_id, count(*)::bigint as total
  from public.coop_rooms
  where mode = 'race'
    and status = 'ended'
    and race_end_kind = 'finish'
    and winner_id is not null
  group by winner_id
)
update public.player_progress progress
set race_wins = historical_wins.total,
    updated_at = now()
from historical_wins
where progress.user_id = historical_wins.user_id
  and progress.race_wins = 0;

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
        'race_wins', coalesce(pp.race_wins, 0),
        'is_host', m.user_id = r.host_id
      ) order by m.side)
      from public.coop_room_members m
      join public.profiles p on p.id = m.user_id
      left join public.player_progress pp on pp.user_id = m.user_id
      where m.room_id = r.id
    ), '[]'::jsonb)
  )
  into result
  from public.coop_rooms r
  where r.id = p_room_id;

  return result;
end;
$$;

create or replace function public.finish_race(
  p_room_id uuid,
  p_progress double precision,
  p_hearts integer,
  p_stars integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  elapsed integer;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if p_progress < 0.98 or p_progress > 1.001 then
    raise exception 'Finish position is not valid';
  end if;
  if p_hearts < 0 or p_hearts > 20 or p_stars < 0 or p_stars > 100 then
    raise exception 'Race result is not valid';
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

  if room.mode <> 'race' then
    raise exception 'This is not a race room';
  end if;

  if room.status = 'playing' and room.winner_id is null then
    elapsed := greatest(
      0,
      floor(extract(epoch from (
        clock_timestamp() - room.started_at - interval '4 seconds'
      )) * 1000)::integer
    );

    update public.coop_rooms
    set status = 'ended',
        end_reason = 'completed',
        ended_at = clock_timestamp(),
        winner_id = player_id,
        winner_finished_at = clock_timestamp(),
        winner_elapsed_ms = elapsed,
        winner_hearts = p_hearts,
        winner_stars = p_stars,
        race_end_kind = 'finish'
    where id = p_room_id;

    insert into public.player_progress (user_id, race_wins, updated_at)
    values (player_id, 1, now())
    on conflict (user_id) do update
    set race_wins = public.player_progress.race_wins + 1,
        updated_at = now();
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;
