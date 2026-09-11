# Asset Passport V80

## Ownership transfer completion
- Adds the complete `asset_transfer_requests` database setup migration.
- Adds secure RLS for senders and recipients.
- Adds recipient-only accept/decline RPCs.
- Accepting a request changes the passport owner and records an ownership-transfer timeline event.
- Passport detail now shows both sent and incoming requests for that passport.
- No changes to the existing assets, documents, events, or verification schemas.

## Required one-time setup
Run `asset-transfer-migration.sql` once in the Supabase SQL Editor, then refresh the app.
