create or replace function private.dispatch_player_notification()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  webhook_secret text;
begin
  select decrypted_secret into webhook_secret
  from vault.decrypted_secrets
  where name = 'balanco_notification_webhook_secret'
  limit 1;

  if webhook_secret is null then
    return new;
  end if;

  perform net.http_post(
    url := 'https://xojfseowbcsrfyocfnph.supabase.co/functions/v1/dispatch-game-notification',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-balanco-webhook-secret', webhook_secret
    ),
    body := jsonb_build_object('notification_id', new.id),
    timeout_milliseconds := 5000
  );
  return new;
end;
$$;

revoke all on function private.dispatch_player_notification()
  from public, anon, authenticated;
