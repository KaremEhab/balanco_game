-- Balanco player accounts and progression. All changes are additive and versioned.
create extension if not exists pgcrypto with schema extensions;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  display_name text not null,
  age smallint not null check (age between 6 and 120),
  avatar_url text,
  avatar_shape text not null default 'circle',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_username_format check (username ~ '^[A-Za-z0-9_]{3,20}$'),
  constraint profiles_display_name_length check (char_length(display_name) between 2 and 30)
);

create table public.player_progress (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  highest_level integer not null default 1 check (highest_level >= 1),
  last_played_level integer not null default 1 check (last_played_level >= 1),
  total_points bigint not null default 0 check (total_points >= 0),
  infinity_high_score bigint not null default 0 check (infinity_high_score >= 0),
  updated_at timestamptz not null default now()
);

create table public.player_wallets (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  coins bigint not null default 5000 check (coins >= 0),
  money_cents bigint not null default 500 check (money_cents >= 0),
  sparks smallint not null default 5 check (sparks between 0 and 5),
  max_sparks smallint not null default 5 check (max_sparks = 5),
  sparks_refreshed_on date not null default current_date,
  updated_at timestamptz not null default now()
);

create table public.player_level_progress (
  user_id uuid not null references public.profiles(id) on delete cascade,
  level_id integer not null check (level_id >= 1),
  stars smallint not null default 0 check (stars between 0 and 3),
  best_points integer not null default 0 check (best_points >= 0),
  passed boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, level_id)
);

create table public.player_unlocks (
  user_id uuid not null references public.profiles(id) on delete cascade,
  unlock_type text not null check (unlock_type in ('ball_shape', 'ball_color')),
  item_key text not null,
  source text not null default 'starter',
  unlocked_at timestamptz not null default now(),
  primary key (user_id, unlock_type, item_key)
);

create table public.game_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  client_attempt_id uuid not null,
  level_id integer not null check (level_id >= 1),
  result text not null check (result in ('victory', 'game_over')),
  points integer not null default 0 check (points >= 0),
  stars smallint not null default 0 check (stars between 0 and 3),
  created_at timestamptz not null default now(),
  unique (user_id, client_attempt_id)
);

create table public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  currency text not null check (currency in ('coins', 'money_cents', 'sparks')),
  amount bigint not null,
  balance_after bigint not null check (balance_after >= 0),
  reason text not null,
  reference_id text not null,
  created_at timestamptz not null default now(),
  unique (user_id, currency, reference_id)
);

create index game_attempts_user_created_idx on public.game_attempts (user_id, created_at desc);
create index wallet_transactions_user_created_idx on public.wallet_transactions (user_id, created_at desc);

alter table public.profiles enable row level security;
alter table public.player_progress enable row level security;
alter table public.player_wallets enable row level security;
alter table public.player_level_progress enable row level security;
alter table public.player_unlocks enable row level security;
alter table public.game_attempts enable row level security;
alter table public.wallet_transactions enable row level security;

create policy "players read own profile" on public.profiles for select to authenticated
  using ((select auth.uid()) = id);
create policy "players update own profile" on public.profiles for update to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
create policy "players read own progress" on public.player_progress for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "players read own wallet" on public.player_wallets for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "players read own levels" on public.player_level_progress for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "players read own unlocks" on public.player_unlocks for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "players read own attempts" on public.game_attempts for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "players read own wallet ledger" on public.wallet_transactions for select to authenticated
  using ((select auth.uid()) = user_id);

grant select, update on public.profiles to authenticated;
grant select on public.player_progress, public.player_wallets,
  public.player_level_progress, public.player_unlocks, public.game_attempts,
  public.wallet_transactions to authenticated;

create or replace function public.handle_new_balanco_player()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  requested_username text;
  requested_name text;
  requested_age smallint;
begin
  requested_username := coalesce(nullif(new.raw_user_meta_data ->> 'username', ''), 'player_' || left(new.id::text, 8));
  requested_name := coalesce(nullif(new.raw_user_meta_data ->> 'display_name', ''), requested_username);
  requested_age := (new.raw_user_meta_data ->> 'age')::smallint;

  insert into public.profiles (id, username, display_name, age)
  values (new.id, requested_username, requested_name, requested_age);
  insert into public.player_progress (user_id) values (new.id);
  insert into public.player_wallets (user_id) values (new.id);
  insert into public.player_unlocks (user_id, unlock_type, item_key, source)
  values
    (new.id, 'ball_shape', 'classic', 'starter'),
    (new.id, 'ball_color', 'orange', 'starter');
  insert into public.wallet_transactions (user_id, currency, amount, balance_after, reason, reference_id)
  values
    (new.id, 'coins', 5000, 5000, 'signup_bonus', 'signup'),
    (new.id, 'money_cents', 500, 500, 'signup_bonus', 'signup');
  return new;
end;
$$;

revoke all on function public.handle_new_balanco_player() from public, anon, authenticated;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_balanco_player();

create or replace function public.get_my_player_state()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  result jsonb;
begin
  if player_id is null then raise exception 'Authentication required'; end if;

  update public.player_wallets
    set sparks = max_sparks, sparks_refreshed_on = current_date, updated_at = now()
    where user_id = player_id and sparks_refreshed_on < current_date;

  select jsonb_build_object(
    'profile', to_jsonb(p),
    'progress', to_jsonb(g),
    'wallet', to_jsonb(w),
    'levels', coalesce((select jsonb_agg(to_jsonb(lp) order by lp.level_id) from public.player_level_progress lp where lp.user_id = player_id), '[]'::jsonb),
    'unlocks', coalesce((select jsonb_agg(to_jsonb(u) order by u.unlocked_at) from public.player_unlocks u where u.user_id = player_id), '[]'::jsonb)
  ) into result
  from public.profiles p
  join public.player_progress g on g.user_id = p.id
  join public.player_wallets w on w.user_id = p.id
  where p.id = player_id;
  return result;
end;
$$;

create or replace function public.record_game_result(
  p_client_attempt_id uuid,
  p_level_id integer,
  p_result text,
  p_points integer default 0,
  p_stars smallint default 0
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  inserted_attempt uuid;
  new_sparks smallint;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_level_id < 1 or p_points < 0 or p_stars not between 0 and 3 or p_result not in ('victory', 'game_over') then
    raise exception 'Invalid game result';
  end if;

  update public.player_wallets
    set sparks = max_sparks, sparks_refreshed_on = current_date, updated_at = now()
    where user_id = player_id and sparks_refreshed_on < current_date;

  insert into public.game_attempts (user_id, client_attempt_id, level_id, result, points, stars)
  values (player_id, p_client_attempt_id, p_level_id, p_result, p_points, p_stars)
  on conflict (user_id, client_attempt_id) do nothing
  returning id into inserted_attempt;

  if inserted_attempt is not null and p_result = 'game_over' then
    update public.player_wallets
      set sparks = greatest(0, sparks - 1), updated_at = now()
      where user_id = player_id
      returning sparks into new_sparks;
    insert into public.wallet_transactions (user_id, currency, amount, balance_after, reason, reference_id)
    values (player_id, 'sparks', -1, new_sparks, 'game_over', p_client_attempt_id::text);
  elsif inserted_attempt is not null then
    insert into public.player_level_progress (user_id, level_id, stars, best_points, passed)
    values (player_id, p_level_id, p_stars, p_points, true)
    on conflict (user_id, level_id) do update set
      stars = greatest(public.player_level_progress.stars, excluded.stars),
      best_points = greatest(public.player_level_progress.best_points, excluded.best_points),
      passed = true,
      updated_at = now();
    update public.player_progress set
      highest_level = greatest(highest_level, least(500, p_level_id + 1)),
      last_played_level = p_level_id,
      total_points = total_points + p_points,
      updated_at = now()
    where user_id = player_id;
    if p_level_id + 1 = any(array[11,16,46,76,106,136,166,196,226,256,286,316,346,376,406,436,466,496]) then
      insert into public.player_unlocks (user_id, unlock_type, item_key, source)
      values (player_id, 'ball_color', 'biome_' || (p_level_id + 1)::text, 'level_reward')
      on conflict do nothing;
    end if;
    if p_level_id = any(array[100,250,500]) then
      insert into public.player_unlocks (user_id, unlock_type, item_key, source)
      values (
        player_id,
        'ball_shape',
        case p_level_id when 100 then 'comet' when 250 then 'crystal' else 'crown' end,
        'level_reward'
      ) on conflict do nothing;
    end if;
  end if;

  return public.get_my_player_state();
end;
$$;

revoke all on function public.get_my_player_state() from public, anon;
revoke all on function public.record_game_result(uuid, integer, text, integer, smallint) from public, anon;
grant execute on function public.get_my_player_state() to authenticated;
grant execute on function public.record_game_result(uuid, integer, text, integer, smallint) to authenticated;
