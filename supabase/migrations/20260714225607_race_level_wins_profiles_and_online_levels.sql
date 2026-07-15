-- Race wins are unique campaign levels, not repeatable match victories.
create table if not exists public.player_race_level_wins (
  user_id uuid not null references public.profiles(id) on delete cascade,
  level_id integer not null check (level_id between 1 and 500),
  first_won_at timestamptz not null default now(),
  best_time_ms integer check (best_time_ms is null or best_time_ms >= 0),
  best_hearts integer not null default 0 check (best_hearts between 0 and 20),
  best_stars integer not null default 0 check (best_stars between 0 and 100),
  primary key (user_id, level_id)
);

alter table public.player_race_level_wins enable row level security;

drop policy if exists "players read their race level wins"
  on public.player_race_level_wins;
create policy "players read their race level wins"
on public.player_race_level_wins
for select to authenticated
using ((select auth.uid()) = user_id);

grant select on public.player_race_level_wins to authenticated;

insert into public.player_race_level_wins (
  user_id,
  level_id,
  first_won_at,
  best_time_ms,
  best_hearts,
  best_stars
)
select
  winner_id,
  race_level,
  min(coalesce(winner_finished_at, ended_at, created_at)),
  min(winner_elapsed_ms),
  max(coalesce(winner_hearts, 0)),
  max(coalesce(winner_stars, 0))
from public.coop_rooms
where mode = 'race'
  and race_end_kind = 'finish'
  and winner_id is not null
group by winner_id, race_level
on conflict (user_id, level_id) do nothing;

update public.player_progress progress
set race_wins = wins.total,
    updated_at = now()
from (
  select user_id, count(*)::bigint as total
  from public.player_race_level_wins
  group by user_id
) wins
where wins.user_id = progress.user_id;

update public.player_progress
set race_wins = 0,
    updated_at = now()
where race_wins <> 0
  and not exists (
    select 1
    from public.player_race_level_wins wins
    where wins.user_id = player_progress.user_id
  );

-- Current published level plus immutable version history. Old versions remain
-- available so an active Race room can stay pinned to identical geometry.
create table if not exists public.game_levels (
  level_id integer primary key check (level_id between 1 and 500),
  published_version integer not null default 1 check (published_version >= 1),
  definition_format text not null default 'level_data_v1'
    check (definition_format in ('campaign_v1', 'level_data_v1')),
  coordinate_space text not null default 'normalized_v1'
    check (coordinate_space = 'normalized_v1'),
  definition jsonb not null check (jsonb_typeof(definition) = 'object'),
  updated_by uuid references public.profiles(id) on delete set null,
  updated_at timestamptz not null default now(),
  published_at timestamptz not null default now()
);

create table if not exists public.game_level_versions (
  level_id integer not null check (level_id between 1 and 500),
  version integer not null check (version >= 1),
  definition_format text not null
    check (definition_format in ('campaign_v1', 'level_data_v1')),
  coordinate_space text not null default 'normalized_v1'
    check (coordinate_space = 'normalized_v1'),
  definition jsonb not null check (jsonb_typeof(definition) = 'object'),
  published_by uuid references public.profiles(id) on delete set null,
  published_at timestamptz not null default now(),
  primary key (level_id, version)
);

alter table public.game_levels enable row level security;
alter table public.game_level_versions enable row level security;

drop policy if exists "authenticated players read published levels"
  on public.game_levels;
create policy "authenticated players read published levels"
on public.game_levels
for select to authenticated
using (true);

drop policy if exists "authenticated players read published level versions"
  on public.game_level_versions;
create policy "authenticated players read published level versions"
on public.game_level_versions
for select to authenticated
using (true);

grant select on public.game_levels, public.game_level_versions to authenticated;

create or replace function public.is_level_editor()
returns boolean
language sql
stable
set search_path = ''
as $$
  select coalesce(
    ((select auth.jwt()) -> 'app_metadata' ->> 'level_editor')::boolean,
    false
  );
$$;

create or replace function public.get_game_level(
  p_level_id integer,
  p_version integer default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  result jsonb;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  if p_level_id < 1 or p_level_id > 500 then
    raise exception 'Invalid level id';
  end if;

  if p_version is null then
    select jsonb_build_object(
      'level_id', level_id,
      'version', published_version,
      'definition_format', definition_format,
      'coordinate_space', coordinate_space,
      'definition', definition
    )
    into result
    from public.game_levels
    where level_id = p_level_id;
  else
    select jsonb_build_object(
      'level_id', level_id,
      'version', version,
      'definition_format', definition_format,
      'coordinate_space', coordinate_space,
      'definition', definition
    )
    into result
    from public.game_level_versions
    where level_id = p_level_id and version = p_version;
  end if;

  return result;
end;
$$;

create or replace function public.publish_game_level(
  p_level_id integer,
  p_definition jsonb,
  p_expected_version integer default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  current_version integer;
  next_version integer;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;
  if not public.is_level_editor() then
    raise exception 'Level editor access required';
  end if;
  if p_level_id < 1 or p_level_id > 500 then
    raise exception 'Invalid level id';
  end if;
  if jsonb_typeof(p_definition) <> 'object'
      or jsonb_typeof(p_definition -> 'holes') <> 'array'
      or jsonb_typeof(p_definition -> 'stars') <> 'array'
      or jsonb_typeof(p_definition -> 'hearts') <> 'array'
      or coalesce((p_definition ->> 'heightMultiplier')::double precision, 0) not between 1 and 5 then
    raise exception 'Invalid normalized level definition';
  end if;

  select published_version
  into current_version
  from public.game_levels
  where level_id = p_level_id
  for update;

  if current_version is null then
    if p_expected_version is not null and p_expected_version <> 0 then
      raise exception 'Level version conflict';
    end if;
    next_version := 1;
  else
    if p_expected_version is not null and p_expected_version <> current_version then
      raise exception 'Level version conflict';
    end if;
    next_version := current_version + 1;
  end if;

  insert into public.game_level_versions (
    level_id,
    version,
    definition_format,
    coordinate_space,
    definition,
    published_by
  ) values (
    p_level_id,
    next_version,
    'level_data_v1',
    'normalized_v1',
    p_definition,
    player_id
  );

  insert into public.game_levels (
    level_id,
    published_version,
    definition_format,
    coordinate_space,
    definition,
    updated_by,
    updated_at,
    published_at
  ) values (
    p_level_id,
    next_version,
    'level_data_v1',
    'normalized_v1',
    p_definition,
    player_id,
    now(),
    now()
  )
  on conflict (level_id) do update
  set published_version = excluded.published_version,
      definition_format = excluded.definition_format,
      coordinate_space = excluded.coordinate_space,
      definition = excluded.definition,
      updated_by = excluded.updated_by,
      updated_at = excluded.updated_at,
      published_at = excluded.published_at;

  return public.get_game_level(p_level_id, next_version);
end;
$$;

create or replace function public.get_player_social_profile(p_user_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  viewer_id uuid := auth.uid();
  relation public.friendships%rowtype;
  relation_status text := 'none';
  result jsonb;
begin
  if viewer_id is null then
    raise exception 'Authentication required';
  end if;
  if not exists (select 1 from public.profiles where id = p_user_id) then
    raise exception 'Player not found';
  end if;

  if viewer_id = p_user_id then
    relation_status := 'self';
  else
    select *
    into relation
    from public.friendships
    where (requester_id = viewer_id and addressee_id = p_user_id)
       or (requester_id = p_user_id and addressee_id = viewer_id)
    order by case status when 'accepted' then 0 when 'pending' then 1 else 2 end,
             updated_at desc
    limit 1;

    if relation.status = 'accepted' then
      relation_status := 'friend';
    elsif relation.status = 'pending' and relation.requester_id = viewer_id then
      relation_status := 'outgoing_pending';
    elsif relation.status = 'pending' and relation.addressee_id = viewer_id then
      relation_status := 'incoming_pending';
    end if;
  end if;

  select jsonb_build_object(
    'id', profile.id,
    'display_name', profile.display_name,
    'username', profile.username,
    'age', profile.age,
    'player_code', profile.player_code,
    'avatar_url', profile.avatar_url,
    'avatar_shape', coalesce(profile.avatar_shape, 'circle'),
    'highest_level', coalesce(progress.highest_level, 1),
    'total_points', coalesce(progress.total_points, 0),
    'infinity_high_score', coalesce(progress.infinity_high_score, 0),
    'race_wins', coalesce(progress.race_wins, 0),
    'friend_count', (
      select count(*)
      from public.friendships friends
      where profile.id in (friends.requester_id, friends.addressee_id)
        and friends.status = 'accepted'
    ),
    'friendship_status', relation_status,
    'friend_request_id', case
      when relation_status = 'incoming_pending' then relation.id
      else null
    end,
    'friends', case
      when viewer_id = profile.id then coalesce((
        select jsonb_agg(jsonb_build_object(
          'id', friend_profile.id,
          'display_name', friend_profile.display_name,
          'player_code', friend_profile.player_code,
          'avatar_url', friend_profile.avatar_url,
          'avatar_shape', coalesce(friend_profile.avatar_shape, 'circle')
        ) order by friend_profile.display_name)
        from public.friendships friends
        join public.profiles friend_profile
          on friend_profile.id = case
            when friends.requester_id = profile.id then friends.addressee_id
            else friends.requester_id
          end
        where profile.id in (friends.requester_id, friends.addressee_id)
          and friends.status = 'accepted'
      ), '[]'::jsonb)
      else '[]'::jsonb
    end
  )
  into result
  from public.profiles profile
  left join public.player_progress progress on progress.user_id = profile.id
  where profile.id = p_user_id;

  return result;
end;
$$;

alter table public.coop_rooms
  add column if not exists race_level_version integer
  check (race_level_version is null or race_level_version >= 1);

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
  level_version integer;
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

  select published_version into level_version
  from public.game_levels where level_id = 1;
  race_seed := floor(random() * 2147483646)::integer;

  insert into public.coop_rooms(
    room_code,
    host_id,
    host_side,
    seed,
    mode,
    race_level,
    race_level_version
  ) values (
    candidate,
    player_id,
    'left',
    race_seed,
    'race',
    1,
    level_version
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
  next_level integer;
  next_version integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_kind not in ('retry', 'continue') then
    raise exception 'Invalid race restart choice';
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

    next_level := case
      when p_kind = 'continue' then least(room.race_level + 1, 500)
      else room.race_level
    end;
    if p_kind = 'continue' then
      select published_version into next_version
      from public.game_levels where level_id = next_level;
    else
      next_version := room.race_level_version;
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
        race_level = next_level,
        race_level_version = next_version,
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

revoke all on function public.is_level_editor() from public, anon;
revoke all on function public.get_game_level(integer, integer) from public, anon;
revoke all on function public.publish_game_level(integer, jsonb, integer)
  from public, anon;
revoke all on function public.get_player_social_profile(uuid) from public, anon;

grant execute on function public.is_level_editor() to authenticated;
grant execute on function public.get_game_level(integer, integer)
  to authenticated;
grant execute on function public.publish_game_level(integer, jsonb, integer)
  to authenticated;
grant execute on function public.get_player_social_profile(uuid)
  to authenticated;
