-- Asset Passport V73: document categories
-- Run once in Supabase SQL Editor.
-- Keeps existing documents and removes the old restrictive document_type check
-- so the app can safely use human-readable document categories.

alter table public.asset_documents
  alter column document_type set default 'document';

update public.asset_documents
set document_type = 'document'
where document_type is null or btrim(document_type) = '';

alter table public.asset_documents
  drop constraint if exists asset_documents_document_type_check;

-- No replacement CHECK is intentionally added: future document categories can
-- be introduced by the app without another database migration.
