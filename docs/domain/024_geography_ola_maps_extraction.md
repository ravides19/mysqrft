# Ola Maps API - Additional Data Extraction Opportunities

## Overview

This document identifies additional models and fields that can be extracted from Ola Maps Geocoding API responses to enrich our internal Geography database.

## Currently Extracted & Persisted

✅ **Country** - name, code, currency_code, locale, timezone  
✅ **State** - name, code  
✅ **City** - name, coordinates, timezone, boundary (viewport)  
✅ **Locality** - name, coordinates, metadata (street, administrative boundaries, place types, viewport)  
✅ **Pincode** - code, coordinates  
✅ **Landmark** - name, category, coordinates (when geocoding result is a POI)  

## Additional Models & Fields to Extract

### 1. Landmarks / Points of Interest (POI)

**Current Status**: We have a `landmarks` table but not extracting from Ola Maps

**What to Extract**:
- Place name (if geocoding result is for a specific place)
- Place type/category (restaurant, hospital, school, shopping_mall, etc.)
- Coordinates
- Locality association

**When to Extract**:
- If API response includes `place_id`, `place_type`, or `types` array indicating it's a POI
- If `formatted_address` contains a specific place name (not just street address)

**Implementation Priority**: High - Useful for location-based search and recommendations

---

### 2. Street-Level Data

**Current Status**: We extract `street` and `street_number` but don't persist them

**What to Extract**:
- Street name / route
- Street number / premise number
- Building name (if available)

**Storage Options**:
- Option A: Store in `locality.metadata` JSONB field
- Option B: Create separate `streets` table (if needed for detailed address management)

**When to Extract**:
- Always when present in API response
- Useful for precise address matching and delivery services

**Implementation Priority**: Medium - Store in metadata for now, can create table later if needed

---

### 3. Neighborhood / Sublocality

**Current Status**: We extract but treat as locality. Could be a separate entity.

**What to Extract**:
- Neighborhood name
- Sublocality level (sublocality_level_1, sublocality_level_2)
- Coordinates

**Storage Options**:
- Option A: Create `neighborhoods` table (between city and locality)
- Option B: Store in `locality.metadata` with `is_neighborhood: true` flag

**When to Extract**:
- When `neighborhood` or `sublocality` fields are present
- When different from main locality name

**Implementation Priority**: Medium - Can enhance locality search granularity

---

### 4. Administrative Boundaries

**Current Status**: Mentioned in PRD (FR7) but not in schema

**What to Extract**:
- Ward (administrative_area_level_3)
- Zone
- District
- Tehsil/Taluk (in India)

**Storage Options**:
- Create `administrative_units` table with polymorphic association
- Or store in `locality.metadata` or `city.metadata`

**When to Extract**:
- When present in API response
- Useful for administrative reporting and filtering

**Implementation Priority**: Low - Can be added when needed for specific use cases

---

### 5. Viewport / Bounding Box

**Current Status**: Not extracted

**What to Extract**:
- Northeast coordinates (viewport_ne_lat, viewport_ne_lng)
- Southwest coordinates (viewport_sw_lat, viewport_sw_lng)
- Or as PostGIS polygon

**Storage Options**:
- Store in `city.boundary` or `locality.boundary` (PostGIS polygon)
- Or store as separate viewport fields in metadata

**When to Extract**:
- Always when available
- Useful for map view extents and boundary visualization

**Implementation Priority**: High - Enhances map display capabilities

---

### 6. Country Metadata Enrichment

**Current Status**: We have fields but not extracting from API

**What to Extract**:
- Currency code (if not already set)
- Locale (if not already set)
- Timezone (if not already set)
- Country calling code

**Storage**: Already in `countries` table fields

**When to Extract**:
- When country is created/updated from Ola Maps
- Fill missing metadata fields

**Implementation Priority**: Medium - Enriches country data

---

### 7. City Metadata Enrichment

**Current Status**: We have timezone field but not extracting

**What to Extract**:
- Timezone (city-specific)
- Population (if available)
- Area (if available)
- Elevation (if available)

**Storage**: Store in `city.metadata` JSONB or dedicated fields

**When to Extract**:
- When city is created/updated from Ola Maps
- Fill missing metadata

**Implementation Priority**: Medium - Enhances city data

---

### 8. Place Types / Categories

**Current Status**: Not extracted

**What to Extract**:
- Array of place types (e.g., ["locality", "political"], ["establishment", "restaurant"])
- Primary place type
- Category classification

**Storage Options**:
- Store in `landmark.category` (if it's a POI)
- Store in `locality.metadata.place_types` (if it's a locality)

**When to Extract**:
- Always when `types` array is present in API response
- Useful for filtering and categorization

**Implementation Priority**: Medium - Enhances search and filtering

---

### 9. Multilingual Names

**Current Status**: We have `name_alt` but not extracting multiple languages

**What to Extract**:
- Names in local languages (Hindi, Kannada, Tamil, etc.)
- Formatted address in local language

**Storage Options**:
- Enhance `name_alt` to support multiple languages (JSONB)
- Or create `localized_names` table

**When to Extract**:
- When API provides multilingual responses
- Based on user locale preferences

**Implementation Priority**: Low - Can be added when multilingual support is needed

---

### 10. Geocoding Quality Metrics

**Current Status**: We extract confidence_score but could extract more

**What to Extract**:
- Accuracy level (rooftop, range_interpolated, geometric_center, approximate)
- Precision level
- Partial match indicators
- Geocoding service used

**Storage**: Store in geocoding cache and metadata

**When to Extract**:
- Always when available
- Useful for data quality assessment

**Implementation Priority**: Low - Nice to have for quality tracking

---

## Recommended Implementation Order

### Phase 1 (High Priority - ✅ IMPLEMENTED)
1. ✅ **Landmarks/POI Extraction** - Extract and create landmark entries when geocoding returns a place
2. ✅ **Viewport/Bounding Box** - Extract and store in boundary fields for map display
3. ✅ **Street Data in Metadata** - Store street name/number in locality metadata
4. ✅ **Country/City Metadata Enrichment** - Extract timezone, currency, locale from API
5. ✅ **Place Types** - Extract and store for better categorization
6. ✅ **Administrative Boundaries** - Store ward, zone, district in metadata

### Phase 2 (Medium Priority - Enhanced Features)
4. **Country/City Metadata Enrichment** - Fill timezone, currency, locale from API
5. **Place Types** - Extract and store for better categorization
6. **Neighborhood Support** - Enhanced locality handling

### Phase 3 (Low Priority - Future Enhancement)
7. **Administrative Boundaries** - When needed for reporting
8. **Multilingual Names** - When multilingual support is required
9. **Advanced Quality Metrics** - For data quality monitoring

---

## Implementation Notes

- All extractions should be **non-blocking** - failures shouldn't break geocoding
- Store extracted data in **metadata JSONB fields** initially for flexibility
- Create dedicated tables only when query performance requires it
- Maintain **audit trail** of what was extracted from which API response
- Use **spatial matching** to avoid duplicates when creating new entities
