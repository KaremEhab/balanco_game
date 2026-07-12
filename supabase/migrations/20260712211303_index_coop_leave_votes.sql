create index if not exists coop_rooms_leave_requested_by_idx
  on public.coop_rooms(leave_requested_by)
  where leave_requested_by is not null;
