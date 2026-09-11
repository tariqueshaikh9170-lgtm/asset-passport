-- Asset Passport V81 — private resale/sale records
-- Run once in Supabase SQL Editor, then refresh the app.

create extension if not exists pgcrypto;

create table if not exists public.asset_sales (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null references public.assets(id) on delete cascade,
  seller_owner_id uuid not null references auth.users(id) on delete cascade,
  sale_price numeric(14,2) not null check (sale_price >= 0),
  currency text not null default 'QAR' check (currency ~ '^[A-Z]{3}$'),
  sale_date date not null default current_date,
  buyer_name text,
  buyer_email text,
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists asset_sales_asset_idx on public.asset_sales(asset_id, sale_date desc, created_at desc);
create index if not exists asset_sales_seller_idx on public.asset_sales(seller_owner_id, created_at desc);

alter table public.asset_sales enable row level security;

drop policy if exists "owners can view sale records" on public.asset_sales;
drop policy if exists "owners can create sale records" on public.asset_sales;
drop policy if exists "owners can update sale records" on public.asset_sales;
drop policy if exists "owners can delete sale records" on public.asset_sales;

create policy "owners can view sale records"
on public.asset_sales for select to authenticated
using (seller_owner_id = auth.uid());

create policy "owners can create sale records"
on public.asset_sales for insert to authenticated
with check (seller_owner_id = auth.uid() and exists (select 1 from public.assets a where a.id = asset_id and a.owner_id = auth.uid()));

create policy "owners can update sale records"
on public.asset_sales for update to authenticated
using (seller_owner_id = auth.uid())
with check (seller_owner_id = auth.uid());

create policy "owners can delete sale records"
on public.asset_sales for delete to authenticated
using (seller_owner_id = auth.uid());

grant select, insert, update, delete on table public.asset_sales to authenticated;
