# Database Seeds

This directory contains seed files for populating the database with initial data.

## Structure

Seed files are organized numerically to ensure they run in the correct dependency order:

### Geography (01-06)
- `01_geography_countries.exs` - Countries (India)
- `02_geography_states.exs` - Indian states
- `03_geography_cities.exs` - Major cities
- `04_geography_localities.exs` - Popular localities within cities
- `05_geography_pincodes.exs` - Postal codes
- `06_geography_landmarks.exs` - Notable landmarks

### User Management (07-10, 13-14)
- `07_user_management_roles.exs` - User roles (owner, tenant, buyer, agent, admin)
- `08_auth_users.exs` - Demo users with authentication
- `09_user_management_profiles.exs` - User profiles
- `10_user_management_user_roles.exs` - User-role assignments
- `13_user_management_addresses.exs` - User addresses
- `14_user_management_consents.exs` - User consents

### Properties & Listings (11-12)
- `11_properties.exs` - Sample properties
- `12_listings.exs` - Property listings (rent/sale)

### Contact (15)
- `15_contact_submissions.exs` - Contact form submissions

## Usage

### Run All Seeds
```bash
mix run priv/repo/seeds.exs
```

### Run Individual Seed File
```bash
mix run priv/repo/seeds/01_geography_countries.exs
```

### Reset and Reseed Database
```bash
mix ecto.reset
```

## Demo Users

The seed creates 4 demo users with the following credentials:

**Password for all users:** `Password123!`

1. **Ravi Kumar**
   - Email: ravi@example.com
   - Mobile: +919876543210
   - Role: Owner

2. **Priya Sharma**
   - Email: priya@example.com
   - Mobile: +919876543211
   - Role: Tenant

3. **Amit Patel**
   - Email: amit@example.com
   - Mobile: +919876543212
   - Roles: Owner, Buyer

4. **Sneha Reddy**
   - Email: sneha@example.com
   - Mobile: +919876543213
   - Role: Agent

## Data Overview

After running seeds, you'll have a comprehensive dataset including:
- 1 Country (India)
- 36 States and Union Territories
- 65 Major cities covering all states
- 64 Popular localities in top metros
- 50+ Pincodes linked to cities
- 50+ Landmarks across various categories
- 5 User roles
- 50 Demo users with profiles and roles
- 50 Properties (Apartments, Villas, etc.)
- 50 Listings (Rent, Sale)
- 75+ User addresses
- 150+ User consent records
- 50 Contact submissions

## Adding New Seeds

When adding new seed files:

1. Create a new file with a numeric prefix (e.g., `16_new_feature.exs`)
2. Add the filename to the `seed_files` list in `priv/repo/seeds.exs`
3. Ensure dependencies are seeded before your file runs
4. Use `Repo.insert!` for required data
5. Add helpful output messages using `IO.puts`

## Notes

- Seeds are idempotent where possible
- Some seeds depend on others (e.g., cities depend on states)
- The order matters! Don't change the numeric prefixes without updating dependencies
- All timestamps use UTC
- Geographic data includes coordinates for mapping features
