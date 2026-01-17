# Inventory Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | Inventory |
| Version | 1.0 |
| Status | Complete |
| Last Updated | 2026-01-17 |
| Owner | Product Team |

---

## 1. Overview

### 1.1 Purpose

The Inventory domain is the backbone of MySqrft's property supply management. It handles the complete lifecycle of property listings from creation through expiration, ensuring high-quality, verified, and fresh inventory for seekers. This domain directly impacts marketplace liquidity and user trust by maintaining accurate, up-to-date property information.

### 1.2 Scope

This PRD covers:
- Property listing lifecycle management (create, edit, pause, expire, relist)
- Media management (photos, videos, floor plans)
- Listing quality assessment and scoring
- Duplicate detection and merge workflows
- Freshness management and auto-expiration
- Property and owner verification workflows

### 1.3 Primary Goal

**Property Supply + Lifecycle** - Ensure MySqrft maintains a high-quality, verified, and fresh inventory of rental and sale properties that maximizes seeker engagement and owner satisfaction.

### 1.4 Target Users

| User Type | Description |
|-----------|-------------|
| Property Owners | Individuals listing their properties for rent or sale |
| Brokers/Agents | Licensed professionals managing multiple property listings |
| RM (Relationship Managers) | MySqrft staff assisting owners with listing creation |
| Admin/Ops | Internal teams managing inventory quality and moderation |
| Seekers | Tenants/buyers consuming the inventory (indirect users) |

---

## 2. Goals

### 2.1 Business Goals

| ID | Goal | Success Indicator |
|----|------|-------------------|
| BG-1 | Increase active listing volume | 20% QoQ growth in active listings |
| BG-2 | Improve listing quality | Average quality score > 75/100 |
| BG-3 | Reduce duplicate listings | < 2% duplicate rate across inventory |
| BG-4 | Maintain listing freshness | > 85% listings updated within 30 days |
| BG-5 | Increase verified listings | > 60% listings with owner verification |

### 2.2 User Goals

| ID | Goal | User Type |
|----|------|-----------|
| UG-1 | List property in under 5 minutes | Owner |
| UG-2 | Easily update listing status and details | Owner |
| UG-3 | Understand listing performance and quality | Owner |
| UG-4 | Find accurate, available properties | Seeker |
| UG-5 | Trust that listings are genuine | Seeker |

### 2.3 Technical Goals

| ID | Goal | Metric |
|----|------|--------|
| TG-1 | High availability for listing operations | 99.9% uptime |
| TG-2 | Fast media upload experience | < 3s per image upload |
| TG-3 | Real-time quality scoring | < 500ms score calculation |
| TG-4 | Efficient duplicate detection | < 2s detection time |

---

## 3. Key Features

### 3.1 Listing Lifecycle Management

#### 3.1.1 Listing Creation
- Multi-step guided listing flow optimized for mobile
- Property type selection (Apartment, Villa, Plot, Commercial, PG/Hostel)
- Transaction type (Rent, Sale, Lease)
- Basic details: bedrooms, bathrooms, area, floor, age
- Pricing: rent/sale price, maintenance, deposit, negotiability
- Location: address, locality, landmark, GPS coordinates
- Amenities and features selection
- Availability date and preferred tenant/buyer profile
- Draft saving and resume capability

#### 3.1.2 Listing Editing
- Full edit capability for active listings
- Edit history tracking for audit
- Bulk edit for owners with multiple properties
- Edit restrictions during verification or dispute

#### 3.1.3 Listing Status Management
- **Active**: Visible to seekers, accepting leads
- **Paused**: Temporarily hidden, owner-initiated
- **Expired**: Past validity period, requires refresh
- **Sold/Rented**: Closed successfully
- **Deleted**: Removed by owner or admin
- **Under Review**: Pending moderation
- **Rejected**: Failed moderation, requires correction

#### 3.1.4 Listing Expiration and Relisting
- Configurable expiration period (default: 60 days)
- Pre-expiry reminders (7 days, 3 days, 1 day before)
- One-click refresh to extend validity
- Relisting with updated details for expired listings

### 3.2 Media Management

#### 3.2.1 Photo Upload
- Support for JPEG, PNG, HEIC formats
- Minimum 3 photos required for listing activation
- Maximum 20 photos per listing
- Automatic image optimization and resizing
- Cover photo selection
- Room/area tagging for photos
- Photo ordering and arrangement

#### 3.2.2 Video Upload
- Support for MP4, MOV formats
- Maximum video length: 3 minutes
- Maximum file size: 100MB
- Video thumbnail extraction
- Optional: 360-degree virtual tour support

#### 3.2.3 Media Validation
- Image quality checks (blur, resolution, lighting)
- Inappropriate content detection (AI-based)
- Watermark and text overlay detection
- Contact information in images blocking
- Duplicate image detection across listings

#### 3.2.4 Media Moderation
- Automated moderation queue for flagged media
- Manual review workflow for edge cases
- Owner notification for rejected media
- Appeal process for media rejections

### 3.3 Duplicate Detection and Merge

#### 3.3.1 Detection Algorithms
- Address and location proximity matching
- Image similarity comparison (perceptual hashing)
- Property attribute matching (BHK, area, floor)
- Owner/contact information correlation
- Pricing pattern analysis

#### 3.3.2 Duplicate Handling
- Automated flagging of potential duplicates
- Admin review queue for confirmed duplicates
- Owner notification of duplicate detection
- Merge workflow preserving best data from each listing
- Source attribution after merge

### 3.4 Listing Quality Scoring

#### 3.4.1 Quality Score Components

| Component | Weight | Factors |
|-----------|--------|---------|
| Completeness | 25% | All fields filled, detailed description |
| Media Quality | 30% | Photo count, quality, variety of rooms |
| Verification | 20% | Owner verified, property verified |
| Freshness | 15% | Recent updates, owner responsiveness |
| Engagement | 10% | Response rate, lead conversion |

#### 3.4.2 Quality Score Actions
- Score displayed to owners in dashboard
- Improvement suggestions based on gaps
- Quality badges for high-scoring listings
- Search ranking boost for quality listings
- Minimum quality threshold for premium plans

### 3.5 Freshness Rules Enforcement

#### 3.5.1 Freshness Indicators
- Last update timestamp
- Owner last active date
- Lead response patterns
- Listing confirmation frequency

#### 3.5.2 Freshness Actions
- Automatic freshness prompts to owners
- Stale listing warnings in search results
- Auto-pause for unresponsive listings (45 days)
- Auto-expire for abandoned listings (90 days)
- Re-verification required after long inactivity

### 3.6 Verification Workflows

#### 3.6.1 Owner Verification
- Integration with KYC domain for identity verification
- Property ownership document upload (optional)
- Phone number verification
- Email verification
- Verified owner badge

#### 3.6.2 Property Verification
- Field verification by MySqrft agents (premium)
- Photo authenticity verification
- Location accuracy verification
- Ownership document verification
- Verified property badge

---

## 4. User Stories

### 4.1 Property Owner Stories

| ID | Story | Priority |
|----|-------|----------|
| US-001 | As a property owner, I want to list my property quickly so that I can start receiving leads | P0 |
| US-002 | As a property owner, I want to upload photos of my property so that seekers can see what it looks like | P0 |
| US-003 | As a property owner, I want to pause my listing temporarily so that I don't receive leads while unavailable | P0 |
| US-004 | As a property owner, I want to edit my listing details so that I can update pricing or availability | P0 |
| US-005 | As a property owner, I want to see my listing quality score so that I can improve it | P1 |
| US-006 | As a property owner, I want to receive expiry reminders so that my listing stays active | P1 |
| US-007 | As a property owner, I want to verify my identity so that seekers trust my listing | P1 |
| US-008 | As a property owner, I want to relist my expired property so that I can receive leads again | P1 |
| US-009 | As a property owner, I want to mark my property as rented/sold so that I stop receiving leads | P0 |
| US-010 | As a property owner, I want to save my listing as draft so that I can complete it later | P2 |

### 4.2 Seeker Stories

| ID | Story | Priority |
|----|-------|----------|
| US-011 | As a seeker, I want to see verified listings so that I can trust the property is genuine | P0 |
| US-012 | As a seeker, I want to see fresh listings so that I know the property is still available | P0 |
| US-013 | As a seeker, I want to see high-quality photos so that I can evaluate the property | P0 |
| US-014 | As a seeker, I want to see listing freshness indicators so that I prioritize recent listings | P1 |
| US-015 | As a seeker, I want to report fake listings so that the platform stays trustworthy | P1 |

### 4.3 Admin/Ops Stories

| ID | Story | Priority |
|----|-------|----------|
| US-016 | As an admin, I want to moderate flagged listings so that quality is maintained | P0 |
| US-017 | As an admin, I want to review duplicate listings so that I can merge or remove them | P1 |
| US-018 | As an admin, I want to bulk update listing status so that I can manage inventory efficiently | P1 |
| US-019 | As an admin, I want to view listing quality metrics so that I can identify areas for improvement | P1 |
| US-020 | As an admin, I want to configure freshness rules so that stale listings are handled appropriately | P2 |

---

## 5. Acceptance Criteria

### 5.1 Listing Creation (US-001)

```gherkin
Feature: Listing Creation

Scenario: Owner creates a new rental listing
  Given I am a logged-in property owner
  When I navigate to "Post Property"
  And I select "Rent" as transaction type
  And I fill in all required fields:
    | Field | Value |
    | Property Type | Apartment |
    | BHK | 2 |
    | Area | 1000 sqft |
    | Rent | 25000 |
    | Deposit | 100000 |
    | Address | 123 Main Street |
    | Locality | Koramangala |
    | City | Bangalore |
  And I upload at least 3 photos
  And I click "Submit Listing"
  Then my listing should be created with status "Under Review"
  And I should see a confirmation message
  And I should receive a notification when listing goes active

Scenario: Owner saves listing as draft
  Given I am creating a new listing
  When I fill in partial details
  And I click "Save Draft"
  Then the listing should be saved with status "Draft"
  And I should be able to resume from where I left
```

### 5.2 Media Upload (US-002)

```gherkin
Feature: Media Upload

Scenario: Owner uploads property photos
  Given I am creating or editing a listing
  When I upload 5 JPEG images
  Then all images should be uploaded successfully
  And images should be optimized for web display
  And I should be able to reorder images
  And I should be able to set a cover image

Scenario: System rejects inappropriate image
  Given I am uploading listing photos
  When I upload an image containing contact information
  Then the image should be rejected
  And I should see a message explaining why
  And I should be able to upload a different image
```

### 5.3 Listing Quality Score (US-005)

```gherkin
Feature: Quality Score

Scenario: Owner views listing quality score
  Given I have an active listing
  When I view my listing dashboard
  Then I should see my quality score (0-100)
  And I should see a breakdown by category
  And I should see suggestions to improve my score

Scenario: Quality score updates on listing improvement
  Given I have a listing with score 60
  When I add 5 more photos
  And the photos pass quality checks
  Then my quality score should increase
  And I should see updated suggestions
```

### 5.4 Duplicate Detection (US-017)

```gherkin
Feature: Duplicate Detection

Scenario: System detects potential duplicate listing
  Given a listing exists at "123 Main Street, Koramangala"
  When a new listing is submitted with the same address
  And similar property details (2BHK, 1000 sqft)
  Then the system should flag it as potential duplicate
  And it should enter moderation queue
  And admin should be notified

Scenario: Admin merges duplicate listings
  Given two listings are flagged as duplicates
  When admin reviews and confirms they are duplicates
  And selects the primary listing
  Then the listings should be merged
  And the duplicate should be archived
  And both owners should be notified
```

---

## 6. Functional Requirements

### 6.1 Listing Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-001 | System shall support listing creation for Rent, Sale, and Lease transactions | P0 |
| FR-002 | System shall support property types: Apartment, Villa, Independent House, Plot, Commercial, PG/Hostel | P0 |
| FR-003 | System shall require minimum mandatory fields: property type, BHK/size, area, price, location | P0 |
| FR-004 | System shall allow owners to save listings as drafts | P1 |
| FR-005 | System shall support listing status transitions: Draft -> Under Review -> Active -> Paused/Expired/Closed | P0 |
| FR-006 | System shall maintain complete edit history for each listing | P1 |
| FR-007 | System shall support bulk operations for users with multiple listings | P2 |
| FR-008 | System shall enforce listing limits based on user entitlements | P0 |

### 6.2 Media Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-009 | System shall support image formats: JPEG, PNG, HEIC | P0 |
| FR-010 | System shall require minimum 3 photos for listing activation | P0 |
| FR-011 | System shall limit maximum 20 photos per listing | P0 |
| FR-012 | System shall automatically optimize and resize uploaded images | P0 |
| FR-013 | System shall support video upload (MP4, MOV) up to 100MB | P1 |
| FR-014 | System shall detect and block images with contact information | P0 |
| FR-015 | System shall detect and flag inappropriate content | P0 |
| FR-016 | System shall support image tagging by room/area | P2 |

### 6.3 Quality Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-017 | System shall calculate quality score (0-100) for each listing | P1 |
| FR-018 | System shall update quality score in real-time on listing changes | P1 |
| FR-019 | System shall provide quality improvement recommendations | P1 |
| FR-020 | System shall apply search ranking boost based on quality score | P1 |
| FR-021 | System shall enforce minimum quality threshold for premium features | P2 |

### 6.4 Freshness Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-022 | System shall track last update timestamp for each listing | P0 |
| FR-023 | System shall send expiry reminders at 7, 3, and 1 days before expiration | P1 |
| FR-024 | System shall auto-pause listings after 45 days of owner inactivity | P1 |
| FR-025 | System shall auto-expire listings after 90 days without refresh | P1 |
| FR-026 | System shall allow one-click listing refresh | P0 |
| FR-027 | System shall display freshness indicators on listings | P1 |

### 6.5 Duplicate Detection

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-028 | System shall detect potential duplicates on listing submission | P1 |
| FR-029 | System shall use location, images, and attributes for duplicate matching | P1 |
| FR-030 | System shall queue potential duplicates for admin review | P1 |
| FR-031 | System shall support listing merge with data preservation | P2 |
| FR-032 | System shall notify owners when duplicates are detected/merged | P1 |

### 6.6 Verification

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-033 | System shall integrate with KYC domain for owner verification | P1 |
| FR-034 | System shall support property document upload for verification | P2 |
| FR-035 | System shall display verification badges on listings | P1 |
| FR-036 | System shall track verification status history | P1 |
| FR-037 | System shall support field verification workflow for premium listings | P2 |

---

## 7. Non-Functional Requirements

### 7.1 Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-001 | Listing creation API response time | < 500ms |
| NFR-002 | Image upload time (per image, 5MB) | < 3 seconds |
| NFR-003 | Quality score calculation time | < 500ms |
| NFR-004 | Duplicate detection time | < 2 seconds |
| NFR-005 | Listing search response time | < 200ms |
| NFR-006 | Concurrent listing creation support | 1000 TPS |

### 7.2 Availability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-007 | System availability | 99.9% uptime |
| NFR-008 | Planned maintenance window | < 4 hours/month |
| NFR-009 | Recovery Time Objective (RTO) | < 15 minutes |
| NFR-010 | Recovery Point Objective (RPO) | < 5 minutes |

### 7.3 Scalability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-011 | Active listings capacity | 10 million listings |
| NFR-012 | Media storage capacity | 100TB |
| NFR-013 | Daily listing creation capacity | 50,000 listings |
| NFR-014 | Horizontal scaling support | Auto-scale based on load |

### 7.4 Security

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-015 | Owner authentication required for all listing operations | Mandatory |
| NFR-016 | Media access via signed URLs | 24-hour expiry |
| NFR-017 | PII masking in logs | All contact information |
| NFR-018 | Audit trail for all listing modifications | 2-year retention |
| NFR-019 | Rate limiting for listing creation | 10 listings/hour/user |

### 7.5 Data Integrity

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-020 | Listing data backup frequency | Every 6 hours |
| NFR-021 | Media backup redundancy | 3 geographic regions |
| NFR-022 | Data consistency model | Strong consistency for writes |
| NFR-023 | Soft delete retention period | 90 days |

---

## 8. Integration Points

### 8.1 Upstream Dependencies (Consumes From)

| Domain | Integration | Data Flow |
|--------|-------------|-----------|
| **Auth** | User authentication and session validation | User identity for listing operations |
| **UserManagement** | Owner profile and role information | Profile data, verification status |
| **KYC** | Identity verification status | Verification level for owner badges |
| **Authorization** | Permission checks for listing operations | Access control decisions |
| **Entitlements** | Plan-based feature access and limits | Listing quota, premium features |

### 8.2 Downstream Consumers (Provides To)

| Domain | Integration | Data Flow |
|--------|-------------|-----------|
| **Search** | Listing data for search indexing | Active listings, attributes, location |
| **Leads** | Listing details for lead generation | Property info, owner contact |
| **Communications** | Listing context for notifications | Expiry alerts, quality updates |
| **Analytics** | Listing events for metrics | Creation, updates, conversions |
| **TrustSafety** | Listings for fraud detection | Flagged content, patterns |

### 8.3 Cross-Domain Events

#### Events Published

| Event | Trigger | Consumers |
|-------|---------|-----------|
| `listing.created` | New listing submitted | Search, Analytics, TrustSafety |
| `listing.activated` | Listing goes active | Search, Communications |
| `listing.updated` | Listing details changed | Search, Analytics |
| `listing.paused` | Owner pauses listing | Search, Leads |
| `listing.expired` | Listing expires | Search, Communications |
| `listing.closed` | Property rented/sold | Search, Analytics, CRM |
| `listing.quality.changed` | Quality score updated | Search, Analytics |
| `listing.verified` | Verification completed | Search, Analytics |
| `media.uploaded` | New media added | TrustSafety |
| `media.rejected` | Media fails moderation | Communications |

#### Events Consumed

| Event | Source | Action |
|-------|--------|--------|
| `user.verified` | KYC | Update owner verification badge |
| `entitlement.changed` | Entitlements | Update listing limits |
| `lead.created` | Leads | Update listing engagement metrics |
| `visit.completed` | Scheduling | Update listing activity |

### 8.4 API Contracts

#### External APIs Provided

```
POST   /api/v1/listings                    # Create listing
GET    /api/v1/listings/{id}               # Get listing details
PUT    /api/v1/listings/{id}               # Update listing
DELETE /api/v1/listings/{id}               # Delete listing
PATCH  /api/v1/listings/{id}/status        # Update listing status
POST   /api/v1/listings/{id}/media         # Upload media
DELETE /api/v1/listings/{id}/media/{mediaId}  # Delete media
GET    /api/v1/listings/{id}/quality       # Get quality score
POST   /api/v1/listings/{id}/refresh       # Refresh listing
GET    /api/v1/owners/{id}/listings        # Get owner's listings
```

#### Internal APIs Consumed

```
GET    /internal/users/{id}/profile        # UserManagement
GET    /internal/users/{id}/verification   # KYC
GET    /internal/entitlements/{userId}     # Entitlements
POST   /internal/moderation/queue          # TrustSafety
```

---

## 9. Dependencies

### 9.1 Technical Dependencies

| Dependency | Purpose | Criticality |
|------------|---------|-------------|
| PostgreSQL | Primary data store for listings | Critical |
| Redis | Caching, rate limiting | High |
| S3/Cloud Storage | Media storage | Critical |
| Elasticsearch | Search indexing (via Search domain) | High |
| CDN (CloudFront) | Media delivery | High |
| Image Processing Service | Optimization, moderation | High |
| ML Service | Duplicate detection, quality scoring | Medium |

### 9.2 Service Dependencies

| Service | Dependency Type | Fallback Strategy |
|---------|-----------------|-------------------|
| Auth Service | Synchronous | Reject requests |
| KYC Service | Asynchronous | Proceed without badge |
| Entitlements Service | Synchronous | Use cached limits |
| Media Processing | Asynchronous | Queue for retry |
| Search Indexer | Asynchronous | Queue for retry |

### 9.3 External Dependencies

| Provider | Service | Purpose |
|----------|---------|---------|
| AWS/GCP | Cloud Storage | Media storage |
| CDN Provider | Content Delivery | Media serving |
| AI/ML Provider | Vision API | Content moderation |
| Maps API | Geocoding | Location validation |

---

## 10. Success Metrics

### 10.1 Key Performance Indicators (KPIs)

| Metric | Description | Target | Measurement |
|--------|-------------|--------|-------------|
| Active Listing Count | Total active listings on platform | 500K+ | Daily snapshot |
| Listing Creation Rate | New listings per day | 2,000+ | Daily count |
| Listing Activation Rate | % of submitted listings that go active | > 90% | Weekly average |
| Average Quality Score | Mean quality score across listings | > 75 | Weekly average |
| Verified Listing Ratio | % of listings with verified owner | > 60% | Weekly snapshot |
| Duplicate Rate | % of listings detected as duplicates | < 2% | Weekly average |
| Freshness Score | % of listings updated in last 30 days | > 85% | Weekly snapshot |
| Media Upload Success Rate | % of successful media uploads | > 99% | Daily average |

### 10.2 Operational Metrics

| Metric | Description | Target | Alert Threshold |
|--------|-------------|--------|-----------------|
| API Latency (P95) | 95th percentile response time | < 500ms | > 1s |
| API Error Rate | % of failed API requests | < 0.1% | > 1% |
| Media Processing Time | Average time to process upload | < 5s | > 30s |
| Moderation Queue Depth | Pending moderation items | < 100 | > 500 |
| Duplicate Detection Accuracy | True positive rate | > 90% | < 80% |

### 10.3 Business Impact Metrics

| Metric | Description | Target | Timeframe |
|--------|-------------|--------|-----------|
| Listing-to-Lead Conversion | Leads generated per listing | > 5 | Monthly |
| Owner NPS | Net Promoter Score for listing experience | > 50 | Quarterly |
| Time to First Lead | Hours from activation to first lead | < 24h | Weekly average |
| Listing Renewal Rate | % of expired listings that relist | > 40% | Monthly |
| Churn Rate | % of owners who don't relist | < 30% | Monthly |

---

## 11. Appendix

### 11.1 Glossary

| Term | Definition |
|------|------------|
| Listing | A property advertisement on MySqrft platform |
| Seeker | A user looking to rent or buy a property |
| Owner | A user who owns property and lists it on the platform |
| Quality Score | A 0-100 rating of listing completeness and attractiveness |
| Freshness | Measure of how recently a listing was updated/confirmed |
| Verification | Process of confirming owner identity or property authenticity |
| Duplicate | Two or more listings representing the same property |

### 11.2 Listing Status Flow

```
[Draft] -> [Under Review] -> [Active] -> [Paused] -> [Active]
                |                |            |
                v                v            v
           [Rejected]       [Expired]    [Closed]
                |                |
                v                v
           [Draft]         [Relisted]
```

### 11.3 Quality Score Calculation

```
Quality Score = (Completeness * 0.25) + (Media * 0.30) +
                (Verification * 0.20) + (Freshness * 0.15) +
                (Engagement * 0.10)

Where:
- Completeness: % of optional fields filled (0-100)
- Media: Photo count (3-20 mapped to 0-100) + quality factors
- Verification: Owner verified (50) + Property verified (50)
- Freshness: Days since update (0-30 days = 100, linear decay)
- Engagement: Response rate to leads + conversion rate
```

### 11.4 Related Documents

- [MySqrft Domain Definitions](/docs/domains.md)
- Auth Domain PRD (to be created)
- Search Domain PRD (to be created)
- Leads Domain PRD (to be created)

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | Product Team | Initial draft |
