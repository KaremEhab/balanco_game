drop policy if exists "coop members receive realtime" on realtime.messages;
drop policy if exists "coop members send realtime" on realtime.messages;

create policy "coop members receive realtime" on realtime.messages
for select to authenticated using (
  realtime.messages.extension in ('broadcast', 'presence')
  and case
    when (select realtime.topic()) ~ '^coop:[0-9a-fA-F-]{36}$'
      then public.is_coop_member(substr((select realtime.topic()), 6)::uuid)
    else false
  end
);

create policy "coop members send realtime" on realtime.messages
for insert to authenticated with check (
  realtime.messages.extension in ('broadcast', 'presence')
  and case
    when (select realtime.topic()) ~ '^coop:[0-9a-fA-F-]{36}$'
      then public.is_coop_member(substr((select realtime.topic()), 6)::uuid)
    else false
  end
);
