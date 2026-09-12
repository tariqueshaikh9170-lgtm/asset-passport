# Asset Passport — Launch Gate

Before inviting real users:

1. Run `SECURITY-AUDIT.sql` in Supabase SQL Editor.
2. Confirm RLS is enabled on every private application table.
3. Confirm policies restrict owner/private records to `auth.uid()` (or an intentional transfer/public-verification rule).
4. Never put a Supabase `service_role` key in browser code.
5. Test with two separate accounts: Account A must not see Account B's private assets, details, sales, reminders, activity, or transfer data.
6. Test public verification: only explicitly public registry fields should be visible.
7. Keep the currently working V116 deployment as the rollback point until these tests pass.
