# Asset Passport V84

## Sale Record — final save fix
- Save button is explicitly non-submit.
- Click propagation is stopped so the detail modal cannot close it.
- Sale save performs only the database insert; secondary refreshes cannot disturb the modal.
- Success remains visible inside the sale dialog.
- Sale dialog is explicitly kept open after a successful insert.
- No database migration required.
