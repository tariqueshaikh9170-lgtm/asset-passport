-- Asset Passport V117 — pre-launch Supabase security audit
-- READ-ONLY: this script does NOT change your database.
-- Run it in Supabase SQL Editor before public launch.

-- 1) Check whether Row Level Security is enabled on application tables.
select
  n.nspname as schema_name,
  c.relname as table_name,
  c.relrowsecurity as rls_enabled,
  c.relforcerowsecurity as rls_forced
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in (
    'assets',
    'asset_details',
    'asset_activity_log',
    'asset_events',
    'asset_reminders',
    'asset_sales',
    'asset_transfer_requests'
  )
order by c.relname;

-- 2) Show every policy currently protecting those tables.
select
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
from pg_policies
where schemaname = 'public'
  and tablename in (
    'assets',
    'asset_details',
    'asset_activity_log',
    'asset_events',
    'asset_reminders',
    'asset_sales',
    'asset_transfer_requests'
  )
order by tablename, policyname;

-- 3) Confirm the browser-safe key is not a service-role secret.
-- The app should ONLY contain a publishable/anon key in index.html.
-- Never paste a service_role key into browser code.
