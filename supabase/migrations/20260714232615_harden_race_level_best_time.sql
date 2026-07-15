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
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_progress < 0.98 or p_progress > 1.001 then
    raise exception 'Finish position is not valid';
  end if;
  if p_hearts < 0 or p_hearts > 20 or p_stars < 0 or p_stars > 100 then
    raise exception 'Race result is not valid';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then
    raise exception 'Room access denied';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.mode <> 'race' then raise exception 'This is not a race room'; end if;

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

    insert into public.player_race_level_wins (
      user_id,
      level_id,
      first_won_at,
      best_time_ms,
      best_hearts,
      best_stars
    ) values (
      player_id,
      room.race_level,
      now(),
      elapsed,
      p_hearts,
      p_stars
    )
    on conflict (user_id, level_id) do update
    set best_time_ms = case
          when public.player_race_level_wins.best_time_ms is null
            then excluded.best_time_ms
          else least(
            public.player_race_level_wins.best_time_ms,
            excluded.best_time_ms
          )
        end,
        best_hearts = greatest(
          public.player_race_level_wins.best_hearts,
          excluded.best_hearts
        ),
        best_stars = greatest(
          public.player_race_level_wins.best_stars,
          excluded.best_stars
        );

    insert into public.player_progress (user_id, race_wins, updated_at)
    values (player_id, 1, now())
    on conflict (user_id) do update
    set race_wins = (
          select count(*)
          from public.player_race_level_wins
          where user_id = player_id
        ),
        updated_at = now();
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on function public.finish_race(uuid, double precision, integer, integer)
  from public;
revoke all on function public.finish_race(uuid, double precision, integer, integer)
  from anon;
grant execute on function public.finish_race(uuid, double precision, integer, integer)
  to authenticated;

