create table public.infinity_runs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  client_run_id uuid not null,
  score integer not null check (score >= 0),
  coins_collected integer not null check (coins_collected >= 0),
  created_at timestamptz not null default now(),
  unique (user_id, client_run_id)
);

create index infinity_runs_user_created_idx
  on public.infinity_runs (user_id, created_at desc);

alter table public.infinity_runs enable row level security;
create policy "players read own infinity runs"
  on public.infinity_runs for select to authenticated
  using ((select auth.uid()) = user_id);
grant select on public.infinity_runs to authenticated;

create or replace function public.record_infinity_run(
  p_client_run_id uuid,
  p_score integer,
  p_coins integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  player_id uuid := auth.uid();
  inserted_run uuid;
  new_coin_balance bigint;
begin
  if player_id is null then raise exception 'Authentication required'; end if;
  if p_score < 0 or p_coins < 0 then raise exception 'Invalid Infinity result'; end if;

  insert into public.infinity_runs (user_id, client_run_id, score, coins_collected)
  values (player_id, p_client_run_id, p_score, p_coins)
  on conflict (user_id, client_run_id) do nothing
  returning id into inserted_run;

  if inserted_run is not null then
    update public.player_progress
      set infinity_high_score = greatest(infinity_high_score, p_score), updated_at = now()
      where user_id = player_id;

    update public.player_wallets
      set coins = coins + p_coins, updated_at = now()
      where user_id = player_id
      returning coins into new_coin_balance;

    if p_coins > 0 then
      insert into public.wallet_transactions
        (user_id, currency, amount, balance_after, reason, reference_id)
      values
        (player_id, 'coins', p_coins, new_coin_balance, 'infinity_run', p_client_run_id::text);
    end if;
  end if;

  return public.get_my_player_state();
end;
$$;

revoke all on function public.record_infinity_run(uuid, integer, integer) from public, anon;
grant execute on function public.record_infinity_run(uuid, integer, integer) to authenticated;
