-- The platform RLS event-trigger helper is DDL-only and must not be exposed
-- through the Data API to anonymous or signed-in game clients.
revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
