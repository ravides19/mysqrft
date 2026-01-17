# HomeServices Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | HomeServices |
| Version | 1.0 |
| Status | Complete |
| Owner | Product Team |
| Last Updated | 2026-01-17 |

---

## 1. Executive Summary

### 1.1 Purpose

The HomeServices domain provides a comprehensive marketplace for home-related services within the MySqrft platform. It enables users to discover, book, and manage professional services such as moving, painting, cleaning, and other home improvement services. The domain handles the complete service lifecycle from quote generation through fulfillment, ratings, and dispute resolution.

### 1.2 Primary Goal

**Movers/Painting/Cleaning + Fulfillment**

Enable MySqrft users to seamlessly access professional home services with guaranteed quality, transparent pricing, and reliable fulfillment.

### 1.3 Business Objectives

- Generate additional revenue through service commissions and platform fees
- Increase user engagement and platform stickiness
- Build a network of verified, quality service providers
- Create a trusted ecosystem for home services in the real estate lifecycle
- Reduce friction in the move-in/move-out process for tenants and owners

---

## 2. Scope

### 2.1 In Scope

- Service catalog management and discovery
- Quote generation and comparison
- Booking creation and management
- Partner (service provider) onboarding and allocation
- Dispatch and scheduling coordination
- Real-time service tracking and status updates
- SLA definition, monitoring, and enforcement
- Service completion verification
- Customer ratings and reviews
- Dispute handling and resolution
- Refund processing workflows
- Partner payout coordination and reconciliation

### 2.2 Out of Scope

- Actual service delivery (handled by partners)
- Partner hiring and employment
- Physical inventory/equipment management
- Partner insurance policies (partners provide their own)
- Long-term property management contracts (PropertyManagement domain)
- Society-level maintenance services (Society domain)

### 2.3 Dependencies

| Domain | Dependency Type | Description |
|--------|----------------|-------------|
| Auth | Required | User authentication and session management |
| UserManagement | Required | User profiles, roles, and preferences |
| Authorization | Required | Access control for bookings and partner operations |
| KYC | Required | Service provider verification |
| Billing | Required | Payment processing, refunds, invoicing |
| Communications | Required | Notifications, booking updates, chat |
| Scheduling | Optional | Calendar integration for service appointments |
| Support | Required | Ticket creation for disputes and issues |
| TrustSafety | Required | Fraud detection, provider vetting |
| Analytics | Consuming | Service metrics, conversion funnels |

---

## 3. Core Responsibilities

### 3.1 Service Catalog, Quotes, and Bookings

**Description:** Manage the catalog of available services and enable users to get quotes and book services.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| SC-001 | Maintain a hierarchical service catalog (category > subcategory > service) | P0 |
| SC-002 | Support service variants (e.g., 1BHK vs 3BHK moving) | P0 |
| SC-003 | Define service attributes (duration, pricing model, requirements) | P0 |
| SC-004 | Enable location-based service availability | P0 |
| SC-005 | Support multiple pricing models (fixed, per-unit, hourly, quote-based) | P0 |
| SC-006 | Generate instant quotes based on service parameters | P0 |
| SC-007 | Allow users to request custom quotes for complex requirements | P1 |
| SC-008 | Enable quote comparison across multiple providers | P1 |
| SC-009 | Set quote validity/expiration periods | P1 |
| SC-010 | Support seasonal/dynamic pricing rules | P2 |

**Quote Flow:**
1. User selects service category and type
2. User provides service details (location, size, date, special requirements)
3. System generates instant quote(s) or requests from available providers
4. User reviews and selects preferred quote
5. Quote is held for booking confirmation

### 3.2 Partner Allocation and Dispatch

**Description:** Match service requests with qualified providers and manage dispatch operations.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| PA-001 | Maintain provider profiles with service capabilities | P0 |
| PA-002 | Implement allocation algorithm based on availability, proximity, rating | P0 |
| PA-003 | Support manual allocation override by operations team | P0 |
| PA-004 | Enable provider acceptance/rejection of assignments | P0 |
| PA-005 | Implement automatic reassignment on rejection/no-response | P1 |
| PA-006 | Track provider capacity and workload limits | P1 |
| PA-007 | Support provider preferences (areas, service types) | P1 |
| PA-008 | Implement dispatch notifications and confirmations | P0 |
| PA-009 | Enable real-time provider location tracking (for applicable services) | P2 |
| PA-010 | Support team dispatch for large jobs | P2 |

**Allocation Algorithm Factors:**
- Provider availability on requested date/time
- Geographic proximity to service location
- Provider rating and performance score
- Historical success rate with similar services
- Provider capacity and current workload
- Customer preference (if returning customer)

### 3.3 Service Tracking and Status Updates

**Description:** Provide visibility into service progress from booking to completion.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| ST-001 | Define standard status workflow per service type | P0 |
| ST-002 | Enable real-time status updates by providers | P0 |
| ST-003 | Send automated notifications on status changes | P0 |
| ST-004 | Provide customer-facing tracking interface | P0 |
| ST-005 | Support photo/document uploads as proof of progress | P1 |
| ST-006 | Enable estimated time of arrival (ETA) updates | P1 |
| ST-007 | Track service milestones for complex jobs | P2 |
| ST-008 | Support live location tracking for mobile services | P2 |

**Standard Status Workflow:**
```
QUOTE_REQUESTED -> QUOTE_PROVIDED -> BOOKING_CONFIRMED ->
PROVIDER_ASSIGNED -> PROVIDER_EN_ROUTE -> SERVICE_STARTED ->
SERVICE_IN_PROGRESS -> SERVICE_COMPLETED -> PAYMENT_COMPLETED -> CLOSED
```

**Exception States:**
```
CANCELLED_BY_CUSTOMER | CANCELLED_BY_PROVIDER | RESCHEDULED |
DISPUTED | REFUND_INITIATED | REFUND_COMPLETED
```

### 3.4 SLA Management

**Description:** Define, monitor, and enforce service level agreements.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| SLA-001 | Define SLA templates per service type | P0 |
| SLA-002 | Track response time SLAs (quote response, booking confirmation) | P0 |
| SLA-003 | Monitor fulfillment SLAs (on-time arrival, completion) | P0 |
| SLA-004 | Track quality SLAs (customer satisfaction thresholds) | P1 |
| SLA-005 | Implement automatic alerts on SLA breach risk | P1 |
| SLA-006 | Calculate and report SLA compliance metrics | P1 |
| SLA-007 | Support SLA-based penalty/bonus calculations | P2 |
| SLA-008 | Enable customer-facing SLA guarantees | P2 |

**Key SLA Metrics:**
| Metric | Target | Measurement |
|--------|--------|-------------|
| Quote Response Time | < 2 hours | Time from request to quote delivery |
| Booking Confirmation | < 30 minutes | Time from payment to confirmation |
| On-Time Arrival | > 95% | Provider arrives within scheduled window |
| Service Completion | Within estimate | Actual vs. estimated duration |
| Customer Satisfaction | > 4.0/5.0 | Average rating post-service |
| First-Contact Resolution | > 80% | Issues resolved without escalation |

### 3.5 Service Completion and Ratings

**Description:** Verify service completion and capture customer feedback.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| CR-001 | Enable customer confirmation of service completion | P0 |
| CR-002 | Support provider confirmation with completion evidence | P0 |
| CR-003 | Implement rating system (1-5 stars + categories) | P0 |
| CR-004 | Enable detailed text reviews | P0 |
| CR-005 | Support photo uploads in reviews | P1 |
| CR-006 | Calculate and update provider rating scores | P0 |
| CR-007 | Enable provider response to reviews | P1 |
| CR-008 | Implement review moderation queue | P1 |
| CR-009 | Send automated review request reminders | P1 |
| CR-010 | Display verified booking badges on reviews | P2 |

**Rating Categories:**
- Overall satisfaction
- Punctuality
- Professionalism
- Quality of work
- Value for money
- Communication

### 3.6 Dispute and Refund Workflows

**Description:** Handle customer complaints, disputes, and refund requests.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| DR-001 | Enable customers to raise disputes with reason codes | P0 |
| DR-002 | Define dispute resolution workflow and SLAs | P0 |
| DR-003 | Support evidence collection from both parties | P0 |
| DR-004 | Implement escalation tiers (L1, L2, L3) | P1 |
| DR-005 | Calculate refund amounts based on dispute type | P0 |
| DR-006 | Support partial refunds and service credits | P0 |
| DR-007 | Track dispute resolution metrics | P1 |
| DR-008 | Enable auto-refund for specific scenarios | P2 |
| DR-009 | Integrate with Support domain for complex disputes | P0 |
| DR-010 | Maintain dispute history for providers | P1 |

**Dispute Categories:**
- Service not completed
- Quality issues
- Provider no-show
- Damage during service
- Overcharging
- Unprofessional behavior
- Safety concerns

**Refund Policies:**
| Scenario | Refund | Processing Time |
|----------|--------|-----------------|
| Cancellation > 24 hours | Full refund | 3-5 business days |
| Cancellation < 24 hours | 50% refund | 3-5 business days |
| Provider no-show | Full refund + credit | Immediate |
| Quality dispute (validated) | Partial/Full | After investigation |
| Service not completed | Prorated refund | 3-5 business days |

### 3.7 Partner Payout Coordination

**Description:** Manage financial settlements with service providers.

**Functional Requirements:**

| ID | Requirement | Priority |
|----|-------------|----------|
| PP-001 | Calculate provider earnings per booking | P0 |
| PP-002 | Apply platform commission rates | P0 |
| PP-003 | Support payout schedules (weekly/bi-weekly/monthly) | P0 |
| PP-004 | Generate payout statements for providers | P0 |
| PP-005 | Handle deductions (disputes, penalties, advances) | P0 |
| PP-006 | Support multiple payout methods (bank transfer, UPI) | P0 |
| PP-007 | Track payout status and reconciliation | P0 |
| PP-008 | Generate TDS calculations and certificates | P1 |
| PP-009 | Support advance payments for large jobs | P2 |
| PP-010 | Enable payout holds for disputed bookings | P0 |

**Payout Calculation:**
```
Provider Earnings = (Service Amount - Platform Commission) - Deductions + Bonuses
```

**Commission Structure (Example):**
| Service Category | Platform Commission |
|-----------------|---------------------|
| Moving/Packers | 15-20% |
| Cleaning | 20-25% |
| Painting | 15-18% |
| Repairs | 18-22% |
| Deep Cleaning | 22-25% |

---

## 4. Key Entities

### 4.1 Entity Definitions

#### Service
The core catalog item representing a type of service offered.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Service name |
| category_id | UUID | Parent category reference |
| description | Text | Detailed description |
| pricing_model | Enum | FIXED, HOURLY, PER_UNIT, QUOTE_BASED |
| base_price | Decimal | Starting price |
| duration_estimate | Integer | Estimated minutes |
| requirements | JSON | Input requirements for quote |
| availability_zones | Array | Serviceable locations |
| is_active | Boolean | Service availability flag |
| created_at | Timestamp | Creation timestamp |
| updated_at | Timestamp | Last update timestamp |

#### Booking
A confirmed service request from a customer.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| booking_number | String | Human-readable booking ID |
| user_id | UUID | Customer reference |
| service_id | UUID | Service reference |
| quote_id | UUID | Associated quote reference |
| provider_id | UUID | Assigned provider reference |
| status | Enum | Current booking status |
| scheduled_date | Date | Service date |
| scheduled_time_slot | TimeSlot | Service time window |
| service_address | JSON | Location details |
| service_details | JSON | Service-specific inputs |
| total_amount | Decimal | Total booking value |
| payment_status | Enum | Payment state |
| notes | Text | Special instructions |
| created_at | Timestamp | Booking creation time |
| completed_at | Timestamp | Service completion time |

#### ServiceProvider
A verified partner offering services on the platform.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| user_id | UUID | Associated user account |
| business_name | String | Company/business name |
| service_categories | Array | Supported service types |
| service_areas | Array | Coverage zones |
| rating_score | Decimal | Aggregate rating |
| total_bookings | Integer | Completed booking count |
| verification_status | Enum | KYC verification state |
| commission_rate | Decimal | Platform commission percentage |
| payout_schedule | Enum | Payout frequency |
| bank_details | JSON | Payout account information |
| is_active | Boolean | Availability for new bookings |
| onboarded_at | Timestamp | Onboarding completion date |

#### Quote
A price estimate for a service request.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| quote_number | String | Human-readable quote ID |
| user_id | UUID | Requesting customer |
| service_id | UUID | Service reference |
| provider_id | UUID | Quoting provider (if provider-specific) |
| service_details | JSON | Service requirements |
| line_items | Array | Itemized pricing breakdown |
| total_amount | Decimal | Total quoted price |
| validity_period | Integer | Hours until expiry |
| status | Enum | PENDING, PROVIDED, ACCEPTED, EXPIRED, REJECTED |
| created_at | Timestamp | Quote creation time |
| expires_at | Timestamp | Quote expiry time |

#### Rating
Customer feedback for a completed service.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| booking_id | UUID | Associated booking |
| user_id | UUID | Rating customer |
| provider_id | UUID | Rated provider |
| overall_score | Integer | Overall rating (1-5) |
| category_scores | JSON | Per-category ratings |
| review_text | Text | Written review |
| photos | Array | Review images |
| provider_response | Text | Provider's reply |
| is_verified | Boolean | Verified purchase flag |
| is_visible | Boolean | Public visibility |
| created_at | Timestamp | Rating submission time |

#### Dispatch
An assignment record linking a booking to a provider.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| booking_id | UUID | Associated booking |
| provider_id | UUID | Assigned provider |
| status | Enum | PENDING, ACCEPTED, REJECTED, EN_ROUTE, ARRIVED, COMPLETED |
| assigned_at | Timestamp | Assignment time |
| response_deadline | Timestamp | Acceptance deadline |
| accepted_at | Timestamp | Provider acceptance time |
| eta | Timestamp | Estimated arrival time |
| arrived_at | Timestamp | Actual arrival time |
| completed_at | Timestamp | Service completion time |
| rejection_reason | Text | Reason if rejected |
| notes | Text | Dispatch notes |

### 4.2 Entity Relationship Diagram

```
+-------------+       +-------------+       +------------------+
|   Service   |<------+    Quote    +------>|       User       |
+------+------+       +------+------+       +--------+---------+
       |                     |                       |
       |                     |                       |
       v                     v                       v
+------+------+       +------+------+       +--------+---------+
|   Booking   +<------+   Dispatch  +------>| ServiceProvider  |
+------+------+       +-------------+       +--------+---------+
       |                                             |
       |                                             |
       v                                             |
+------+------+                                      |
|   Rating    +--------------------------------------+
+-------------+
```

---

## 5. User Stories

### 5.1 Customer Stories

| ID | Story | Priority |
|----|-------|----------|
| US-C01 | As a customer, I want to browse available home services by category so that I can find what I need | P0 |
| US-C02 | As a customer, I want to get an instant quote for standard services so that I can quickly understand pricing | P0 |
| US-C03 | As a customer, I want to compare quotes from multiple providers so that I can choose the best option | P1 |
| US-C04 | As a customer, I want to book a service with my preferred date and time so that it fits my schedule | P0 |
| US-C05 | As a customer, I want to track my booking status in real-time so that I know when to expect the provider | P0 |
| US-C06 | As a customer, I want to receive notifications about my booking so that I stay informed | P0 |
| US-C07 | As a customer, I want to rate and review the service after completion so that I can share my experience | P0 |
| US-C08 | As a customer, I want to raise a dispute if I'm unsatisfied so that I can get resolution | P0 |
| US-C09 | As a customer, I want to reschedule or cancel my booking so that I have flexibility | P0 |
| US-C10 | As a customer, I want to see provider ratings and reviews so that I can make informed decisions | P1 |

### 5.2 Service Provider Stories

| ID | Story | Priority |
|----|-------|----------|
| US-P01 | As a provider, I want to receive booking requests in my service area so that I can grow my business | P0 |
| US-P02 | As a provider, I want to accept or decline assignments so that I can manage my capacity | P0 |
| US-P03 | As a provider, I want to update booking status so that customers are informed | P0 |
| US-P04 | As a provider, I want to view my earnings and payout history so that I can track my income | P0 |
| US-P05 | As a provider, I want to respond to customer reviews so that I can address feedback | P1 |
| US-P06 | As a provider, I want to set my availability so that I only receive bookings when I'm free | P1 |
| US-P07 | As a provider, I want to upload completion photos so that I have proof of work | P1 |
| US-P08 | As a provider, I want to view dispute details so that I can provide my side | P0 |
| US-P09 | As a provider, I want to manage my service offerings so that my profile is accurate | P1 |
| US-P10 | As a provider, I want to receive training materials so that I can improve my service quality | P2 |

### 5.3 Operations Stories

| ID | Story | Priority |
|----|-------|----------|
| US-O01 | As an ops manager, I want to monitor SLA compliance so that I can ensure service quality | P0 |
| US-O02 | As an ops manager, I want to manually assign providers so that I can handle edge cases | P0 |
| US-O03 | As an ops manager, I want to resolve disputes so that customers and providers are treated fairly | P0 |
| US-O04 | As an ops manager, I want to view performance dashboards so that I can identify issues | P1 |
| US-O05 | As an ops manager, I want to manage the service catalog so that offerings stay current | P0 |
| US-O06 | As an ops manager, I want to process refunds so that customers are compensated appropriately | P0 |
| US-O07 | As an ops manager, I want to onboard new providers so that we can expand coverage | P1 |
| US-O08 | As an ops manager, I want to configure pricing rules so that we stay competitive | P1 |

---

## 6. API Specifications

### 6.1 Core Endpoints

#### Service Catalog

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/services | List all services with filters |
| GET | /api/v1/services/{id} | Get service details |
| GET | /api/v1/services/categories | List service categories |
| POST | /api/v1/services | Create service (admin) |
| PUT | /api/v1/services/{id} | Update service (admin) |

#### Quotes

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/quotes | Request a quote |
| GET | /api/v1/quotes/{id} | Get quote details |
| GET | /api/v1/quotes | List user's quotes |
| POST | /api/v1/quotes/{id}/accept | Accept a quote |

#### Bookings

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/bookings | Create booking from quote |
| GET | /api/v1/bookings | List bookings (with filters) |
| GET | /api/v1/bookings/{id} | Get booking details |
| PUT | /api/v1/bookings/{id}/status | Update booking status |
| POST | /api/v1/bookings/{id}/cancel | Cancel booking |
| POST | /api/v1/bookings/{id}/reschedule | Reschedule booking |

#### Ratings

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/bookings/{id}/rating | Submit rating |
| GET | /api/v1/providers/{id}/ratings | Get provider ratings |
| POST | /api/v1/ratings/{id}/response | Provider response to rating |

#### Disputes

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/bookings/{id}/dispute | Raise dispute |
| GET | /api/v1/disputes/{id} | Get dispute details |
| PUT | /api/v1/disputes/{id} | Update dispute (ops) |
| POST | /api/v1/disputes/{id}/resolve | Resolve dispute |

#### Provider Operations

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/providers/me/dispatches | Get assigned dispatches |
| PUT | /api/v1/dispatches/{id}/accept | Accept dispatch |
| PUT | /api/v1/dispatches/{id}/reject | Reject dispatch |
| PUT | /api/v1/dispatches/{id}/status | Update dispatch status |
| GET | /api/v1/providers/me/earnings | Get earnings summary |
| GET | /api/v1/providers/me/payouts | Get payout history |

### 6.2 Webhook Events

| Event | Trigger | Payload |
|-------|---------|---------|
| booking.created | New booking confirmed | Booking details |
| booking.status_changed | Status update | Booking ID, old/new status |
| booking.completed | Service completed | Booking details, completion data |
| booking.cancelled | Booking cancelled | Booking ID, cancellation reason |
| dispatch.assigned | Provider assigned | Dispatch details |
| dispatch.accepted | Provider accepted | Dispatch ID, provider details |
| dispatch.rejected | Provider rejected | Dispatch ID, reason |
| rating.submitted | Customer rated | Rating details |
| dispute.created | Dispute raised | Dispute details |
| dispute.resolved | Dispute closed | Resolution details |
| payout.processed | Payout completed | Payout summary |

---

## 7. Non-Functional Requirements

### 7.1 Performance

| Metric | Requirement |
|--------|-------------|
| Quote Generation | < 2 seconds for instant quotes |
| Booking Creation | < 3 seconds end-to-end |
| Search Response | < 500ms for catalog queries |
| Status Updates | Real-time (< 1 second latency) |
| API Response | 95th percentile < 500ms |

### 7.2 Availability

| Requirement | Target |
|-------------|--------|
| Uptime | 99.9% availability |
| Planned Downtime | < 4 hours/month during off-peak |
| Recovery Time | < 15 minutes for critical failures |

### 7.3 Scalability

| Metric | Initial Target | Growth Target |
|--------|---------------|---------------|
| Concurrent Bookings | 1,000/hour | 10,000/hour |
| Active Providers | 1,000 | 50,000 |
| Service Catalog | 50 services | 500 services |
| Geographic Coverage | 10 cities | 100 cities |

### 7.4 Security

- All provider banking details encrypted at rest
- PCI-DSS compliance for payment handling (via Billing domain)
- Provider identity verification mandatory
- Customer address data access restricted
- Audit logging for all financial transactions

### 7.5 Compliance

- GST invoicing for all transactions
- TDS deduction on provider payouts
- Consumer protection regulations adherence
- Data retention policies per legal requirements

---

## 8. Success Metrics

### 8.1 Business Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| GMV | Total booking value | Growth 20% MoM |
| Take Rate | Platform revenue / GMV | 18-22% |
| Bookings per User | Monthly bookings per active user | 1.5+ |
| Provider Utilization | Booked hours / Available hours | 70%+ |
| Attach Rate | Users booking services / Total users | 15%+ |

### 8.2 Operational Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| On-Time Fulfillment | Services completed on schedule | > 95% |
| First-Time Resolution | Disputes resolved at L1 | > 80% |
| Provider Acceptance Rate | Accepted / Assigned dispatches | > 85% |
| Average Response Time | Quote request to quote delivery | < 2 hours |

### 8.3 Quality Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| Customer Satisfaction | Average booking rating | > 4.2/5 |
| Net Promoter Score | NPS for service customers | > 40 |
| Repeat Rate | Users with 2+ bookings | > 30% |
| Dispute Rate | Disputes / Total bookings | < 5% |
| Refund Rate | Refunded bookings / Total | < 3% |

---

## 9. Implementation Phases

### Phase 1: Foundation (MVP)

**Duration:** 8-10 weeks

**Scope:**
- Basic service catalog (Moving, Cleaning, Painting)
- Instant quote generation for standard services
- Booking creation and confirmation
- Manual provider assignment
- Basic status tracking
- Simple rating system (stars only)
- Basic refund workflow

**Success Criteria:**
- 100+ bookings completed
- 20+ active providers onboarded
- < 10% cancellation rate

### Phase 2: Automation

**Duration:** 6-8 weeks

**Scope:**
- Automated provider allocation algorithm
- Real-time status updates
- SLA monitoring and alerts
- Detailed rating categories
- Dispute workflow with escalation
- Provider mobile app/interface

**Success Criteria:**
- 80% automated allocation
- SLA compliance > 90%
- Provider acceptance rate > 80%

### Phase 3: Scale

**Duration:** 6-8 weeks

**Scope:**
- Multi-provider quote comparison
- Dynamic pricing engine
- Advanced dispatch optimization
- Provider performance scoring
- Payout automation
- Expanded service catalog

**Success Criteria:**
- 50+ service types
- 500+ active providers
- 10+ city coverage

### Phase 4: Excellence

**Duration:** Ongoing

**Scope:**
- Predictive demand forecasting
- Provider training and certification
- Quality guarantee programs
- Subscription-based services
- Enterprise/B2B offerings
- IoT integration for smart home services

---

## 10. Risks and Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Provider quality inconsistency | High | Medium | Strict onboarding, ongoing training, rating-based filtering |
| Low provider supply in new cities | High | High | Aggressive onboarding incentives, graduated launch |
| High dispute/refund rates | Medium | Medium | Clear service descriptions, SLA guarantees, quality checks |
| Provider churn | High | Medium | Competitive payouts, bonus programs, growth opportunities |
| Payment fraud | High | Low | KYC verification, transaction monitoring, payout delays |
| Seasonal demand fluctuations | Medium | High | Dynamic pricing, provider capacity planning |
| Competitor pricing pressure | Medium | Medium | Value differentiation, loyalty programs, quality focus |

---

## 11. Glossary

| Term | Definition |
|------|------------|
| Booking | A confirmed service request with scheduled date/time |
| Dispatch | The assignment of a provider to fulfill a booking |
| GMV | Gross Merchandise Value - total transaction value |
| Quote | A price estimate for a service request |
| SLA | Service Level Agreement - performance commitments |
| Take Rate | Platform commission percentage |
| Provider | A verified service partner on the platform |
| Fulfillment | The complete execution of a service booking |

---

## 12. Appendix

### A. Service Category Examples

| Category | Services |
|----------|----------|
| Moving & Packing | Local moving, intercity moving, packing only, unpacking |
| Cleaning | Regular cleaning, deep cleaning, move-in/out cleaning, carpet cleaning |
| Painting | Interior painting, exterior painting, texture painting, waterproofing |
| Repairs | Plumbing, electrical, carpentry, appliance repair |
| Pest Control | General pest control, termite treatment, mosquito control |
| Home Improvement | AC installation, modular kitchen, false ceiling |

### B. Integration Points

```
                    +-------------------+
                    |   Auth/UserMgmt   |
                    +--------+----------+
                             |
                             v
+-------------+     +--------+----------+     +-------------+
|   Billing   |<--->|   HomeServices    |<--->|   Support   |
+-------------+     +--------+----------+     +-------------+
                             |
              +--------------+--------------+
              |              |              |
              v              v              v
      +-------+---+   +------+-----+   +----+--------+
      | Scheduling|   |Communications|  | TrustSafety |
      +-----------+   +------------+   +-------------+
```

### C. Status State Machine

```
                                    +------------------+
                                    |  QUOTE_REQUESTED |
                                    +--------+---------+
                                             |
                                             v
                                    +--------+---------+
                                    |  QUOTE_PROVIDED  |
                                    +--------+---------+
                                             |
                         +-------------------+-------------------+
                         |                                       |
                         v                                       v
              +----------+---------+                  +----------+---------+
              | BOOKING_CONFIRMED  |                  |    QUOTE_EXPIRED   |
              +----------+---------+                  +--------------------+
                         |
                         v
              +----------+---------+
              | PROVIDER_ASSIGNED  +<-----------------------------+
              +----------+---------+                              |
                         |                                        |
           +-------------+-------------+                          |
           |                           |                          |
           v                           v                          |
+----------+---------+      +----------+---------+      +---------+--------+
|  DISPATCH_ACCEPTED |      | DISPATCH_REJECTED  +----->|   REASSIGNMENT   |
+----------+---------+      +--------------------+      +------------------+
           |
           v
+----------+---------+
|  PROVIDER_EN_ROUTE |
+----------+---------+
           |
           v
+----------+---------+
|  SERVICE_STARTED   |
+----------+---------+
           |
           v
+----------+---------+
| SERVICE_IN_PROGRESS|
+----------+---------+
           |
           v
+----------+---------+
| SERVICE_COMPLETED  |
+----------+---------+
           |
           v
+----------+---------+
| PAYMENT_COMPLETED  |
+----------+---------+
           |
           v
+----------+---------+
|       CLOSED       |
+--------------------+
```

---

*Document End*
