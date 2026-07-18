revoke all on function public.configure_race_series(uuid, integer, integer)
from public, anon;
revoke all on function public.transfer_race_host(uuid, uuid)
from public, anon;

grant execute on function public.configure_race_series(uuid, integer, integer)
to authenticated;
grant execute on function public.transfer_race_host(uuid, uuid)
to authenticated;

create index if not exists coop_rooms_series_winner_id_idx
on public.coop_rooms(series_winner_id)
where series_winner_id is not null;
