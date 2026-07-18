alter table public.coop_rooms
  drop constraint if exists coop_rooms_race_end_kind_check;

alter table public.coop_rooms
  add constraint coop_rooms_race_end_kind_check
  check (race_end_kind in ('finish', 'surrender', 'disconnect', 'draw'));
