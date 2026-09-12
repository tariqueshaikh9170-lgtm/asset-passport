-- Asset Passport V118 — READ-ONLY security review
-- This script does NOT change the database.

-- 1) RLS status for core tables.
select n.nspname as schema_name, c.relname as table_name,
       c.relrowsecurity as rls_enabled,
       c.relforcerowsecurity as rls_forced
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in (
    'assets','asset_details','asset_activity_log','asset_events',
    'asset_reminders','asset_sales','asset_transfer_requests'
  )
order by c.relname;

-- 2) All policies on those tables.
select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in (
    'assets','asset_details','asset_activity_log','asset_events',
    'asset_reminders','asset_sales','asset_transfer_requests'
  )
order by tablename, policyname;

-- 3) Flag policies that do not visibly reference auth.uid().
-- Review these manually: public verification/transfer policies may be intentional.
select schemaname, tablename, policyname, cmd, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in (
    'assets','asset_details','asset_activity_log','asset_events',
    'asset_reminders','asset_sales','asset_transfer_requests'
  )
  and coalesce(qual,'') not ilike '%auth.uid()%'
  and coalesce(with_check,'') not ilike '%auth.uid()%'
order by tablename, policyname;

-- 4) Browser-key reminder: only a publishable/anon key belongs in index.html.
-- Never put a Supabase service_role key in browser code.
