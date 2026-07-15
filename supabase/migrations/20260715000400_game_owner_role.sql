create or replace function public.is_game_owner()
returns boolean
language sql
stable
set search_path = ''
as $$
  select coalesce(
    ((select auth.jwt()) -> 'app_metadata' ->> 'game_owner')::boolean,
    false
  );
$$;

create or replace function public.is_level_editor()
returns boolean
language sql
stable
set search_path = ''
as $$
  select
    coalesce(
      ((select auth.jwt()) -> 'app_metadata' ->> 'game_owner')::boolean,
      false
    )
    or coalesce(
      ((select auth.jwt()) -> 'app_metadata' ->> 'level_editor')::boolean,
      false
    );
$$;

revoke all on function public.is_game_owner() from public, anon;
revoke all on function public.is_level_editor() from public, anon;
grant execute on function public.is_game_owner() to authenticated;
grant execute on function public.is_level_editor() to authenticated;
