revoke all on function public.finish_race(uuid, double precision, integer, integer)
  from anon;

create index if not exists game_level_versions_published_by_idx
  on public.game_level_versions (published_by)
  where published_by is not null;

create index if not exists game_levels_updated_by_idx
  on public.game_levels (updated_by)
  where updated_by is not null;
