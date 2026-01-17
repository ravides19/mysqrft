# Search Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Search |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | 2026-01-17 |
| **Implementation Phase** | Phase 1: MVP Foundation |

---

## 1. Executive Summary

### 1.1 Purpose
The Search domain powers the discovery experience on MySqrft, enabling users to find rental and purchase properties efficiently through advanced search capabilities, intelligent filtering, personalized recommendations, and proactive alerts.

### 1.2 Primary Goal
**Discovery Experience** - Provide users with a fast, intuitive, and personalized property discovery journey that maximizes the likelihood of finding their ideal home.

### 1.3 Business Value
- **Conversion Driver**: Search quality directly impacts lead generation and platform monetization
- **User Retention**: Personalized search experiences increase user engagement and repeat visits
- **Competitive Advantage**: Superior search relevance differentiates MySqrft from competitors
- **Data Asset**: Search behavior data fuels platform-wide personalization and insights

---

## 2. Domain Overview

### 2.1 Scope

#### In Scope
- Property search with comprehensive filtering and sorting
- Map view integration for geographic discovery (optional)
- Commute and distance layer calculations (optional)
- Recommendation engine for personalized property suggestions
- Similar listings suggestions based on property attributes
- Saved searches with persistent filter configurations
- Search alerts for new matching properties
- Locality guides and pricing insights (optional)

#### Out of Scope
- Property listing creation and management (Inventory domain)
- Lead generation from search results (Leads domain)
- User profile and preferences storage (UserManagement domain)
- Payment for premium search features (Billing/Entitlements domains)

### 2.2 Key Entities

| Entity | Description |
|--------|-------------|
| **SearchQuery** | Represents a user's search request including keywords, filters, sorting, and pagination |
| **Filter** | Individual filter criteria (location, price, bedrooms, amenities, etc.) |
| **SavedSearch** | Persisted search configuration that users can revisit |
| **SearchAlert** | Notification subscription for new properties matching saved search criteria |
| **Recommendation** | AI-generated property suggestion based on user behavior and preferences |

---

## 3. User Stories & Requirements

### 3.1 Core Search Functionality

#### US-SEARCH-001: Basic Property Search
**As a** property seeker (tenant/buyer)
**I want to** search for properties using keywords and location
**So that** I can discover available properties in my desired area

**Acceptance Criteria:**
- Users can enter free-text search queries (locality, landmark, city)
- Search supports autocomplete with popular localities and landmarks
- Results display relevant properties sorted by default relevance score
- Search is performant (<500ms response time for 95th percentile)
- Zero-result pages show helpful suggestions and nearby alternatives

**Priority:** P0 (Must Have)

---

#### US-SEARCH-002: Advanced Filtering
**As a** property seeker
**I want to** filter search results by multiple criteria
**So that** I can narrow down properties matching my specific requirements

**Acceptance Criteria:**
- **Location Filters:**
  - City selection (mandatory)
  - Locality/neighborhood (multi-select)
  - Landmark proximity
  - Pin code

- **Property Type Filters:**
  - Transaction type: Rent / Buy
  - Property type: Apartment, Independent House, Villa, PG/Hostel, Plot
  - BHK configuration: 1, 2, 3, 4, 5+ BHK
  - Furnishing: Unfurnished, Semi-Furnished, Fully Furnished

- **Price Filters:**
  - Price range slider (min-max)
  - Predefined price buckets
  - Include/exclude maintenance charges

- **Property Details:**
  - Built-up area (sq ft range)
  - Floor preference (ground, low, mid, high, top)
  - Age of property
  - Facing direction
  - Parking availability (2-wheeler, 4-wheeler)

- **Amenities:**
  - Power backup, Lift, Security, Gym, Swimming Pool, Club House
  - Pet-friendly, Gated community

- **Availability:**
  - Available from date
  - Immediate availability toggle

- **Preferences:**
  - Preferred tenants (Family, Bachelor, Company)
  - Vegetarian/Non-vegetarian preference
  - Gender preference (for PG/shared)

- Filter combinations persist across sessions
- "Clear all filters" option available
- Filter count badge shows active filters

**Priority:** P0 (Must Have)

---

#### US-SEARCH-003: Search Results Sorting
**As a** property seeker
**I want to** sort search results by different criteria
**So that** I can prioritize properties based on what matters most to me

**Acceptance Criteria:**
- **Sort Options:**
  - Relevance (default)
  - Price: Low to High
  - Price: High to Low
  - Newest First (listing date)
  - Freshness (last updated)
  - Popularity (view count)
  - Distance (when location is provided)

- Sort preference persists within session
- Sort option clearly displayed in UI

**Priority:** P0 (Must Have)

---

#### US-SEARCH-004: Search Results Display
**As a** property seeker
**I want to** view search results in a clear, informative format
**So that** I can quickly evaluate properties

**Acceptance Criteria:**
- **List View (default):**
  - Property thumbnail images (carousel)
  - Title (BHK, property type, locality)
  - Price (rent/sale price, maintenance if applicable)
  - Key specs (area, floor, furnishing)
  - Owner/Agent badge
  - Verified badge (if applicable)
  - Posted date / Freshness indicator
  - Quick action buttons (Contact, Shortlist, Share)

- **Grid View (optional):**
  - Compact card layout
  - Primary image with image count
  - Essential details only

- Pagination with infinite scroll option
- Result count displayed
- "No results" state with suggestions

**Priority:** P0 (Must Have)

---

### 3.2 Map-Based Search (Optional)

#### US-SEARCH-005: Map View Integration
**As a** property seeker
**I want to** view properties on a map
**So that** I can understand geographic distribution and explore by location

**Acceptance Criteria:**
- Toggle between list view and map view
- Properties displayed as pins/clusters on map
- Pin click shows property preview card
- Map supports zoom, pan, and area selection
- "Search this area" functionality when map is moved
- Cluster breakout on zoom
- Current location detection with permission

**Priority:** P1 (Should Have)

---

#### US-SEARCH-006: Commute/Distance Layers
**As a** property seeker
**I want to** see commute times and distances to important locations
**So that** I can evaluate properties based on my daily travel needs

**Acceptance Criteria:**
- Add multiple commute destinations (office, school, etc.)
- Display commute time overlays on map
- Filter by maximum commute time
- Support for different transport modes (car, public transit, walk)
- Integrate with mapping service APIs (Google Maps/MapMyIndia)
- Show distance in property cards when commute point is set

**Priority:** P2 (Nice to Have)

---

### 3.3 Personalization & Recommendations

#### US-SEARCH-007: Recommendation Engine
**As a** property seeker
**I want to** receive personalized property recommendations
**So that** I can discover relevant properties I might have missed

**Acceptance Criteria:**
- **Recommendation Types:**
  - "Recommended for You" based on search history
  - "Based on Your Recent Searches"
  - "Popular in [Locality]"
  - "New Arrivals Matching Your Criteria"
  - "Price Drop Alerts" for viewed properties

- Recommendations displayed on:
  - Homepage
  - Search results page (between results)
  - Property detail page
  - Empty search states

- Recommendation algorithm considers:
  - Search history and filter patterns
  - Viewed properties
  - Shortlisted properties
  - User profile preferences (budget, BHK, locality)
  - Similar user behavior (collaborative filtering)

- Users can dismiss/hide recommendations
- Feedback mechanism ("Not interested" / "Show more like this")

**Priority:** P1 (Should Have)

---

#### US-SEARCH-008: Similar Listings Suggestions
**As a** property seeker viewing a property
**I want to** see similar available properties
**So that** I can explore alternatives and make informed decisions

**Acceptance Criteria:**
- Display "Similar Properties" section on property detail page
- Similarity based on:
  - Same locality or nearby localities
  - Same BHK configuration
  - Similar price range (+/- 20%)
  - Similar property type
  - Similar amenities

- Show 4-8 similar properties
- Exclude already viewed/shortlisted properties (optional)
- Handle edge cases (new listings with limited data)

**Priority:** P1 (Should Have)

---

### 3.4 Saved Searches & Alerts

#### US-SEARCH-009: Save Search
**As a** registered user
**I want to** save my search criteria
**So that** I can quickly access the same search later

**Acceptance Criteria:**
- Save current search with all active filters
- Custom naming for saved searches
- Maximum 20 saved searches per user
- Access saved searches from profile/search page
- Edit saved search name
- Delete saved searches
- Saved searches sync across devices
- Guest users prompted to register to save

**Priority:** P0 (Must Have)

---

#### US-SEARCH-010: Search Alerts
**As a** registered user
**I want to** receive notifications when new properties match my saved search
**So that** I can be among the first to contact for new listings

**Acceptance Criteria:**
- Enable/disable alerts per saved search
- **Alert Frequency Options:**
  - Instant (real-time)
  - Daily digest
  - Weekly digest

- **Alert Channels:**
  - Push notification
  - Email
  - SMS (premium users)
  - WhatsApp (premium users)

- Alert content includes:
  - Number of new matches
  - Top 3-5 property previews
  - Direct link to full results

- Manage alert preferences from settings
- Unsubscribe link in all alert communications
- Respect user's DND settings (Communications domain)
- Maximum alerts per day to prevent spam

**Priority:** P0 (Must Have)

---

### 3.5 Locality Intelligence (Optional)

#### US-SEARCH-011: Locality Guides
**As a** property seeker
**I want to** access detailed information about localities
**So that** I can make informed decisions about where to live

**Acceptance Criteria:**
- Locality overview pages with:
  - About the locality (description)
  - Average property prices (rent/buy)
  - Price trends (historical)
  - Nearby amenities (schools, hospitals, malls, transit)
  - Connectivity information
  - Safety score (if available)
  - Lifestyle indicators
  - Photo gallery

- Locality pages accessible from search and property details
- SEO-optimized URLs for organic traffic
- User reviews/ratings for localities (future)

**Priority:** P2 (Nice to Have)

---

#### US-SEARCH-012: Pricing Insights
**As a** property seeker
**I want to** understand market pricing for my search criteria
**So that** I can evaluate if a property is fairly priced

**Acceptance Criteria:**
- Price distribution chart for search results
- "Price Analysis" on property detail page:
  - Comparison to locality average
  - Price per sq ft analysis
  - "Good Deal" / "Above Average" indicators

- Historical pricing trends for localities
- Price alerts for saved searches when prices change

**Priority:** P2 (Nice to Have)

---

## 4. Technical Requirements

### 4.1 Search Infrastructure

#### 4.1.1 Search Engine
- Implement using Elasticsearch or similar full-text search engine
- Support for:
  - Full-text search with relevance scoring
  - Faceted search for filters
  - Geo-spatial queries for location-based search
  - Aggregations for filter counts and analytics

#### 4.1.2 Indexing
- Near real-time indexing of new/updated listings
- Index schema optimized for search performance
- Support for index aliases for zero-downtime reindexing
- Periodic full reindex capability

#### 4.1.3 Query Optimization
- Query caching for common searches
- Filter caching for faceted search
- Query result caching with TTL
- Search suggestion caching

### 4.2 Performance Requirements

| Metric | Target | Notes |
|--------|--------|-------|
| Search Response Time (P95) | < 500ms | End-to-end API response |
| Search Response Time (P99) | < 1000ms | Including edge cases |
| Autocomplete Response | < 100ms | Type-ahead suggestions |
| Map Tile Load | < 200ms | Map rendering |
| Indexing Latency | < 5 minutes | New listing searchable |
| System Availability | 99.9% | Search must be highly available |

### 4.3 Scalability Requirements
- Handle 10,000+ concurrent search requests
- Support 1M+ indexed properties
- Horizontal scaling for search nodes
- Geographic distribution for latency optimization

### 4.4 Data Requirements

#### 4.4.1 Search Index Schema
```
Property Document:
- id: string (unique identifier)
- title: string (searchable)
- description: text (searchable)
- property_type: keyword
- transaction_type: keyword (rent/buy)
- bhk: integer
- price: long
- maintenance_charge: long
- built_up_area: integer
- carpet_area: integer
- floor: integer
- total_floors: integer
- facing: keyword
- furnishing: keyword
- age_of_property: integer
- amenities: keyword[] (multi-value)
- location: geo_point
- city: keyword
- locality: keyword
- landmark: keyword
- pin_code: keyword
- owner_type: keyword (owner/agent/builder)
- is_verified: boolean
- posted_date: date
- updated_date: date
- availability_date: date
- images: nested[]
- quality_score: float
- freshness_score: float
- popularity_score: float
```

#### 4.4.2 Recommendation Data
- User search history (anonymized for non-logged users)
- Property view history
- Shortlist data
- Click-through rates
- Contact/lead conversion rates

---

## 5. Integration Requirements

### 5.1 Domain Dependencies

| Domain | Integration Type | Description |
|--------|-----------------|-------------|
| **Inventory** | Upstream | Receives listing data for indexing; listens to listing events (create, update, pause, expire) |
| **UserManagement** | Upstream | Retrieves user preferences for personalization |
| **Authorization** | Upstream | Validates user access for premium search features |
| **Entitlements** | Upstream | Checks user plan for feature access (alerts, premium filters) |
| **Communications** | Downstream | Sends search alerts via notification channels |
| **Analytics** | Downstream | Publishes search events for funnel analysis |
| **Leads** | Downstream | Search results link to lead creation |

### 5.2 Domain Events

#### Events Published
```
search.query.executed
  - user_id (optional)
  - session_id
  - query_params
  - result_count
  - response_time_ms
  - timestamp

search.filter.applied
  - user_id (optional)
  - session_id
  - filter_type
  - filter_value
  - timestamp

search.saved
  - user_id
  - saved_search_id
  - search_criteria
  - timestamp

search.alert.created
  - user_id
  - alert_id
  - saved_search_id
  - frequency
  - channels
  - timestamp

search.alert.triggered
  - user_id
  - alert_id
  - match_count
  - property_ids
  - timestamp

recommendation.generated
  - user_id
  - recommendation_type
  - property_ids
  - algorithm_version
  - timestamp

recommendation.clicked
  - user_id
  - recommendation_id
  - property_id
  - position
  - timestamp
```

#### Events Consumed
```
inventory.listing.created
inventory.listing.updated
inventory.listing.paused
inventory.listing.expired
inventory.listing.deleted
user.preferences.updated
```

### 5.3 External Integrations

| Service | Purpose | Priority |
|---------|---------|----------|
| Google Maps API / MapMyIndia | Map view, geocoding, commute calculation | P1 |
| Elasticsearch / OpenSearch | Search infrastructure | P0 |
| Redis | Caching layer | P0 |
| ML Platform | Recommendation model serving | P1 |

---

## 6. API Specifications

### 6.1 Core APIs

#### Search Properties
```
POST /api/v1/search/properties
Request:
{
  "query": "string",
  "filters": {
    "city": "string (required)",
    "localities": ["string"],
    "transaction_type": "rent|buy",
    "property_types": ["apartment", "house", "villa"],
    "bhk": [1, 2, 3],
    "price_min": number,
    "price_max": number,
    "area_min": number,
    "area_max": number,
    "furnishing": ["unfurnished", "semi", "fully"],
    "amenities": ["lift", "parking", "gym"],
    "available_from": "date",
    "posted_within": "24h|7d|30d",
    "verified_only": boolean,
    "owner_only": boolean
  },
  "location": {
    "lat": number,
    "lng": number,
    "radius_km": number
  },
  "sort": {
    "field": "relevance|price|date|distance",
    "order": "asc|desc"
  },
  "pagination": {
    "page": number,
    "size": number
  }
}

Response:
{
  "results": [PropertySummary],
  "total": number,
  "page": number,
  "size": number,
  "facets": {
    "property_types": [{"value": "string", "count": number}],
    "bhk": [{"value": number, "count": number}],
    "localities": [{"value": "string", "count": number}],
    "price_ranges": [{"min": number, "max": number, "count": number}]
  },
  "suggestions": ["string"] // when no results
}
```

#### Search Autocomplete
```
GET /api/v1/search/autocomplete?q={query}&city={city}
Response:
{
  "suggestions": [
    {
      "type": "locality|landmark|city",
      "text": "string",
      "highlight": "string",
      "metadata": {}
    }
  ]
}
```

#### Saved Searches
```
POST /api/v1/search/saved
GET /api/v1/search/saved
GET /api/v1/search/saved/{id}
PUT /api/v1/search/saved/{id}
DELETE /api/v1/search/saved/{id}
```

#### Search Alerts
```
POST /api/v1/search/saved/{id}/alert
PUT /api/v1/search/saved/{id}/alert
DELETE /api/v1/search/saved/{id}/alert
GET /api/v1/search/alerts
```

#### Recommendations
```
GET /api/v1/recommendations?type={type}&limit={limit}
GET /api/v1/properties/{id}/similar?limit={limit}
POST /api/v1/recommendations/{id}/feedback
  - action: "interested"|"not_interested"|"hide"
```

---

## 7. User Interface Requirements

### 7.1 Key Screens

1. **Search Results Page**
   - Search bar with autocomplete
   - Filter panel (collapsible on mobile)
   - Sort dropdown
   - View toggle (list/map)
   - Results grid/list
   - Pagination / infinite scroll
   - Saved search CTA

2. **Map View**
   - Full-screen map with property pins
   - Collapsible results sidebar
   - Cluster indicators
   - Property preview on pin click
   - "Search this area" button

3. **Saved Searches Page**
   - List of saved searches
   - Alert status indicators
   - Quick actions (run, edit, delete)
   - Last run / new results count

4. **Locality Guide Page**
   - Locality overview
   - Price charts
   - Amenity map
   - Available properties CTA

### 7.2 Mobile Considerations
- Bottom sheet for filters on mobile
- Swipeable property cards
- Map view optimized for touch
- Progressive loading for images
- Offline support for saved searches

---

## 8. Security & Privacy

### 8.1 Data Protection
- Search history encrypted at rest
- Personal search data not shared with third parties
- Option to delete search history
- Anonymous search for non-logged users

### 8.2 Rate Limiting
- API rate limits per user/IP
- Bot detection and blocking
- CAPTCHA for suspicious activity

### 8.3 Access Control
- Premium filters gated by entitlements
- Alert channels based on user plan
- Admin access for search analytics

---

## 9. Analytics & Metrics

### 9.1 Key Performance Indicators (KPIs)

| Metric | Description | Target |
|--------|-------------|--------|
| Search-to-Lead Conversion | % of searches resulting in contact | > 5% |
| Zero Result Rate | % of searches with no results | < 10% |
| Filter Usage Rate | Avg filters used per search | > 2.5 |
| Saved Search Rate | % users saving searches | > 15% |
| Alert Activation Rate | % saved searches with alerts | > 40% |
| Recommendation CTR | Click-through on recommendations | > 8% |
| Search Refinement Rate | % searches followed by filter change | Track |
| Time to First Contact | Avg time from search to lead | Track |

### 9.2 Tracking Events
- Search executed (with all parameters)
- Filter applied/removed
- Sort changed
- Result clicked
- Property viewed from search
- Contact initiated from search
- Search saved
- Alert created/modified
- Recommendation shown/clicked
- Map interaction events

---

## 10. Rollout Strategy

### 10.1 Phase 1: MVP (Weeks 1-4)
- Basic search with core filters
- Sorting functionality
- Search results display
- Saved searches (without alerts)

### 10.2 Phase 2: Alerts & Personalization (Weeks 5-8)
- Search alerts implementation
- Basic recommendation engine
- Similar listings suggestions
- Search history-based suggestions

### 10.3 Phase 3: Map & Location (Weeks 9-12)
- Map view integration
- Geo-based search
- Distance filters
- Commute layer (if prioritized)

### 10.4 Phase 4: Intelligence (Weeks 13-16)
- Locality guides
- Pricing insights
- Advanced recommendations (ML-powered)
- Search quality optimization

---

## 11. Success Criteria

### 11.1 Launch Criteria
- [ ] Core search functionality operational
- [ ] Response time SLAs met
- [ ] Filtering covers 90% of user needs
- [ ] Saved search functionality complete
- [ ] Search alerts delivering on schedule
- [ ] Integration with Inventory domain stable
- [ ] Mobile experience optimized
- [ ] Analytics instrumentation complete

### 11.2 Success Metrics (3 months post-launch)
- Search-to-lead conversion > 5%
- Zero result rate < 10%
- User satisfaction score > 4.0/5.0
- Recommendation engagement > 8% CTR
- Alert-driven lead rate > 15% of total leads

---

## 12. Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Search latency degradation | High | Medium | CDN caching, query optimization, horizontal scaling |
| Poor relevance quality | High | Medium | A/B testing, user feedback loops, ML ranking models |
| Recommendation cold start | Medium | High | Fallback to popularity-based; progressive personalization |
| Map API cost overruns | Medium | Medium | Caching, rate limiting, fallback to static maps |
| Alert spam complaints | Medium | Low | Frequency caps, easy unsubscribe, smart batching |
| Index sync delays | Medium | Medium | Event-driven architecture, monitoring, manual reindex capability |

---

## 13. Open Questions

1. Should we implement voice search for mobile users?
2. What is the acceptable delay for alert delivery (real-time vs. batched)?
3. Should locality guides be user-generated or editorial content?
4. How do we handle search for new cities with limited inventory?
5. What ML models will power recommendations (collaborative filtering, content-based, hybrid)?
6. Should we offer "search by photo" (image similarity search)?

---

## 14. Appendix

### 14.1 Glossary

| Term | Definition |
|------|------------|
| **BHK** | Bedroom, Hall, Kitchen - standard property configuration unit |
| **Freshness** | How recently a listing was updated/confirmed by owner |
| **Quality Score** | Internal metric for listing completeness and accuracy |
| **Faceted Search** | Search with dynamic filter counts based on results |
| **Geo-spatial Query** | Search based on geographic coordinates and distance |

### 14.2 Related Documents
- Platform Domain Definitions (`/docs/domains.md`)
- Inventory Domain PRD
- Leads Domain PRD
- Communications Domain PRD

### 14.3 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | Product Team | Initial draft |

---

*This document is maintained by the Product Team and should be reviewed quarterly or upon significant feature changes.*
