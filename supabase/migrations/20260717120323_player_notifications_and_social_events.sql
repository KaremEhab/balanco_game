create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table public.player_notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  actor_id uuid references public.profiles(id) on delete set null,
  notification_type text not null check (
    notification_type in (
      'friend_request',
      'friend_accepted',
      'friend_declined',
      'game_invite',
      'game_invite_accepted',
      'game_invite_declined',
      'game_invite_cancelled',
      'system'
    )
  ),
  title text not null check (char_length(title) between 1 and 80),
  body text not null check (char_length(body) between 1 and 240),
  data jsonb not null default '{}'::jsonb check (jsonb_typeof(data) = 'object'),
  dedupe_key text,
  read_at timestamptz,
  push_status text not null default 'pending'
    check (push_status in ('pending', 'processing', 'sent', 'failed')),
  push_attempts integer not null default 0 check (push_attempts >= 0),
  push_sent_at timestamptz,
  push_error text,
  created_at timestamptz not null default clock_timestamp()
);

create index player_notifications_recipient_created_idx
  on public.player_notifications(recipient_id, created_at desc);
create index player_notifications_recipient_unread_idx
  on public.player_notifications(recipient_id, created_at desc)
  where read_at is null;
create index player_notifications_pending_push_idx
  on public.player_notifications(created_at)
  where push_status in ('pending', 'failed');
create unique index player_notifications_dedupe_idx
  on public.player_notifications(recipient_id, dedupe_key)
  where dedupe_key is not null;

alter table public.player_notifications enable row level security;

create policy "players read their notifications"
on public.player_notifications
for select to authenticated
using ((select auth.uid()) = recipient_id);

create policy "players mark their notifications read"
on public.player_notifications
for update to authenticated
using ((select auth.uid()) = recipient_id)
with check ((select auth.uid()) = recipient_id);

create policy "players delete their notifications"
on public.player_notifications
for delete to authenticated
using ((select auth.uid()) = recipient_id);

revoke all on table public.player_notifications
  from public, anon, authenticated;
grant select on table public.player_notifications to authenticated;
grant update(read_at) on table public.player_notifications to authenticated;
grant delete on table public.player_notifications to authenticated;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'player_notifications'
  ) then
    alter publication supabase_realtime
      add table public.player_notifications;
  end if;
end;
$$;

create or replace function private.insert_player_notification(
  p_recipient_id uuid,
  p_actor_id uuid,
  p_type text,
  p_title text,
  p_body text,
  p_data jsonb,
  p_dedupe_key text
)
returns void
language sql
security definer
set search_path = ''
as $$
  insert into public.player_notifications(
    recipient_id,
    actor_id,
    notification_type,
    title,
    body,
    data,
    dedupe_key
  )
  values (
    p_recipient_id,
    p_actor_id,
    p_type,
    p_title,
    p_body,
    coalesce(p_data, '{}'::jsonb),
    p_dedupe_key
  )
  on conflict (recipient_id, dedupe_key)
    where dedupe_key is not null
  do nothing;
$$;

create or replace function private.notify_friendship_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  actor_name text;
  event_time text := extract(epoch from new.updated_at)::text;
begin
  if new.status = 'pending'
      and (tg_op = 'INSERT' or old.status is distinct from new.status
        or old.updated_at is distinct from new.updated_at) then
    select display_name into actor_name
    from public.profiles where id = new.requester_id;

    perform private.insert_player_notification(
      new.addressee_id,
      new.requester_id,
      'friend_request',
      'NEW FRIEND REQUEST!',
      coalesce(actor_name, 'A Balanco player') || ' wants to be your friend.',
      jsonb_build_object(
        'route', 'friends',
        'request_id', new.id
      ),
      'friend_request:' || new.id::text || ':' || event_time
    );
  elsif tg_op = 'UPDATE' and old.status is distinct from new.status
      and new.status in ('accepted', 'declined') then
    select display_name into actor_name
    from public.profiles where id = new.addressee_id;

    perform private.insert_player_notification(
      new.requester_id,
      new.addressee_id,
      case when new.status = 'accepted'
        then 'friend_accepted' else 'friend_declined' end,
      case when new.status = 'accepted'
        then 'FRIEND REQUEST ACCEPTED!'
        else 'FRIEND REQUEST UPDATE' end,
      coalesce(actor_name, 'A Balanco player') ||
        case when new.status = 'accepted'
          then ' is now your friend.'
          else ' declined your friend request.' end,
      jsonb_build_object(
        'route', 'friends',
        'request_id', new.id
      ),
      'friend_' || new.status || ':' || new.id::text || ':' || event_time
    );
  end if;

  return new;
end;
$$;

create or replace function private.notify_game_invite_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  actor_name text;
  room_mode text;
  room_size integer;
  event_time text := extract(epoch from new.updated_at)::text;
begin
  select mode, max_players into room_mode, room_size
  from public.coop_rooms where id = new.room_id;

  if new.status = 'pending'
      and (tg_op = 'INSERT' or old.status is distinct from new.status
        or old.updated_at is distinct from new.updated_at) then
    select display_name into actor_name
    from public.profiles where id = new.inviter_id;

    perform private.insert_player_notification(
      new.invitee_id,
      new.inviter_id,
      'game_invite',
      upper(coalesce(room_mode, 'game')) || ' INVITATION!',
      coalesce(actor_name, 'A Balanco player') || ' invited you to play ' ||
        upper(coalesce(room_mode, 'a game')) || '.',
      jsonb_build_object(
        'route', 'friends',
        'invite_id', new.id,
        'room_id', new.room_id,
        'mode', room_mode,
        'max_players', room_size,
        'expires_at', new.expires_at
      ),
      'game_invite:' || new.id::text || ':' || event_time
    );
  elsif tg_op = 'UPDATE' and old.status is distinct from new.status
      and new.status in ('accepted', 'declined', 'cancelled') then
    select display_name into actor_name
    from public.profiles where id = new.invitee_id;

    perform private.insert_player_notification(
      new.inviter_id,
      new.invitee_id,
      case new.status
        when 'accepted' then 'game_invite_accepted'
        when 'declined' then 'game_invite_declined'
        else 'game_invite_cancelled'
      end,
      case new.status
        when 'accepted' then 'GAME INVITE ACCEPTED!'
        when 'declined' then 'GAME INVITE DECLINED'
        else 'GAME INVITE CLOSED'
      end,
      coalesce(actor_name, 'A Balanco player') ||
        case new.status
          when 'accepted' then ' joined your game room.'
          when 'declined' then ' declined your game invitation.'
          else '''s invitation is no longer active.'
        end,
      jsonb_build_object(
        'route', 'friends',
        'invite_id', new.id,
        'room_id', new.room_id,
        'mode', room_mode,
        'max_players', room_size
      ),
      'game_invite_' || new.status || ':' || new.id::text || ':' || event_time
    );
  end if;

  return new;
end;
$$;

drop trigger if exists friendships_create_notifications
  on public.friendships;
create trigger friendships_create_notifications
after insert or update of status, updated_at on public.friendships
for each row execute function private.notify_friendship_change();

drop trigger if exists game_invites_create_notifications
  on public.coop_invites;
create trigger game_invites_create_notifications
after insert or update of status, updated_at on public.coop_invites
for each row execute function private.notify_game_invite_change();

revoke all on function private.insert_player_notification(
  uuid, uuid, text, text, text, jsonb, text
) from public, anon, authenticated;
revoke all on function private.notify_friendship_change()
  from public, anon, authenticated;
revoke all on function private.notify_game_invite_change()
  from public, anon, authenticated;

-- Dispatch push asynchronously. The durable notification row remains the
-- source of truth even when a device has push disabled or is on Windows.
create extension if not exists pg_net with schema extensions;

create or replace function public.verify_notification_webhook_secret(
  p_candidate text
)
returns boolean
language sql
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from vault.decrypted_secrets
    where name = 'balanco_notification_webhook_secret'
      and decrypted_secret = p_candidate
  );
$$;

revoke all on function public.verify_notification_webhook_secret(text)
  from public, anon, authenticated;
grant execute on function public.verify_notification_webhook_secret(text)
  to service_role;

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

  -- The application inbox remains fully functional before push credentials
  -- are configured. Push starts automatically once this Vault secret exists.
  if webhook_secret is null then
    return new;
  end if;

  perform net.http_post(
    url := 'https://xojfseowbcsrfyocfnph.supabase.co/functions/v1/dispatch-player-notification',
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

drop trigger if exists player_notifications_dispatch_push
  on public.player_notifications;
create trigger player_notifications_dispatch_push
after insert on public.player_notifications
for each row execute function private.dispatch_player_notification();

revoke all on function private.dispatch_player_notification()
  from public, anon, authenticated;
