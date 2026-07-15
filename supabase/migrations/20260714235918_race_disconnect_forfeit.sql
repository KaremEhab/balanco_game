alter table public.coop_room_members
  add column if not exists last_seen_at timestamptz;

update public.coop_room_members member
set last_seen_at = clock_timestamp()
from public.coop_rooms room
where room.id = member.room_id
  and room.mode = 'race'
  and room.status in ('playing', 'paused', 'leave_vote');

create index if not exists coop_room_members_room_last_seen_idx
  on public.coop_room_members (room_id, last_seen_at);

alter table public.coop_rooms
  drop constraint if exists coop_rooms_end_reason_check;
alter table public.coop_rooms
  add constraint coop_rooms_end_reason_check
  check (end_reason is null or end_reason in ('completed', 'leave', 'forfeit'));

create or replace function public.maintain_race_presence(p_room_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  checked_at timestamptz := clock_timestamp();
  room public.coop_rooms%rowtype;
  player_previous_seen timestamptz;
  opponent_id uuid;
  opponent_seen timestamptz;
  elapsed integer;
begin
  if player_id is null then
    raise exception 'Authentication required';
  end if;

  select *
  into room
  from public.coop_rooms
  where id = p_room_id
  for update;

  if room.id is null or room.mode <> 'race' then
    raise exception 'Race room not found';
  end if;

  select last_seen_at
  into player_previous_seen
  from public.coop_room_members
  where room_id = p_room_id and user_id = player_id;

  if not found then
    raise exception 'Room access denied';
  end if;

  update public.coop_room_members
  set last_seen_at = checked_at
  where room_id = p_room_id and user_id = player_id;

  if room.status in ('playing', 'paused', 'leave_vote')
      and room.started_at is not null
      and player_previous_seen is not null
      and player_previous_seen >= checked_at - interval '45 seconds' then
    select
      member.user_id,
      coalesce(
        member.last_seen_at,
        greatest(member.joined_at, room.started_at)
      )
    into opponent_id, opponent_seen
    from public.coop_room_members member
    where member.room_id = p_room_id
      and member.user_id <> player_id
    order by member.joined_at
    limit 1;

    if opponent_id is not null
        and opponent_seen < checked_at - interval '2 minutes' then
      elapsed := greatest(
        0,
        floor(extract(epoch from (
          checked_at - room.started_at - interval '4 seconds'
        )) * 1000)::integer
      );

      update public.coop_rooms
      set status = 'ended',
          status_before_vote = null,
          leave_requested_by = null,
          end_reason = 'forfeit',
          ended_at = checked_at,
          winner_id = player_id,
          winner_finished_at = checked_at,
          winner_elapsed_ms = elapsed,
          winner_hearts = null,
          winner_stars = null,
          race_end_kind = 'disconnect',
          rematch_requested_by = null,
          race_restart_kind = null
      where id = p_room_id
        and status in ('playing', 'paused', 'leave_vote');

      if found then
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
          checked_at,
          null,
          0,
          0
        )
        on conflict (user_id, level_id) do nothing;

        insert into public.player_progress (user_id, race_wins, updated_at)
        values (
          player_id,
          (
            select count(*)
            from public.player_race_level_wins
            where user_id = player_id
          ),
          checked_at
        )
        on conflict (user_id) do update
        set race_wins = excluded.race_wins,
            updated_at = excluded.updated_at;
      end if;
    end if;
  end if;

  return public.get_coop_room_state(p_room_id);
end;
$$;

revoke all on function public.maintain_race_presence(uuid) from public, anon;
grant execute on function public.maintain_race_presence(uuid) to authenticated;
