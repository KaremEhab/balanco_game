create index player_notifications_actor_idx
  on public.player_notifications(actor_id)
  where actor_id is not null;
