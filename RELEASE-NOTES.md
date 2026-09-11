# Asset Passport V72

- Connects the passport timeline to a live `public.asset_events` table.
- Adds owner-only RLS policies for service, repair, inspection, ownership-transfer and note events.
- Timeline events are stored against the passport and reload from Supabase.
- Includes `asset-events-migration.sql` for the one-time Supabase database setup.
