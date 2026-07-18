alter table public.coop_rooms
  add column if not exists race_start_level integer not null default 1,
  add column if not exists race_end_level integer not null default 1,
  add column if not exists series_winner_id uuid references public.profiles(id),
  add column if not exists series_end_kind text,
  add column if not exists series_finished_at timestamptz,
  add column if not exists series_scored_attempt integer not null default 0;

alter table public.coop_room_members
  add column if not exists series_stars integer not null default 0;

update public.coop_rooms
set race_start_level = race_level,
    race_end_level = race_level
where mode = 'race'
  and race_start_level = 1
  and race_end_level = 1
  and race_level <> 1;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'coop_rooms_race_series_range_check'
  ) then
    alter table public.coop_rooms
      add constraint coop_rooms_race_series_range_check check (
        race_start_level between 1 and 500
        and race_end_level between race_start_level and 500
        and mod(race_end_level - race_start_level + 1, 2) = 1
      );
  end if;
  if not exists (
    select 1 from pg_constraint
    where conname = 'coop_rooms_series_end_kind_check'
  ) then
    alter table public.coop_rooms
      add constraint coop_rooms_series_end_kind_check
      check (series_end_kind is null or series_end_kind in ('winner', 'draw'));
  end if;
end
$$;

create or replace function public.finalize_race_series_if_needed(p_room_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  room public.coop_rooms%rowtype;
  top_points integer;
  top_stars integer;
  leaders integer;
  champion uuid;
  active_count integer;
begin
  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race'
      or room.status <> 'ended'
      or room.end_reason not in ('completed', 'forfeit') then
    return;
  end if;

  if room.series_scored_attempt < room.attempt_number then
    update public.coop_room_members member
    set series_stars = member.series_stars + (
      select count(*)::integer
      from public.race_pickup_claims claim
      where claim.room_id = p_room_id
        and claim.attempt_number = room.attempt_number
        and claim.race_level = room.race_level
        and claim.pickup_type = 'star'
        and claim.claimant_id = member.user_id
    )
    where member.room_id = p_room_id;

    update public.coop_rooms
    set series_scored_attempt = room.attempt_number
    where id = p_room_id;
  end if;

  select count(*) into active_count
  from public.coop_room_members member
  where member.room_id = p_room_id
    and member.left_at is null
    and member.eliminated_at is null;

  if room.race_level < room.race_end_level and active_count > 1 then
    return;
  end if;

  if active_count = 1 and room.race_end_kind in ('surrender', 'disconnect') then
    select member.user_id into champion
    from public.coop_room_members member
    where member.room_id = p_room_id
      and member.left_at is null
      and member.eliminated_at is null
    limit 1;
    update public.coop_rooms
    set series_winner_id = champion,
        series_end_kind = 'winner',
        series_finished_at = coalesce(series_finished_at, clock_timestamp())
    where id = p_room_id;
    return;
  end if;

  select max(member.session_wins)
  into top_points
  from public.coop_room_members member
  where member.room_id = p_room_id
    and member.left_at is null
    and member.eliminated_at is null;

  select max(member.series_stars)
  into top_stars
  from public.coop_room_members member
  where member.room_id = p_room_id
    and member.left_at is null
    and member.eliminated_at is null
    and member.session_wins = top_points;

  select count(*), min(member.user_id)
  into leaders, champion
  from public.coop_room_members member
  where member.room_id = p_room_id
    and member.left_at is null
    and member.eliminated_at is null
    and member.session_wins = top_points
    and member.series_stars = top_stars;

  update public.coop_rooms
  set series_winner_id = case when leaders = 1 then champion else null end,
      series_end_kind = case when leaders = 1 then 'winner' else 'draw' end,
      series_finished_at = coalesce(series_finished_at, clock_timestamp())
  where id = p_room_id;
end;
$$;

revoke all on function public.finalize_race_series_if_needed(uuid)
from public, anon, authenticated;

create or replace function public.configure_race_series(
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
  level_version integer;
  available_levels integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.id is null or room.mode <> 'race' or room.status <> 'waiting'
      or room.host_id <> player_id then
    raise exception 'Only the waiting-room host can choose the race levels';
  end if;
  if p_start_level is null or p_end_level is null
      or p_start_level < 1 or p_end_level < p_start_level
      or p_end_level > 500
      or mod(p_end_level - p_start_level + 1, 2) <> 1 then
    raise exception 'Choose an odd inclusive range of 1, 3, 5, or more levels';
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

  select count(*), max(published_version)
  into available_levels, level_version
  from public.game_levels
  where level_id between p_start_level and p_end_level;
  if available_levels <> p_end_level - p_start_level + 1 then
    raise exception 'One or more selected levels are unavailable';
  end if;
  select published_version into level_version
  from public.game_levels where level_id = p_start_level;

  update public.coop_rooms
  set race_start_level = p_start_level,
      race_end_level = p_end_level,
      race_level = p_start_level,
      race_level_version = level_version,
      series_winner_id = null,
      series_end_kind = null,
      series_finished_at = null,
      series_scored_attempt = 0
  where id = p_room_id;
  update public.coop_room_members
  set ready = false, session_wins = 0, series_stars = 0
  where room_id = p_room_id;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.transfer_race_host(
  p_room_id uuid,
  p_new_host_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  room public.coop_rooms%rowtype;
  new_host_highest integer;
  first_version integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.id is null or room.mode <> 'race' or room.status <> 'waiting'
      or room.host_id <> player_id then
    raise exception 'Only the current waiting-room host can transfer the lead';
  end if;
  if p_new_host_id = player_id or not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = p_new_host_id and left_at is null
  ) then
    raise exception 'Choose another player who is in this room';
  end if;

  select coalesce(progress.highest_level, 1)
  into new_host_highest
  from public.profiles profile
  left join public.player_progress progress on progress.user_id = profile.id
  where profile.id = p_new_host_id;
  new_host_highest := coalesce(new_host_highest, 1);

  update public.coop_rooms set host_id = p_new_host_id where id = p_room_id;
  if room.race_end_level > new_host_highest then
    select published_version into first_version
    from public.game_levels where level_id = 1;
    update public.coop_rooms
    set race_start_level = 1, race_end_level = 1, race_level = 1,
        race_level_version = first_version,
        series_winner_id = null, series_end_kind = null,
        series_finished_at = null, series_scored_attempt = 0
    where id = p_room_id;
  end if;
  update public.coop_room_members
  set ready = false, session_wins = 0, series_stars = 0
  where room_id = p_room_id;
  return public.get_coop_room_state(p_room_id);
end;
$$;

create or replace function public.create_race_room(p_max_players integer default 2)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  player_id uuid := auth.uid(); new_room_id uuid; candidate text; level_version integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_max_players not between 2 and 4 then raise exception 'Race rooms support 2 to 4 players'; end if;
  update public.coop_rooms set status='ended', end_reason='leave', ended_at=now()
  where host_id=player_id and status='waiting';
  loop
    candidate := upper(substr(md5(random()::text || clock_timestamp()::text),1,6));
    exit when not exists(select 1 from public.coop_rooms where room_code=candidate and expires_at>now());
  end loop;
  select published_version into level_version from public.game_levels where level_id=1;
  insert into public.coop_rooms(room_code,host_id,host_side,seed,mode,race_level,
    race_level_version,max_players,race_start_level,race_end_level)
  values(candidate,player_id,'left',floor(random()*2147483646)::integer,'race',1,
    level_version,p_max_players,1,1) returning id into new_room_id;
  insert into public.coop_room_members(room_id,user_id,side) values(new_room_id,player_id,'slot1');
  return public.get_coop_room_state(new_room_id);
end; $$;

create or replace function public.start_coop_room(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare target public.coop_rooms%rowtype; member_count integer; host_highest integer; first_version integer;
begin
  select * into target from public.coop_rooms where id=p_room_id for update;
  if target.id is null or target.host_id<>auth.uid() or target.status<>'waiting' then
    raise exception 'Only the host can start'; end if;
  select count(*) into member_count from public.coop_room_members where room_id=p_room_id;
  if (target.mode='coop' and member_count<>2)
      or (target.mode='race' and member_count<>target.max_players)
      or exists(select 1 from public.coop_room_members where room_id=p_room_id and not ready) then
    raise exception 'Every selected player must be present and ready'; end if;
  if target.mode='race' then
    select coalesce(highest_level,1) into host_highest from public.player_progress where user_id=target.host_id;
    if target.race_end_level > coalesce(host_highest,1) then
      raise exception 'The host has not unlocked every selected level'; end if;
    select published_version into first_version from public.game_levels where level_id=target.race_start_level;
    update public.coop_rooms set race_level=target.race_start_level,
      race_level_version=first_version, series_winner_id=null, series_end_kind=null,
      series_finished_at=null, series_scored_attempt=0 where id=p_room_id;
    update public.coop_room_members set session_wins=0, series_stars=0 where room_id=p_room_id;
  end if;
  update public.coop_rooms set status='playing', started_at=clock_timestamp() where id=p_room_id;
  update public.coop_room_members set last_seen_at=clock_timestamp(), eliminated_at=null where room_id=p_room_id;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.get_coop_room_state(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare player_id uuid:=auth.uid(); checked_at timestamptz:=clock_timestamp(); result jsonb;
begin
  if player_id is null or not exists(select 1 from public.coop_room_members where room_id=p_room_id and user_id=player_id)
    then raise exception 'Room access denied'; end if;
  update public.coop_room_members member set last_seen_at=checked_at
  where member.room_id=p_room_id and member.user_id=player_id and member.left_at is null
    and exists(select 1 from public.coop_rooms room where room.id=p_room_id and room.status in ('waiting','playing','paused','leave_vote'));
  select jsonb_build_object(
    'room',to_jsonb(r)||jsonb_build_object(
      'restart_vote_count',(select count(*) from public.coop_room_action_votes vote where vote.room_id=r.id and vote.attempt_number=r.attempt_number and vote.action=r.race_restart_kind),
      'leave_vote_count',(select count(*) from public.coop_room_action_votes vote where vote.room_id=r.id and vote.attempt_number=r.attempt_number and vote.action in ('leave','postgame_exit'))),
    'members',coalesce((select jsonb_agg(jsonb_build_object(
      'user_id',member.user_id,'side',member.side,'ready',member.ready,'mic_muted',member.mic_muted,
      'display_name',profile.display_name,'player_code',profile.player_code,'avatar_url',profile.avatar_url,
      'avatar_shape',coalesce(profile.avatar_shape,'circle'),'race_wins',coalesce(progress.race_wins,0),
      'highest_level',coalesce(progress.highest_level,1),'session_wins',member.session_wins,
      'series_stars',member.series_stars,'eliminated_at',member.eliminated_at,'left_at',member.left_at,
      'last_seen_at',member.last_seen_at,'is_online',member.left_at is null and coalesce(member.last_seen_at,member.joined_at)>=checked_at-interval '2 minutes',
      'is_host',member.user_id=r.host_id) order by case member.side when 'left' then 1 when 'slot1' then 1 when 'right' then 2 when 'slot2' then 2 when 'slot3' then 3 else 4 end)
      from public.coop_room_members member join public.profiles profile on profile.id=member.user_id
      left join public.player_progress progress on progress.user_id=member.user_id where member.room_id=r.id),'[]'::jsonb),
    'race_pickup_claims',coalesce((select jsonb_agg(jsonb_build_object(
      'pickup_key',claim.pickup_key,'pickup_type',claim.pickup_type,'claimant_id',claim.claimant_id,
      'claimant_name',profile.display_name,'claimed_at',claim.claimed_at) order by claim.claimed_at,claim.pickup_key)
      from public.race_pickup_claims claim join public.profiles profile on profile.id=claim.claimant_id
      where claim.room_id=r.id and claim.attempt_number=r.attempt_number and claim.race_level=r.race_level),'[]'::jsonb)
  ) into result from public.coop_rooms r where r.id=p_room_id;
  return result;
end; $$;

create or replace function public.finish_race(p_room_id uuid,p_progress double precision,p_hearts integer,p_stars integer)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare player_id uuid:=auth.uid(); room public.coop_rooms%rowtype; elapsed integer; authoritative_stars integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_progress<0.98 or p_progress>1.001 then raise exception 'Finish position is not valid'; end if;
  if p_hearts<0 or p_hearts>20 then raise exception 'Race result is not valid'; end if;
  if not exists(select 1 from public.coop_room_members where room_id=p_room_id and user_id=player_id and eliminated_at is null and left_at is null)
    then raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id=p_room_id for update;
  if room.mode<>'race' then raise exception 'This is not a race room'; end if;
  select count(*)::integer into authoritative_stars from public.race_pickup_claims claim
  where claim.room_id=p_room_id and claim.attempt_number=room.attempt_number and claim.race_level=room.race_level
    and claim.pickup_type='star' and claim.claimant_id=player_id;
  if room.status='playing' and room.winner_id is null then
    elapsed:=greatest(0,floor(extract(epoch from(clock_timestamp()-room.started_at-interval '4 seconds'))*1000)::integer);
    update public.coop_rooms set status='ended',end_reason='completed',ended_at=clock_timestamp(),winner_id=player_id,
      winner_finished_at=clock_timestamp(),winner_elapsed_ms=elapsed,winner_hearts=p_hearts,winner_stars=authoritative_stars,
      race_end_kind='finish' where id=p_room_id;
    update public.coop_room_members set session_wins=session_wins+1 where room_id=p_room_id and user_id=player_id;
    insert into public.player_race_level_wins(user_id,level_id,first_won_at,best_time_ms,best_hearts,best_stars)
    values(player_id,room.race_level,now(),elapsed,p_hearts,authoritative_stars)
    on conflict(user_id,level_id) do update set
      best_time_ms=case when public.player_race_level_wins.best_time_ms is null then excluded.best_time_ms
        else least(public.player_race_level_wins.best_time_ms,excluded.best_time_ms) end,
      best_hearts=greatest(public.player_race_level_wins.best_hearts,excluded.best_hearts),
      best_stars=greatest(public.player_race_level_wins.best_stars,excluded.best_stars);
    perform public.finalize_race_series_if_needed(p_room_id);
  end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.draw_race(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare player_id uuid:=auth.uid(); room public.coop_rooms%rowtype;
begin
  if player_id is null or not exists(select 1 from public.coop_room_members where room_id=p_room_id and user_id=player_id and left_at is null)
    then raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id=p_room_id for update;
  if room.id is null then raise exception 'Room not found'; end if;
  if room.mode<>'race' then raise exception 'This is not a race room'; end if;
  if room.status not in ('playing','paused') or room.winner_id is not null then return public.get_coop_room_state(p_room_id); end if;
  update public.coop_room_members set session_wins=session_wins+1
  where room_id=p_room_id and left_at is null and eliminated_at is null;
  update public.coop_rooms set status='ended',ended_at=clock_timestamp(),end_reason='completed',race_end_kind='draw',
    winner_id=null,winner_finished_at=null,winner_elapsed_ms=null,winner_hearts=null,winner_stars=null,
    status_before_vote=null,leave_requested_by=null where id=p_room_id;
  perform public.finalize_race_series_if_needed(p_room_id);
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.surrender_race(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare player_id uuid:=auth.uid(); room public.coop_rooms%rowtype; survivor_id uuid; survivor_count integer; elapsed integer;
begin
  if player_id is null or not exists(select 1 from public.coop_room_members where room_id=p_room_id and user_id=player_id)
    then raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id=p_room_id for update;
  if room.mode<>'race' then raise exception 'This is not a race room'; end if;
  if room.status not in ('playing','paused') or room.winner_id is not null then return public.get_coop_room_state(p_room_id); end if;
  update public.coop_room_members set eliminated_at=clock_timestamp() where room_id=p_room_id and user_id=player_id and eliminated_at is null;
  select count(*) into survivor_count from public.coop_room_members where room_id=p_room_id and eliminated_at is null and left_at is null;
  select user_id into survivor_id from public.coop_room_members where room_id=p_room_id and eliminated_at is null and left_at is null limit 1;
  if survivor_count=1 then
    elapsed:=greatest(0,floor(extract(epoch from(clock_timestamp()-room.started_at-interval '4 seconds'))*1000)::integer);
    update public.coop_rooms set status='ended',end_reason='completed',ended_at=clock_timestamp(),winner_id=survivor_id,
      winner_finished_at=clock_timestamp(),winner_elapsed_ms=elapsed,race_end_kind='surrender' where id=p_room_id;
    update public.coop_room_members set session_wins=session_wins+1 where room_id=p_room_id and user_id=survivor_id;
    perform public.finalize_race_series_if_needed(p_room_id);
  end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.vote_race_restart(p_room_id uuid,p_kind text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare player_id uuid:=auth.uid(); room public.coop_rooms%rowtype; next_level integer; next_version integer; vote_count integer; member_count integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_kind not in ('retry','continue') then raise exception 'Invalid race restart choice'; end if;
  if not exists(select 1 from public.coop_room_members where room_id=p_room_id and user_id=player_id and left_at is null)
    then raise exception 'Room access denied'; end if;
  select * into room from public.coop_rooms where id=p_room_id for update;
  if room.series_finished_at is not null then raise exception 'The race series is already finished'; end if;
  if room.id is null or room.mode<>'race' or not (
    (room.status='ended' and room.end_reason='completed' and p_kind='continue' and room.race_level<room.race_end_level)
    or (room.status='paused' and p_kind='retry')) then raise exception 'The race is not ready to restart'; end if;
  delete from public.coop_room_action_votes where room_id=p_room_id and user_id=player_id
    and attempt_number=room.attempt_number and action in('retry','continue');
  insert into public.coop_room_action_votes(room_id,user_id,attempt_number,action) values(p_room_id,player_id,room.attempt_number,p_kind);
  update public.coop_rooms set rematch_requested_by=coalesce(rematch_requested_by,player_id),race_restart_kind=p_kind where id=p_room_id;
  select count(*) into vote_count from public.coop_room_action_votes vote
  where vote.room_id=p_room_id and vote.attempt_number=room.attempt_number and vote.action=p_kind
    and exists(select 1 from public.coop_room_members member where member.room_id=vote.room_id and member.user_id=vote.user_id and member.left_at is null);
  select count(*) into member_count from public.coop_room_members where room_id=p_room_id and left_at is null;
  if vote_count=member_count then
    next_level:=case when p_kind='continue' then room.race_level+1 else room.race_level end;
    if next_level>room.race_end_level then raise exception 'The race series is already finished'; end if;
    if p_kind='continue' then select published_version into next_version from public.game_levels where level_id=next_level;
    else next_version:=room.race_level_version; end if;
    delete from public.coop_room_members where room_id=p_room_id and left_at is not null;
    update public.coop_rooms set status='playing',status_before_vote=null,leave_requested_by=null,rematch_requested_by=null,
      race_restart_kind=null,end_reason=null,ended_at=null,winner_id=null,winner_finished_at=null,winner_elapsed_ms=null,
      winner_hearts=null,winner_stars=null,race_end_kind=null,race_level=next_level,race_level_version=next_version,
      seed=floor(random()*2147483646)::integer,attempt_number=attempt_number+1,started_at=clock_timestamp(),expires_at=now()+interval '2 hours'
    where id=p_room_id;
    update public.coop_room_members set ready=true,eliminated_at=null,left_at=null,last_seen_at=clock_timestamp() where room_id=p_room_id;
  end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

create or replace function public.leave_race_room(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  player_id uuid:=auth.uid(); room public.coop_rooms%rowtype; survivor_id uuid;
  next_host_id uuid; remaining_members integer; active_racers integer; elapsed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into room from public.coop_rooms where id=p_room_id for update;
  if room.id is null or room.mode<>'race' then raise exception 'Race room not found'; end if;
  if not exists(select 1 from public.coop_room_members where room_id=p_room_id and user_id=player_id and left_at is null)
    then raise exception 'Room access denied'; end if;
  delete from public.coop_room_action_votes where room_id=p_room_id and user_id=player_id;
  if room.status='waiting' then
    delete from public.coop_room_members where room_id=p_room_id and user_id=player_id;
  else
    update public.coop_room_members set left_at=clock_timestamp(),eliminated_at=coalesce(eliminated_at,clock_timestamp()),
      last_seen_at=clock_timestamp(),ready=false where room_id=p_room_id and user_id=player_id;
  end if;
  select count(*) into remaining_members from public.coop_room_members where room_id=p_room_id and left_at is null;
  select count(*) into active_racers from public.coop_room_members where room_id=p_room_id and left_at is null and eliminated_at is null;
  if room.host_id=player_id and remaining_members>0 then
    select user_id into next_host_id from public.coop_room_members where room_id=p_room_id and left_at is null order by joined_at,user_id limit 1;
    update public.coop_rooms set host_id=next_host_id where id=p_room_id;
  end if;
  if remaining_members=0 then
    update public.coop_rooms set status='ended',status_before_vote=null,leave_requested_by=null,end_reason='leave',
      ended_at=clock_timestamp(),race_end_kind=null,rematch_requested_by=null,race_restart_kind=null where id=p_room_id;
  elsif room.status='waiting' then
    update public.coop_rooms set leave_requested_by=null where id=p_room_id;
  elsif room.status in ('playing','paused','leave_vote') and room.winner_id is null then
    if active_racers=1 then
      select user_id into survivor_id from public.coop_room_members
      where room_id=p_room_id and left_at is null and eliminated_at is null limit 1;
      elapsed:=greatest(0,floor(extract(epoch from(clock_timestamp()-coalesce(room.started_at,clock_timestamp())-interval '4 seconds'))*1000)::integer);
      update public.coop_rooms set status='ended',status_before_vote=null,leave_requested_by=null,end_reason='completed',
        ended_at=clock_timestamp(),winner_id=survivor_id,winner_finished_at=clock_timestamp(),winner_elapsed_ms=elapsed,
        winner_hearts=null,winner_stars=(select count(*)::integer from public.race_pickup_claims claim
          where claim.room_id=p_room_id and claim.attempt_number=room.attempt_number and claim.race_level=room.race_level
            and claim.pickup_type='star' and claim.claimant_id=survivor_id),
        race_end_kind='surrender',rematch_requested_by=null,race_restart_kind=null where id=p_room_id;
      update public.coop_room_members set session_wins=session_wins+1 where room_id=p_room_id and user_id=survivor_id;
      perform public.finalize_race_series_if_needed(p_room_id);
    elsif active_racers=0 then
      update public.coop_rooms set status='ended',status_before_vote=null,leave_requested_by=null,end_reason='leave',
        ended_at=clock_timestamp(),race_end_kind=null,rematch_requested_by=null,race_restart_kind=null where id=p_room_id;
    elsif room.status='leave_vote' then
      update public.coop_rooms set status=coalesce(status_before_vote,'playing'),status_before_vote=null,leave_requested_by=null where id=p_room_id;
    end if;
  end if;
  return jsonb_build_object('left',true,'room_id',p_room_id,'remaining_players',remaining_members,
    'race_ended',(select status='ended' from public.coop_rooms where id=p_room_id));
end; $$;

create or replace function public.maintain_race_presence(p_room_id uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  player_id uuid:=auth.uid(); checked_at timestamptz:=clock_timestamp(); room public.coop_rooms%rowtype;
  previous_seen timestamptz; survivor_id uuid; survivor_count integer; eliminated_count integer; elapsed integer;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  select * into room from public.coop_rooms where id=p_room_id for update;
  if room.id is null or room.mode<>'race' then raise exception 'Race room not found'; end if;
  select last_seen_at into previous_seen from public.coop_room_members where room_id=p_room_id and user_id=player_id;
  if not found then raise exception 'Room access denied'; end if;
  update public.coop_room_members set last_seen_at=checked_at where room_id=p_room_id and user_id=player_id;
  if room.status in ('playing','paused','leave_vote') and room.started_at is not null and previous_seen is not null
      and previous_seen>=checked_at-interval '45 seconds' then
    with eliminated as (
      update public.coop_room_members member set eliminated_at=checked_at
      where member.room_id=p_room_id and member.user_id<>player_id and member.eliminated_at is null and member.left_at is null
        and coalesce(member.last_seen_at,greatest(member.joined_at,room.started_at))<checked_at-interval '2 minutes'
      returning 1
    ) select count(*) into eliminated_count from eliminated;
    if eliminated_count>0 then
      select count(*) into survivor_count from public.coop_room_members where room_id=p_room_id and eliminated_at is null and left_at is null;
      select user_id into survivor_id from public.coop_room_members where room_id=p_room_id and eliminated_at is null and left_at is null limit 1;
      if survivor_count=1 then
        elapsed:=greatest(0,floor(extract(epoch from(checked_at-room.started_at-interval '4 seconds'))*1000)::integer);
        update public.coop_rooms set status='ended',status_before_vote=null,leave_requested_by=null,end_reason='forfeit',
          ended_at=checked_at,winner_id=survivor_id,winner_finished_at=checked_at,winner_elapsed_ms=elapsed,
          winner_hearts=null,winner_stars=null,race_end_kind='disconnect',rematch_requested_by=null,race_restart_kind=null where id=p_room_id;
        update public.coop_room_members set session_wins=session_wins+1 where room_id=p_room_id and user_id=survivor_id;
        perform public.finalize_race_series_if_needed(p_room_id);
      end if;
    end if;
  end if;
  return public.get_coop_room_state(p_room_id);
end; $$;

grant execute on function public.configure_race_series(uuid,integer,integer) to authenticated;
grant execute on function public.transfer_race_host(uuid,uuid) to authenticated;
