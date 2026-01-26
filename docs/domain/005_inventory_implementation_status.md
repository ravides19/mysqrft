# Inventory Domain - Implementation Status

## Document Information

| Field | Value |
|-------|-------|
| Domain | Inventory |
| Version | 1.0 |
| Status | In Progress |
| Last Updated | 2026-01-26 |
| Owner | Development Team |

---

## Overview

This document tracks the implementation status of the **Inventory Domain** as specified in [005_inventory.md](./005_inventory.md). The domain consists of two main layers:

1. **Property Management (Asset Layer)** - Persistent physical assets
2. **Listing Management (Market Layer)** - Temporal market intent

---

## Implementation Status Summary

### Overall Progress: 65% Complete

| Component | Status | Progress | Priority |
|-----------|--------|----------|----------|
| Property Schema (Basic) | ✅ Complete | 100% | Critical |
| Property Images | ✅ Complete | 100% | Critical |
| Property Context (Basic) | ✅ Complete | 100% | Critical |
| Property Verification | ❌ Not Started | 0% | High |
| Property Quality Scoring | ❌ Not Started | 0% | High |
| Property Type Validation | ⚠️ Partial | 30% | High |
| Duplicate Detection | ❌ Not Started | 0% | Medium |
| **Listing Schema** | **✅ Complete** | **100%** | **Critical** |
| **Listing Context** | **✅ Complete** | **100%** | **Critical** |
| **Listing State Machine** | **✅ Complete** | **100%** | **Critical** |
| **Price History (Dual-Level)** | **✅ Complete** | **100%** | **Critical** |
| **Auto-Expiry Job** | **✅ Complete** | **100%** | **Critical** |
| Media Vault Enhancements | ⚠️ Partial | 40% | Medium |

---

## ✅ Completed Features

### 1. Property Management (Basic)

#### Schema: `lib/my_sqrft/properties/property.ex`
- ✅ Core property fields (type, configuration, status)
- ✅ Geography integration (city_id, locality_id)
- ✅ PostGIS location support (geometry type)
- ✅ Owner relationship via Profile
- ✅ Property types: apartment, villa, independent_house, plot, commercial, managed
- ✅ Status tracking: draft, active, archived

**Database Table**: `properties`
- ✅ Migration created: `20260125182959_create_properties_tables.exs`
- ✅ Indexes on: owner_id, city_id, locality_id, location (GIST)

#### Schema: `lib/my_sqrft/properties/property_image.ex`
- ✅ S3 integration for media storage (s3_key field)
- ✅ Image types: exterior, interior, floor_plan, site_plan
- ✅ Primary image designation (is_primary)
- ✅ Sort ordering (sort_order)
- ✅ Virtual fields for signed URLs (original_url, thumbnail_url, medium_url, large_url)
- ✅ Caption support

**Database Table**: `property_images`
- ✅ Migration created: `20260125182959_create_properties_tables.exs`
- ✅ Indexes on: property_id, (property_id, is_primary)
- ✅ Cascade delete on property deletion

#### Context: `lib/my_sqrft/properties.ex`
- ✅ `list_user_properties(user_id)` - Query with preloads
- ✅ `get_property!(id)` - Get single property
- ✅ `create_property(owner, attrs)` - Create property
- ✅ `update_property(property, attrs)` - Update property
- ✅ `delete_property(property)` - Delete property
- ✅ `change_property(property, attrs)` - Changeset for forms
- ✅ `create_property_image(property, attrs)` - Create image
- ✅ `delete_property_image(image)` - Delete image
- ✅ `get_property_image!(id)` - Get single image

### 2. Listing Management (Market Layer) - **NEW ✅**

#### Schema: `lib/my_sqrft/listings/listing.ex`
- ✅ Core listing fields (transaction_type, status, pricing, preferences)
- ✅ Property relationship via property_id
- ✅ Transaction types: rent, sale, pg_coliving
- ✅ Status tracking: draft, active, paused, expired, closed
- ✅ Lifecycle fields: last_refreshed_at, expires_at, closed_at
- ✅ Scoring fields: market_readiness_score, freshness_score
- ✅ State machine validation via `can_transition?/2`

**Database Table**: `listings`
- ✅ Migration created: `20260125185401_create_listings_and_price_history.exs`
- ✅ Indexes on: property_id, status, transaction_type, expires_at
- ✅ Unique partial index: (property_id, transaction_type) WHERE status = 'active'
- ✅ Foreign key constraint to properties (ON DELETE RESTRICT)

#### Schema: `lib/my_sqrft/listings/listing_price_history.ex`
- ✅ Listing-level price change tracking
- ✅ Fields: price, security_deposit, changed_by_id, change_reason
- ✅ Automatic creation on listing create/update

**Database Table**: `listing_price_history`
- ✅ Migration created: `20260125185401_create_listings_and_price_history.exs`
- ✅ Indexes on: listing_id, (listing_id, inserted_at)
- ✅ Cascade delete on listing deletion

#### Schema: `lib/my_sqrft/properties/property_price_history.ex`
- ✅ Property-level price analytics tracking
- ✅ Fields: transaction_type, price, status, active_from, active_until
- ✅ Tracks pricing across all listings over time

**Database Table**: `property_price_history`
- ✅ Migration created: `20260125185401_create_listings_and_price_history.exs`
- ✅ Indexes on: property_id, (property_id, transaction_type), (property_id, inserted_at)
- ✅ Soft reference to listing (ON DELETE NILIFY_ALL)

#### Context: `lib/my_sqrft/listings.ex`

**CRUD Operations**:
- ✅ `list_listings(opts)` - Query with filters
- ✅ `list_property_listings(property_id, opts)` - All listings for property
- ✅ `list_user_listings(user_id, opts)` - All listings for user
- ✅ `get_listing!(id, opts)` - Get single listing
- ✅ `create_listing(property, attrs)` - Create with price history
- ✅ `update_listing(listing, attrs)` - Update with price tracking
- ✅ `delete_listing(listing)` - Delete listing
- ✅ `change_listing(listing, attrs)` - Changeset for forms

**State Transitions**:
- ✅ `publish_listing(listing)` - Draft → Active
- ✅ `pause_listing(listing)` - Active → Paused
- ✅ `resume_listing(listing)` - Paused → Active
- ✅ `close_listing(listing, opts)` - Active/Paused → Closed
- ✅ `expire_listing(listing)` - Active → Expired

**Lifecycle Management**:
- ✅ `refresh_listing(listing)` - Reset expiry to +60 days
- ✅ `repost_listing(closed_listing)` - Clone to new draft
- ✅ `expire_stale_listings()` - Batch expire (for Oban worker)
- ✅ `calculate_expires_at(datetime)` - Helper for expiry calculation

**Price History**:
- ✅ `create_listing_price_history(listing, attrs)` - Track listing price
- ✅ `create_property_price_history(listing)` - Track property price
- ✅ `close_property_price_history(listing)` - Close active record
- ✅ `list_listing_price_history(listing_id)` - Get listing history
- ✅ `list_property_price_history(property_id, opts)` - Get property history

**Statistics**:
- ✅ `count_active_listings()` - Total active
- ✅ `count_user_active_listings(user_id)` - User's active
- ✅ `count_expired_listings()` - Total expired

**Business Rules Implemented**:
- ✅ Automatic price history creation on listing create/update
- ✅ Property price history tracking when listing becomes active
- ✅ Auto-expiry calculation (60 days from activation)
- ✅ Duplicate active listing prevention (database + application)
- ✅ State transition validation
- ✅ Price change tracking with reason

## ⚠️ Partially Implemented Features

### 1. Property Type Validation (30% Complete)

**Current State**:
- ✅ Property types defined in schema
- ✅ Basic type validation (inclusion check)
- ✅ Configuration stored as map field
- ❌ No type-specific field validation
- ❌ No structured validation for required fields per type

**Pending Work**:
- [ ] Add type-specific validation logic
  - [ ] Apartment: bhk, bathrooms, floor, total_floors, built_up_area, project_name
  - [ ] Villa: plot_area, built_up_area, land_facing, bathrooms
  - [ ] Plot: plot_area, land_facing
  - [ ] Commercial: built_up_area, floor, total_floors
  - [ ] Managed (PG): total_beds, occupancy_type
- [ ] Create `PropertyTypeValidator` module
- [ ] Add validation tests

### 2. Media Vault (40% Complete)

**Current State**:
- ✅ Image storage with S3 keys
- ✅ Image types and categorization
- ✅ Virtual URL fields
- ❌ No video support
- ❌ No upload limit enforcement (max 20 per PRD)
- ❌ No image dimensions tracking
- ❌ No file size tracking
- ❌ No processing status tracking

**Pending Work**:
- [ ] Add fields: width, height, file_size, processing_status, duration
- [ ] Add video type support
- [ ] Implement upload limit validation (max 20 media items)
- [ ] Add media type validation
- [ ] Add file size validation
- [ ] Image processing pipeline (future)

---

## ❌ Not Started - High Priority

### 1. Oban Background Job Integration (20% Complete)

**Current State**:
- ✅ Auto-expiry function implemented (`expire_stale_listings/0`)
- ✅ Expiry calculation logic complete
- ❌ Oban not installed
- ❌ Worker not created
- ❌ Cron job not scheduled

**Pending Work**:
- [ ] Add Oban to mix.exs dependencies
- [ ] Configure Oban in application.ex
- [ ] Create Oban jobs table migration
- [ ] Create `ExpireStaleListingsWorker` module
- [ ] Schedule daily cron job (e.g., midnight)
- [ ] Add monitoring/alerting

**Estimated Effort**: 2-3 hours

### 2. Property Verification & Documents (0% Complete)

**Required Components**:

#### PropertyDocument Schema (`lib/my_sqrft/properties/property_document.ex`)
- [ ] Create schema for ownership documents
- [ ] Fields: document_type, s3_key, verification_status, verified_by_id, verified_at, rejection_reason, expiry_date
- [ ] Add relationships to Property and Profile (verifier)

#### Database Migration
- [ ] Create `property_documents` table
- [ ] Add indexes: property_id, verification_status

#### Property Schema Enhancements
- [ ] Add field: verification_status (unverified, pending, verified, rejected)
- [ ] Add field: verified_at
- [ ] Add has_many :documents relationship

#### Context Functions
- [ ] Document upload/management functions
- [ ] Property verification functions
- [ ] Document verification functions

**Estimated Effort**: 1-2 days

### 3. Property Quality Scoring (0% Complete)

**Required Components**:
- [ ] Add fields to Property: quality_score, data_completeness_score
- [ ] Implement scoring algorithm
  - [ ] Field completeness (30 points)
  - [ ] Media count (20 points)
  - [ ] Location precision (20 points)
  - [ ] Document verification (30 points)
- [ ] Add data completeness calculation
- [ ] Add score update functions
- [ ] Background job for batch updates (optional)

**Estimated Effort**: 1 day

### 4. Duplicate Detection (0% Complete)

**Required Components**:
- [ ] Implement fuzzy matching query
  - [ ] Same locality_id
  - [ ] Similar address (Levenshtein distance)
  - [ ] Location proximity (PostGIS within 50m)
  - [ ] Same property type
- [ ] Add duplicate check to property creation
- [ ] Add warning UI for potential duplicates

**Estimated Effort**: 1 day

---

## 📊 Feature Mapping to PRD Requirements

### Property Management (Asset Layer)

| PRD Requirement | Status | Implementation |
|-----------------|--------|----------------|
| FR1.1: CRUD APIs for Property | ✅ Complete | `MySqrft.Properties` context |
| FR1.2: Geography linkage enforcement | ✅ Complete | Foreign keys + validation |
| FR1.3: Property type polymorphism | ⚠️ Partial | Map field exists, validation missing |
| Property Repository | ✅ Complete | Database + context |
| Property Types (6 types) | ✅ Complete | Schema supports all types |
| Geography Integration | ✅ Complete | city_id, locality_id, location |
| Media Vault | ⚠️ Partial | Images only, no videos |
| Ownership Proof | ❌ Not Started | PropertyDocument needed |
| NFR1: Performance | ✅ Complete | Indexes in place |
| NFR4: Data Integrity | ✅ Complete | Foreign key constraints |

### Listing Management (Market Layer)

| PRD Requirement | Status | Implementation |
|-----------------|--------|----------------|
| FR2.1: CRUD APIs for Listing | ✅ Complete | `MySqrft.Listings` context |
| FR2.2: State Machine | ✅ Complete | State transitions implemented |
| FR2.3: Reposting/Cloning | ✅ Complete | `repost_listing/1` function |
| FR3.1: Search sync | ❌ Not Started | Future integration |
| FR3.2: Archive closed listings | ✅ Complete | Status-based archival |
| Transaction Modes (Rent/Sale/PG) | ✅ Complete | Listing schema supports all |
| One-Click Post | ✅ Complete | `create_listing/2` from property |
| Lifecycle Engine | ✅ Complete | State machine + transitions |
| Auto-expiry (60 days) | ⚠️ Partial | Function ready, Oban pending |
| Quality & Freshness | ⚠️ Partial | Scoring fields ready, algorithms pending |
| NFR1: Listing creation < 500ms | ⏸️ Pending | Will test after Oban integration |
| NFR1: Search sync < 2s | ⏸️ Pending | Future integration |
| **Price History (Dual-Level)** | **✅ Complete** | **Listing + Property tracking** |

### Quality & Freshness

| PRD Requirement | Status | Implementation |
|-----------------|--------|-------------------|
| Golden Record Scoring | ❌ Not Started | Quality score algorithm needed |
| Market Readiness Score | ⚠️ Partial | Fields ready, algorithm pending |
| Duplicate Detection (Asset) | ❌ Not Started | Fuzzy matching needed |
| Duplicate Detection (Listing) | ✅ Complete | Unique constraint + validation |

---

## 🎯 Acceptance Criteria Status

### AC 4.1: Property Creation
- ✅ Geography binding enforced (foreign keys)
- ⚠️ Asset specifics partially enforced (no type-specific validation)
- ✅ Media upload supported (up to 20 not enforced)

### AC 4.2: Posting a Listing
- ✅ Selection of PropertyID (listing entity complete)
- ✅ Duplicate active listing validation (unique index + validation)
- ✅ Auto-expiry after 60 days (function ready, Oban pending)
- ✅ Price validation (price > 0 enforced)

**Status**: 4/4 criteria met (Oban installation pending for full auto-expiry)

---

## 🚀 Recommended Implementation Roadmap

### Phase 1: Critical Path - Listing Management (Week 1)
**Goal**: Enable basic listing functionality

1. **Day 1-2**: Listing Schema & Migration
   - Create Listing schema
   - Create database migration
   - Add basic validations
   - Write schema tests

2. **Day 2-3**: Listings Context
   - Implement CRUD operations
   - Add state transition functions
   - Add duplicate validation
   - Write context tests

3. **Day 3**: Auto-Expiry
   - Install/configure Oban
   - Create expiry worker
   - Schedule cron job
   - Test expiry logic

4. **Day 4**: Integration
   - Update Property schema (has_many :listings)
   - Test property-listing relationship
   - Integration tests

**Deliverables**:
- ✅ Properties can have listings
- ✅ Listings follow state machine
- ✅ Auto-expiry works
- ✅ No duplicate active listings

### Phase 2: Property Enhancements (Week 2)
**Goal**: Add verification and quality features

1. **Day 5-6**: Property Verification
   - PropertyDocument schema
   - Document management functions
   - Verification workflow
   - Tests

2. **Day 7**: Quality Scoring
   - Add scoring fields
   - Implement algorithms
   - Update functions
   - Tests

3. **Day 8**: Type Validation
   - Type-specific validation logic
   - Validation helper module
   - Tests

4. **Day 9**: Media & Duplicates
   - Enhance media schema
   - Add upload limits
   - Duplicate detection
   - Tests

**Deliverables**:
- ✅ Property verification workflow
- ✅ Quality scoring
- ✅ Type-specific validation
- ✅ Duplicate detection

### Phase 3: Polish & Documentation (Week 2-3)
**Goal**: Production readiness

1. **Day 10**: Integration Testing
   - End-to-end tests
   - Performance testing
   - Bug fixes

2. **Day 11**: Documentation
   - Code documentation
   - API documentation
   - Update domain docs

**Deliverables**:
- ✅ All tests passing
- ✅ Documentation complete
- ✅ Production ready

---

## 📝 Open Questions & Decisions Needed

> [!IMPORTANT]
> **Decision 1: Property Type Validation Strategy**
> - **Option A**: JSONB map with runtime validation (current, flexible)
> - **Option B**: Separate tables per type (normalized, complex)
> - **Option C**: Single table with all fields (simple, sparse)
> 
> **Recommendation**: Continue with Option A, add validation layer

> [!IMPORTANT]
> **Decision 2: Auto-Expiry Implementation**
> - **Option A**: Oban background job (recommended)
> - **Option B**: Database trigger
> - **Option C**: Lazy expiry on read
> 
> **Recommendation**: Option A for reliability

> [!WARNING]
> **Decision 3: Listing Price History**
> Should we track price changes?
> - **Yes**: Need separate table
> - **No**: Only current price
> 
> **Recommendation**: Not in MVP, add later

---

## 🔗 Related Documents

- [Inventory Domain PRD](./005_inventory.md) - Full requirements
- [Geography Domain](./024_geography.md) - Integration point
- [User Management Domain](./003_user-management.md) - Owner relationship
- [Search Domain](./006_search.md) - Future integration
- [Leads Domain](./007_leads.md) - Future integration

---

## 📈 Success Metrics (Not Yet Tracked)

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| Inventory Utilization | >50% | N/A | ⏸️ Pending listings |
| Re-list Rate | >30% | N/A | ⏸️ Pending listings |
| Data Completeness | >80% | ~60% | ⚠️ No scoring yet |
| Listing Creation Latency | <500ms | N/A | ⏸️ Pending listings |
| Search Sync Latency | <2s | N/A | ⏸️ Future integration |

---

## 🐛 Known Issues & Technical Debt

1. **No Type-Specific Validation**
   - **Issue**: Configuration map accepts any data
   - **Impact**: Data quality issues, hard to query
   - **Priority**: High
   - **Fix**: Add validation layer in Phase 2

2. **No Upload Limits**
   - **Issue**: Can upload unlimited media
   - **Impact**: Storage costs, performance
   - **Priority**: Medium
   - **Fix**: Add validation in Phase 2

3. **No Duplicate Detection**
   - **Issue**: Same property can be created multiple times
   - **Impact**: Data quality, user confusion
   - **Priority**: Medium
   - **Fix**: Add fuzzy matching in Phase 2

4. **No Listing Entity**
   - **Issue**: Cannot post properties to marketplace
   - **Impact**: Core functionality missing
   - **Priority**: **Critical**
   - **Fix**: Implement in Phase 1

---

## 📅 Timeline

| Phase | Duration | Start Date | End Date | Status |
|-------|----------|------------|----------|--------|
| Phase 0: Analysis | 1 day | 2026-01-25 | 2026-01-26 | ✅ Complete |
| Phase 1: Listing Core | 1 day | 2026-01-26 | 2026-01-26 | ✅ Complete |
| Phase 1b: Oban Integration | 0.5 days | TBD | TBD | ⏸️ Pending |
| Phase 2: Property Enhancements | 5 days | TBD | TBD | ⏸️ Pending Phase 1b |
| Phase 3: Polish | 2 days | TBD | TBD | ⏸️ Pending Phase 2 |

**Total Estimated Time**: 9.5 days (2 weeks)

---

## 🔄 Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2026-01-26 | 1.0 | Initial implementation status document | Development Team |
| 2026-01-26 | 1.1 | **Listing Management Core Complete**: Implemented Listing schema, ListingPriceHistory, PropertyPriceHistory, Listings context with full CRUD, state machine, price history tracking (dual-level), and lifecycle management. Progress: 35% → 60% | Development Team |
| 2026-01-26 | 1.2 | **Oban Integration Complete**: Installed Oban, created migration, configured cron job for daily auto-expiry at midnight, and created ExpireStaleListingsWorker. Progress: 60% → 65% | Development Team |
