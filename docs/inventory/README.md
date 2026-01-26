# Inventory Domain Documentation

Welcome to the MySqrft Inventory Domain documentation. This domain manages properties and listings in the real estate marketplace.

## Overview

The Inventory domain is the core of the MySqrft platform, handling:

- **Properties**: Physical real estate assets (apartments, villas, plots, commercial, etc.)
- **Listings**: Marketable offerings (rent/sale) of properties
- **Documents**: Ownership verification and compliance
- **Media**: Property images and floor plans
- **Pricing**: Historical price tracking and analytics
- **Scoring**: Quality and freshness metrics

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Inventory Domain                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐              ┌──────────────┐        │
│  │  Properties  │◄────────────►│   Listings   │        │
│  │   Context    │              │   Context    │        │
│  └──────┬───────┘              └──────┬───────┘        │
│         │                              │                 │
│         │                              │                 │
│  ┌──────▼───────┐              ┌──────▼───────┐        │
│  │  Documents   │              │Price History │        │
│  │    Images    │              │   Scoring    │        │
│  │  Validation  │              │Search Sync   │        │
│  └──────────────┘              └──────────────┘        │
│                                                          │
└─────────────────────────────────────────────────────────┘
         │                              │
         ▼                              ▼
┌─────────────────┐          ┌─────────────────┐
│   Geography     │          │  User Mgmt      │
│     Domain      │          │    Domain       │
└─────────────────┘          └─────────────────┘
```

---

## Documentation Index

### Getting Started

1. **[Property Types Guide](./property_types_guide.md)**
   - All 6 property types
   - Required and optional configurations
   - Validation rules
   - Examples

2. **[Listing Lifecycle Guide](./listing_lifecycle_guide.md)**
   - State machine diagram
   - All state transitions
   - Business rules
   - Common workflows
   - Best practices

3. **[API Documentation](./api_documentation.md)**
   - Complete function reference
   - Parameters and return values
   - Code examples
   - Error handling

---

## Quick Start

### Creating a Property

```elixir
# 1. Create property
{:ok, property} = MySqrft.Properties.create_property(owner, %{
  "type" => "apartment",
  "configuration" => %{
    "bhk" => 2,
    "bathrooms" => 2,
    "built_up_area" => 1200
  },
  "address_text" => "123 Main Street, Koramangala",
  "city_id" => city_id,
  "locality_id" => locality_id
})

# 2. Upload images
{:ok, _image} = MySqrft.Properties.create_property_image(property, %{
  "s3_key" => "images/property_123/exterior.jpg",
  "type" => "exterior",
  "is_primary" => true
})

# 3. Upload documents
{:ok, document} = MySqrft.Properties.create_property_document(property, %{
  "document_type" => "sale_deed",
  "s3_key" => "documents/property_123/sale_deed.pdf"
})

# 4. Update quality scores
{:ok, property} = MySqrft.Properties.update_quality_scores(property)
```

### Creating and Publishing a Listing

```elixir
# 1. Create listing (draft)
{:ok, listing} = MySqrft.Listings.create_listing(property, %{
  "transaction_type" => "rent",
  "ask_price" => "25000",
  "available_from" => ~D[2026-02-01],
  "tenant_preference" => "family",
  "diet_preference" => "vegetarian"
})

# 2. Update scores
{:ok, listing} = MySqrft.Listings.update_all_scores(listing)

# 3. Publish (draft → active)
{:ok, active_listing} = MySqrft.Listings.publish_listing(listing)
```

---

## Key Features

### 1. Type-Specific Validation

Each property type has specific required fields:

- **Apartment**: bhk, bathrooms, built_up_area
- **Villa**: plot_area, built_up_area, bathrooms
- **Plot**: plot_area
- **Commercial**: built_up_area, commercial_type
- **Managed (PG)**: total_beds, occupancy_type

See [Property Types Guide](./property_types_guide.md) for details.

### 2. State Machine

Listings follow a strict state machine:

```
draft → active → paused → active → closed
         ↓
      expired → active (via refresh)
```

See [Listing Lifecycle Guide](./listing_lifecycle_guide.md) for details.

### 3. Dual-Level Price History

- **Listing-level**: Tracks price changes within a single listing
- **Property-level**: Tracks historical prices across all listings

### 4. Quality Scoring

**Property Quality Score** (0-100):
- Field completeness: 30%
- Media count: 20%
- Location precision: 20%
- Document verification: 30%

**Listing Freshness Score** (0-100):
- Time since creation: 40%
- Time since refresh: 30%
- Time until expiry: 20%
- Recent activity: 10%

**Market Readiness Score** (0-100):
- Property quality: 30%
- Listing completeness: 25%
- Pricing: 25%
- Owner trust: 20%

### 5. Duplicate Detection

Fuzzy matching algorithm:
- Address similarity (Jaro distance): 60%
- GPS proximity (< 50m): 40%
- Threshold: > 50% similarity

### 6. Auto-Expiry

- Listings expire after 60 days
- Daily Oban job auto-expires stale listings
- Owners can refresh to extend by 60 days

### 7. Search Integration

- Real-time sync to search index
- 30+ indexed fields
- Boost scoring for ranking

---

## Database Schema

### Core Tables

- `properties` - Property assets
- `property_images` - Property media
- `property_documents` - Ownership documents
- `listings` - Rent/sale listings
- `listing_price_history` - Listing price changes
- `property_price_history` - Property-level analytics

### Key Indexes

- PostGIS GIST indexes on `location` fields
- Composite index: `(property_id, transaction_type)` WHERE `status = 'active'`
- Indexes on: `status`, `expires_at`, `verification_status`

---

## Background Jobs (Oban)

### Daily Jobs

- **ExpireStaleListingsWorker** (midnight)
  - Auto-expires listings past `expires_at`
  - Runs: `MySqrft.Listings.expire_stale_listings/0`

### Optional Jobs

- **UpdateScoresWorker** (weekly)
  - Bulk updates freshness and market readiness scores
  - Runs: `MySqrft.Listings.bulk_update_scores/0`

---

## Testing

### Test Suite

- **Properties Tests**: 9 tests (CRUD, validation, scoring, duplicates, documents, media)
- **Listings Tests**: 15+ tests (state machine, price history, scoring, lifecycle)
- **Integration Tests**: Full end-to-end workflows

### Running Tests

```bash
# All inventory tests
mix test test/my_sqrft/

# Specific test file
mix test test/my_sqrft/properties_test.exs
mix test test/my_sqrft/listings_test.exs
mix test test/my_sqrft/inventory_integration_test.exs

# With trace
mix test --trace
```

---

## Integration Points

### Geography Domain

- Validates city-locality relationships
- Uses PostGIS for location queries
- Syncs locality changes

### User Management Domain

- Links to owner profiles
- Calculates owner trust scores
- Tracks verification status

### Search Domain (Future)

- Real-time sync hooks
- 30+ indexed fields
- Boost scoring algorithm

### RERA/Market Data (Future)

- RERA verification API (Surepass)
- Market analytics (Propstack)
- Transaction prices (Zapkey)

---

## Performance Considerations

### Optimizations

1. **Indexes**: PostGIS GIST, composite, partial
2. **Preloading**: Avoid N+1 queries
3. **Caching**: Search document caching
4. **Batch Operations**: Bulk score updates

### Limits

- **20 images** per property (enforced)
- **1 active listing** per property-transaction type (enforced)
- **Refresh frequency**: Once per 7 days (recommended)

---

## Common Patterns

### Pattern 1: Property Creation Flow

```elixir
Repo.transaction(fn ->
  # Create property
  {:ok, property} = Properties.create_property(owner, attrs)
  
  # Upload media
  Enum.each(images, fn img ->
    Properties.create_property_image(property, img)
  end)
  
  # Upload documents
  Enum.each(documents, fn doc ->
    Properties.create_property_document(property, doc)
  end)
  
  # Calculate scores
  Properties.update_quality_scores(property)
end)
```

### Pattern 2: Listing Lifecycle

```elixir
# Create and publish
{:ok, listing} = Listings.create_listing(property, attrs)
{:ok, listing} = Listings.update_all_scores(listing)
{:ok, active} = Listings.publish_listing(listing)

# Manage
{:ok, refreshed} = Listings.refresh_listing(active)
{:ok, updated} = Listings.update_listing_price(refreshed, new_price)

# Close
{:ok, closed} = Listings.close_listing(updated, %{
  "closure_reason" => "rented",
  "final_price" => final_price
})
```

---

## Troubleshooting

### Common Issues

1. **Validation Error**: Check property type configuration requirements
2. **State Transition Error**: Verify current state before transition
3. **Duplicate Active Listing**: Close/pause existing listing first
4. **Image Upload Limit**: Maximum 20 images per property

### Debug Commands

```elixir
# Check property quality
property = Properties.get_property!(id) |> Repo.preload([:images, :documents])
Properties.update_quality_scores(property)

# Check listing scores
listing = Listings.get_listing!(id)
Listings.update_all_scores(listing)
suggestions = Listings.get_improvement_suggestions(listing)

# Check duplicates
duplicates = Properties.find_potential_duplicates(attrs)
```

---

## Future Enhancements

### Planned Features

1. **RERA Integration**
   - Verify RERA registration
   - Fetch project details
   - Builder reputation scoring

2. **Market Data Integration**
   - Real-time price comparisons
   - Market trend analysis
   - Demand indicators

3. **Advanced Search**
   - Elasticsearch/Typesense integration
   - Faceted search
   - Geo-radius queries

4. **AI Features**
   - Price recommendations
   - Image quality scoring
   - Automated descriptions

---

## Support

For questions or issues:

1. Check the [API Documentation](./api_documentation.md)
2. Review the [Listing Lifecycle Guide](./listing_lifecycle_guide.md)
3. See test files for usage examples
4. Contact the development team

---

## Version History

- **v1.0.0** (2026-01-26): Initial release
  - Complete CRUD for properties and listings
  - State machine implementation
  - Dual-level price history
  - Quality and freshness scoring
  - Duplicate detection
  - Auto-expiry functionality
  - Search integration hooks
  - Comprehensive test suite

---

## License

Copyright © 2026 MySqrft. All rights reserved.
