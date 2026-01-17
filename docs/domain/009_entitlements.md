# Entitlements Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | Entitlements |
| Version | 1.0 |
| Status | Complete |
| Last Updated | 2026-01-17 |
| Owner | Product Team |
| Platform | MySqrft |

---

## 1. Executive Summary

### 1.1 Overview

The Entitlements domain is the plan-based access control system for MySqrft, responsible for managing subscription plans, feature access, quota enforcement, and credit wallet functionality. It serves as the gatekeeper that determines what features and resources users can access based on their subscription tier, add-ons, and accumulated credits.

### 1.2 Primary Goal

**Plan-Based Access Control** - Enable monetization through tiered subscription plans while ensuring fair usage limits and premium feature gating.

### 1.3 Business Value

- **Revenue Generation**: Drive subscription conversions through tiered feature access
- **Fair Usage**: Enforce quotas to prevent abuse and ensure resource availability
- **Upsell Opportunities**: Create natural upgrade paths through feature gating
- **User Retention**: Reward loyal users through credit systems and referral programs
- **Operational Control**: Enable rapid feature rollouts and experiments through feature flags

---

## 2. Domain Responsibilities

### 2.1 Plan Catalog and Add-on Management

- Define and manage subscription plans (Free, Basic, Premium, etc.)
- Configure plan attributes (pricing, duration, features included)
- Manage add-on products that extend base plan capabilities
- Handle plan versioning and migration between plan versions
- Support geographic pricing variations (city-based pricing)
- Manage plan bundles and combo offers

### 2.2 Quota Enforcement

The domain enforces usage limits across multiple dimensions:

#### 2.2.1 Contact Unlock Counts
- Track number of property owner contacts revealed per billing period
- Enforce daily/weekly/monthly unlock limits by plan tier
- Support carryover rules for unused unlocks (if applicable)

#### 2.2.2 Lead Priority Levels
- Assign lead priority based on user's plan tier
- Premium users get priority in lead queue
- Determine response time SLAs based on priority

#### 2.2.3 RM Assistance Eligibility
- Determine if user qualifies for Relationship Manager support
- Track RM session allocations and usage
- Manage RM service tiers (chat, call, dedicated)

### 2.3 Expiry and Renewal Rules

- Track subscription start and end dates
- Handle auto-renewal logic and payment integration
- Manage grace periods for expired subscriptions
- Process subscription cancellations and refunds
- Handle plan downgrades and feature access transitions
- Send renewal reminders and expiry notifications

### 2.4 Credit Wallet Management

- Maintain referral credit balances
- Track credit transactions (earn, spend, expire)
- Apply credits during checkout
- Manage credit expiry rules
- Support promotional credit grants
- Handle credit reversals and adjustments

### 2.5 Feature Flags by Plan (Paywall Gating)

- Define feature availability per plan tier
- Support gradual feature rollouts
- Enable A/B testing of feature access
- Handle feature deprecation and migration
- Support override rules for specific users/segments

---

## 3. Key Entities

### 3.1 Plan

The subscription plan definition containing pricing, duration, and included features.

```
Plan {
  id: UUID
  code: String (unique identifier, e.g., "TENANT_PREMIUM_MONTHLY")
  name: String
  description: String
  type: Enum (TENANT, OWNER, VENDOR)
  tier: Enum (FREE, BASIC, PREMIUM, ENTERPRISE)
  pricing: {
    basePrice: Decimal
    currency: String
    taxRate: Decimal
    discountedPrice: Decimal (optional)
  }
  duration: {
    value: Integer
    unit: Enum (DAY, WEEK, MONTH, YEAR)
  }
  quotas: QuotaDefinition[]
  features: FeatureFlag[]
  isActive: Boolean
  validFrom: DateTime
  validUntil: DateTime (optional)
  metadata: JSON
  createdAt: DateTime
  updatedAt: DateTime
}
```

### 3.2 Addon

Optional add-on products that can be purchased with or added to a base plan.

```
Addon {
  id: UUID
  code: String
  name: String
  description: String
  type: Enum (QUOTA_BOOST, FEATURE_UNLOCK, SERVICE_PACK)
  pricing: {
    basePrice: Decimal
    currency: String
    taxRate: Decimal
  }
  duration: {
    value: Integer
    unit: Enum (DAY, WEEK, MONTH, YEAR, UNLIMITED)
  }
  quotaGrants: QuotaGrant[] (optional)
  featureGrants: FeatureGrant[] (optional)
  compatiblePlans: PlanCode[] (plans this addon can be added to)
  isActive: Boolean
  createdAt: DateTime
  updatedAt: DateTime
}
```

### 3.3 Quota

Defines usage limits and tracks consumption.

```
Quota {
  id: UUID
  userId: UUID
  entitlementId: UUID
  quotaType: Enum (CONTACT_UNLOCKS, LEAD_PRIORITY, RM_SESSIONS, LISTING_BOOSTS, etc.)
  limit: Integer
  used: Integer
  resetPeriod: Enum (DAILY, WEEKLY, MONTHLY, BILLING_CYCLE, NEVER)
  lastResetAt: DateTime
  nextResetAt: DateTime
  carryoverEnabled: Boolean
  carryoverLimit: Integer (max carryover amount)
  createdAt: DateTime
  updatedAt: DateTime
}
```

### 3.4 Entitlement

The user's active subscription/access rights.

```
Entitlement {
  id: UUID
  userId: UUID
  planId: UUID
  addons: AddonEntitlement[]
  status: Enum (ACTIVE, EXPIRED, CANCELLED, SUSPENDED, PENDING)
  startDate: DateTime
  endDate: DateTime
  autoRenew: Boolean
  renewalPaymentMethodId: UUID (optional)
  cancelledAt: DateTime (optional)
  cancellationReason: String (optional)
  graceEndDate: DateTime (optional)
  source: Enum (PURCHASE, TRIAL, PROMOTIONAL, REFERRAL, UPGRADE, DOWNGRADE)
  previousEntitlementId: UUID (optional, for upgrades/downgrades)
  orderId: UUID (reference to Billing domain)
  metadata: JSON
  createdAt: DateTime
  updatedAt: DateTime
}
```

### 3.5 CreditWallet

User's credit balance for promotional and referral credits.

```
CreditWallet {
  id: UUID
  userId: UUID
  balance: Decimal
  currency: String
  lifetimeEarned: Decimal
  lifetimeSpent: Decimal
  lifetimeExpired: Decimal
  lastTransactionAt: DateTime
  createdAt: DateTime
  updatedAt: DateTime
}

CreditTransaction {
  id: UUID
  walletId: UUID
  type: Enum (EARN, SPEND, EXPIRE, ADJUST, REVERSAL)
  amount: Decimal
  balanceAfter: Decimal
  source: Enum (REFERRAL, PROMOTION, REFUND, PURCHASE, ADMIN_GRANT, EXPIRY)
  referenceType: String (e.g., "referral", "order", "promotion")
  referenceId: UUID
  description: String
  expiresAt: DateTime (optional)
  createdAt: DateTime
}
```

### 3.6 FeatureFlag

Feature availability configuration by plan.

```
FeatureFlag {
  id: UUID
  code: String (unique identifier, e.g., "ADVANCED_SEARCH_FILTERS")
  name: String
  description: String
  category: Enum (SEARCH, LEADS, COMMUNICATION, ANALYTICS, SUPPORT, etc.)
  defaultEnabled: Boolean
  planOverrides: {
    planCode: String
    enabled: Boolean
    config: JSON (optional feature-specific configuration)
  }[]
  userOverrides: {
    userId: UUID
    enabled: Boolean
    expiresAt: DateTime (optional)
  }[]
  rolloutPercentage: Integer (0-100, for gradual rollouts)
  isActive: Boolean
  createdAt: DateTime
  updatedAt: DateTime
}
```

---

## 4. User Stories

### 4.1 Tenant/Buyer User Stories

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| ENT-T01 | As a tenant, I want to view available plans so that I can choose the best option for my property search | - Display all active plans with features and pricing<br>- Show comparison matrix<br>- Highlight recommended plan |
| ENT-T02 | As a tenant, I want to unlock owner contacts so that I can directly communicate about properties | - Check quota before allowing unlock<br>- Decrement quota on successful unlock<br>- Show remaining unlocks<br>- Prompt upgrade when quota exhausted |
| ENT-T03 | As a tenant, I want to use my referral credits during checkout so that I can save money | - Show available credit balance<br>- Allow partial or full credit application<br>- Update wallet after transaction |
| ENT-T04 | As a tenant, I want to upgrade my plan so that I can access more features | - Prorate billing for mid-cycle upgrades<br>- Immediately grant new entitlements<br>- Migrate quotas appropriately |
| ENT-T05 | As a tenant, I want to know when my plan expires so that I can renew on time | - Send reminders at 7, 3, 1 days before expiry<br>- Show expiry date prominently in UI<br>- Offer easy renewal flow |

### 4.2 Property Owner User Stories

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| ENT-O01 | As an owner, I want to purchase a listing boost add-on so that my property gets more visibility | - Show compatible add-ons<br>- Process add-on purchase<br>- Apply boost immediately |
| ENT-O02 | As an owner, I want to manage my auto-renewal settings so that I control my subscription | - Toggle auto-renewal on/off<br>- Update payment method<br>- Confirm changes |
| ENT-O03 | As an owner, I want my premium listing priority so that I get more qualified leads | - Assign lead priority based on plan<br>- Show priority badge on listing<br>- Track lead quality metrics |

### 4.3 System/Admin User Stories

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| ENT-A01 | As an admin, I want to create new plans so that we can offer new pricing tiers | - Define all plan attributes<br>- Set activation date<br>- Preview before publishing |
| ENT-A02 | As an admin, I want to grant promotional credits to users so that we can run marketing campaigns | - Bulk credit grant capability<br>- Set expiry dates<br>- Track grant reason |
| ENT-A03 | As an admin, I want to configure feature flags so that we can control feature rollouts | - Toggle features by plan<br>- Set rollout percentages<br>- Override for specific users |
| ENT-A04 | As an admin, I want to view entitlement analytics so that we can understand plan performance | - Subscription metrics dashboard<br>- Churn analysis<br>- Revenue by plan |

---

## 5. Functional Requirements

### 5.1 Plan Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-PM01 | System shall support creating, updating, and deactivating plans | P0 |
| FR-PM02 | System shall support plan versioning with migration paths | P1 |
| FR-PM03 | System shall validate plan configurations before activation | P0 |
| FR-PM04 | System shall support scheduled plan activation/deactivation | P1 |
| FR-PM05 | System shall support geographic pricing variations | P2 |
| FR-PM06 | System shall maintain plan change history for auditing | P1 |

### 5.2 Entitlement Processing

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-EP01 | System shall create entitlement upon successful payment confirmation | P0 |
| FR-EP02 | System shall support immediate activation of purchased plans | P0 |
| FR-EP03 | System shall handle plan upgrades with prorated billing | P1 |
| FR-EP04 | System shall handle plan downgrades at end of billing cycle | P1 |
| FR-EP05 | System shall process subscription cancellations with confirmation | P0 |
| FR-EP06 | System shall support trial periods with automatic conversion | P1 |
| FR-EP07 | System shall enforce only one active plan per user per plan type | P0 |

### 5.3 Quota Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-QM01 | System shall initialize quotas when entitlement is created | P0 |
| FR-QM02 | System shall check quota availability before allowing usage | P0 |
| FR-QM03 | System shall decrement quota atomically on usage | P0 |
| FR-QM04 | System shall reset quotas based on configured reset period | P0 |
| FR-QM05 | System shall support quota carryover between periods | P2 |
| FR-QM06 | System shall aggregate quotas from base plan and add-ons | P1 |
| FR-QM07 | System shall provide real-time quota balance information | P0 |

### 5.4 Credit Wallet

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-CW01 | System shall create wallet for each user upon registration | P0 |
| FR-CW02 | System shall credit referral rewards upon qualifying action | P1 |
| FR-CW03 | System shall deduct credits during checkout when applied | P0 |
| FR-CW04 | System shall expire credits based on configured expiry rules | P1 |
| FR-CW05 | System shall maintain complete transaction history | P0 |
| FR-CW06 | System shall support admin credit grants and adjustments | P1 |
| FR-CW07 | System shall prevent negative wallet balance | P0 |

### 5.5 Feature Flags

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-FF01 | System shall evaluate feature access based on user's entitlement | P0 |
| FR-FF02 | System shall support feature overrides at user level | P1 |
| FR-FF03 | System shall support gradual feature rollouts by percentage | P2 |
| FR-FF04 | System shall cache feature flag evaluations for performance | P1 |
| FR-FF05 | System shall log feature access for analytics | P2 |

### 5.6 Expiry and Renewal

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-ER01 | System shall send renewal reminders before expiry | P1 |
| FR-ER02 | System shall process auto-renewal payments before expiry | P0 |
| FR-ER03 | System shall provide grace period for failed renewals | P1 |
| FR-ER04 | System shall downgrade to free tier upon final expiry | P0 |
| FR-ER05 | System shall support manual renewal for cancelled subscriptions | P1 |

---

## 6. Non-Functional Requirements

### 6.1 Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-P01 | Entitlement check response time | < 50ms (p99) |
| NFR-P02 | Feature flag evaluation response time | < 10ms (p99) |
| NFR-P03 | Quota check and decrement response time | < 100ms (p99) |
| NFR-P04 | Credit wallet transaction processing | < 200ms (p99) |
| NFR-P05 | System shall handle concurrent quota operations | 10,000 ops/sec |

### 6.2 Availability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-A01 | Entitlement service availability | 99.99% uptime |
| NFR-A02 | Feature flag service availability | 99.99% uptime |
| NFR-A03 | Graceful degradation on dependency failures | Default to deny |

### 6.3 Consistency

| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-C01 | Quota operations must be strongly consistent | Prevent over-usage |
| NFR-C02 | Credit wallet transactions must be atomic | Prevent double-spend |
| NFR-C03 | Entitlement status must be eventually consistent | Within 1 second |

### 6.4 Security

| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-S01 | All entitlement data must be encrypted at rest | AES-256 |
| NFR-S02 | Entitlement APIs require authentication | JWT validation |
| NFR-S03 | Admin operations require elevated permissions | RBAC enforcement |
| NFR-S04 | Audit log all entitlement modifications | Immutable audit trail |

### 6.5 Scalability

| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-SC01 | Support horizontal scaling of services | Kubernetes-native |
| NFR-SC02 | Support 10M+ active entitlements | Database partitioning |
| NFR-SC03 | Cache entitlement data for high-frequency access | Redis cluster |

---

## 7. API Specifications

### 7.1 Entitlement APIs

#### Check User Entitlement
```
GET /api/v1/entitlements/users/{userId}

Response:
{
  "entitlement": {
    "id": "uuid",
    "planCode": "TENANT_PREMIUM_MONTHLY",
    "planName": "Premium",
    "tier": "PREMIUM",
    "status": "ACTIVE",
    "startDate": "2026-01-01T00:00:00Z",
    "endDate": "2026-02-01T00:00:00Z",
    "autoRenew": true,
    "addons": [
      {
        "code": "EXTRA_UNLOCKS_10",
        "name": "10 Extra Unlocks",
        "expiresAt": "2026-02-01T00:00:00Z"
      }
    ]
  },
  "quotas": {
    "contactUnlocks": { "limit": 30, "used": 12, "remaining": 18 },
    "rmSessions": { "limit": 5, "used": 2, "remaining": 3 }
  }
}
```

#### Check Feature Access
```
GET /api/v1/entitlements/features/{featureCode}/access?userId={userId}

Response:
{
  "featureCode": "ADVANCED_SEARCH_FILTERS",
  "hasAccess": true,
  "source": "PLAN",
  "planCode": "TENANT_PREMIUM_MONTHLY",
  "config": {
    "maxFilters": 10
  }
}
```

### 7.2 Quota APIs

#### Check Quota Availability
```
GET /api/v1/quotas/{quotaType}/availability?userId={userId}

Response:
{
  "quotaType": "CONTACT_UNLOCKS",
  "limit": 30,
  "used": 12,
  "remaining": 18,
  "resetsAt": "2026-02-01T00:00:00Z",
  "canUse": true
}
```

#### Consume Quota
```
POST /api/v1/quotas/{quotaType}/consume

Request:
{
  "userId": "uuid",
  "amount": 1,
  "referenceType": "contact_unlock",
  "referenceId": "listing-uuid"
}

Response:
{
  "success": true,
  "quotaType": "CONTACT_UNLOCKS",
  "consumed": 1,
  "remaining": 17,
  "transactionId": "uuid"
}
```

### 7.3 Credit Wallet APIs

#### Get Wallet Balance
```
GET /api/v1/wallets/users/{userId}

Response:
{
  "walletId": "uuid",
  "balance": 250.00,
  "currency": "INR",
  "expiringCredits": [
    { "amount": 100.00, "expiresAt": "2026-02-15T00:00:00Z" }
  ]
}
```

#### Apply Credits
```
POST /api/v1/wallets/users/{userId}/apply

Request:
{
  "amount": 100.00,
  "orderId": "order-uuid",
  "description": "Applied to Premium plan purchase"
}

Response:
{
  "success": true,
  "amountApplied": 100.00,
  "remainingBalance": 150.00,
  "transactionId": "uuid"
}
```

### 7.4 Plan APIs

#### List Available Plans
```
GET /api/v1/plans?type={TENANT|OWNER}&active=true

Response:
{
  "plans": [
    {
      "code": "TENANT_FREE",
      "name": "Free",
      "tier": "FREE",
      "pricing": { "basePrice": 0, "currency": "INR" },
      "features": ["basic_search", "5_unlocks_monthly"],
      "quotas": { "contactUnlocks": 5 }
    },
    {
      "code": "TENANT_PREMIUM_MONTHLY",
      "name": "Premium",
      "tier": "PREMIUM",
      "pricing": { "basePrice": 999, "currency": "INR" },
      "features": ["advanced_search", "unlimited_unlocks", "rm_support"],
      "quotas": { "contactUnlocks": -1, "rmSessions": 5 }
    }
  ]
}
```

---

## 8. Domain Events

### 8.1 Published Events

| Event | Trigger | Consumers |
|-------|---------|-----------|
| `entitlement.created` | New subscription purchased | Billing, Analytics, Communications |
| `entitlement.upgraded` | Plan upgraded | Billing, Analytics, CRM |
| `entitlement.downgraded` | Plan downgraded | Analytics, CRM |
| `entitlement.renewed` | Subscription renewed | Billing, Analytics |
| `entitlement.expired` | Subscription expired | Analytics, Communications, Leads |
| `entitlement.cancelled` | User cancelled subscription | Analytics, CRM, Support |
| `quota.exhausted` | User reached quota limit | Analytics, Communications |
| `quota.reset` | Periodic quota reset | Analytics |
| `credits.earned` | Credits added to wallet | Analytics, Communications |
| `credits.spent` | Credits used in purchase | Billing, Analytics |
| `credits.expired` | Credits expired unused | Analytics |
| `feature.access.granted` | Feature enabled for user | Analytics |
| `feature.access.revoked` | Feature disabled for user | Analytics |

### 8.2 Consumed Events

| Event | Source | Action |
|-------|--------|--------|
| `payment.completed` | Billing | Create/renew entitlement |
| `payment.failed` | Billing | Mark renewal failed, start grace period |
| `refund.processed` | Billing | Cancel entitlement, reverse credits |
| `referral.qualified` | Marketing | Grant referral credits |
| `user.created` | UserManagement | Create credit wallet |
| `user.deleted` | UserManagement | Archive entitlements and wallet |

---

## 9. Integration Points

### 9.1 Upstream Dependencies

| Domain | Integration | Purpose |
|--------|-------------|---------|
| Auth | JWT validation | Authenticate API requests |
| UserManagement | User profile | User context for entitlements |

### 9.2 Downstream Integrations

| Domain | Integration | Purpose |
|--------|-------------|---------|
| Billing | Payment events | Trigger entitlement creation/renewal |
| Authorization | Feature flags | Permission evaluation |
| Leads | Quota check | Contact unlock limits |
| Search | Feature flags | Premium search features |
| CRM | Entitlement status | RM eligibility |
| Communications | Notifications | Renewal reminders, quota alerts |
| Analytics | Events | Subscription metrics |
| Marketing | Credits | Referral program |
| Sales | Plan info | Upsell workflows |

### 9.3 External Integrations

| System | Integration Type | Purpose |
|--------|------------------|---------|
| Payment Gateway | Via Billing domain | Process subscription payments |
| Analytics Platform | Event streaming | Track entitlement metrics |

---

## 10. Data Model

### 10.1 Entity Relationship Diagram

```
+----------------+       +----------------+       +----------------+
|     Plan       |       |  Entitlement   |       |     User       |
+----------------+       +----------------+       +----------------+
| id (PK)        |<------| planId (FK)    |------>| id (PK)        |
| code           |       | userId (FK)    |       | (from UserMgmt)|
| name           |       | status         |       +----------------+
| tier           |       | startDate      |
| pricing        |       | endDate        |       +----------------+
| duration       |       | autoRenew      |       | CreditWallet   |
| quotas         |       +----------------+       +----------------+
| features       |              |                 | id (PK)        |
+----------------+              |                 | userId (FK)    |
       |                        v                 | balance        |
       |                 +----------------+       +----------------+
       v                 |     Quota      |              |
+----------------+       +----------------+              v
|     Addon      |       | id (PK)        |       +------------------+
+----------------+       | entitlementId  |       |CreditTransaction |
| id (PK)        |       | quotaType      |       +------------------+
| code           |       | limit          |       | id (PK)          |
| name           |       | used           |       | walletId (FK)    |
| pricing        |       | resetPeriod    |       | type             |
| quotaGrants    |       +----------------+       | amount           |
| featureGrants  |                                | source           |
| compatiblePlans|       +----------------+       +------------------+
+----------------+       |  FeatureFlag   |
                         +----------------+
                         | id (PK)        |
                         | code           |
                         | planOverrides  |
                         | userOverrides  |
                         | rolloutPct     |
                         +----------------+
```

### 10.2 Database Considerations

- **Primary Database**: PostgreSQL for transactional data
- **Cache Layer**: Redis for entitlement and feature flag lookups
- **Event Store**: Kafka for domain events
- **Partitioning**: Partition entitlements by userId for query performance
- **Indexing**: Composite indexes on (userId, status), (planId, status)

---

## 11. Business Rules

### 11.1 Plan Rules

| Rule ID | Rule Description |
|---------|------------------|
| BR-PL01 | A user can have only one active entitlement per plan type (TENANT/OWNER) |
| BR-PL02 | Plan upgrades take effect immediately with prorated billing |
| BR-PL03 | Plan downgrades take effect at end of current billing cycle |
| BR-PL04 | Free plan is automatically assigned if no paid plan is active |
| BR-PL05 | Trial periods are limited to one per user per plan type |

### 11.2 Quota Rules

| Rule ID | Rule Description |
|---------|------------------|
| BR-QT01 | Quota consumption is first-come-first-served (no reservations) |
| BR-QT02 | Quota resets occur at midnight IST based on reset period |
| BR-QT03 | Add-on quotas stack with base plan quotas |
| BR-QT04 | Unlimited quota is represented as limit = -1 |
| BR-QT05 | Carryover cannot exceed 50% of monthly limit |

### 11.3 Credit Rules

| Rule ID | Rule Description |
|---------|------------------|
| BR-CR01 | Credits cannot be converted to cash |
| BR-CR02 | Credits expire 12 months from earning date (unless otherwise specified) |
| BR-CR03 | FIFO: Oldest credits are consumed first |
| BR-CR04 | Credits can only be applied to subscription purchases, not add-ons |
| BR-CR05 | Maximum credit application is 50% of order value |

### 11.4 Renewal Rules

| Rule ID | Rule Description |
|---------|------------------|
| BR-RN01 | Auto-renewal is attempted 3 days before expiry |
| BR-RN02 | Failed renewal triggers 7-day grace period |
| BR-RN03 | Grace period allows limited feature access (read-only) |
| BR-RN04 | 3 renewal retry attempts with exponential backoff |
| BR-RN05 | Cancellation takes effect at end of current billing cycle |

---

## 12. Plan Catalog (Initial)

### 12.1 Tenant Plans

| Plan | Tier | Monthly Price | Contact Unlocks | RM Sessions | Key Features |
|------|------|---------------|-----------------|-------------|--------------|
| Tenant Free | FREE | 0 | 5/month | 0 | Basic search, Saved properties |
| Tenant Basic | BASIC | 499 | 15/month | 1 | Advanced filters, Priority support |
| Tenant Premium | PREMIUM | 999 | Unlimited | 5 | RM assistance, Verified listings priority |

### 12.2 Owner Plans

| Plan | Tier | Monthly Price | Listing Limit | Lead Priority | Key Features |
|------|------|---------------|---------------|---------------|--------------|
| Owner Free | FREE | 0 | 1 | Standard | Basic listing |
| Owner Basic | BASIC | 799 | 3 | High | Listing boost, Analytics |
| Owner Premium | PREMIUM | 1499 | Unlimited | Highest | Featured listings, RM support |

### 12.3 Add-ons

| Add-on | Price | Duration | Description |
|--------|-------|----------|-------------|
| Extra Unlocks (10) | 199 | 30 days | 10 additional contact unlocks |
| Listing Boost | 299 | 7 days | 5x visibility boost for one listing |
| RM Session Pack | 499 | 30 days | 3 additional RM sessions |
| Verified Badge | 199 | 30 days | Verified user badge display |

---

## 13. Metrics and Analytics

### 13.1 Key Performance Indicators

| Metric | Description | Target |
|--------|-------------|--------|
| Subscription Conversion Rate | Free to paid conversion | > 5% |
| Plan Upgrade Rate | Basic to Premium upgrades | > 15% |
| Churn Rate | Monthly subscription cancellations | < 5% |
| ARPU | Average Revenue Per User | Track by segment |
| Quota Utilization | % of quota used before reset | > 60% |
| Credit Redemption Rate | Credits used vs earned | > 40% |
| Feature Adoption | Usage of gated features | Track by feature |

### 13.2 Operational Metrics

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Entitlement Creation Latency | Time to activate subscription | > 1s |
| Quota Check Latency | Time to validate quota | > 100ms |
| Feature Flag Evaluation Time | Time to determine access | > 50ms |
| Failed Renewal Rate | Auto-renewals failing | > 10% |
| Credit Expiry Rate | Credits expiring unused | > 50% |

---

## 14. Security Considerations

### 14.1 Access Control

- All entitlement APIs require authenticated user context
- Users can only access their own entitlement data
- Admin APIs require elevated RBAC permissions
- Rate limiting on quota consumption APIs (100 req/min)

### 14.2 Data Protection

- PII in entitlement records encrypted at rest
- Credit transactions logged with immutable audit trail
- Payment method references stored securely (tokenized)
- GDPR-compliant data retention (entitlements retained for 7 years for compliance)

### 14.3 Fraud Prevention

- Detect and prevent multiple trial abuse
- Monitor unusual quota consumption patterns
- Validate credit applications against fraud signals
- Rate limit credit grants to prevent abuse

---

## 15. Migration and Rollout

### 15.1 Phase 1: Core Entitlements (Week 1-4)

- Plan and Addon entity setup
- Entitlement creation and management
- Basic quota enforcement
- Integration with Billing for payment events

### 15.2 Phase 2: Quota System (Week 5-6)

- Quota tracking and enforcement
- Reset period handling
- Add-on quota stacking
- Real-time quota APIs

### 15.3 Phase 3: Credit Wallet (Week 7-8)

- Wallet creation and management
- Credit earning (referral integration)
- Credit spending (checkout integration)
- Expiry handling

### 15.4 Phase 4: Feature Flags (Week 9-10)

- Feature flag configuration
- Plan-based feature gating
- Gradual rollout support
- Integration with Authorization domain

### 15.5 Phase 5: Advanced Features (Week 11-12)

- Plan upgrades/downgrades
- Auto-renewal handling
- Grace period logic
- Analytics integration

---

## 16. Open Questions

| ID | Question | Status | Resolution |
|----|----------|--------|------------|
| OQ-01 | Should credits be transferable between users? | Open | - |
| OQ-02 | Should we support family/shared plans? | Open | - |
| OQ-03 | How to handle refunds for partial period usage? | Open | - |
| OQ-04 | Should quota carryover be unlimited or capped? | Open | Proposed: 50% cap |
| OQ-05 | What's the grace period duration for failed renewals? | Open | Proposed: 7 days |

---

## 17. Appendix

### 17.1 Glossary

| Term | Definition |
|------|------------|
| Entitlement | User's active subscription and access rights |
| Quota | Usage limit for a specific action or resource |
| Feature Flag | Toggle controlling access to a specific feature |
| Credit Wallet | User's promotional/referral credit balance |
| Grace Period | Time after expiry during which limited access is maintained |
| Proration | Billing adjustment for mid-cycle plan changes |
| Carryover | Unused quota transferred to next period |

### 17.2 Related Documents

- MySqrft Domains Overview (`/docs/domains.md`)
- Billing Domain PRD
- Authorization Domain PRD
- Marketing Domain PRD (Referral Program)

### 17.3 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | Product Team | Initial draft |

---

*This document is maintained by the MySqrft Product Team. For questions or updates, please contact the domain owner.*
