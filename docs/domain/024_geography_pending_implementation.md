# Geography Domain - Pending Implementation Analysis

## Overview

This document identifies pending implementations from:
1. **024_geography.md** - Product Requirements Document (PRD)
2. **024_geography_ola_maps_extraction.md** - OLA Maps API extraction opportunities

---

## ✅ IMPLEMENTED Features

### From PRD (024_geography.md)

1. ✅ **FR1: Geographic Hierarchy Management** - Complete
   - Country → State → City → Locality hierarchy
   - Parent-child relationships enforced
   - Hierarchical queries supported
   - Locality metadata and aliases

2. ✅ **FR2: Geospatial Data Storage** - Complete
   - PostGIS extension enabled
   - Coordinates (latitude/longitude) stored
   - PostGIS point geometry for locations
   - Spatial indexes (GIST) on location fields
   - WGS84/EPSG:4326 coordinate system

3. ✅ **FR3: Geocoding Services** - Complete
   - Geocoding API implemented
   - Internal DB lookup first, then external provider fallback
   - Caching implemented (90-day expiry)
   - Confidence scores included
   - Provider abstraction (Ola Maps, Google Maps, etc.)

4. ✅ **FR4: Reverse Geocoding Services** - Complete
   - Reverse geocoding API implemented
   - PostGIS-based nearest locality lookup
   - Formatted address returned
   - Nearest landmark identification
   - Caching implemented

5. ✅ **FR5: Location-Based Search and Filtering** - Complete
   - Radius search queries (PostGIS ST_Distance)
   - Distance calculations (Haversine via PostGIS)
   - Proximity search with distance-based sorting
   - Boundary containment checks (ST_Within)
   - Distance in kilometers

6. ✅ **FR6: Address Validation** - Complete
   - Address component validation
   - Pincode verification against locality
   - Locality-city relationship validation
   - Standardized address format

7. ✅ **FR7: Geographic Metadata Management** - Partially Complete
   - Pincode data with locality associations ✅
   - Landmark database with coordinates ✅
   - Neighborhood stored in metadata ✅
   - Administrative boundaries in metadata ✅
   - ⚠️ **PENDING**: Administrative boundaries table (currently in metadata only)
   - ⚠️ **PENDING**: Locality insights APIs (average property prices, demographics)

8. ✅ **FR8: Geographic Data Import and Synchronization** - Schema Ready
   - Database schema supports bulk import
   - ⚠️ **PENDING**: Actual import/sync functions not implemented
   - ⚠️ **PENDING**: CSV/JSON import handlers
   - ⚠️ **PENDING**: Scheduled synchronization

9. ⚠️ **FR9: Multi-City and Multi-Country Support** - Partially Complete
   - Multiple countries supported ✅
   - Country-specific hierarchies ✅
   - ⚠️ **PENDING**: Country-specific address format validation rules
   - ⚠️ **PENDING**: Timezone per city (field exists, extraction implemented)
   - ⚠️ **PENDING**: Currency/locale per country (fields exist, extraction implemented)
   - ⚠️ **PENDING**: Country-specific pincode format validation
   - ⚠️ **PENDING**: City-level feature flags

### From OLA Maps Extraction (024_geography_ola_maps_extraction.md)

#### Phase 1 (High Priority) - ✅ IMPLEMENTED
1. ✅ **Landmarks/POI Extraction** - Fully implemented
   - Extracts place name, category, coordinates
   - Creates landmark entries when geocoding returns POI
   - Stores place types in metadata

2. ✅ **Viewport/Bounding Box** - Fully implemented
   - ✅ Extracted from API response
   - ✅ Stored in metadata for localities
   - ✅ Converted to PostGIS polygon for cities (boundary field)
   - ✅ Converted to PostGIS polygon for localities (boundary field) via Ola Maps geocoding persistence

3. ✅ **Street Data in Metadata** - Fully implemented
   - Street name, street number, building name
   - Stored in locality.metadata

4. ✅ **Country/City Metadata Enrichment** - Fully implemented
   - Timezone extraction and storage
   - Currency code extraction and storage
   - Locale extraction and storage
   - Updates existing records with missing metadata

5. ✅ **Place Types** - Fully implemented
   - Extracts place_types array
   - Stores in locality.metadata

6. ✅ **Administrative Boundaries** - Partially implemented
   - Ward, zone, district extracted
   - Stored in locality.metadata
   - ⚠️ **PENDING**: Dedicated administrative_units table (as per PRD FR7)

---

## ⚠️ PENDING Implementation

### High Priority

#### 1. Locality Boundary from Viewport
**Status**: Completed – viewport is now converted to PostGIS polygon for localities and stored in `locality.boundary`

**Current State**:
- Viewport is extracted from OLA Maps API ✅
- Viewport stored in `locality.metadata["viewport"]` ✅
- Viewport converted to PostGIS polygon for cities (`city.boundary`) ✅
- Viewport converted to PostGIS polygon for localities (`locality.boundary`) ✅

**What's Needed**:
- No further work required; keeping this section for historical context

**Location**: `lib/my_sqrft/geography.ex` - `persist_ola_maps_geocoding/4` function

**Priority**: High (enhances map display and boundary validation)

---

#### 2. Geographic Data Import and Synchronization
**Status**: Schema ready, functions not implemented

**What's Needed**:
- CSV/JSON import functions for bulk geographic data
- Validation of hierarchy integrity during import
- Update handling for existing locations
- Scheduled synchronization with external data sources
- Import error logging and reporting
- Audit trail of data changes

**Priority**: High (required for initial data population and updates)

**Location**: New functions in `lib/my_sqrft/geography.ex` or separate module

---

### Medium Priority

#### 3. Administrative Units Table
**Status**: Data stored in metadata, dedicated table not created

**Current State**:
- Ward, zone, district extracted and stored in `locality.metadata` ✅
- No dedicated table for administrative units ❌

**What's Needed**:
- Create `administrative_units` table with polymorphic association
- Support ward, zone, district, tehsil/taluk
- Link to cities/localities
- Enable administrative reporting and filtering

**Priority**: Medium (can use metadata for now, table needed for reporting)

**Location**: New migration + schema + context functions

---

#### 4. Neighborhood/Sublocality Enhanced Handling
**Status**: Extracted and stored in metadata, but not as separate entity

**Current State**:
- Neighborhood extracted and stored in `locality.metadata["neighborhood"]` ✅
- Treated as part of locality, not separate entity ❌

**What's Needed**:
- Option A: Create `neighborhoods` table (between city and locality)
- Option B: Add `is_neighborhood: true` flag to locality metadata
- Enhanced locality search granularity

**Priority**: Medium (current metadata approach works, but separate entity would improve search)

---

#### 5. Locality Insights APIs
**Status**: Not implemented

**What's Needed**:
- APIs for locality insights (average property prices, demographics)
- Locality-specific attributes (popularity, growth trends, amenities)
- Metadata APIs for locality analytics

**Priority**: Medium (depends on other domains like Inventory, Analytics)

**Location**: New functions in `lib/my_sqrft/geography.ex`

---

### Low Priority

#### 6. Country-Specific Validation Rules
**Status**: Basic validation exists, country-specific rules not implemented

**What's Needed**:
- Country-specific address format validation
- Country-specific pincode format validation
- Configurable validation rules per country

**Priority**: Low (basic validation works, country-specific rules can be added when needed)

---

#### 7. City-Level Feature Flags
**Status**: Not implemented

**What's Needed**:
- Feature flag system per city
- City-level configuration management

**Priority**: Low (can be added when multi-city feature differentiation is needed)

---

#### 8. Multilingual Names Support
**Status**: `name_alt` field exists, but not extracting multiple languages

**What's Needed**:
- Extract names in local languages (Hindi, Kannada, Tamil, etc.)
- Store in enhanced `name_alt` (JSONB) or `localized_names` table
- Support for multilingual formatted addresses

**Priority**: Low (can be added when multilingual support is required)

---

#### 9. Advanced Geocoding Quality Metrics
**Status**: Confidence score extracted, but not all metrics

**What's Needed**:
- Accuracy level (rooftop, range_interpolated, geometric_center, approximate)
- Precision level
- Partial match indicators
- Enhanced quality tracking

**Priority**: Low (nice to have for quality monitoring)

---

## Implementation Recommendations

### Immediate (Next Sprint)
1. ~~**Locality Boundary from Viewport** - Convert viewport to PostGIS polygon for localities~~ **(COMPLETED)**
2. **Geographic Data Import** - Basic CSV/JSON import functions

### Short Term (Next 2-3 Sprints)
3. **Administrative Units Table** - For better reporting and filtering
4. **Neighborhood Enhanced Handling** - Improve search granularity
5. **Locality Insights APIs** - When Inventory/Analytics domains are ready

### Long Term (Future Enhancements)
6. **Country-Specific Validation Rules** - When expanding to multiple countries
7. **City-Level Feature Flags** - When multi-city feature differentiation needed
8. **Multilingual Names** - When multilingual support required
9. **Advanced Quality Metrics** - For data quality monitoring

---

## Notes

- All pending features should maintain **non-blocking** extraction (failures shouldn't break geocoding)
- Use **metadata JSONB fields** for flexibility before creating dedicated tables
- Maintain **audit trail** of data changes
- Use **spatial matching** to avoid duplicates
