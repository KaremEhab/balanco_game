create index if not exists coop_room_action_votes_user_idx
  on public.coop_room_action_votes(user_id, room_id);

drop policy if exists "room members read action votes"
  on public.coop_room_action_votes;
create policy "room members read action votes"
on public.coop_room_action_votes
for select to authenticated
using (public.is_coop_member(room_id));

grant select on public.coop_room_action_votes to authenticated;
