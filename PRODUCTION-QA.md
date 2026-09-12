# Asset Passport — Production QA Gate (V119)

V119 is a release-readiness gate. It intentionally makes no UI/navigation changes.

## 1. Existing app smoke test
- [ ] Home loads normally on Android mobile.
- [ ] Assets opens focused Assets mode.
- [ ] + opens Create Asset Passport without the bottom navigation covering the form.
- [ ] Verify opens focused Verify mode.
- [ ] Activity opens focused Activity mode.
- [ ] Closing an asset/modal returns to the normal page.

## 2. Passport CRUD
Use a disposable test passport, not a real user's data.
- [ ] Create a passport.
- [ ] Open it from Assets.
- [ ] Edit name/status/category.
- [ ] Confirm the edited values persist after reload.
- [ ] Add a reminder and confirm it persists after reload.
- [ ] Add an event and confirm it appears in History.
- [ ] Record a sale and confirm it appears in Sales and Activity.

## 3. Ownership / transfers
Use two separate test accounts.
- [ ] Account A creates a disposable passport.
- [ ] Account A sends a transfer request to Account B.
- [ ] Account B sees the request in Transfer Inbox.
- [ ] Account B accepts it.
- [ ] Account B becomes the owner.
- [ ] Account A can no longer modify the private passport data.

## 4. Two-account privacy test (launch blocker)
With Account A and Account B in separate browser sessions:
- [ ] B cannot list or open A's private assets.
- [ ] B cannot read A's private asset details.
- [ ] B cannot read A's reminders.
- [ ] B cannot read A's sales.
- [ ] B cannot read A's activity records.
- [ ] B cannot read A's transfer records unless intentionally shared by the transfer flow.

If any box fails, do not invite real users yet.

## 5. Public verification
- [ ] Verify a passport marked Public from the Verify screen.
- [ ] Confirm verification succeeds.
- [ ] Confirm only intended public registry fields are exposed.
- [ ] Test a non-public passport and confirm private fields are not exposed.
- [ ] Test an invalid passport code and confirm it fails cleanly.

## 6. Database security
- [ ] `SECURITY-AUDIT.sql` completed.
- [ ] RLS is enabled on all private application tables.
- [ ] Policies are reviewed for `auth.uid()` ownership checks or intentional public/transfer exceptions.
- [ ] No service-role key is present in browser code.

## 7. Launch rule
Only proceed to public launch after the two-account privacy test and public-verification test pass.
