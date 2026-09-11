-- Asset Passport V62: private activity/audit log
create table if not exists public.asset_activity_log (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  asset_id uuid null references public.assets(id) on delete set null,
  event_type text not null,
  event_text text not null,
  created_at timestamptz not null default now()
);

alter table public.asset_activity_log enable row level security;
drop policy if exists "owners can view activity" on public.asset_activity_log;
drop policy if exists "owners can create activity" on public.asset_activity_log;
create policy "owners can view activity" on public.asset_activity_log for select to authenticated using (owner_id = auth.uid());
create policy "owners can create activity" on public.asset_activity_log for insert to authenticated with check (owner_id = auth.uid());
grant select, insert on table public.asset_activity_log to authenticated;
create index if not exists asset_activity_log_owner_created_idx on public.asset_activity_log(owner_id, created_at desc);
