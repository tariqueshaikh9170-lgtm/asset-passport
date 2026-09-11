-- Asset Passport V72: live passport timeline events
create table if not exists public.asset_events (
  id uuid primary key default gen_random_uuid(),
  asset_id uuid not null references public.assets(id) on delete cascade,
  actor_user_id uuid not null references auth.users(id) on delete cascade,
  event_type text not null default 'note',
  event_date date not null default current_date,
  event_text text not null,
  created_at timestamptz not null default now()
);

create index if not exists asset_events_asset_date_idx
on public.asset_events(asset_id, event_date desc, created_at desc);

alter table public.asset_events enable row level security;

drop policy if exists "owners can view asset events" on public.asset_events;
drop policy if exists "owners can create asset events" on public.asset_events;
drop policy if exists "owners can update asset events" on public.asset_events;
drop policy if exists "owners can delete asset events" on public.asset_events;

create policy "owners can view asset events"
on public.asset_events for select to authenticated
using (actor_user_id = auth.uid() or exists (
  select 1 from public.assets a
  where a.id = asset_events.asset_id and a.owner_id = auth.uid()
));

create policy "owners can create asset events"
on public.asset_events for insert to authenticated
with check (
  actor_user_id = auth.uid()
  and exists (
    select 1 from public.assets a
    where a.id = asset_events.asset_id and a.owner_id = auth.uid()
  )
);

create policy "owners can update asset events"
on public.asset_events for update to authenticated
using (exists (
  select 1 from public.assets a
  where a.id = asset_events.asset_id and a.owner_id = auth.uid()
))
with check (actor_user_id = auth.uid());

create policy "owners can delete asset events"
on public.asset_events for delete to authenticated
using (exists (
  select 1 from public.assets a
  where a.id = asset_events.asset_id and a.owner_id = auth.uid()
));

grant select, insert, update, delete on table public.asset_events to authenticated;
