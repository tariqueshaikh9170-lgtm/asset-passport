-- Asset Passport V86: warranty & service reminders
create table if not exists public.asset_reminders (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null references public.assets(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  reminder_type text not null default 'other',
  title text not null,
  due_date date not null,
  notes text,
  status text not null default 'open',
  created_at timestamptz not null default now()
);

alter table public.asset_reminders enable row level security;
drop policy if exists "owners can view their reminders" on public.asset_reminders;
drop policy if exists "owners can create their reminders" on public.asset_reminders;
drop policy if exists "owners can update their reminders" on public.asset_reminders;
drop policy if exists "owners can delete their reminders" on public.asset_reminders;
create policy "owners can view their reminders" on public.asset_reminders for select to authenticated using (owner_id = auth.uid());
create policy "owners can create their reminders" on public.asset_reminders for insert to authenticated with check (owner_id = auth.uid());
create policy "owners can update their reminders" on public.asset_reminders for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());
create policy "owners can delete their reminders" on public.asset_reminders for delete to authenticated using (owner_id = auth.uid());
grant select, insert, update, delete on table public.asset_reminders to authenticated;
create index if not exists asset_reminders_asset_due_idx on public.asset_reminders(asset_id, due_date);
