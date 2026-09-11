# Asset Passport V78

- Ownership Center now shows pending/accepted/declined/cancelled status states.
- Added cancel action for outgoing pending transfer requests.
- Prevents sending a transfer to the signed-in user's own email.
- Prevents duplicate pending transfer requests for the same passport.
- Refreshes transfer inbox after a successful send.
- No new database migration required; uses the existing `asset_transfer_requests` table and transfer RPCs.
