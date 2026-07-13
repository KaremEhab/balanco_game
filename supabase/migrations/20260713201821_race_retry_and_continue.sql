alter table public.coop_rooms
  add column if not exists race_restart_kind text
  check (race_restart_kind is null or race_restart_kind in ('retry', 'continue'));

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
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_kind not in ('retry', 'continue') then
    raise exception 'Invalid race restart choice';
  end if;
  if not exists (
    select 1 from public.coop_room_members
    where room_id = p_room_id and user_id = player_id
  ) then raise exception 'Room access denied'; end if;

  select * into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race' or room.status <> 'ended'
     or room.end_reason <> 'completed' then
    raise exception 'The race is not ready to restart';
  end if;

  if room.rematch_requested_by is null then
    update public.coop_rooms
    set rematch_requested_by = player_id,
        race_restart_kind = p_kind
    where id = p_room_id;
  elsif room.rematch_requested_by = player_id then
    -- The requester may change their choice until the other player accepts.
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

-- Preserve compatibility for installed builds that only knew "continue".
create or replace function public.vote_race_rematch(p_room_id uuid)
returns jsonb
language sql
security definer
set search_path = ''
as $$
  select public.vote_race_restart(p_room_id, 'continue');
$$;

revoke all on function public.vote_race_restart(uuid, text) from public, anon;
grant execute on function public.vote_race_restart(uuid, text) to authenticated;
revoke all on function public.vote_race_rematch(uuid) from public, anon;
grant execute on function public.vote_race_rematch(uuid) to authenticated;
