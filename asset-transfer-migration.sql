-- Asset Passport V80 — ownership transfer setup
-- Run once in Supabase SQL Editor, then refresh the app.

create extension if not exists pgcrypto;

create table if not exists public.asset_transfer_requests (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null references public.assets(id) on delete cascade,
  from_owner_id uuid not null references auth.users(id) on delete cascade,
  recipient_email text not null,
  message text,
  status text not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint asset_transfer_requests_status_check check (status in ('pending','accepted','declined','cancelled'))
);

create index if not exists asset_transfer_requests_asset_idx on public.asset_transfer_requests(asset_id, created_at desc);
create index if not exists asset_transfer_requests_from_owner_idx on public.asset_transfer_requests(from_owner_id, created_at desc);
create index if not exists asset_transfer_requests_recipient_idx on public.asset_transfer_requests(lower(recipient_email), status, created_at desc);

alter table public.asset_transfer_requests enable row level security;

drop policy if exists "owners can view sent transfer requests" on public.asset_transfer_requests;
drop policy if exists "recipients can view incoming transfer requests" on public.asset_transfer_requests;
drop policy if exists "owners can create transfer requests" on public.asset_transfer_requests;
drop policy if exists "owners can cancel transfer requests" on public.asset_transfer_requests;

create policy "owners can view sent transfer requests"
on public.asset_transfer_requests for select to authenticated
using (from_owner_id = auth.uid());

create policy "recipients can view incoming transfer requests"
on public.asset_transfer_requests for select to authenticated
using (lower(recipient_email) = lower(coalesce(auth.email(), '')));

create policy "owners can create transfer requests"
on public.asset_transfer_requests for insert to authenticated
with check (
  from_owner_id = auth.uid()
  and exists (select 1 from public.assets a where a.id = asset_id and a.owner_id = auth.uid())
);

create policy "owners can cancel transfer requests"
on public.asset_transfer_requests for update to authenticated
using (from_owner_id = auth.uid())
with check (from_owner_id = auth.uid());

grant select, insert, update on table public.asset_transfer_requests to authenticated;

create or replace function public.accept_asset_transfer(p_request_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  r public.asset_transfer_requests%rowtype;
  recipient uuid;
  old_owner uuid;
  asset_name text;
begin
  select * into r
  from public.asset_transfer_requests
  where id = p_request_id
    and status = 'pending'
    and lower(recipient_email) = lower(coalesce(auth.email(), ''))
  for update;

  if not found then
    raise exception 'Transfer request not found or not assigned to your account';
  end if;

  recipient := auth.uid();
  select owner_id, name into old_owner, asset_name from public.assets where id = r.asset_id for update;

  if old_owner is null then
    raise exception 'Asset owner could not be found';
  end if;

  update public.assets
  set owner_id = recipient, updated_at = now()
  where id = r.asset_id and owner_id = old_owner;

  if not found then
    raise exception 'Asset is no longer owned by the sender';
  end if;

  update public.asset_transfer_requests
  set status = 'accepted', updated_at = now()
  where id = r.id;

  insert into public.asset_events(asset_id, actor_user_id, event_type, event_date, event_text)
  values (r.asset_id, recipient, 'ownership_transfer', current_date, 'Ownership transfer accepted');

  return jsonb_build_object('ok', true, 'asset_id', r.asset_id, 'request_id', r.id, 'status', 'accepted');
end;
$$;

grant execute on function public.accept_asset_transfer(uuid) to authenticated;

create or replace function public.decline_asset_transfer(p_request_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.asset_transfer_requests
  set status = 'declined', updated_at = now()
  where id = p_request_id
    and status = 'pending'
    and lower(recipient_email) = lower(coalesce(auth.email(), ''));

  if not found then
    raise exception 'Transfer request not found or not assigned to your account';
  end if;

  return jsonb_build_object('ok', true, 'request_id', p_request_id, 'status', 'declined');
end;
$$;

grant execute on function public.decline_asset_transfer(uuid) to authenticated;

-- Keep updated_at current for future edits.
create or replace function public.asset_transfer_requests_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists asset_transfer_requests_touch_updated_at on public.asset_transfer_requests;
create trigger asset_transfer_requests_touch_updated_at
before update on public.asset_transfer_requests
for each row execute function public.asset_transfer_requests_touch_updated_at();
