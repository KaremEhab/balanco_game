# Balanco Supabase setup

The app is connected to Supabase project `xojfseowbcsrfyocfnph` with a publishable client key. Never add a secret or `service_role` key to Flutter.

## Player data

- `profiles`: display name, unique username, player-selected age, avatar metadata.
- `player_progress`: highest/current level, total points, infinity high score.
- `player_wallets`: 5,000 signup coins, $5.00 (`money_cents = 500`), and 5 daily sparks.
- `player_level_progress`: passed levels, best score, and stars.
- `player_unlocks`: unlocked ball shapes and colors.
- `game_attempts`: idempotent victory/Game Over history.
- `wallet_transactions`: append-only audit trail for signup rewards and spark usage.

All public tables use row-level security. Players can read only their own rows. Wallet and progression mutations go through authenticated database functions that verify `auth.uid()`.

## Safe schema changes

Never delete or recreate the production database. Add a new migration instead:

```powershell
npx supabase migration new descriptive_change_name
```

Review and apply migrations in order. The Flutter SQLite database follows the same additive `onUpgrade` approach, so installed players keep their local data.

## Production authentication checklist

1. Keep email/password enabled in Supabase Authentication > Providers.
2. Configure a custom SMTP provider before release; the built-in sender is intended for development and is rate-limited.
3. Customize confirmation and password-recovery email templates with Balanco branding.
4. Add the mobile recovery redirect URL when deep-link password recovery is enabled.
5. Keep leaked-password protection enabled and review Authentication rate limits.
6. Run Supabase security and performance advisors after every migration.

The signup form collects only data needed by the game: display name, username, age, email, and password. Age is constrained to 6–120 in both Flutter and Postgres.

## Online co-op

- Private Supabase Realtime channels use room membership for Broadcast and Presence authorization.
- Room codes expire after two hours and rooms contain at most one left-side and one right-side player.
- The host provides deterministic Infinity state snapshots; controls are sent with low-latency Broadcast.
- Pause affects both players immediately. Leaving requires the other player's approval.
- Completed co-op rewards are written once and granted to both room members atomically.
- Audio uses peer-to-peer WebRTC with Supabase Broadcast for signaling. Public STUN is adequate for local testing; configure a production TURN service before broad release for restrictive NAT/mobile networks.
- Enable leaked-password protection in Supabase Authentication settings before production release.
