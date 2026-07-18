-- Preserve useful names returned by social identity providers while still
-- requiring Balanco-specific username and age onboarding in the client.
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
  metadata_age text := new.raw_user_meta_data ->> 'age';
begin
  requested_username := nullif(btrim(new.raw_user_meta_data ->> 'username'), '');
  if requested_username is null
     or requested_username !~ '^[A-Za-z0-9_]{3,20}$'
     or exists (
       select 1 from public.profiles where username = requested_username
     ) then
    requested_username := 'player_' || left(replace(new.id::text, '-', ''), 13);
  end if;

  requested_name := coalesce(
    nullif(btrim(new.raw_user_meta_data ->> 'display_name'), ''),
    nullif(btrim(new.raw_user_meta_data ->> 'full_name'), ''),
    nullif(btrim(new.raw_user_meta_data ->> 'name'), '')
  );
  if requested_name is null or char_length(requested_name) not between 2 and 30 then
    requested_name := requested_username;
  end if;

  if metadata_age is not null and metadata_age ~ '^[0-9]{1,3}$' then
    requested_age := metadata_age::smallint;
    if requested_age not between 6 and 120 then
      requested_age := 18;
    end if;
  else
    -- Social providers do not supply a trustworthy age. The client recognizes
    -- generated usernames and requires profile completion before gameplay.
    requested_age := 18;
  end if;

  insert into public.profiles (id, username, display_name, age)
  values (new.id, requested_username, requested_name, requested_age);
  insert into public.player_progress (user_id) values (new.id);
  insert into public.player_wallets (user_id) values (new.id);
  insert into public.player_unlocks (user_id, unlock_type, item_key, source)
  values
    (new.id, 'ball_shape', 'classic', 'starter'),
    (new.id, 'ball_color', 'orange', 'starter');
  insert into public.wallet_transactions (
    user_id,
    currency,
    amount,
    balance_after,
    reason,
    reference_id
  )
  values
    (new.id, 'coins', 5000, 5000, 'signup_bonus', 'signup'),
    (new.id, 'money_cents', 500, 500, 'signup_bonus', 'signup');
  return new;
end;
$$;

revoke all on function public.handle_new_balanco_player()
  from public, anon, authenticated;
