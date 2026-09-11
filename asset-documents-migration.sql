-- Asset Passport V59: secure Documents Vault
-- Run once in Supabase SQL Editor.

insert into storage.buckets (id, name, public)
values ('asset-documents', 'asset-documents', false)
on conflict (id) do nothing;

create table if not exists public.asset_documents (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null references public.assets(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  file_name text not null,
  file_size bigint not null,
  mime_type text not null,
  storage_path text not null unique,
  created_at timestamptz not null default now()
);

alter table public.asset_documents enable row level security;

drop policy if exists "document owners can view" on public.asset_documents;
drop policy if exists "document owners can insert" on public.asset_documents;
drop policy if exists "document owners can delete" on public.asset_documents;

create policy "document owners can view"
on public.asset_documents for select to authenticated
using (owner_id = auth.uid());

create policy "document owners can insert"
on public.asset_documents for insert to authenticated
with check (owner_id = auth.uid());

create policy "document owners can delete"
on public.asset_documents for delete to authenticated
using (owner_id = auth.uid());

grant select, insert, delete on public.asset_documents to authenticated;

drop policy if exists "asset document storage select" on storage.objects;
drop policy if exists "asset document storage insert" on storage.objects;
drop policy if exists "asset document storage delete" on storage.objects;

create policy "asset document storage select"
on storage.objects for select to authenticated
using (bucket_id = 'asset-documents' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "asset document storage insert"
on storage.objects for insert to authenticated
with check (bucket_id = 'asset-documents' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "asset document storage delete"
on storage.objects for delete to authenticated
using (bucket_id = 'asset-documents' and (storage.foldername(name))[1] = auth.uid()::text);
