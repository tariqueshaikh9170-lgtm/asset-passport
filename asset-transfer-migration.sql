-- Asset Passport V60: ownership transfer requests
create table if not exists public.asset_transfer_requests (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null references public.assets(id) on delete cascade,
  from_owner_id uuid not null references auth.users(id) on delete cascade,
  recipient_email text not null,
  message text,
  status text not null default 'pending' check (status in ('pending','accepted','declined','cancelled','expired')),
  created_at timestamptz not null default now(),
  responded_at timestamptz
);

alter table public.asset_transfer_requests enable row level security;
drop policy if exists "transfer requests sender access" on public.asset_transfer_requests;
create policy "transfer requests sender access" on public.asset_transfer_requests
for all to authenticated
using (from_owner_id = auth.uid())
with check (from_owner_id = auth.uid());

grant select, insert, update, delete on public.asset_transfer_requests to authenticated;
create index if not exists asset_transfer_requests_asset_idx on public.asset_transfer_requests(asset_id);
create index if not exists asset_transfer_requests_email_idx on public.asset_transfer_requests(lower(recipient_email));
