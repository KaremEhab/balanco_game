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
  select * into room from public.coop_rooms where id = p_room_id for update;
  if room.id is null or room.mode <> 'race' or room.status <> 'ended'
      or room.end_reason is null
      or room.end_reason not in ('completed', 'forfeit') then
    return;
  end if;

  if room.series_scored_attempt < room.attempt_number then
    update public.coop_room_members member
    set series_stars = member.series_stars + (
      select count(*)::integer from public.race_pickup_claims claim
      where claim.room_id = p_room_id
        and claim.attempt_number = room.attempt_number
        and claim.race_level = room.race_level
        and claim.pickup_type = 'star'
        and claim.claimant_id = member.user_id
    )
    where member.room_id = p_room_id;
    update public.coop_rooms set series_scored_attempt = room.attempt_number
    where id = p_room_id;
  end if;

  select count(*) into active_count
  from public.coop_room_members member
  where member.room_id = p_room_id
    and member.left_at is null and member.eliminated_at is null;

  if room.race_level < room.race_end_level and active_count > 1 then return; end if;

  if active_count = 1 and room.race_end_kind in ('surrender', 'disconnect') then
    select member.user_id into champion
    from public.coop_room_members member
    where member.room_id = p_room_id
      and member.left_at is null and member.eliminated_at is null
    limit 1;
    update public.coop_rooms
    set series_winner_id = champion, series_end_kind = 'winner',
        series_finished_at = coalesce(series_finished_at, clock_timestamp())
    where id = p_room_id;
    return;
  end if;

  select max(member.session_wins) into top_points
  from public.coop_room_members member
  where member.room_id = p_room_id
    and member.left_at is null and member.eliminated_at is null;
  select max(member.series_stars) into top_stars
  from public.coop_room_members member
  where member.room_id = p_room_id and member.left_at is null
    and member.eliminated_at is null and member.session_wins = top_points;
  select count(*), min(member.user_id::text)::uuid into leaders, champion
  from public.coop_room_members member
  where member.room_id = p_room_id and member.left_at is null
    and member.eliminated_at is null and member.session_wins = top_points
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
