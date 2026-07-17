create or replace function public.enforce_consistent_race_restart_vote()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.action in ('retry', 'continue') and exists (
    select 1 from public.coop_room_action_votes vote
    where vote.room_id = new.room_id
      and vote.attempt_number = new.attempt_number
      and vote.action in ('retry', 'continue')
      and vote.action <> new.action
  ) then
    raise exception 'The players selected different restart choices';
  end if;
  return new;
end;
$$;

drop trigger if exists enforce_consistent_race_restart_vote_before_insert
  on public.coop_room_action_votes;
create trigger enforce_consistent_race_restart_vote_before_insert
before insert on public.coop_room_action_votes
for each row execute function public.enforce_consistent_race_restart_vote();

revoke all on function public.enforce_consistent_race_restart_vote()
  from public, anon, authenticated;
