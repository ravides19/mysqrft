# Marketing Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Marketing |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | 2026-01-17 |

---

## 1. Executive Summary

### 1.1 Purpose
The Marketing domain powers growth loops and lifecycle campaigns for the MySqrft platform. It encompasses all customer acquisition, retention, and engagement mechanisms including referral programs, promotional campaigns, multi-channel communication orchestration, and experimentation infrastructure.

### 1.2 Primary Goal
**Growth Loops + Lifecycle Campaigns**

### 1.3 Business Value
- Drive organic user acquisition through viral referral mechanisms
- Increase conversion rates through targeted promotions and pricing experiments
- Improve SEO visibility via locality-specific landing pages
- Optimize marketing spend through attribution tracking
- Enable data-driven decisions via A/B testing infrastructure

---

## 2. Domain Responsibilities

### 2.1 Core Capabilities

| Capability | Description |
|------------|-------------|
| Referral Program | Credit-based referral system with fraud detection |
| Promotions & Coupons | Discount codes, pricing experiments, limited-time offers |
| Campaign Landing Pages | SEO-optimized locality pages for organic traffic |
| Multi-Channel Orchestration | Coordinated campaigns across push/SMS/WhatsApp/email |
| Attribution Tracking | UTM parameter management and conversion attribution |
| A/B Testing | Experimentation infrastructure for product optimization |

### 2.2 Detailed Responsibilities

#### 2.2.1 Referral Program with Credits and Fraud Detection
- Unique referral code/link generation per user
- Credit allocation rules (referrer and referee rewards)
- Multi-tier referral tracking (direct and indirect)
- Referral status lifecycle (pending, verified, credited, expired)
- Fraud detection mechanisms:
  - Device fingerprint analysis
  - IP address clustering detection
  - Behavioral pattern analysis
  - Self-referral prevention
  - Velocity checks (too many referrals in short time)
- Credit wallet integration with Entitlements domain
- Referral analytics and leaderboards

#### 2.2.2 Promotions, Coupons, and Pricing Experiments
- Coupon code generation (single-use, multi-use, limited quantity)
- Discount types:
  - Percentage off
  - Fixed amount off
  - Free trial periods
  - Feature unlocks
- Eligibility rules engine:
  - User segments (new users, specific cities, plan types)
  - Time-based restrictions (valid from/to dates)
  - Usage limits (per user, total redemptions)
  - Minimum order value requirements
- Stacking rules (which promotions can combine)
- Pricing experiments with control/variant groups
- Real-time coupon validation API

#### 2.2.3 Campaign Landing Pages (SEO/Locality Pages)
- Template-based landing page generation
- Locality-specific content:
  - Property availability stats
  - Price ranges by BHK type
  - Neighborhood information
  - Nearby amenities
- SEO metadata management (title, description, schema markup)
- Dynamic content injection from Inventory domain
- URL structure optimization (/rent/bangalore/koramangala)
- Performance tracking per landing page
- A/B testing of page variants

#### 2.2.4 Multi-Channel Campaign Orchestration
- Campaign definition and targeting:
  - Audience segmentation rules
  - Trigger conditions (event-based, time-based, behavior-based)
  - Channel selection logic
- Channel support:
  - Push notifications (iOS/Android/Web)
  - SMS messages
  - WhatsApp business messages
  - Email campaigns
- Journey orchestration:
  - Multi-step campaign flows
  - Wait steps and delays
  - Conditional branching
  - Exit conditions
- Integration with Communications domain for delivery
- Campaign scheduling and throttling
- Personalization tokens and dynamic content
- Suppression list management

#### 2.2.5 Attribution Tracking and UTM Parameter Management
- UTM parameter capture and storage:
  - utm_source
  - utm_medium
  - utm_campaign
  - utm_term
  - utm_content
- First-touch and last-touch attribution models
- Multi-touch attribution support
- Conversion tracking across:
  - User registration
  - Lead creation
  - Plan purchase
  - Service booking
- Attribution window configuration
- Cross-device attribution (where possible)
- Integration with Analytics domain for reporting

#### 2.2.6 A/B Testing Infrastructure
- Experiment definition:
  - Hypothesis documentation
  - Variant configuration
  - Traffic allocation rules
  - Success metrics
- User bucketing:
  - Consistent user assignment
  - Segment-based targeting
  - Mutual exclusivity groups
- Experiment types:
  - Feature experiments
  - UI/UX experiments
  - Pricing experiments
  - Messaging experiments
- Statistical analysis:
  - Sample size calculation
  - Significance testing
  - Confidence intervals
- Experiment lifecycle (draft, running, paused, concluded)
- Winner selection and rollout

---

## 3. Key Entities

### 3.1 Entity Overview

```
Campaign
    |-- CampaignVersion
    |-- CampaignAudience
    |-- CampaignSchedule
    |-- CampaignMetrics

Referral
    |-- ReferralCode
    |-- ReferralReward
    |-- FraudSignal

Promotion
    |-- PromotionRule
    |-- PromotionUsage
    |-- PromotionSegment

Coupon
    |-- CouponCode
    |-- CouponRedemption
    |-- CouponEligibility

Attribution
    |-- UTMParams
    |-- TouchPoint
    |-- ConversionEvent

Experiment
    |-- ExperimentVariant
    |-- ExperimentBucket
    |-- ExperimentResult
```

### 3.2 Entity Definitions

#### 3.2.1 Campaign
Represents a marketing campaign that can be executed across multiple channels.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Campaign name |
| description | Text | Campaign description |
| type | Enum | lifecycle, promotional, transactional, engagement |
| status | Enum | draft, scheduled, active, paused, completed, archived |
| channels | Array | List of channels (push, sms, whatsapp, email) |
| audience_rules | JSON | Segmentation criteria |
| start_date | DateTime | Campaign start date/time |
| end_date | DateTime | Campaign end date/time |
| created_by | UUID | Reference to admin user |
| created_at | DateTime | Creation timestamp |
| updated_at | DateTime | Last update timestamp |

#### 3.2.2 Referral
Tracks referral relationships between users.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| referrer_user_id | UUID | User who made the referral |
| referee_user_id | UUID | User who was referred |
| referral_code | String | Code used for referral |
| status | Enum | pending, verified, credited, expired, fraudulent |
| referrer_credit | Decimal | Credit amount for referrer |
| referee_credit | Decimal | Credit amount for referee |
| fraud_score | Decimal | Fraud probability score (0-1) |
| fraud_signals | JSON | Detected fraud indicators |
| verified_at | DateTime | When referral was verified |
| credited_at | DateTime | When credits were issued |
| created_at | DateTime | Creation timestamp |

#### 3.2.3 Promotion
Defines a promotional offer or discount.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Promotion name |
| description | Text | Promotion description |
| type | Enum | percentage, fixed_amount, free_trial, feature_unlock |
| value | Decimal | Discount value |
| max_discount | Decimal | Maximum discount cap |
| min_order_value | Decimal | Minimum order requirement |
| applicable_plans | Array | Plans this applies to |
| applicable_services | Array | Services this applies to |
| stackable | Boolean | Can combine with other promotions |
| status | Enum | draft, active, paused, expired |
| valid_from | DateTime | Start validity |
| valid_to | DateTime | End validity |
| total_budget | Decimal | Total budget for promotion |
| used_budget | Decimal | Budget consumed |
| created_at | DateTime | Creation timestamp |

#### 3.2.4 Coupon
Represents a redeemable coupon code.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| promotion_id | UUID | Reference to parent promotion |
| code | String | Unique coupon code |
| type | Enum | single_use, multi_use, user_specific |
| max_redemptions | Integer | Total allowed redemptions |
| redemption_count | Integer | Current redemption count |
| max_per_user | Integer | Max uses per user |
| status | Enum | active, exhausted, expired, revoked |
| valid_from | DateTime | Start validity |
| valid_to | DateTime | End validity |
| created_at | DateTime | Creation timestamp |

#### 3.2.5 Attribution
Captures marketing attribution data for conversions.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| user_id | UUID | User being tracked |
| session_id | String | Session identifier |
| utm_source | String | Traffic source |
| utm_medium | String | Marketing medium |
| utm_campaign | String | Campaign name |
| utm_term | String | Search terms |
| utm_content | String | Content variant |
| referrer_url | String | HTTP referrer |
| landing_page | String | Entry page URL |
| device_type | String | Device category |
| touch_type | Enum | first_touch, last_touch, assist |
| conversion_event | String | Event that triggered attribution |
| conversion_value | Decimal | Value of conversion |
| captured_at | DateTime | When attribution was captured |

#### 3.2.6 Experiment
Defines an A/B test or experiment.

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Experiment name |
| hypothesis | Text | What we're testing |
| description | Text | Detailed description |
| type | Enum | feature, ui, pricing, messaging |
| status | Enum | draft, running, paused, concluded |
| variants | JSON | Variant definitions with traffic allocation |
| success_metrics | Array | Metrics to measure |
| primary_metric | String | Main success metric |
| target_sample_size | Integer | Required sample size |
| current_sample_size | Integer | Current participants |
| confidence_level | Decimal | Required confidence (e.g., 0.95) |
| audience_rules | JSON | Targeting criteria |
| exclusion_groups | Array | Mutually exclusive experiments |
| start_date | DateTime | Experiment start |
| end_date | DateTime | Planned end date |
| concluded_at | DateTime | Actual conclusion date |
| winner_variant | String | Winning variant (if concluded) |
| created_by | UUID | Creator user ID |
| created_at | DateTime | Creation timestamp |

---

## 4. Domain Interactions

### 4.1 Dependencies

| Domain | Interaction Type | Description |
|--------|------------------|-------------|
| **Entitlements** | Outbound | Credit wallet integration for referral rewards |
| **Communications** | Outbound | Campaign message delivery across channels |
| **UserManagement** | Inbound | User profiles and segments for targeting |
| **Billing** | Outbound | Coupon validation during checkout |
| **Analytics** | Outbound | Campaign performance data export |
| **Authorization** | Inbound | Permission checks for campaign management |

### 4.2 Events Published

| Event | Description | Consumers |
|-------|-------------|-----------|
| `referral.created` | New referral link used | Entitlements, Analytics |
| `referral.verified` | Referral validated | Entitlements, Notifications |
| `referral.credited` | Credits issued | Entitlements, Analytics |
| `referral.fraud_detected` | Fraud identified | TrustSafety, Analytics |
| `coupon.redeemed` | Coupon code used | Billing, Analytics |
| `coupon.exhausted` | Coupon limit reached | Ops, Analytics |
| `campaign.started` | Campaign began execution | Analytics |
| `campaign.completed` | Campaign finished | Analytics |
| `campaign.message_sent` | Individual message sent | Communications, Analytics |
| `experiment.started` | Experiment began | Analytics |
| `experiment.concluded` | Experiment finished | Analytics, Ops |
| `experiment.user_bucketed` | User assigned to variant | Analytics |
| `attribution.captured` | Attribution data recorded | Analytics |
| `conversion.attributed` | Conversion linked to source | Analytics, Sales |

### 4.3 Events Consumed

| Event | Source | Action |
|-------|--------|--------|
| `user.registered` | UserManagement | Trigger welcome campaign, capture attribution |
| `user.profile_updated` | UserManagement | Update audience segments |
| `lead.created` | Leads | Track conversion for attribution |
| `payment.completed` | Billing | Track conversion, issue referral credits |
| `entitlement.activated` | Entitlements | Trigger onboarding campaigns |

---

## 5. User Stories

### 5.1 Referral Program

#### US-MKT-001: Generate Referral Code
**As a** registered user
**I want to** get my unique referral code/link
**So that** I can invite friends and earn credits

**Acceptance Criteria:**
- User can access referral section from profile/menu
- Unique referral code is generated on first access
- Shareable link includes referral code
- Social sharing options available (WhatsApp, SMS, copy link)
- Display current referral stats (invites sent, pending, credited)

#### US-MKT-002: Track Referral Status
**As a** user who referred friends
**I want to** see the status of my referrals
**So that** I know when I'll receive credits

**Acceptance Criteria:**
- List of all referrals with status
- Status values: pending signup, pending verification, credited
- Credit amount shown for each successful referral
- Total earned credits displayed

#### US-MKT-003: Redeem Referral Credits
**As a** user with referral credits
**I want to** use credits during checkout
**So that** I can get discounts on plans/services

**Acceptance Criteria:**
- Credit balance visible during checkout
- Option to apply credits to purchase
- Credits deducted from wallet after payment
- Partial credit usage supported

### 5.2 Promotions & Coupons

#### US-MKT-004: Apply Coupon Code
**As a** user making a purchase
**I want to** apply a coupon code
**So that** I can get a discount

**Acceptance Criteria:**
- Coupon input field on checkout page
- Real-time validation with error messages
- Discount amount shown after successful application
- Clear indication of what discount was applied
- Option to remove applied coupon

#### US-MKT-005: View Available Promotions
**As a** user
**I want to** see current promotions
**So that** I can take advantage of offers

**Acceptance Criteria:**
- Promotions banner/section on homepage
- Promotion details page with terms
- Applicable plans/services clearly marked
- Validity period displayed
- One-click copy of coupon code

### 5.3 Campaign Management

#### US-MKT-006: Create Marketing Campaign
**As a** marketing admin
**I want to** create a multi-channel campaign
**So that** I can reach users across touchpoints

**Acceptance Criteria:**
- Campaign builder with audience selection
- Channel selection (push/SMS/WhatsApp/email)
- Message template editor with personalization
- Schedule configuration (one-time, recurring)
- Preview before launch
- Approval workflow if required

#### US-MKT-007: Monitor Campaign Performance
**As a** marketing admin
**I want to** see campaign metrics in real-time
**So that** I can optimize ongoing campaigns

**Acceptance Criteria:**
- Dashboard with key metrics (sent, delivered, opened, clicked)
- Channel-wise breakdown
- Conversion tracking
- Audience reach percentage
- A/B variant performance comparison

### 5.4 A/B Testing

#### US-MKT-008: Create Experiment
**As a** product manager
**I want to** set up an A/B test
**So that** I can validate product changes

**Acceptance Criteria:**
- Experiment creation wizard
- Variant definition with traffic allocation
- Success metric selection
- Sample size calculator
- Audience targeting options
- Preview of experiment setup

#### US-MKT-009: Analyze Experiment Results
**As a** product manager
**I want to** see experiment results
**So that** I can make data-driven decisions

**Acceptance Criteria:**
- Results dashboard with statistical significance
- Confidence interval display
- Metric comparison across variants
- Sample size achieved vs. required
- Recommendation for winner selection

### 5.5 Attribution

#### US-MKT-010: Track Marketing Attribution
**As a** marketing analyst
**I want to** see conversion attribution
**So that** I can optimize marketing spend

**Acceptance Criteria:**
- Attribution report by source/medium/campaign
- First-touch vs. last-touch comparison
- Conversion funnel by attribution
- Revenue attribution
- Export capability

---

## 6. Non-Functional Requirements

### 6.1 Performance

| Requirement | Target |
|-------------|--------|
| Coupon validation API response time | < 200ms |
| Experiment bucketing latency | < 50ms |
| Campaign message throughput | 10,000 messages/minute |
| Attribution capture latency | < 100ms |
| Landing page load time | < 2 seconds |

### 6.2 Scalability

| Requirement | Target |
|-------------|--------|
| Concurrent campaigns | 100+ active campaigns |
| Referral codes | 10M+ unique codes |
| Daily attribution events | 1M+ events |
| Experiment participants | 100K+ per experiment |
| Coupon redemptions | 50K+ per day |

### 6.3 Availability

| Component | Target SLA |
|-----------|------------|
| Coupon validation API | 99.9% |
| Experiment bucketing | 99.9% |
| Attribution tracking | 99.5% |
| Campaign execution | 99.5% |

### 6.4 Security

- Coupon codes must be cryptographically random
- Referral fraud detection required before credit issuance
- PII data in campaigns must be encrypted
- Attribution data must comply with privacy regulations
- Admin actions must be audit logged

### 6.5 Compliance

- GDPR compliance for user targeting and communication
- Opt-out mechanism for marketing communications
- Data retention policies for attribution data (configurable)
- Consent tracking for marketing campaigns

---

## 7. API Specifications

### 7.1 Referral APIs

```
POST   /api/v1/referral/code           - Generate referral code
GET    /api/v1/referral/code           - Get user's referral code
GET    /api/v1/referral/stats          - Get referral statistics
POST   /api/v1/referral/validate       - Validate referral code
GET    /api/v1/referral/history        - Get referral history
```

### 7.2 Coupon APIs

```
POST   /api/v1/coupons/validate        - Validate coupon code
POST   /api/v1/coupons/apply           - Apply coupon to cart
DELETE /api/v1/coupons/apply           - Remove applied coupon
GET    /api/v1/promotions/active       - Get active promotions
GET    /api/v1/promotions/{id}         - Get promotion details
```

### 7.3 Campaign APIs (Admin)

```
GET    /api/v1/admin/campaigns                - List campaigns
POST   /api/v1/admin/campaigns                - Create campaign
GET    /api/v1/admin/campaigns/{id}           - Get campaign details
PUT    /api/v1/admin/campaigns/{id}           - Update campaign
POST   /api/v1/admin/campaigns/{id}/schedule  - Schedule campaign
POST   /api/v1/admin/campaigns/{id}/pause     - Pause campaign
POST   /api/v1/admin/campaigns/{id}/resume    - Resume campaign
GET    /api/v1/admin/campaigns/{id}/metrics   - Get campaign metrics
```

### 7.4 Experiment APIs

```
GET    /api/v1/experiments/{key}/variant      - Get user's variant (client)
POST   /api/v1/experiments/{key}/convert      - Track conversion (client)
GET    /api/v1/admin/experiments              - List experiments
POST   /api/v1/admin/experiments              - Create experiment
PUT    /api/v1/admin/experiments/{id}         - Update experiment
GET    /api/v1/admin/experiments/{id}/results - Get experiment results
POST   /api/v1/admin/experiments/{id}/conclude - Conclude experiment
```

### 7.5 Attribution APIs

```
POST   /api/v1/attribution/capture     - Capture attribution (client)
GET    /api/v1/admin/attribution/report - Get attribution report
```

---

## 8. Data Model

### 8.1 Database Schema Overview

```sql
-- Core Tables
campaigns
campaigns_versions
campaign_audiences
campaign_schedules
campaign_metrics

referrals
referral_codes
referral_rewards
referral_fraud_signals

promotions
promotion_rules
promotion_segments
promotion_usage

coupons
coupon_redemptions
coupon_eligibility_rules

attributions
attribution_touchpoints
conversion_events

experiments
experiment_variants
experiment_buckets
experiment_results
experiment_metrics
```

### 8.2 Key Indexes

- `referrals`: user_id, referral_code, status
- `coupons`: code (unique), promotion_id, status
- `campaigns`: status, start_date, end_date
- `attributions`: user_id, session_id, captured_at
- `experiments`: status, key (unique)
- `experiment_buckets`: experiment_id, user_id (composite unique)

---

## 9. Implementation Phases

### Phase 1: Foundation (MVP)
- Basic coupon/promotion system
- Simple referral program (without fraud detection)
- UTM parameter capture
- Basic attribution tracking

### Phase 2: Growth
- Advanced referral fraud detection
- Multi-tier referral rewards
- Campaign builder (single channel)
- Basic A/B testing

### Phase 3: Optimization
- Multi-channel campaign orchestration
- Journey builder
- Advanced experimentation
- Attribution modeling (multi-touch)

### Phase 4: Advanced
- AI-powered audience segmentation
- Predictive campaign optimization
- Real-time personalization
- Cross-device attribution

---

## 10. Success Metrics

### 10.1 Referral Program
| Metric | Description | Target |
|--------|-------------|--------|
| Referral rate | % of users who refer | > 10% |
| Referral conversion | % of referred users who sign up | > 30% |
| K-factor | Viral coefficient | > 0.5 |
| Fraud rate | % of fraudulent referrals | < 2% |

### 10.2 Promotions
| Metric | Description | Target |
|--------|-------------|--------|
| Coupon redemption rate | % of coupons redeemed | > 15% |
| Incremental revenue | Revenue from promo users | Track |
| Discount efficiency | Revenue per discount dollar | > 3x |

### 10.3 Campaigns
| Metric | Description | Target |
|--------|-------------|--------|
| Open rate | Email/push open rate | > 20% |
| Click rate | Click-through rate | > 5% |
| Conversion rate | Campaign-driven conversions | Track |
| Unsubscribe rate | Opt-out rate | < 0.5% |

### 10.4 Experimentation
| Metric | Description | Target |
|--------|-------------|--------|
| Experiment velocity | Experiments run per month | > 10 |
| Win rate | % of experiments with winners | > 30% |
| Coverage | % of decisions backed by experiments | > 50% |

---

## 11. Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Referral fraud abuse | High | Medium | Implement fraud detection, velocity limits, verification |
| Coupon code leakage | Medium | Medium | Use unique codes, rate limiting, user verification |
| Campaign spam complaints | High | Low | Frequency caps, unsubscribe, preference management |
| Experiment interference | Medium | Medium | Mutual exclusivity groups, careful bucketing |
| Attribution inaccuracy | Medium | High | Multiple models, cross-validation, clear limitations |

---

## 12. Glossary

| Term | Definition |
|------|------------|
| **Attribution** | Identifying which marketing touchpoint led to a conversion |
| **Bucketing** | Assigning users to experiment variants |
| **CAC** | Customer Acquisition Cost |
| **Conversion** | Desired user action (signup, purchase, etc.) |
| **First-touch** | Attribution to first marketing interaction |
| **K-factor** | Viral growth coefficient |
| **Last-touch** | Attribution to last marketing interaction before conversion |
| **LTV** | Lifetime Value of a customer |
| **Statistical significance** | Confidence that experiment results are not random |
| **UTM** | Urchin Tracking Module - URL parameters for tracking |
| **Variant** | A version in an A/B test |

---

## 13. References

- [MySqrft Domain Definitions](/docs/domains.md)
- Entitlements Domain PRD (for credit wallet integration)
- Communications Domain PRD (for message delivery)
- Analytics Domain PRD (for reporting integration)

---

## 14. Appendix

### A. Referral Fraud Detection Rules

1. **Device Fingerprint Match**: Flag if referee device matches referrer
2. **IP Clustering**: Flag if multiple referrals from same IP range
3. **Email Domain Clustering**: Flag if multiple referrals with similar email patterns
4. **Velocity Check**: Flag if referrer gets too many referrals in short time
5. **Account Age**: Flag if referee account shows minimal engagement
6. **Behavioral Patterns**: Flag if referee behavior matches referrer exactly

### B. Campaign Channel Specifications

| Channel | Character Limit | Media Support | Personalization |
|---------|-----------------|---------------|-----------------|
| Push | 50 title / 150 body | Image | Yes |
| SMS | 160 (or 320 concatenated) | No | Yes |
| WhatsApp | 1024 | Image, PDF | Yes |
| Email | Unlimited | Full HTML | Yes |

### C. UTM Parameter Standards

| Parameter | Format | Example |
|-----------|--------|---------|
| utm_source | lowercase, underscore | google, facebook_ads |
| utm_medium | lowercase | cpc, email, social |
| utm_campaign | lowercase, underscore | jan_2026_sale |
| utm_term | lowercase | bangalore_rent |
| utm_content | lowercase | banner_v1, cta_blue |
