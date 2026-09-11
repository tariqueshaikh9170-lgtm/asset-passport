-- Asset Passport V67: structured asset-specific identity details
create table if not exists public.asset_details (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null unique references public.assets(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.asset_details enable row level security;

drop policy if exists "owners can view asset details" on public.asset_details;
drop policy if exists "owners can create asset details" on public.asset_details;
drop policy if exists "owners can update asset details" on public.asset_details;
drop policy if exists "owners can delete asset details" on public.asset_details;

create policy "owners can view asset details"
on public.asset_details for select to authenticated
using (owner_id = auth.uid());

create policy "owners can create asset details"
on public.asset_details for insert to authenticated
with check (owner_id = auth.uid());

create policy "owners can update asset details"
on public.asset_details for update to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create policy "owners can delete asset details"
on public.asset_details for delete to authenticated
using (owner_id = auth.uid());

grant select, insert, update, delete on table public.asset_details to authenticated;

create or replace function public.set_asset_details_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists asset_details_updated_at on public.asset_details;
create trigger asset_details_updated_at
before update on public.asset_details
for each row execute function public.set_asset_details_updated_at();
