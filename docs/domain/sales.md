# Sales Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Sales |
| **Version** | 1.0.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | 2026-01-17 |
| **Platform** | MySqrft |

---

## 1. Executive Summary

### 1.1 Purpose
The Sales domain is responsible for driving monetization conversion and enabling assisted selling workflows within the MySqrft platform. It serves as the bridge between lead generation and revenue realization, managing the complete sales lifecycle from upsell opportunities through commission payouts.

### 1.2 Primary Goal
**Monetization Conversion + Assisted Selling**

### 1.3 Business Value
- Maximize conversion of free users to paid subscribers
- Enable Relationship Managers (RMs) to efficiently assist tenants and owners
- Optimize lead allocation for balanced workload and maximum conversion
- Track and incentivize sales performance through commission structures
- Manage guarantee and refund policies to build customer trust

---

## 2. Domain Responsibilities

### 2.1 Core Responsibilities

| Responsibility | Description | Priority |
|----------------|-------------|----------|
| Plan Upsell Flows | Design and manage subscription upsell journeys for tenants and owners | P0 |
| RM-Assisted Workflows | Orchestrate the requirements-to-shortlist-to-visit pipeline | P0 |
| Guarantee/Refund Policy Handling | Manage service guarantees and process refund requests | P0 |
| Lead Allocation Rules | Define and enforce lead distribution to RMs | P0 |
| RM Workload Balancing | Optimize lead distribution based on RM capacity and performance | P1 |
| Sales Performance Dashboards | Provide visibility into sales metrics and KPIs | P1 |
| Commission Tracking | Calculate, track, and report RM commissions | P1 |

### 2.2 Detailed Responsibility Breakdown

#### 2.2.1 Plan Upsell Flows
- Tenant subscription plan upselling (Basic, Premium, Prime tiers)
- Owner subscription plan upselling (Listing boost, Premium visibility)
- Contextual upsell triggers based on user behavior
- A/B testing of upsell messaging and timing
- Conversion funnel tracking and optimization
- Plan comparison and recommendation engine

#### 2.2.2 RM-Assisted Workflows
- Requirements capture and validation from tenants/buyers
- Property shortlist generation based on requirements
- Visit scheduling coordination with Scheduling domain
- Follow-up workflow management
- Deal closure assistance and documentation
- Handoff protocols between self-service and assisted modes

#### 2.2.3 Guarantee/Refund Policy Handling
- Service guarantee definition and enforcement
- Refund eligibility determination
- Refund request processing and approval workflows
- Guarantee claim investigation
- Policy exception handling with escalation paths
- Refund status tracking and communication

#### 2.2.4 Lead Allocation Rules
- Geographic-based allocation (city, locality, zone)
- Skill-based routing (property type, deal size, customer segment)
- Round-robin distribution with weighted priorities
- Lead quality scoring for priority allocation
- Real-time allocation based on RM availability
- Re-allocation rules for unactioned leads

#### 2.2.5 RM Workload Balancing
- Capacity modeling per RM (leads per day/week)
- Queue depth monitoring and alerts
- Load balancing across teams and shifts
- Spillover handling to backup RMs
- Performance-weighted allocation adjustments
- Leave and availability management integration

#### 2.2.6 Sales Performance Dashboards
- Individual RM performance metrics
- Team and city-level performance views
- Conversion funnel analytics
- Pipeline health indicators
- Target vs. actual tracking
- Trend analysis and forecasting

#### 2.2.7 Commission Tracking
- Commission structure definition (fixed, percentage, tiered)
- Earnings calculation per transaction
- Commission approval workflows
- Payout scheduling and tracking
- Clawback handling for refunds/cancellations
- Commission dispute resolution

---

## 3. Key Entities

### 3.1 Entity Overview

```
+------------------+     +------------------+     +------------------+
|  SalesPipeline   |---->|     Upsell       |---->|   RMAllocation   |
+------------------+     +------------------+     +------------------+
        |                        |                        |
        v                        v                        v
+------------------+     +------------------+
|   SalesTarget    |     |   Commission     |
+------------------+     +------------------+
```

### 3.2 Entity Definitions

#### 3.2.1 SalesPipeline

| Attribute | Type | Description | Required |
|-----------|------|-------------|----------|
| id | UUID | Unique pipeline identifier | Yes |
| lead_id | UUID | Reference to Leads domain | Yes |
| rm_id | UUID | Assigned Relationship Manager | Yes |
| stage | Enum | Current pipeline stage | Yes |
| source | Enum | Origin of the sales opportunity | Yes |
| deal_value | Decimal | Estimated or actual deal value | No |
| probability | Integer | Win probability percentage (0-100) | No |
| expected_close_date | Date | Projected closure date | No |
| actual_close_date | Date | Actual closure date | No |
| outcome | Enum | Won, Lost, or Pending | Yes |
| loss_reason | String | Reason for lost deals | No |
| notes | Text | RM notes and observations | No |
| created_at | Timestamp | Pipeline creation time | Yes |
| updated_at | Timestamp | Last modification time | Yes |

**Pipeline Stages:**
- `NEW` - Freshly allocated lead
- `CONTACTED` - Initial contact made
- `REQUIREMENTS_CAPTURED` - Customer needs documented
- `SHORTLIST_SENT` - Properties shared with customer
- `VISIT_SCHEDULED` - Property visits planned
- `VISIT_COMPLETED` - Visits conducted
- `NEGOTIATION` - Deal terms being discussed
- `AGREEMENT_PENDING` - Awaiting documentation
- `CLOSED_WON` - Deal successfully closed
- `CLOSED_LOST` - Deal lost

#### 3.2.2 Upsell

| Attribute | Type | Description | Required |
|-----------|------|-------------|----------|
| id | UUID | Unique upsell identifier | Yes |
| user_id | UUID | Target user for upsell | Yes |
| user_type | Enum | TENANT, OWNER, BUYER | Yes |
| current_plan_id | UUID | Current subscription plan | No |
| target_plan_id | UUID | Recommended upgrade plan | Yes |
| trigger_event | String | Event that triggered upsell | Yes |
| trigger_context | JSON | Additional trigger context | No |
| status | Enum | Upsell campaign status | Yes |
| channel | Enum | Delivery channel | Yes |
| presented_at | Timestamp | When upsell was shown | No |
| response | Enum | User response to upsell | No |
| converted_at | Timestamp | Conversion timestamp | No |
| conversion_value | Decimal | Revenue from conversion | No |
| experiment_variant | String | A/B test variant | No |
| created_at | Timestamp | Record creation time | Yes |

**Upsell Statuses:**
- `PENDING` - Awaiting presentation
- `PRESENTED` - Shown to user
- `DISMISSED` - User dismissed
- `CLICKED` - User engaged
- `CONVERTED` - Successfully upgraded
- `EXPIRED` - Offer no longer valid

**Channels:**
- `IN_APP_BANNER`
- `IN_APP_MODAL`
- `PUSH_NOTIFICATION`
- `EMAIL`
- `SMS`
- `WHATSAPP`
- `RM_CALL`

#### 3.2.3 RMAllocation

| Attribute | Type | Description | Required |
|-----------|------|-------------|----------|
| id | UUID | Unique allocation identifier | Yes |
| lead_id | UUID | Reference to allocated lead | Yes |
| rm_id | UUID | Assigned RM | Yes |
| allocation_type | Enum | Type of allocation | Yes |
| allocation_reason | String | Reason for this allocation | No |
| priority | Integer | Lead priority (1-5) | Yes |
| status | Enum | Allocation status | Yes |
| allocated_at | Timestamp | Time of allocation | Yes |
| accepted_at | Timestamp | When RM accepted | No |
| first_action_at | Timestamp | First RM action time | No |
| sla_deadline | Timestamp | SLA expiration time | Yes |
| is_reassignment | Boolean | Whether this is a reassignment | Yes |
| previous_rm_id | UUID | Previous RM if reassigned | No |
| reassignment_reason | String | Reason for reassignment | No |
| created_at | Timestamp | Record creation time | Yes |

**Allocation Types:**
- `AUTO` - System-allocated
- `MANUAL` - Admin/supervisor assigned
- `ROUND_ROBIN` - Sequential distribution
- `SKILL_BASED` - Matched to RM expertise
- `GEOGRAPHIC` - Locality-based
- `OVERFLOW` - Spillover allocation

**Allocation Statuses:**
- `PENDING` - Awaiting RM acceptance
- `ACCEPTED` - RM has accepted
- `ACTIVE` - RM is working the lead
- `ESCALATED` - Escalated to supervisor
- `REASSIGNED` - Moved to another RM
- `COMPLETED` - Lead closed
- `EXPIRED` - SLA breached

#### 3.2.4 SalesTarget

| Attribute | Type | Description | Required |
|-----------|------|-------------|----------|
| id | UUID | Unique target identifier | Yes |
| target_type | Enum | Individual, Team, or City | Yes |
| assignee_id | UUID | RM, Team, or City ID | Yes |
| period_type | Enum | Daily, Weekly, Monthly, Quarterly | Yes |
| period_start | Date | Period start date | Yes |
| period_end | Date | Period end date | Yes |
| metric_type | Enum | Metric being measured | Yes |
| target_value | Decimal | Target amount/count | Yes |
| achieved_value | Decimal | Current achievement | Yes |
| achievement_percentage | Decimal | Percentage achieved | Yes |
| status | Enum | Target status | Yes |
| created_by | UUID | Admin who set target | Yes |
| created_at | Timestamp | Record creation time | Yes |
| updated_at | Timestamp | Last update time | Yes |

**Metric Types:**
- `REVENUE` - Total revenue generated
- `DEALS_CLOSED` - Number of closed deals
- `LEADS_CONTACTED` - Leads with first contact
- `VISITS_SCHEDULED` - Visits arranged
- `CONVERSION_RATE` - Lead-to-close ratio
- `UPSELL_CONVERSIONS` - Successful upsells
- `CUSTOMER_SATISFACTION` - NPS/CSAT scores

**Target Statuses:**
- `ACTIVE` - Currently being tracked
- `ACHIEVED` - Target met or exceeded
- `MISSED` - Period ended below target
- `CANCELLED` - Target cancelled

#### 3.2.5 Commission

| Attribute | Type | Description | Required |
|-----------|------|-------------|----------|
| id | UUID | Unique commission identifier | Yes |
| rm_id | UUID | RM earning commission | Yes |
| transaction_id | UUID | Related transaction/deal | Yes |
| transaction_type | Enum | Type of transaction | Yes |
| commission_type | Enum | Structure type | Yes |
| base_amount | Decimal | Transaction value | Yes |
| commission_rate | Decimal | Applied rate | Yes |
| commission_amount | Decimal | Calculated commission | Yes |
| adjustments | Decimal | Bonus/deductions | No |
| final_amount | Decimal | Net commission payable | Yes |
| status | Enum | Commission status | Yes |
| earned_at | Timestamp | When commission was earned | Yes |
| approved_by | UUID | Approver (if required) | No |
| approved_at | Timestamp | Approval timestamp | No |
| paid_at | Timestamp | Payment timestamp | No |
| payout_reference | String | Payment transaction ID | No |
| clawback_reason | String | Reason if clawed back | No |
| created_at | Timestamp | Record creation time | Yes |

**Transaction Types:**
- `SUBSCRIPTION_NEW` - New subscription sale
- `SUBSCRIPTION_RENEWAL` - Renewal
- `SUBSCRIPTION_UPGRADE` - Plan upgrade
- `SERVICE_BOOKING` - HomeServices booking
- `AGREEMENT_EXECUTION` - Legal document service
- `PROPERTY_MANAGEMENT` - PM contract

**Commission Types:**
- `FIXED` - Fixed amount per transaction
- `PERCENTAGE` - Percentage of transaction value
- `TIERED` - Slab-based rates
- `BONUS` - Performance bonus

**Commission Statuses:**
- `PENDING` - Awaiting eligibility confirmation
- `EARNED` - Eligible for payout
- `APPROVED` - Approved for payment
- `PAID` - Paid to RM
- `CLAWED_BACK` - Reversed due to refund
- `DISPUTED` - Under review

---

## 4. User Stories

### 4.1 Upsell Flows

#### US-SALE-001: Tenant Plan Upsell
**As a** tenant on the free plan
**I want to** see relevant upgrade options when I hit contact limits
**So that** I can access more property owner contacts

**Acceptance Criteria:**
- System detects when user reaches 80% of free tier contact limits
- Contextual upsell modal displays with plan comparison
- One-click upgrade flow with saved payment methods
- Immediate entitlement activation upon successful payment
- Confirmation notification sent via preferred channel

#### US-SALE-002: Owner Listing Boost Upsell
**As a** property owner with a listing
**I want to** boost my listing visibility when views are low
**So that** I can receive more tenant inquiries

**Acceptance Criteria:**
- System identifies listings with below-average views after 7 days
- Push notification sent with boost offer
- In-app banner displayed on listing management screen
- Clear ROI messaging (expected increase in views)
- Easy activation with transparent pricing

#### US-SALE-003: Upsell A/B Testing
**As a** product manager
**I want to** test different upsell messages and timings
**So that** I can optimize conversion rates

**Acceptance Criteria:**
- Experiment configuration via admin console
- Random user assignment to variants
- Real-time conversion tracking per variant
- Statistical significance calculation
- Winner declaration and rollout capability

### 4.2 RM-Assisted Workflows

#### US-SALE-010: Lead Assignment to RM
**As an** RM
**I want to** receive leads matched to my expertise and locality
**So that** I can provide effective assistance

**Acceptance Criteria:**
- Leads allocated based on RM's assigned localities
- Property type matching (residential, commercial)
- Notification upon new lead assignment
- SLA timer displayed with deadline
- Accept/reject capability with reason capture

#### US-SALE-011: Requirements Capture
**As an** RM
**I want to** capture detailed tenant requirements
**So that** I can create accurate property shortlists

**Acceptance Criteria:**
- Structured requirements form (budget, location, size, amenities)
- Requirements linked to lead/pipeline record
- Flexible preference weighting (must-have vs. nice-to-have)
- Requirements history for returning customers
- Integration with Search domain for matching

#### US-SALE-012: Shortlist Generation
**As an** RM
**I want to** generate and share property shortlists
**So that** customers can review suitable options

**Acceptance Criteria:**
- Automated suggestions based on captured requirements
- Manual property addition capability
- Shortlist sharing via WhatsApp, email, or in-app
- Customer feedback capture per property
- Shortlist version history

#### US-SALE-013: Visit Planning
**As an** RM
**I want to** coordinate property visits efficiently
**So that** customers can view multiple properties conveniently

**Acceptance Criteria:**
- Multi-property visit scheduling in single session
- Route optimization suggestions
- Owner availability confirmation
- Customer confirmation and reminders
- Visit outcome capture post-visit

### 4.3 Guarantee and Refund Handling

#### US-SALE-020: Refund Request Processing
**As a** customer
**I want to** request a refund when service guarantees are not met
**So that** I can recover my payment

**Acceptance Criteria:**
- Self-service refund request from order history
- Eligibility auto-check based on policy rules
- Required documentation upload capability
- Status tracking with estimated resolution time
- Automated refund for eligible claims

#### US-SALE-021: Guarantee Claim Investigation
**As a** support agent
**I want to** investigate guarantee claims
**So that** I can make fair refund decisions

**Acceptance Criteria:**
- Complete transaction and service history available
- Customer communication history accessible
- Evidence upload and annotation
- Decision workflow with approval hierarchy
- Customer notification of decision

### 4.4 Lead Allocation

#### US-SALE-030: Automated Lead Distribution
**As a** system
**I want to** distribute leads automatically to available RMs
**So that** customers receive timely assistance

**Acceptance Criteria:**
- Lead scoring based on deal potential
- RM availability check (online, queue depth)
- Skill and locality matching
- Fair distribution across team
- Fallback to overflow pool if no match

#### US-SALE-031: Manual Lead Reassignment
**As a** sales supervisor
**I want to** reassign leads between RMs
**So that** I can balance workload or handle escalations

**Acceptance Criteria:**
- Bulk and individual reassignment capability
- Reason capture for audit trail
- Notification to both RMs
- SLA timer reset option
- History preservation

### 4.5 Performance and Commission

#### US-SALE-040: Sales Dashboard Access
**As an** RM
**I want to** view my performance metrics
**So that** I can track progress toward targets

**Acceptance Criteria:**
- Real-time target vs. achieved display
- Period selection (daily, weekly, monthly)
- Trend visualization
- Leaderboard position
- Commission earnings summary

#### US-SALE-041: Commission Calculation
**As an** RM
**I want to** see my commission on closed deals
**So that** I know my expected earnings

**Acceptance Criteria:**
- Automatic calculation upon deal closure
- Commission structure visibility
- Pending vs. approved vs. paid breakdown
- Dispute raising capability
- Payout schedule visibility

#### US-SALE-042: Commission Approval
**As a** finance admin
**I want to** review and approve commissions
**So that** accurate payouts are processed

**Acceptance Criteria:**
- Batch approval capability
- Exception flagging for review
- Clawback handling for refunds
- Export for payroll integration
- Audit trail for all actions

---

## 5. Domain Interactions

### 5.1 Upstream Dependencies

| Domain | Interaction | Data Received |
|--------|-------------|---------------|
| **Leads** | Lead creation triggers allocation | Lead details, contact info, property interest |
| **CRM** | Customer context for sales | Contact history, requirements, interactions |
| **UserManagement** | User and RM profiles | User roles, RM details, team assignments |
| **Entitlements** | Current plan information | Active plans, quotas, features |
| **Inventory** | Property details for shortlisting | Listings, availability, pricing |

### 5.2 Downstream Dependencies

| Domain | Interaction | Data Sent |
|--------|-------------|-----------|
| **Billing** | Payment processing for upsells | Payment requests, refund requests |
| **Entitlements** | Activate new plans post-sale | Plan activation events |
| **Communications** | Send notifications | Upsell messages, confirmations, alerts |
| **Scheduling** | Visit coordination | Visit requests, RM availability |
| **Analytics** | Performance data | Sales events, conversion metrics |

### 5.3 Integration Diagram

```
                    +----------------+
                    |     Leads      |
                    +-------+--------+
                            |
                            v
+----------------+  +-------+--------+  +----------------+
|      CRM       |->|     SALES      |->|    Billing     |
+----------------+  +-------+--------+  +----------------+
                            |
        +-------------------+-------------------+
        |                   |                   |
        v                   v                   v
+-------+--------+  +-------+--------+  +-------+--------+
|  Entitlements  |  | Communications |  |   Scheduling   |
+----------------+  +----------------+  +----------------+
        |                   |                   |
        +-------------------+-------------------+
                            |
                            v
                    +-------+--------+
                    |   Analytics    |
                    +----------------+
```

### 5.4 Event Contracts

#### Events Published

| Event Name | Trigger | Payload |
|------------|---------|---------|
| `sales.pipeline.created` | New pipeline created | Pipeline ID, lead ID, RM ID |
| `sales.pipeline.stage_changed` | Stage transition | Pipeline ID, old stage, new stage |
| `sales.pipeline.closed` | Deal won or lost | Pipeline ID, outcome, value |
| `sales.upsell.presented` | Upsell shown to user | Upsell ID, user ID, plan ID |
| `sales.upsell.converted` | User upgraded plan | Upsell ID, user ID, revenue |
| `sales.lead.allocated` | Lead assigned to RM | Allocation ID, lead ID, RM ID |
| `sales.lead.reassigned` | Lead moved to new RM | Allocation ID, from RM, to RM |
| `sales.commission.earned` | Commission calculated | Commission ID, RM ID, amount |
| `sales.commission.paid` | Commission disbursed | Commission ID, payout reference |
| `sales.refund.requested` | Refund claim initiated | Refund ID, order ID, amount |
| `sales.refund.processed` | Refund completed | Refund ID, status, amount |

#### Events Consumed

| Event Name | Source Domain | Action |
|------------|---------------|--------|
| `leads.lead.created` | Leads | Trigger allocation workflow |
| `leads.lead.qualified` | Leads | Update pipeline stage |
| `billing.payment.completed` | Billing | Confirm upsell conversion |
| `billing.refund.completed` | Billing | Update refund status |
| `scheduling.visit.completed` | Scheduling | Update pipeline with outcome |
| `entitlements.plan.expired` | Entitlements | Trigger renewal upsell |

---

## 6. Business Rules

### 6.1 Lead Allocation Rules

| Rule ID | Rule Name | Description | Priority |
|---------|-----------|-------------|----------|
| LAR-001 | Geographic Match | Allocate leads to RMs serving the lead's locality | P0 |
| LAR-002 | Capacity Check | Do not allocate if RM queue exceeds 25 active leads | P0 |
| LAR-003 | Skill Match | Match property type to RM expertise | P1 |
| LAR-004 | Round Robin | Equal distribution among eligible RMs | P1 |
| LAR-005 | Performance Boost | High performers receive higher-value leads | P2 |
| LAR-006 | SLA Enforcement | Reassign if no action within 2 hours | P0 |
| LAR-007 | Overflow Handling | Route to backup pool if no RMs available | P0 |

### 6.2 Commission Rules

| Rule ID | Rule Name | Description |
|---------|-----------|-------------|
| CMR-001 | Eligibility Period | Commission earned only if customer stays for 30 days |
| CMR-002 | Clawback Window | Commission clawed back for refunds within 45 days |
| CMR-003 | Tiered Rates | Higher rates for exceeding monthly targets |
| CMR-004 | Team Bonus | Additional bonus if team target achieved |
| CMR-005 | Cap Limit | Monthly commission capped at 3x base salary |
| CMR-006 | Dispute Window | Disputes must be raised within 7 days of calculation |

### 6.3 Upsell Rules

| Rule ID | Rule Name | Description |
|---------|-----------|-------------|
| UPR-001 | Cooldown Period | No upsell within 48 hours of previous dismissal |
| UPR-002 | Usage Trigger | Upsell at 80% quota utilization |
| UPR-003 | Behavior Trigger | Upsell after 5 property views without contact |
| UPR-004 | Channel Priority | In-app first, then push, then email |
| UPR-005 | Frequency Cap | Maximum 3 upsell touches per week |
| UPR-006 | Opt-Out Respect | Honor user preferences for marketing communications |

### 6.4 Refund Rules

| Rule ID | Rule Name | Description |
|---------|-----------|-------------|
| RFR-001 | Eligibility Window | Refund eligible within 7 days of purchase |
| RFR-002 | Usage Check | No refund if >50% of plan benefits consumed |
| RFR-003 | Auto-Approve | Auto-approve refunds under Rs. 500 |
| RFR-004 | Manager Approval | Refunds over Rs. 5,000 require manager approval |
| RFR-005 | Fraud Check | Flag accounts with >2 refunds in 90 days |
| RFR-006 | Pro-Rata Calculation | Partial refunds calculated on unused days |

---

## 7. API Specifications

### 7.1 API Overview

| Endpoint Category | Base Path | Authentication |
|-------------------|-----------|----------------|
| Pipeline Management | `/api/v1/sales/pipelines` | JWT + RBAC |
| Upsell Management | `/api/v1/sales/upsells` | JWT + RBAC |
| Lead Allocation | `/api/v1/sales/allocations` | JWT + RBAC |
| Targets | `/api/v1/sales/targets` | JWT + RBAC |
| Commissions | `/api/v1/sales/commissions` | JWT + RBAC |
| Refunds | `/api/v1/sales/refunds` | JWT + RBAC |

### 7.2 Key Endpoints

#### Pipeline APIs

```
POST   /api/v1/sales/pipelines                    # Create pipeline
GET    /api/v1/sales/pipelines                    # List pipelines (with filters)
GET    /api/v1/sales/pipelines/{id}               # Get pipeline details
PUT    /api/v1/sales/pipelines/{id}               # Update pipeline
PATCH  /api/v1/sales/pipelines/{id}/stage         # Update stage
GET    /api/v1/sales/pipelines/{id}/history       # Get stage history
GET    /api/v1/sales/pipelines/stats              # Pipeline statistics
```

#### Upsell APIs

```
POST   /api/v1/sales/upsells                      # Create upsell campaign
GET    /api/v1/sales/upsells                      # List upsells
GET    /api/v1/sales/upsells/{id}                 # Get upsell details
PATCH  /api/v1/sales/upsells/{id}/response        # Record user response
GET    /api/v1/sales/upsells/recommendations/{userId}  # Get user recommendations
GET    /api/v1/sales/upsells/experiments          # List experiments
POST   /api/v1/sales/upsells/experiments          # Create experiment
```

#### Allocation APIs

```
POST   /api/v1/sales/allocations                  # Allocate lead
GET    /api/v1/sales/allocations                  # List allocations
GET    /api/v1/sales/allocations/{id}             # Get allocation details
PATCH  /api/v1/sales/allocations/{id}/accept      # RM accepts lead
PATCH  /api/v1/sales/allocations/{id}/reject      # RM rejects lead
POST   /api/v1/sales/allocations/{id}/reassign    # Reassign lead
GET    /api/v1/sales/allocations/rm/{rmId}/queue  # Get RM's lead queue
GET    /api/v1/sales/allocations/workload         # Team workload summary
```

#### Target APIs

```
POST   /api/v1/sales/targets                      # Create target
GET    /api/v1/sales/targets                      # List targets
GET    /api/v1/sales/targets/{id}                 # Get target details
PUT    /api/v1/sales/targets/{id}                 # Update target
GET    /api/v1/sales/targets/rm/{rmId}            # Get RM's targets
GET    /api/v1/sales/targets/team/{teamId}        # Get team targets
GET    /api/v1/sales/targets/leaderboard          # Get leaderboard
```

#### Commission APIs

```
GET    /api/v1/sales/commissions                  # List commissions
GET    /api/v1/sales/commissions/{id}             # Get commission details
POST   /api/v1/sales/commissions/{id}/approve     # Approve commission
POST   /api/v1/sales/commissions/{id}/dispute     # Dispute commission
POST   /api/v1/sales/commissions/batch-approve    # Batch approve
GET    /api/v1/sales/commissions/rm/{rmId}/summary # RM commission summary
GET    /api/v1/sales/commissions/payout-report    # Generate payout report
```

#### Refund APIs

```
POST   /api/v1/sales/refunds                      # Request refund
GET    /api/v1/sales/refunds                      # List refunds
GET    /api/v1/sales/refunds/{id}                 # Get refund details
POST   /api/v1/sales/refunds/{id}/approve         # Approve refund
POST   /api/v1/sales/refunds/{id}/reject          # Reject refund
GET    /api/v1/sales/refunds/eligibility/{orderId} # Check eligibility
```

### 7.3 Request/Response Examples

#### Create Pipeline Request

```json
POST /api/v1/sales/pipelines
{
  "lead_id": "550e8400-e29b-41d4-a716-446655440000",
  "rm_id": "550e8400-e29b-41d4-a716-446655440001",
  "source": "INBOUND_CALL",
  "deal_value": 25000.00,
  "expected_close_date": "2026-02-15",
  "notes": "Customer looking for 2BHK in Koramangala"
}
```

#### Pipeline Response

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440002",
  "lead_id": "550e8400-e29b-41d4-a716-446655440000",
  "rm_id": "550e8400-e29b-41d4-a716-446655440001",
  "stage": "NEW",
  "source": "INBOUND_CALL",
  "deal_value": 25000.00,
  "probability": 20,
  "expected_close_date": "2026-02-15",
  "outcome": "PENDING",
  "notes": "Customer looking for 2BHK in Koramangala",
  "created_at": "2026-01-17T10:30:00Z",
  "updated_at": "2026-01-17T10:30:00Z",
  "sla_deadline": "2026-01-17T12:30:00Z",
  "customer": {
    "id": "550e8400-e29b-41d4-a716-446655440003",
    "name": "Rahul Sharma",
    "phone": "+91-98XXXXXXXX",
    "email": "rahul@example.com"
  },
  "rm": {
    "id": "550e8400-e29b-41d4-a716-446655440001",
    "name": "Priya Patel",
    "team": "Bangalore South"
  }
}
```

---

## 8. Non-Functional Requirements

### 8.1 Performance Requirements

| Metric | Requirement | Measurement |
|--------|-------------|-------------|
| Lead Allocation Latency | < 500ms | P99 response time |
| Dashboard Load Time | < 2 seconds | Full page render |
| API Response Time | < 200ms | P95 for read operations |
| API Response Time | < 500ms | P95 for write operations |
| Concurrent RMs | Support 500 concurrent users | Load test |
| Pipeline Query | < 100ms | For single RM's pipelines |

### 8.2 Scalability Requirements

| Aspect | Current | Target (12 months) |
|--------|---------|-------------------|
| Active RMs | 100 | 1,000 |
| Daily Lead Allocations | 1,000 | 25,000 |
| Active Pipelines | 10,000 | 250,000 |
| Monthly Transactions | 5,000 | 100,000 |
| Commission Calculations | 5,000/month | 100,000/month |

### 8.3 Availability Requirements

| Component | Availability Target | RTO | RPO |
|-----------|---------------------|-----|-----|
| Lead Allocation Service | 99.9% | 15 min | 0 |
| Pipeline Management | 99.5% | 30 min | 5 min |
| Commission Service | 99.5% | 1 hour | 15 min |
| Dashboards | 99.0% | 2 hours | 1 hour |

### 8.4 Security Requirements

| Requirement | Implementation |
|-------------|----------------|
| Data Encryption | AES-256 at rest, TLS 1.3 in transit |
| Access Control | RBAC with team-level scoping |
| Audit Logging | All write operations logged |
| PII Protection | Masking for non-authorized views |
| Session Management | 30-minute timeout, single session per device |
| API Security | Rate limiting, request validation |

### 8.5 Compliance Requirements

- Commission calculations must be auditable for tax compliance
- Refund processing must comply with RBI guidelines
- Customer data handling per GDPR/Indian data protection regulations
- Sales communication records retained for 7 years

---

## 9. Success Metrics

### 9.1 Key Performance Indicators (KPIs)

| Metric | Description | Target | Frequency |
|--------|-------------|--------|-----------|
| Upsell Conversion Rate | % of upsell presentations that convert | > 5% | Weekly |
| Lead-to-Close Ratio | % of allocated leads that close | > 15% | Weekly |
| Average Deal Cycle Time | Days from allocation to close | < 14 days | Weekly |
| RM Utilization Rate | % of RM capacity utilized | 70-85% | Daily |
| SLA Compliance | % of leads actioned within SLA | > 95% | Daily |
| Commission Accuracy | % of commissions without disputes | > 99% | Monthly |
| Refund Rate | % of transactions resulting in refunds | < 3% | Monthly |
| Customer Satisfaction | NPS for RM-assisted sales | > 50 | Monthly |

### 9.2 Business Metrics

| Metric | Description | Baseline | Target |
|--------|-------------|----------|--------|
| Revenue per RM | Monthly revenue generated per RM | Rs. 2L | Rs. 3L |
| Cost per Acquisition | Cost to acquire a paying customer | Rs. 500 | Rs. 400 |
| Average Revenue per User | Revenue from upgraded users | Rs. 1,500 | Rs. 2,000 |
| Churn Rate (Paid Users) | Monthly churn of paid subscribers | 8% | 5% |
| Attach Rate | % of free users who upgrade | 3% | 5% |

### 9.3 Operational Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| Lead Response Time | Time to first RM contact | < 30 min |
| Pipeline Accuracy | Forecast accuracy | > 80% |
| Workload Balance | Variance in lead distribution | < 15% |
| System Uptime | Sales platform availability | 99.5% |

---

## 10. Implementation Phases

### 10.1 Phase 1: Foundation (Weeks 1-4)

**Scope:**
- SalesPipeline entity and basic CRUD operations
- RMAllocation with automated distribution
- Basic lead acceptance workflow
- Initial pipeline stage management

**Deliverables:**
- Pipeline management APIs
- Lead allocation service
- RM queue management
- Basic admin console

**Success Criteria:**
- Leads allocated within 5 minutes
- RMs can manage their pipeline
- Stage transitions tracked

### 10.2 Phase 2: Upsell Engine (Weeks 5-8)

**Scope:**
- Upsell entity and trigger framework
- Trigger rule configuration
- Multi-channel upsell delivery
- Conversion tracking

**Deliverables:**
- Upsell APIs
- Trigger engine
- Channel integration
- A/B testing framework

**Success Criteria:**
- Upsells triggered based on user behavior
- Conversion tracking operational
- A/B tests can be configured

### 10.3 Phase 3: Performance Management (Weeks 9-12)

**Scope:**
- SalesTarget entity and tracking
- Commission calculation engine
- Performance dashboards
- Leaderboards

**Deliverables:**
- Target management APIs
- Commission calculation service
- RM and team dashboards
- Reporting exports

**Success Criteria:**
- Real-time target tracking
- Automated commission calculation
- Dashboard load < 2 seconds

### 10.4 Phase 4: Advanced Features (Weeks 13-16)

**Scope:**
- Guarantee/refund handling
- Advanced allocation rules
- Commission approval workflows
- Analytics integration

**Deliverables:**
- Refund processing APIs
- Skill-based allocation
- Approval workflows
- Event streaming to Analytics

**Success Criteria:**
- Refunds processed within SLA
- Allocation accuracy improved
- Full audit trail available

---

## 11. Risks and Mitigations

### 11.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Allocation service bottleneck | Medium | High | Implement async processing with queue |
| Commission calculation errors | Medium | High | Multi-level validation, manual review for large amounts |
| Dashboard performance degradation | Medium | Medium | Implement caching, pagination, data aggregation |
| Integration failures with Billing | Low | High | Circuit breaker, retry logic, fallback handling |

### 11.2 Business Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Low upsell conversion | Medium | High | A/B testing, personalization, timing optimization |
| RM resistance to new system | Medium | Medium | Training, gradual rollout, feedback incorporation |
| Commission disputes | Medium | Medium | Clear rules, transparency, quick resolution process |
| Refund abuse | Low | Medium | Fraud detection, progressive limits, account monitoring |

### 11.3 Operational Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Unbalanced lead distribution | Medium | High | Real-time monitoring, automatic rebalancing |
| SLA breaches | Medium | Medium | Escalation automation, supervisor alerts |
| Data accuracy issues | Low | High | Validation rules, reconciliation, audit logs |

---

## 12. Appendix

### 12.1 Glossary

| Term | Definition |
|------|------------|
| RM | Relationship Manager - Sales representative assisting customers |
| Pipeline | Series of stages a sales opportunity progresses through |
| Upsell | Encouraging customers to upgrade to higher-value plans |
| Lead Allocation | Process of assigning leads to RMs |
| SLA | Service Level Agreement - defined response time targets |
| Commission | Incentive payment to RMs based on sales performance |
| Clawback | Reversal of commission due to refund or cancellation |
| Conversion Rate | Percentage of opportunities that result in sales |

### 12.2 Related Documents

- [Leads Domain PRD](/docs/domain/leads.md)
- [CRM Domain PRD](/docs/domain/crm.md)
- [Billing Domain PRD](/docs/domain/billing.md)
- [Entitlements Domain PRD](/docs/domain/entitlements.md)
- [Communications Domain PRD](/docs/domain/communications.md)

### 12.3 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2026-01-17 | Product Team | Initial draft |

---

## 13. Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product Owner | | | |
| Engineering Lead | | | |
| Design Lead | | | |
| QA Lead | | | |
| Business Stakeholder | | | |
