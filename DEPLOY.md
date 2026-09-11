# Asset Passport — Live HTTPS deployment

This package is prepared for static HTTPS hosting such as Cloudflare Pages or Netlify.

## Deploy
1. Upload the contents of this folder (not the parent folder) to your static host.
2. The host must serve `index.html` at `/` and `verify.html` at `/verify.html`.
3. Confirm the site uses HTTPS.
4. Open the HTTPS site and sign in.
5. Open a passport, choose QR Passport, and scan the QR with another device.
6. The QR should open `/verify.html?code=PP-XXXXXXXX` and show the verified passport.

## Important
- Do not upload any Supabase service-role or secret key to the browser.
- `config.js` contains only the browser-safe publishable key.
- Supabase database migrations in this package are not automatically applied by static hosting.
