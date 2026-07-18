-- CO-OP campaign rooms reuse the authoritative level/version columns that
-- already synchronize Race rooms. Race series still require an odd number of
-- rounds; cooperative runs may contain any inclusive range.
alter table public.coop_rooms
  drop constraint if exists coop_rooms_race_series_range_check;

alter table public.coop_rooms
  add constraint coop_rooms_level_range_check check (
    race_start_level between 1 and 500
    and race_end_level between race_start_level and 500
    and (mode <> 'race' or mod(race_end_level - race_start_level + 1, 2) = 1)
  );

alter table public.coop_rooms
  drop constraint if exists coop_rooms_end_reason_check;

alter table public.coop_rooms
  add constraint coop_rooms_end_reason_check check (
    end_reason is null
    or end_reason in ('completed', 'game_over', 'leave', 'forfeit')
  );

create or replace function public.configure_coop_series(
  p_room_id uuid,
  p_start_level integer,
  p_end_level integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  highest_unlocked integer;
  first_version integer;
  available_levels integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'coop' or room.status <> 'waiting'
      or room.host_id <> player_id then
    raise exception 'Only the waiting-room host can choose the CO-OP levels';
  end if;
  if p_start_level is null or p_end_level is null
      or p_start_level < 1 or p_end_level < p_start_level
      or p_end_level > 500 then
    raise exception 'Choose an inclusive level range between 1 and 500';
  end if;

  select coalesce(progress.highest_level, 1)
  into highest_unlocked
  from public.profiles profile
  left join public.player_progress progress on progress.user_id = profile.id
  where profile.id = player_id;
  highest_unlocked := coalesce(highest_unlocked, 1);
  if p_end_level > highest_unlocked then
    raise exception 'You can only choose levels you have unlocked';
  end if;

  select count(*) into available_levels
  from public.game_levels
  where level_id between p_start_level and p_end_level
    and published_version is not null;
  if available_levels <> p_end_level - p_start_level + 1 then
    raise exception 'One or more selected levels are unavailable';
  end if;
  select published_version into first_version
  from public.game_levels
  where level_id = p_start_level;

  delete from public.coop_room_action_votes where room_id = p_room_id;
  update public.coop_rooms
  set race_start_level = p_start_level,
      race_end_level = p_end_level,
      race_level = p_start_level,
      race_level_version = first_version,
      rematch_requested_by = null,
      race_restart_kind = null,
      series_winner_id = null,
      series_end_kind = null,
      series_finished_at = null,
      series_scored_attempt = 0
  where id = p_room_id;
  update public.coop_room_members
  set ready = false
  where room_id = p_room_id;

  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.start_coop_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  target public.coop_rooms%rowtype;
  member_count integer;
  host_highest integer;
  first_version integer;
  available_levels integer;
begin
  select * into target
  from public.coop_rooms
  where id = p_room_id
  for update;
  if target.id is null or target.host_id <> auth.uid()
      or target.status <> 'waiting' then
    raise exception 'Only the host can start';
  end if;

  select count(*) into member_count
  from public.coop_room_members
  where room_id = p_room_id and left_at is null;
  if (target.mode = 'coop' and member_count <> 2)
      or (target.mode = 'race' and member_count <> target.max_players)
      or exists (
        select 1 from public.coop_room_members
        where room_id = p_room_id and left_at is null and not ready
      ) then
    raise exception 'Every selected player must be present and ready';
  end if;

  select coalesce(progress.highest_level, 1)
  into host_highest
  from public.profiles profile
  left join public.player_progress progress on progress.user_id = profile.id
  where profile.id = target.host_id;
  host_highest := coalesce(host_highest, 1);
  if target.race_end_level > host_highest then
    raise exception 'The host has not unlocked every selected level';
  end if;

  select count(*) into available_levels
  from public.game_levels
  where level_id between target.race_start_level and target.race_end_level
    and published_version is not null;
  if available_levels <> target.race_end_level - target.race_start_level + 1 then
    raise exception 'One or more selected levels are unavailable';
  end if;
  select published_version into first_version
  from public.game_levels
  where level_id = target.race_start_level;

  delete from public.coop_room_action_votes where room_id = p_room_id;
  update public.coop_rooms
  set race_level = target.race_start_level,
      race_level_version = first_version,
      series_winner_id = null,
      series_end_kind = null,
      series_finished_at = null,
      series_scored_attempt = 0,
      rematch_requested_by = null,
      race_restart_kind = null,
      status = 'playing',
      end_reason = null,
      started_at = clock_timestamp(),
      ended_at = null
  where id = p_room_id;
  update public.coop_room_members
  set last_seen_at = clock_timestamp(),
      eliminated_at = null,
      session_wins = 0,
      series_stars = 0
  where room_id = p_room_id and left_at is null;

  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.vote_coop_postgame_exit(
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
  vote_count integer;
  member_count integer;
begin
  if player_id is null or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id and left_at is null
  ) then
    raise exception 'Room access denied';
  end if;
  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;
  if room.status <> 'ended'
      or room.end_reason not in ('completed', 'game_over') then
    raise exception 'Post-game exit is not available';
  end if;

  if room.leave_requested_by is null then
    update public.coop_rooms
    set leave_requested_by = player_id
    where id = p_room_id;
    insert into public.coop_room_action_votes(
      room_id, user_id, attempt_number, action
    ) values (
      p_room_id, player_id, room.attempt_number, 'postgame_exit'
    ) on conflict do nothing;
  elsif not p_approve then
    delete from public.coop_room_action_votes
    where room_id = p_room_id
      and attempt_number = room.attempt_number
      and action = 'postgame_exit';
    update public.coop_rooms
    set leave_requested_by = null
    where id = p_room_id;
    return public.get_coop_room_state(p_room_id);
  else
    insert into public.coop_room_action_votes(
      room_id, user_id, attempt_number, action
    ) values (
      p_room_id, player_id, room.attempt_number, 'postgame_exit'
    ) on conflict do nothing;
  end if;

  select count(*) into vote_count
  from public.coop_room_action_votes vote
  where vote.room_id = p_room_id
    and vote.attempt_number = room.attempt_number
    and vote.action = 'postgame_exit'
    and exists (
      select 1 from public.coop_room_members member
      where member.room_id = vote.room_id
        and member.user_id = vote.user_id
        and member.left_at is null
    );
  select count(*) into member_count
  from public.coop_room_members
  where room_id = p_room_id and left_at is null;
  if vote_count = member_count then
    update public.coop_rooms
    set end_reason = 'leave', leave_requested_by = null
    where id = p_room_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.complete_coop_level(
  p_room_id uuid,
  p_points integer,
  p_stars integer,
  p_coins integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  room public.coop_rooms%rowtype;
  member record;
  run_id uuid;
  new_coin_balance bigint;
begin
  if p_points < 0 or p_stars not between 0 and 3 or p_coins < 0 then
    raise exception 'Invalid CO-OP level result';
  end if;
  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;
  if room.id is null or room.mode <> 'coop' or room.host_id <> auth.uid() then
    raise exception 'Only the CO-OP host can complete the shared level';
  end if;
  if room.status <> 'playing' then
    return public.get_coop_room_state(p_room_id);
  end if;

  insert into public.coop_runs(room_id, attempt_number, score, coins)
  values (p_room_id, room.attempt_number, p_points, p_coins)
  on conflict (room_id, attempt_number) do nothing
  returning id into run_id;

  if run_id is not null then
    update public.coop_rooms
    set status = 'ended',
        end_reason = 'completed',
        score = score + p_points,
        ended_at = clock_timestamp(),
        rematch_requested_by = null,
        race_restart_kind = null
    where id = p_room_id;

    for member in
      select user_id
      from public.coop_room_members
      where room_id = p_room_id and left_at is null
    loop
      insert into public.game_attempts(
        user_id, client_attempt_id, level_id, result, points, stars
      ) values (
        member.user_id, gen_random_uuid(), room.race_level,
        'victory', p_points, p_stars
      );
      insert into public.player_level_progress(
        user_id, level_id, stars, best_points, passed
      ) values (
        member.user_id, room.race_level, p_stars, p_points, true
      )
      on conflict (user_id, level_id) do update set
        stars = greatest(public.player_level_progress.stars, excluded.stars),
        best_points = greatest(
          public.player_level_progress.best_points,
          excluded.best_points
        ),
        passed = true,
        updated_at = now();
      update public.player_progress
      set highest_level = greatest(
            highest_level,
            least(500, room.race_level + 1)
          ),
          last_played_level = room.race_level,
          total_points = total_points + p_points,
          updated_at = now()
      where user_id = member.user_id;

      update public.player_wallets
      set coins = coins + p_coins,
          updated_at = now()
      where user_id = member.user_id
      returning coins into new_coin_balance;
      if p_coins > 0 then
        insert into public.wallet_transactions(
          user_id, currency, amount, balance_after, reason, reference_id
        ) values (
          member.user_id,
          'coins',
          p_coins,
          new_coin_balance,
          'coop_level',
          'coop-level:' || p_room_id::text || ':' || room.attempt_number::text
        ) on conflict (user_id, currency, reference_id) do nothing;
      end if;

      if room.race_level + 1 = any(
        array[11,16,46,76,106,136,166,196,226,256,286,316,346,376,406,436,466,496]
      ) then
        insert into public.player_unlocks(user_id, unlock_type, item_key, source)
        values (
          member.user_id,
          'ball_color',
          'biome_' || (room.race_level + 1)::text,
          'coop_level_reward'
        ) on conflict do nothing;
      end if;
      if room.race_level = any(array[100,250,500]) then
        insert into public.player_unlocks(user_id, unlock_type, item_key, source)
        values (
          member.user_id,
          'ball_shape',
          case room.race_level
            when 100 then 'comet'
            when 250 then 'crystal'
            else 'crown'
          end,
          'coop_level_reward'
        ) on conflict do nothing;
      end if;
    end loop;
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.fail_coop_level(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  room public.coop_rooms%rowtype;
  member record;
  new_sparks smallint;
begin
  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;
  if room.id is null or room.mode <> 'coop' or room.host_id <> auth.uid() then
    raise exception 'Only the CO-OP host can finish the shared attempt';
  end if;
  if room.status <> 'playing' then
    return public.get_coop_room_state(p_room_id);
  end if;

  update public.coop_rooms
  set status = 'ended',
      end_reason = 'game_over',
      ended_at = clock_timestamp(),
      rematch_requested_by = null,
      race_restart_kind = null
  where id = p_room_id;

  for member in
    select user_id
    from public.coop_room_members
    where room_id = p_room_id and left_at is null
  loop
    update public.player_wallets
    set sparks = max_sparks,
        sparks_refreshed_on = current_date,
        updated_at = now()
    where user_id = member.user_id and sparks_refreshed_on < current_date;
    insert into public.game_attempts(
      user_id, client_attempt_id, level_id, result, points, stars
    ) values (
      member.user_id, gen_random_uuid(), room.race_level, 'game_over', 0, 0
    );
    update public.player_wallets
    set sparks = greatest(0, sparks - 1),
        updated_at = now()
    where user_id = member.user_id
    returning sparks into new_sparks;
    insert into public.wallet_transactions(
      user_id, currency, amount, balance_after, reason, reference_id
    ) values (
      member.user_id,
      'sparks',
      -1,
      new_sparks,
      'coop_game_over',
      'coop-game-over:' || p_room_id::text || ':' || room.attempt_number::text
    ) on conflict (user_id, currency, reference_id) do nothing;
  end loop;

  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.vote_coop_level_restart(
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
  vote_count integer;
  member_count integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_kind not in ('retry', 'continue') then
    raise exception 'Invalid CO-OP restart choice';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id and left_at is null
  ) then
    raise exception 'Room access denied';
  end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;
  if room.id is null or room.mode <> 'coop' or room.status <> 'ended' then
    raise exception 'The CO-OP level is not ready to restart';
  end if;
  if p_kind = 'continue' and not (
    room.end_reason = 'completed' and room.race_level < room.race_end_level
  ) then
    raise exception 'There is no next CO-OP level in this run';
  end if;
  if p_kind = 'retry' and room.end_reason <> 'game_over' then
    raise exception 'Only a failed CO-OP level can be retried';
  end if;
  if room.race_restart_kind is not null and room.race_restart_kind <> p_kind then
    raise exception 'Your partner proposed a different shared action';
  end if;

  delete from public.coop_room_action_votes
  where room_id = p_room_id
    and user_id = player_id
    and attempt_number = room.attempt_number
    and action in ('retry', 'continue');
  insert into public.coop_room_action_votes(
    room_id, user_id, attempt_number, action
  ) values (
    p_room_id, player_id, room.attempt_number, p_kind
  );
  update public.coop_rooms
  set rematch_requested_by = coalesce(rematch_requested_by, player_id),
      race_restart_kind = p_kind
  where id = p_room_id;

  select count(*) into vote_count
  from public.coop_room_action_votes vote
  where vote.room_id = p_room_id
    and vote.attempt_number = room.attempt_number
    and vote.action = p_kind
    and exists (
      select 1 from public.coop_room_members member
      where member.room_id = vote.room_id
        and member.user_id = vote.user_id
        and member.left_at is null
    );
  select count(*) into member_count
  from public.coop_room_members
  where room_id = p_room_id and left_at is null;

  if vote_count = member_count then
    next_level := case
      when p_kind = 'continue' then room.race_level + 1
      else room.race_level
    end;
    select published_version into next_version
    from public.game_levels
    where level_id = next_level;
    if next_version is null then raise exception 'The next level is unavailable'; end if;

    delete from public.coop_room_action_votes where room_id = p_room_id;
    update public.coop_rooms
    set status = 'playing',
        status_before_vote = null,
        leave_requested_by = null,
        rematch_requested_by = null,
        race_restart_kind = null,
        end_reason = null,
        ended_at = null,
        race_level = next_level,
        race_level_version = next_version,
        seed = floor(random() * 2147483646)::integer,
        attempt_number = attempt_number + 1,
        started_at = clock_timestamp(),
        expires_at = now() + interval '2 hours'
    where id = p_room_id;
    update public.coop_room_members
    set ready = true,
        last_seen_at = clock_timestamp()
    where room_id = p_room_id and left_at is null;
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

-- Compatibility endpoints used by older clients now follow the shared vote
-- and campaign failure rules instead of restarting or rewarding unilaterally.
create or replace function public.retry_coop_room(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
begin
  return public.vote_coop_level_restart(p_room_id, 'retry');
end;
$$;

create or replace function public.complete_coop_run(
  p_room_id uuid,
  p_score integer,
  p_coins integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_score < 0 or p_coins < 0 then raise exception 'Invalid CO-OP result'; end if;
  return public.fail_coop_level(p_room_id);
end;
$$;

revoke all on function public.configure_coop_series(uuid, integer, integer)
from public, anon, authenticated;
revoke all on function public.complete_coop_level(uuid, integer, integer, integer)
from public, anon, authenticated;
revoke all on function public.fail_coop_level(uuid)
from public, anon, authenticated;
revoke all on function public.vote_coop_level_restart(uuid, text)
from public, anon, authenticated;
revoke all on function public.retry_coop_room(uuid)
from public, anon, authenticated;
revoke all on function public.complete_coop_run(uuid, integer, integer)
from public, anon, authenticated;
revoke all on function public.start_coop_room(uuid)
from public, anon, authenticated;
revoke all on function public.vote_coop_postgame_exit(uuid, boolean)
from public, anon, authenticated;

grant execute on function public.configure_coop_series(uuid, integer, integer)
to authenticated;
grant execute on function public.complete_coop_level(uuid, integer, integer, integer)
to authenticated;
grant execute on function public.fail_coop_level(uuid)
to authenticated;
grant execute on function public.vote_coop_level_restart(uuid, text)
to authenticated;
grant execute on function public.retry_coop_room(uuid)
to authenticated;
grant execute on function public.complete_coop_run(uuid, integer, integer)
to authenticated;
grant execute on function public.start_coop_room(uuid)
to authenticated;
grant execute on function public.vote_coop_postgame_exit(uuid, boolean)
to authenticated;
