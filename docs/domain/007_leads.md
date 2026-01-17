# Leads Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | Leads |
| Version | 1.0 |
| Status | Complete |
| Last Updated | 2026-01-17 |
| Owner | Product Team |
| Implementation Phase | Phase 1 (MVP Foundation) |

---

## 1. Executive Summary

### 1.1 Purpose

The Leads domain is the **Core Marketplace Engine** of MySqrft, responsible for connecting property seekers (tenants/buyers) with property owners. It manages the complete lifecycle of a lead from initial contact request through to successful connection or closure, while implementing robust anti-abuse controls to maintain platform integrity.

### 1.2 Business Value

- **Primary Revenue Driver**: Leads are the core value proposition that drives subscription monetization
- **Marketplace Liquidity**: Enables efficient matching between supply (listings) and demand (seekers)
- **Trust Building**: Controlled contact reveals protect both owners and seekers from spam
- **Conversion Optimization**: Lead qualification and matching rules improve conversion rates

### 1.3 Success Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| Lead Conversion Rate | Leads that progress to scheduled visits | > 25% |
| Contact Response Rate | Owner responses within 24 hours | > 60% |
| Lead Quality Score | Average qualification score of leads | > 70/100 |
| Spam Detection Rate | Percentage of spam leads blocked | > 95% |
| Time to First Contact | Average time from lead creation to owner response | < 4 hours |

---

## 2. Domain Overview

### 2.1 Primary Goal

**Direct Connect + Lead Lifecycle Management** - Enable property seekers to connect with property owners through controlled contact mechanisms while managing the complete lead lifecycle with qualification, throttling, and anti-abuse controls.

### 2.2 Scope

#### In Scope

- Lead creation via "Contact Owner" and "Request Callback" actions
- Lead qualification based on seeker profile and match rules
- Lead state machine management (new -> contacted -> scheduled -> closed/lost)
- Contact reveal management with quota enforcement
- Owner response handling and tracking
- Lead throttling to prevent abuse
- Anti-abuse controls (spam detection, cooldown periods, rate limiting)
- Lead prioritization based on entitlements
- Lead expiration and cleanup

#### Out of Scope

- Subscription plan management (handled by Entitlements domain)
- Payment processing for contact unlocks (handled by Billing domain)
- Visit scheduling (handled by Scheduling domain)
- Communication delivery (handled by Communications domain)
- CRM pipeline management (handled by CRM domain)

### 2.3 Key Entities

| Entity | Description |
|--------|-------------|
| **Lead** | Core entity representing a seeker's interest in a property |
| **LeadState** | State machine tracking lead lifecycle stages |
| **ContactReveal** | Record of contact information disclosure events |
| **LeadThrottle** | Configuration and tracking for rate limiting |
| **MatchRule** | Qualification rules for lead-listing matching |

---

## 3. User Stories

### 3.1 Property Seeker (Tenant/Buyer)

#### US-L001: Contact Owner
**As a** property seeker
**I want to** contact a property owner about their listing
**So that** I can express interest and schedule a property visit

**Acceptance Criteria:**
- Seeker can initiate contact from listing detail page
- System validates seeker has available contact reveals (based on entitlements)
- Lead is created with seeker and listing details
- Owner contact information is revealed upon successful lead creation
- Seeker receives confirmation with next steps

#### US-L002: Request Callback
**As a** property seeker
**I want to** request a callback from the property owner
**So that** the owner can contact me at their convenience

**Acceptance Criteria:**
- Seeker can request callback without using a contact reveal
- System captures seeker's preferred callback time
- Owner receives notification with seeker's contact details
- Lead is created in "callback_requested" state

#### US-L003: View My Leads
**As a** property seeker
**I want to** view all properties I have expressed interest in
**So that** I can track my property search progress

**Acceptance Criteria:**
- Seeker can view list of all their leads
- Leads are grouped by status (active, scheduled, closed)
- Each lead shows listing details, owner response status, and next steps

### 3.2 Property Owner

#### US-L004: View Incoming Leads
**As a** property owner
**I want to** see all leads for my listings
**So that** I can respond to interested parties

**Acceptance Criteria:**
- Owner can view all leads across their listings
- Leads are sortable by date, listing, and status
- New leads are prominently highlighted
- Lead details include seeker profile and qualification score

#### US-L005: Respond to Lead
**As a** property owner
**I want to** respond to a lead
**So that** I can progress the rental/sale process

**Acceptance Criteria:**
- Owner can mark lead as "contacted"
- Owner can add notes about the interaction
- Owner can schedule a visit (triggers Scheduling domain)
- Owner can mark lead as "not interested" with reason

#### US-L006: Close Lead
**As a** property owner
**I want to** close a lead with an outcome
**So that** the system can track conversion and learn from outcomes

**Acceptance Criteria:**
- Owner can close lead as "successful" (deal closed)
- Owner can close lead as "lost" with reason (wrong fit, price, timing, etc.)
- Closed leads update listing availability status
- System captures feedback for analytics

### 3.3 System/Platform

#### US-L007: Lead Qualification
**As the** MySqrft platform
**I want to** automatically qualify leads based on match rules
**So that** owners receive high-quality, relevant leads

**Acceptance Criteria:**
- System evaluates seeker profile against listing requirements
- Match score is calculated based on budget, preferences, verification status
- Low-quality leads are flagged or filtered
- Match score is visible to owners

#### US-L008: Throttle Abusive Behavior
**As the** MySqrft platform
**I want to** detect and throttle abusive lead behavior
**So that** platform integrity is maintained

**Acceptance Criteria:**
- System tracks lead creation velocity per user
- Excessive lead creation triggers cooldown period
- Spam patterns are detected and blocked
- Repeat offenders are flagged for review

---

## 4. Functional Requirements

### 4.1 Lead Creation

#### FR-L001: Contact Owner Flow
| ID | Requirement |
|----|-------------|
| FR-L001.1 | System shall validate seeker's entitlement to create leads |
| FR-L001.2 | System shall check seeker's remaining contact reveal quota |
| FR-L001.3 | System shall verify listing is active and accepting leads |
| FR-L001.4 | System shall create lead with initial state "new" |
| FR-L001.5 | System shall deduct one contact reveal from seeker's quota |
| FR-L001.6 | System shall reveal owner contact information to seeker |
| FR-L001.7 | System shall notify owner of new lead via Communications domain |

#### FR-L002: Request Callback Flow
| ID | Requirement |
|----|-------------|
| FR-L002.1 | System shall capture seeker's preferred callback time slots |
| FR-L002.2 | System shall create lead with state "callback_requested" |
| FR-L002.3 | System shall reveal seeker contact information to owner |
| FR-L002.4 | System shall notify owner with callback request details |
| FR-L002.5 | Callback requests shall not consume seeker's contact reveal quota |

#### FR-L003: Lead Data Capture
| ID | Requirement |
|----|-------------|
| FR-L003.1 | System shall capture seeker ID and profile snapshot |
| FR-L003.2 | System shall capture listing ID and listing snapshot |
| FR-L003.3 | System shall capture owner ID |
| FR-L003.4 | System shall record creation timestamp and channel |
| FR-L003.5 | System shall capture optional seeker message to owner |
| FR-L003.6 | System shall calculate and store initial match score |

### 4.2 Lead Qualification

#### FR-L010: Match Rules Engine
| ID | Requirement |
|----|-------------|
| FR-L010.1 | System shall evaluate seeker budget against listing price |
| FR-L010.2 | System shall evaluate seeker preferences against listing attributes |
| FR-L010.3 | System shall factor seeker verification status into match score |
| FR-L010.4 | System shall factor seeker's lead history and conversion rate |
| FR-L010.5 | System shall support configurable match rule weights |
| FR-L010.6 | Match score shall be on a 0-100 scale |

#### FR-L011: Match Score Components
| Component | Weight | Description |
|-----------|--------|-------------|
| Budget Fit | 30% | Seeker's budget range vs listing price |
| Preference Match | 25% | Property type, furnishing, amenities alignment |
| Verification Level | 20% | KYC verification status of seeker |
| Profile Completeness | 15% | Completeness of seeker profile |
| Historical Quality | 10% | Seeker's past lead conversion rate |

#### FR-L012: Qualification Thresholds
| ID | Requirement |
|----|-------------|
| FR-L012.1 | Leads with match score < 30 shall be flagged as low quality |
| FR-L012.2 | Leads with match score >= 70 shall be marked as high quality |
| FR-L012.3 | Owners shall be able to set minimum match score threshold |
| FR-L012.4 | Premium listings may require higher minimum match scores |

### 4.3 Lead State Management

#### FR-L020: Lead States
```
new -> contacted -> scheduled -> closed (success)
                              -> lost

new -> callback_requested -> contacted -> scheduled -> closed (success)
                                                    -> lost

new -> expired (after 7 days without owner response)

new -> rejected (by owner)
```

#### FR-L021: State Transitions
| From State | To State | Trigger | Actor |
|------------|----------|---------|-------|
| new | contacted | Owner marks as contacted | Owner |
| new | rejected | Owner rejects lead | Owner |
| new | expired | 7 days without action | System |
| contacted | scheduled | Visit scheduled | Owner/Seeker |
| contacted | lost | No further interest | Owner |
| scheduled | closed | Deal completed | Owner |
| scheduled | lost | Deal fell through | Owner |
| callback_requested | contacted | Owner responds | Owner |

#### FR-L022: State Transition Rules
| ID | Requirement |
|----|-------------|
| FR-L022.1 | State transitions shall be logged with timestamp and actor |
| FR-L022.2 | Invalid state transitions shall be rejected |
| FR-L022.3 | State changes shall trigger appropriate notifications |
| FR-L022.4 | Closed/lost/expired states shall be terminal |
| FR-L022.5 | System shall support reopening expired leads within 48 hours |

### 4.4 Contact Reveal Management

#### FR-L030: Contact Reveal Tracking
| ID | Requirement |
|----|-------------|
| FR-L030.1 | System shall create ContactReveal record for each disclosure |
| FR-L030.2 | ContactReveal shall record revealer, recipient, and timestamp |
| FR-L030.3 | ContactReveal shall record what information was disclosed |
| FR-L030.4 | System shall integrate with Entitlements for quota enforcement |

#### FR-L031: Contact Reveal Limits
| ID | Requirement |
|----|-------------|
| FR-L031.1 | Free users shall have limited contact reveals per month |
| FR-L031.2 | Paid plan users shall have quota based on plan tier |
| FR-L031.3 | System shall warn users when approaching quota limit |
| FR-L031.4 | System shall block reveals when quota exhausted |
| FR-L031.5 | Unused reveals shall not roll over to next billing period |

### 4.5 Owner Response Handling

#### FR-L040: Response Tracking
| ID | Requirement |
|----|-------------|
| FR-L040.1 | System shall track time from lead creation to first response |
| FR-L040.2 | System shall track response method (call, message, in-app) |
| FR-L040.3 | System shall allow owners to log interaction notes |
| FR-L040.4 | System shall track multiple interactions per lead |

#### FR-L041: Response Reminders
| ID | Requirement |
|----|-------------|
| FR-L041.1 | System shall send reminder if lead not responded within 4 hours |
| FR-L041.2 | System shall send escalation if lead not responded within 24 hours |
| FR-L041.3 | Owners shall be able to configure reminder preferences |
| FR-L041.4 | Premium leads shall have expedited reminder cadence |

### 4.6 Lead Throttling

#### FR-L050: Throttle Configuration
| ID | Requirement |
|----|-------------|
| FR-L050.1 | System shall limit leads per seeker per listing to 1 |
| FR-L050.2 | System shall limit leads per seeker per day (configurable, default 10) |
| FR-L050.3 | System shall limit leads per listing per hour (configurable, default 20) |
| FR-L050.4 | System shall limit leads to same owner per day (configurable, default 5) |

#### FR-L051: Throttle Actions
| ID | Requirement |
|----|-------------|
| FR-L051.1 | Throttled requests shall return clear error message |
| FR-L051.2 | System shall indicate when throttle will reset |
| FR-L051.3 | Throttle violations shall be logged for analysis |
| FR-L051.4 | Repeated throttle violations shall trigger abuse review |

### 4.7 Anti-Abuse Controls

#### FR-L060: Spam Detection
| ID | Requirement |
|----|-------------|
| FR-L060.1 | System shall detect rapid-fire lead creation patterns |
| FR-L060.2 | System shall detect copy-paste message patterns |
| FR-L060.3 | System shall detect leads from unverified accounts |
| FR-L060.4 | System shall integrate with TrustSafety for fraud signals |
| FR-L060.5 | Suspected spam leads shall require manual review |

#### FR-L061: Cooldown Periods
| ID | Requirement |
|----|-------------|
| FR-L061.1 | Users exceeding throttle limits shall enter cooldown period |
| FR-L061.2 | Initial cooldown period shall be 1 hour |
| FR-L061.3 | Repeated violations shall increase cooldown exponentially |
| FR-L061.4 | Maximum cooldown period shall be 7 days |
| FR-L061.5 | Cooldown can be appealed through Support domain |

#### FR-L062: Contact Reveal Abuse Prevention
| ID | Requirement |
|----|-------------|
| FR-L062.1 | System shall detect mass contact reveal patterns |
| FR-L062.2 | System shall flag users harvesting contact information |
| FR-L062.3 | System shall track contact reveal to actual engagement ratio |
| FR-L062.4 | Users with low engagement ratio shall be flagged |

---

## 5. Non-Functional Requirements

### 5.1 Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-L001 | Lead creation latency | < 500ms |
| NFR-L002 | Lead list retrieval | < 200ms |
| NFR-L003 | Match score calculation | < 100ms |
| NFR-L004 | Throttle check | < 50ms |
| NFR-L005 | Concurrent lead creation support | 1000 TPS |

### 5.2 Availability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-L010 | Service availability | 99.9% uptime |
| NFR-L011 | Data durability | 99.999% |
| NFR-L012 | Recovery Time Objective (RTO) | < 15 minutes |
| NFR-L013 | Recovery Point Objective (RPO) | < 5 minutes |

### 5.3 Scalability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-L020 | Horizontal scaling capability | Auto-scale 2x-10x |
| NFR-L021 | Database partitioning | By city/region |
| NFR-L022 | Peak load handling | 5x normal traffic |

### 5.4 Security

| ID | Requirement |
|----|-------------|
| NFR-L030 | Contact information shall be encrypted at rest |
| NFR-L031 | Contact reveals shall require authentication |
| NFR-L032 | All lead operations shall be audit logged |
| NFR-L033 | PII access shall be logged and monitored |
| NFR-L034 | Rate limiting shall prevent enumeration attacks |

### 5.5 Data Retention

| ID | Requirement |
|----|-------------|
| NFR-L040 | Active leads shall be retained indefinitely |
| NFR-L041 | Closed leads shall be retained for 2 years |
| NFR-L042 | Lead PII shall be anonymized after retention period |
| NFR-L043 | Audit logs shall be retained for 5 years |

---

## 6. Data Model

### 6.1 Lead Entity

```
Lead {
    id: UUID (PK)
    listing_id: UUID (FK -> Inventory.Listing)
    seeker_id: UUID (FK -> UserManagement.User)
    owner_id: UUID (FK -> UserManagement.User)

    // State
    state: LeadState (new, callback_requested, contacted, scheduled, closed, lost, expired, rejected)
    state_history: JSON[] // Array of state transitions

    // Qualification
    match_score: Integer (0-100)
    match_details: JSON // Breakdown of score components
    quality_tier: Enum (high, medium, low)

    // Context
    source_channel: Enum (web, mobile_app, api)
    seeker_message: Text (optional)
    preferred_callback_times: JSON[] (optional)

    // Snapshots (denormalized for historical reference)
    listing_snapshot: JSON
    seeker_profile_snapshot: JSON

    // Tracking
    created_at: Timestamp
    updated_at: Timestamp
    first_response_at: Timestamp (nullable)
    closed_at: Timestamp (nullable)
    close_reason: String (nullable)

    // Metadata
    is_premium: Boolean // Based on seeker's entitlement at creation
    priority_score: Integer // For lead queue ordering
}
```

### 6.2 LeadState Entity

```
LeadStateTransition {
    id: UUID (PK)
    lead_id: UUID (FK -> Lead)

    from_state: LeadState
    to_state: LeadState

    actor_id: UUID (FK -> UserManagement.User, nullable for system)
    actor_type: Enum (seeker, owner, system)

    reason: String (optional)
    notes: Text (optional)

    created_at: Timestamp
}
```

### 6.3 ContactReveal Entity

```
ContactReveal {
    id: UUID (PK)
    lead_id: UUID (FK -> Lead)

    revealer_id: UUID (FK -> UserManagement.User) // Who's contact was revealed
    recipient_id: UUID (FK -> UserManagement.User) // Who received the contact

    revealed_fields: String[] // [email, phone, whatsapp]

    // Entitlement tracking
    entitlement_id: UUID (FK -> Entitlements.Entitlement, nullable)
    quota_deducted: Boolean

    created_at: Timestamp

    // Audit
    ip_address: String
    device_fingerprint: String (optional)
}
```

### 6.4 LeadThrottle Entity

```
LeadThrottle {
    id: UUID (PK)
    user_id: UUID (FK -> UserManagement.User)

    throttle_type: Enum (daily_limit, hourly_limit, cooldown)

    // Counters
    current_count: Integer
    max_count: Integer
    window_start: Timestamp
    window_duration_seconds: Integer

    // Cooldown specific
    cooldown_until: Timestamp (nullable)
    cooldown_level: Integer (1-5, for exponential backoff)

    // Metadata
    violation_count: Integer
    last_violation_at: Timestamp (nullable)

    created_at: Timestamp
    updated_at: Timestamp
}
```

### 6.5 MatchRule Entity

```
MatchRule {
    id: UUID (PK)

    name: String
    description: Text

    // Rule definition
    rule_type: Enum (budget, preference, verification, profile, historical)
    condition: JSON // Rule condition expression
    weight: Decimal (0-1) // Contribution to match score

    // Applicability
    is_active: Boolean
    applies_to_listing_types: String[] // [rental, sale, commercial]
    applies_to_cities: String[] // Empty = all cities

    // Metadata
    created_at: Timestamp
    updated_at: Timestamp
    created_by: UUID (FK -> UserManagement.User)
}
```

---

## 7. API Specifications

### 7.1 Lead Creation APIs

#### POST /api/v1/leads
Create a new lead (Contact Owner flow)

**Request:**
```json
{
    "listing_id": "uuid",
    "message": "string (optional)",
    "source_channel": "web | mobile_app"
}
```

**Response (201):**
```json
{
    "lead_id": "uuid",
    "state": "new",
    "match_score": 85,
    "owner_contact": {
        "name": "string",
        "phone": "string",
        "email": "string"
    },
    "remaining_reveals": 8,
    "created_at": "timestamp"
}
```

#### POST /api/v1/leads/callback
Create a callback request lead

**Request:**
```json
{
    "listing_id": "uuid",
    "message": "string (optional)",
    "preferred_times": [
        {
            "date": "2026-01-18",
            "time_slot": "morning | afternoon | evening"
        }
    ]
}
```

**Response (201):**
```json
{
    "lead_id": "uuid",
    "state": "callback_requested",
    "match_score": 85,
    "created_at": "timestamp"
}
```

### 7.2 Lead Management APIs

#### GET /api/v1/leads
List leads for authenticated user

**Query Parameters:**
- `role`: `seeker | owner` (required)
- `state`: Filter by state
- `listing_id`: Filter by listing
- `from_date`: Filter by creation date
- `to_date`: Filter by creation date
- `page`: Pagination
- `limit`: Items per page (default 20)

#### GET /api/v1/leads/{lead_id}
Get lead details

#### PATCH /api/v1/leads/{lead_id}/state
Update lead state

**Request:**
```json
{
    "state": "contacted | scheduled | closed | lost | rejected",
    "reason": "string (required for lost/rejected)",
    "notes": "string (optional)"
}
```

#### POST /api/v1/leads/{lead_id}/interactions
Log an interaction

**Request:**
```json
{
    "type": "call | message | visit | note",
    "notes": "string",
    "outcome": "positive | neutral | negative"
}
```

### 7.3 Throttle & Quota APIs

#### GET /api/v1/leads/quota
Get current user's lead quota status

**Response:**
```json
{
    "contact_reveals": {
        "used": 12,
        "total": 20,
        "resets_at": "timestamp"
    },
    "daily_leads": {
        "used": 5,
        "limit": 10,
        "resets_at": "timestamp"
    },
    "cooldown": {
        "active": false,
        "ends_at": null
    }
}
```

### 7.4 Match Rules APIs (Admin)

#### GET /api/v1/admin/leads/match-rules
List all match rules

#### POST /api/v1/admin/leads/match-rules
Create a new match rule

#### PUT /api/v1/admin/leads/match-rules/{rule_id}
Update a match rule

#### DELETE /api/v1/admin/leads/match-rules/{rule_id}
Delete a match rule

---

## 8. Domain Events

### 8.1 Events Published

| Event | Description | Consumers |
|-------|-------------|-----------|
| `lead.created` | New lead created | Communications, CRM, Analytics |
| `lead.state_changed` | Lead state transition | Communications, CRM, Analytics |
| `lead.contacted` | Owner marked lead as contacted | CRM, Analytics |
| `lead.scheduled` | Visit scheduled for lead | Scheduling, CRM, Analytics |
| `lead.closed` | Lead closed successfully | CRM, Analytics, Inventory |
| `lead.lost` | Lead marked as lost | CRM, Analytics |
| `lead.expired` | Lead expired without response | Communications, Analytics |
| `contact.revealed` | Contact information revealed | Entitlements, Analytics |
| `throttle.triggered` | User hit throttle limit | TrustSafety, Analytics |
| `abuse.detected` | Potential abuse detected | TrustSafety |

### 8.2 Events Consumed

| Event | Source | Action |
|-------|--------|--------|
| `listing.paused` | Inventory | Block new leads, notify existing leads |
| `listing.expired` | Inventory | Close pending leads as lost |
| `listing.closed` | Inventory | Close pending leads as lost (deal elsewhere) |
| `entitlement.quota_updated` | Entitlements | Update user's lead quota |
| `payment.completed` | Billing | Unlock additional reveals if purchased |
| `visit.completed` | Scheduling | Update lead state, request feedback |
| `fraud.user_flagged` | TrustSafety | Block user from creating leads |

---

## 9. Integration Points

### 9.1 Upstream Dependencies

| Domain | Integration | Purpose |
|--------|-------------|---------|
| **Auth** | User authentication | Verify seeker/owner identity |
| **UserManagement** | User profiles | Seeker profile for qualification |
| **Authorization** | Permission checks | Verify lead creation permissions |
| **Inventory** | Listing data | Validate listing, get owner details |
| **Entitlements** | Quota management | Check/deduct contact reveals |

### 9.2 Downstream Integrations

| Domain | Integration | Purpose |
|--------|-------------|---------|
| **Communications** | Notifications | Lead alerts to owners/seekers |
| **Scheduling** | Visit booking | Schedule property visits |
| **CRM** | Contact records | Sync leads to CRM pipeline |
| **Analytics** | Event tracking | Lead funnel analytics |
| **TrustSafety** | Fraud signals | Report abuse patterns |
| **Billing** | Reveal purchase | Handle additional reveal purchases |

### 9.3 External Integrations

| System | Purpose | Priority |
|--------|---------|----------|
| WhatsApp Business API | Lead notifications | High |
| SMS Gateway | Fallback notifications | Medium |
| Fraud Detection Service | Enhanced spam detection | Medium |

---

## 10. Business Rules

### 10.1 Lead Creation Rules

| Rule ID | Rule | Enforcement |
|---------|------|-------------|
| BR-L001 | Seeker cannot create duplicate lead for same listing | Hard block |
| BR-L002 | Seeker must have verified phone to create leads | Hard block |
| BR-L003 | Listing must be active to receive leads | Hard block |
| BR-L004 | Seeker must have available contact reveals (for contact flow) | Hard block |
| BR-L005 | Lead cannot be created if seeker is in cooldown | Hard block |
| BR-L006 | Seeker budget should be within 30% of listing price | Soft warning |

### 10.2 Lead Qualification Rules

| Rule ID | Rule | Impact |
|---------|------|--------|
| BR-L010 | Budget mismatch > 50% reduces score by 30 points | Score reduction |
| BR-L011 | Unverified seeker reduces score by 20 points | Score reduction |
| BR-L012 | Incomplete profile (<50%) reduces score by 15 points | Score reduction |
| BR-L013 | Previous no-shows reduce score by 25 points | Score reduction |
| BR-L014 | Premium seeker adds 10 bonus points | Score boost |

### 10.3 Throttling Rules

| Rule ID | Rule | Limit | Cooldown |
|---------|------|-------|----------|
| BR-L020 | Max leads per seeker per day | 10 | 24 hours |
| BR-L021 | Max leads to same owner per day | 5 | 24 hours |
| BR-L022 | Max leads per listing per hour | 20 | 1 hour |
| BR-L023 | Repeated violations trigger cooldown | 3 violations | 1h -> 4h -> 24h -> 72h -> 168h |

### 10.4 Anti-Abuse Rules

| Rule ID | Rule | Action |
|---------|------|--------|
| BR-L030 | >5 leads in 5 minutes triggers review | Flag for review |
| BR-L031 | Same message to >3 listings triggers spam check | Block + review |
| BR-L032 | <10% response rate over 10+ leads triggers review | Flag account |
| BR-L033 | Contact reveal without subsequent activity flagged | Track pattern |

---

## 11. Acceptance Criteria

### 11.1 MVP Acceptance Criteria

| ID | Criteria | Priority |
|----|----------|----------|
| AC-001 | Seeker can create lead from listing page | P0 |
| AC-002 | Owner receives notification of new lead | P0 |
| AC-003 | Contact information is revealed to seeker | P0 |
| AC-004 | Lead state can be updated by owner | P0 |
| AC-005 | Basic throttling prevents spam | P0 |
| AC-006 | Quota is enforced for contact reveals | P0 |
| AC-007 | Lead list is viewable by both parties | P0 |
| AC-008 | Match score is calculated and displayed | P1 |
| AC-009 | Callback request flow works | P1 |
| AC-010 | Lead expiration is automatic | P1 |

### 11.2 Post-MVP Acceptance Criteria

| ID | Criteria | Priority |
|----|----------|----------|
| AC-011 | Advanced spam detection is operational | P2 |
| AC-012 | Match rules are configurable via admin | P2 |
| AC-013 | Lead analytics dashboard is available | P2 |
| AC-014 | Cooldown escalation works correctly | P2 |
| AC-015 | Lead reopening works within window | P3 |

---

## 12. Risks and Mitigations

### 12.1 Technical Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| High lead volume impacts performance | High | Medium | Implement caching, database sharding |
| Spam overwhelms moderation | High | Medium | Automated detection, escalating cooldowns |
| Quota bypass through multiple accounts | Medium | Medium | Device fingerprinting, phone verification |
| Data inconsistency between domains | Medium | Low | Event sourcing, saga patterns |

### 12.2 Business Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Low lead quality frustrates owners | High | Medium | Improve qualification rules, feedback loops |
| Strict throttling limits genuine users | Medium | Medium | Plan-based higher limits, appeal process |
| Contact reveal abuse for data harvesting | High | Low | Engagement tracking, progressive limits |
| Poor owner response rates | Medium | Medium | Response reminders, performance penalties |

---

## 13. Success Metrics & Monitoring

### 13.1 Key Performance Indicators

| KPI | Definition | Target | Measurement |
|-----|------------|--------|-------------|
| Lead Volume | Total leads created per day | Growth trend | Daily count |
| Lead Quality | Average match score | > 70 | Weekly average |
| Conversion Rate | Leads -> Closed (success) | > 15% | Weekly cohort |
| Response Rate | Leads responded within 24h | > 60% | Daily tracking |
| Spam Rate | Leads flagged as spam | < 2% | Daily percentage |
| Throttle Rate | Users hitting throttle limits | < 5% | Daily percentage |

### 13.2 Alerts & Monitoring

| Alert | Condition | Severity |
|-------|-----------|----------|
| Lead creation spike | >200% of normal volume | Warning |
| Spam detection spike | >5% spam rate | High |
| Response rate drop | <40% in 24h | Warning |
| Throttle rate spike | >10% of users | Warning |
| Service latency | >1s p95 | Critical |
| Service errors | >1% error rate | Critical |

---

## 14. Implementation Notes

### 14.1 Technical Considerations

1. **State Machine**: Use a proper state machine library to enforce valid transitions
2. **Event Sourcing**: Consider event sourcing for lead state history
3. **Caching**: Cache throttle counters in Redis for performance
4. **Idempotency**: Lead creation should be idempotent (prevent double-submits)
5. **Async Processing**: Match score calculation can be async for better latency

### 14.2 Migration Considerations

- N/A for new system

### 14.3 Feature Flags

| Flag | Purpose | Default |
|------|---------|---------|
| `leads.callback_flow_enabled` | Enable callback request flow | true |
| `leads.advanced_spam_detection` | Enable ML-based spam detection | false |
| `leads.match_score_visible` | Show match score to owners | true |
| `leads.premium_priority` | Enable premium lead prioritization | true |

---

## 15. Appendix

### 15.1 Glossary

| Term | Definition |
|------|------------|
| Lead | A record of a seeker's interest in a specific listing |
| Contact Reveal | The action of disclosing owner/seeker contact information |
| Match Score | Numerical score (0-100) indicating lead-listing fit quality |
| Throttle | Rate limiting mechanism to prevent abuse |
| Cooldown | Temporary restriction on lead creation after violations |
| Callback Request | Alternative lead type where owner initiates contact |

### 15.2 Related Documents

- [Domain Definitions](/docs/domains.md)
- Inventory Domain PRD (to be created)
- Entitlements Domain PRD (to be created)
- Communications Domain PRD (to be created)
- CRM Domain PRD (to be created)

### 15.3 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | Product Team | Initial draft |

---

*This document is part of the MySqrft Platform Documentation.*
