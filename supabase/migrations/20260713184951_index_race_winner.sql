create index if not exists coop_rooms_winner_id_idx
  on public.coop_rooms(winner_id)
  where winner_id is not null;
