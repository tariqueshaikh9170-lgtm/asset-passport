# Asset Passport V82

## Sale record reliability fix
- Fixed the sale save button remaining disabled when an ancillary activity/history refresh stalled.
- Added visible "Saving sale record…" feedback.
- Added timeout handling for the sale insert and optional sold-status update.
- Sale success is shown immediately after the sale record is stored; background refreshes no longer block the modal.
- No database schema changes from V81.
