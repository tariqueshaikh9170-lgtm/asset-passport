# Asset Passport V67

V61 adds a recipient-side ownership transfer inbox and atomic accept/decline workflow.

## Supabase migration
Run `asset-transfer-acceptance-migration.sql` in Supabase SQL Editor after the existing V60 transfer migration.

The acceptance RPC verifies the signed-in user's email matches the recipient email, changes the asset owner atomically, and marks the request accepted. Decline only marks the request declined.

Existing assets, authentication, documents, QR verification, and timeline features are preserved.


V63 adds a private Activity & Security Log. Run `asset-activity-log-migration.sql` once in Supabase SQL Editor to enable it. The UI remains functional if the migration has not yet been run.

## V67 asset details
Run `asset-details-migration.sql` once in Supabase before creating passports with category-specific details.
