# Asset Passport V118 — Security Review Gate

This release does not change the working app UI/navigation.

## Before public launch

- Run `SECURITY-AUDIT.sql` in the Supabase SQL Editor.
- Confirm RLS is enabled for every private table.
- Confirm private policies use `auth.uid()` (or an intentionally documented ownership/transfer rule).
- Confirm public verification exposes only approved public fields.
- Test with two separate accounts: A must not read or modify B's private records.
- Never place a `service_role` secret in browser code.
- Keep the current working deployment available as rollback until these checks pass.

## Important

This package is a review gate, not a substitute for applying database policies. Do not claim the database is secure until the Supabase checks and two-account test pass.
