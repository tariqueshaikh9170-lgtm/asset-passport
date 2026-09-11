# Asset Passport V67

## New
- Real asset creation form with category-specific identity fields.
- Electronics: brand, model, serial, IMEI.
- Car/Bike: make, model, year, VIN/chassis, registration, mileage.
- Property: address, unit/plot, property ID/deed reference, area.
- Furniture: brand, model, serial, material.
- Watch: brand, model, reference, serial.
- Machinery: manufacturer, model, serial, year, operating location.
- Other: identifier, manufacturer/brand, notes.
- Structured details stored in `public.asset_details` via the included migration.

## Migration
Run `asset-details-migration.sql` once in the Supabase SQL editor before using the new category-specific fields.
