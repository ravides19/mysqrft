# Seed Files Summary

## Overview
Created comprehensive seed files for all schemas defined in the `lib` folder.

## Schemas Covered

### ✅ Geography Schemas
- [x] **Country** (`countries`) - 1 record (India)
- [x] **State** (`states`) - 36 records (All States & UTs)
- [x] **City** (`cities`) - 65 records (Major cities)
- [x] **Locality** (`localities`) - 64 records (Popular localities)
- [x] **Pincode** (`pincodes`) - 50+ records
- [x] **Landmark** (`landmarks`) - 50+ records
- [ ] **LocalityAlias** (`locality_aliases`) - Not seeded (optional)
- [ ] **GeocodingCache** (`geocoding_cache`) - Not seeded (runtime generated)
- [ ] **ReverseGeocodingCache** (`reverse_geocoding_cache`) - Not seeded (runtime generated)

### ✅ User Management Schemas
- [x] **Role** (`roles`) - 5 records (Fixed roles)
- [x] **Profile** (`user_profiles`) - 50 records
- [x] **UserRole** (`user_roles`) - 50 records
- [x] **Address** (`addresses`) - 75+ records
- [x] **Consent** (`consents`) - 150+ records
- [ ] **ConsentHistory** (`consent_history`) - Not seeded (audit log, generated on consent changes)
- [ ] **EmergencyContact** (`emergency_contacts`) - Not seeded (user-specific)
- [ ] **OnboardingFlow** (`onboarding_flows`) - Not seeded (runtime generated)
- [ ] **Preference** (`preferences`) - Not seeded (user-specific)
- [ ] **ProfileCompleteness** (`profile_completeness`) - Not seeded (calculated field)
- [ ] **ProfilePhoto** (`profile_photos`) - Not seeded (requires file uploads)
- [ ] **TrustScore** (`trust_scores`) - Not seeded (calculated field)
- [ ] **VerificationBadge** (`verification_badges`) - Not seeded (earned through verification)

### ✅ Auth Schemas
- [x] **User** (`users`) - 50 records
- [ ] **UserToken** (`users_tokens`) - Not seeded (session tokens, runtime generated)

### ✅ Properties Schemas
- [x] **Property** (`properties`) - 50 records
- [ ] **PropertyImage** (`property_images`) - Not seeded (requires file uploads)
- [ ] **PropertyDocument** (`property_documents`) - Not seeded (requires file uploads)
- [ ] **PropertyPriceHistory** (`property_price_history`) - Not seeded (generated on price changes)

### ✅ Listings Schemas
- [x] **Listing** (`listings`) - 50 records
- [ ] **ListingPriceHistory** (`listing_price_history`) - Not seeded (generated on price changes)

### ✅ Contact Schemas
- [x] **Submission** (`contact_submissions`) - 50 records

## Schemas Not Seeded (By Design)

The following schemas are intentionally not seeded because they are:

1. **Runtime Generated**: Created automatically during application usage
   - GeocodingCache
   - ReverseGeocodingCache
   - UserToken
   - OnboardingFlow

2. **Calculated/Derived**: Computed from other data
   - ProfileCompleteness
   - TrustScore
   - PropertyPriceHistory
   - ListingPriceHistory

3. **Audit Logs**: Historical records generated on changes
   - ConsentHistory

4. **User-Specific**: Require user input or file uploads
   - EmergencyContact
   - Preference
   - ProfilePhoto
   - VerificationBadge
   - PropertyImage
   - PropertyDocument

5. **Optional/Aliases**: Not essential for initial data
   - LocalityAlias

## File Organization

```
priv/repo/
├── seeds.exs                              # Main seed file (imports all)
└── seeds/
    ├── README.md                          # Documentation
    ├── 01_geography_countries.exs         # Countries
    ├── 02_geography_states.exs            # States
    ├── 03_geography_cities.exs            # Cities
    ├── 04_geography_localities.exs        # Localities
    ├── 05_geography_pincodes.exs          # Pincodes
    ├── 06_geography_landmarks.exs         # Landmarks
    ├── 07_user_management_roles.exs       # Roles
    ├── 08_auth_users.exs                  # Users
    ├── 09_user_management_profiles.exs    # Profiles
    ├── 10_user_management_user_roles.exs  # User-Role assignments
    ├── 11_properties.exs                  # Properties
    ├── 12_listings.exs                    # Listings
    ├── 13_user_management_addresses.exs   # Addresses
    ├── 14_user_management_consents.exs    # Consents
    └── 15_contact_submissions.exs         # Contact submissions
```

## Usage

Run all seeds:
```bash
mix run priv/repo/seeds.exs
```

Reset and reseed:
```bash
mix ecto.reset
```

## Statistics

- **Total Schemas in Application**: 31
- **Schemas with Seed Files**: 16
- **Schemas Not Seeded**: 15 (by design)
- **Seed Files Created**: 15 + 1 main file
