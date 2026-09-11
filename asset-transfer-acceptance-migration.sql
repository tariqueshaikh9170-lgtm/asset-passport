-- Asset Passport V61: recipient inbox + atomic accept/decline workflow
alter table public.asset_transfer_requests add column if not exists responded_at timestamptz;

alter table public.asset_transfer_requests enable row level security;
drop policy if exists "transfer requests recipient access" on public.asset_transfer_requests;
create policy "transfer requests recipient access"
on public.asset_transfer_requests for select to authenticated
using (lower(recipient_email) = lower(coalesce(auth.jwt()->>'email','')));

drop policy if exists "transfer requests recipient update" on public.asset_transfer_requests;
create policy "transfer requests recipient update"
on public.asset_transfer_requests for update to authenticated
using (lower(recipient_email) = lower(coalesce(auth.jwt()->>'email','')))
with check (lower(recipient_email) = lower(coalesce(auth.jwt()->>'email','')));

grant execute on function public.accept_asset_transfer(uuid) to authenticated;
grant execute on function public.decline_asset_transfer(uuid) to authenticated;

drop function if exists public.accept_asset_transfer(uuid);
create or replace function public.accept_asset_transfer(p_request_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare r asset_transfer_requests%rowtype; email_now text;
begin
  email_now := lower(coalesce(auth.jwt()->>'email',''));
  select * into r from public.asset_transfer_requests where id=p_request_id for update;
  if not found then raise exception 'Transfer request not found'; end if;
  if lower(r.recipient_email) <> email_now then raise exception 'Not authorized'; end if;
  if r.status <> 'pending' then raise exception 'Transfer request is no longer pending'; end if;
  update public.assets set owner_id=auth.uid(), status='active', updated_at=now() where id=r.asset_id;
  if not found then raise exception 'Asset not found'; end if;
  update public.asset_transfer_requests set status='accepted', responded_at=now() where id=r.id;
  return jsonb_build_object('ok',true,'request_id',r.id,'asset_id',r.asset_id,'status','accepted');
end; $$;

drop function if exists public.decline_asset_transfer(uuid);
create or replace function public.decline_asset_transfer(p_request_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare r asset_transfer_requests%rowtype; email_now text;
begin
  email_now := lower(coalesce(auth.jwt()->>'email',''));
  select * into r from public.asset_transfer_requests where id=p_request_id for update;
  if not found then raise exception 'Transfer request not found'; end if;
  if lower(r.recipient_email) <> email_now then raise exception 'Not authorized'; end if;
  if r.status <> 'pending' then raise exception 'Transfer request is no longer pending'; end if;
  update public.asset_transfer_requests set status='declined', responded_at=now() where id=r.id;
  return jsonb_build_object('ok',true,'request_id',r.id,'status','declined');
end; $$;

grant execute on function public.accept_asset_transfer(uuid) to authenticated;
grant execute on function public.decline_asset_transfer(uuid) to authenticated;
