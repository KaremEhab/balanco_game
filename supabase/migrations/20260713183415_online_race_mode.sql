alter table public.coop_rooms
  add column if not exists mode text not null default 'coop'
    check (mode in ('coop', 'race')),
  add column if not exists race_level integer not null default 1
    check (race_level between 1 and 500),
  add column if not exists winner_id uuid references public.profiles(id),
  add column if not exists winner_finished_at timestamptz,
  add column if not exists winner_elapsed_ms integer
    check (winner_elapsed_ms is null or winner_elapsed_ms >= 0),
  add column if not exists winner_hearts integer
    check (winner_hearts is null or winner_hearts between 0 and 20),
  add column if not exists winner_stars integer
    check (winner_stars is null or winner_stars between 0 and 100),
  add column if not exists race_end_kind text
    check (race_end_kind in ('finish', 'surrender', 'disconnect'));

create index if not exists coop_rooms_mode_status_idx
  on public.coop_rooms(mode, status, created_at desc);

create or replace function public.create_race_room()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  new_room_id uuid;
  candidate text;
  race_seed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;

  update public.coop_rooms
  set status = 'ended', end_reason = 'leave', ended_at = now()
  where host_id = player_id and status = 'waiting';

  loop
    candidate := upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (
      select 1 from public.coop_rooms
      where room_code = candidate and expires_at > now()
    );
  end loop;

  race_seed := floor(random() * 2147483646)::integer;
  insert into public.coop_rooms(
    room_code, host_id, host_side, seed, mode, race_level
  ) values (
    candidate, player_id, 'left', race_seed, 'race', 1
  ) returning id into new_room_id;

  insert into public.coop_room_members(room_id, user_id, side)
  values (new_room_id, player_id, 'left');

  return public.get_coop_room_state(new_room_id);
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
  ) then raise exception 'Room access denied'; end if;

  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.mode <> 'race' then raise exception 'This is not a race room'; end if;

  if room.status = 'playing' and room.winner_id is null then
    elapsed := greatest(
      0,
      floor(extract(epoch from (clock_timestamp() - room.started_at - interval '4 seconds')) * 1000)::integer
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
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.surrender_race(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  opponent_id uuid;
  elapsed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then raise exception 'Room access denied'; end if;

  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.mode <> 'race' then raise exception 'This is not a race room'; end if;
  if room.status not in ('playing', 'paused') or room.winner_id is not null then
    return public.get_coop_room_state(p_room_id);
  end if;

  select user_id into opponent_id
  from public.coop_room_members
  where room_id = p_room_id and user_id <> player_id
  limit 1;
  elapsed := greatest(
    0,
    floor(extract(epoch from (clock_timestamp() - room.started_at - interval '4 seconds')) * 1000)::integer
  );

  update public.coop_rooms
  set status = 'ended',
      end_reason = case when opponent_id is null then 'leave' else 'completed' end,
      ended_at = clock_timestamp(),
      winner_id = opponent_id,
      winner_finished_at = case when opponent_id is null then null else clock_timestamp() end,
      winner_elapsed_ms = case when opponent_id is null then null else elapsed end,
      race_end_kind = 'surrender'
  where id = p_room_id;

  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.prevent_race_coop_run()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if exists (
    select 1 from public.coop_rooms
    where id = new.room_id and mode <> 'coop'
  ) then raise exception 'Co-op rewards cannot be recorded for race rooms'; end if;
  return new;
end;
$$;

drop trigger if exists prevent_race_coop_run_before_insert on public.coop_runs;
create trigger prevent_race_coop_run_before_insert
before insert on public.coop_runs
for each row execute function public.prevent_race_coop_run();

revoke all on function public.create_race_room() from public, anon;
revoke all on function public.finish_race(uuid, double precision, integer, integer)
  from public, anon;
revoke all on function public.surrender_race(uuid) from public, anon;
grant execute on function public.create_race_room() to authenticated;
grant execute on function public.finish_race(uuid, double precision, integer, integer)
  to authenticated;
grant execute on function public.surrender_race(uuid) to authenticated;
