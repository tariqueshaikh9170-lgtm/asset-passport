V118 — security review gate.
No app UI or navigation changes from V117.
Refined the read-only Supabase audit to report RLS, policies, and policies that need manual review when they do not visibly reference auth.uid().
Added SECURITY-REVIEW.md with the two-account isolation test and public-verification launch gate.

V119 — production launch QA gate.
No app UI/navigation changes. Added PRODUCTION-QA.md covering mobile smoke tests, passport CRUD, reminders/history/sales, ownership transfer, two-account privacy isolation, public verification, and database-security launch blockers.
