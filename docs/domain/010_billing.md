# Billing Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Billing |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | 2026-01-17 |
| **Platform** | MySqrft |

---

## 1. Executive Summary

### 1.1 Primary Goal
**Money Movement + Invoices**

The Billing domain is the financial backbone of MySqrft, responsible for all payment processing, invoice generation, refund management, and revenue tracking across the platform. It ensures secure, compliant, and auditable financial transactions while providing a seamless checkout experience for users.

### 1.2 Business Context
Billing is a Phase 2 (Monetization) domain that directly enables revenue generation for MySqrft. It integrates with multiple revenue-generating domains including Sales (subscription plans), HomeServices (service bookings), Society (maintenance billing), and FinancialServices (loan referrals).

### 1.3 Success Metrics
- Payment success rate > 95%
- Average checkout completion time < 2 minutes
- Invoice generation accuracy: 100%
- Refund processing time < 48 hours
- GST compliance rate: 100%
- Chargeback rate < 0.5%

---

## 2. Domain Responsibilities

### 2.1 Core Responsibilities

| Responsibility | Description | Priority |
|----------------|-------------|----------|
| Checkout flows | Support UPI, cards, and netbanking payment methods | P0 |
| Invoice and receipt generation | Generate compliant invoices and payment receipts | P0 |
| GST field management | Capture and validate GSTIN, apply correct GST rates | P0 |
| Refunds (full and partial) | Process refund requests with proper validations | P0 |
| Chargeback handling | Manage disputes and chargeback workflows | P1 |
| Revenue categorization | Categorize revenue by source (plans/services/society/finance) | P1 |
| Ledger-ready event generation | Emit financial events for accounting systems | P1 |

### 2.2 Out of Scope
- Plan catalog management (owned by Entitlements)
- Subscription lifecycle management (owned by Entitlements)
- Payment gateway selection and contracts (owned by Ops)
- Financial reporting and analytics (owned by Analytics)
- Commission calculations (owned by Sales/FinancialServices)

---

## 3. Key Entities

### 3.1 Entity Overview

```
+------------------+     +------------------+     +------------------+
|     Payment      |---->|    Transaction   |---->|     Invoice      |
+------------------+     +------------------+     +------------------+
        |                        |                        |
        v                        v                        v
+------------------+     +------------------+     +------------------+
|      Refund      |     | RevenueCategory  |     |   InvoiceItem    |
+------------------+     +------------------+     +------------------+
```

### 3.2 Entity Definitions

#### 3.2.1 Payment
Represents a payment attempt or completed payment by a user.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique payment identifier |
| user_id | UUID | Yes | Reference to paying user |
| amount | Decimal | Yes | Payment amount in INR |
| currency | String | Yes | Currency code (default: INR) |
| payment_method | Enum | Yes | UPI, CARD, NETBANKING, WALLET |
| payment_gateway | String | Yes | Gateway used (Razorpay, PayU, etc.) |
| gateway_payment_id | String | No | External payment reference |
| status | Enum | Yes | INITIATED, PENDING, SUCCESS, FAILED, EXPIRED |
| source_type | Enum | Yes | PLAN, SERVICE, SOCIETY, FINANCE, OTHER |
| source_id | UUID | Yes | Reference to source entity |
| metadata | JSON | No | Additional payment context |
| created_at | Timestamp | Yes | Payment initiation time |
| updated_at | Timestamp | Yes | Last status update time |
| completed_at | Timestamp | No | Payment completion time |

#### 3.2.2 Invoice
Represents a tax-compliant invoice for a completed transaction.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique invoice identifier |
| invoice_number | String | Yes | Sequential invoice number |
| user_id | UUID | Yes | Reference to billed user |
| payment_id | UUID | Yes | Reference to payment |
| subtotal | Decimal | Yes | Amount before taxes |
| tax_amount | Decimal | Yes | Total tax amount |
| total_amount | Decimal | Yes | Final invoice amount |
| currency | String | Yes | Currency code |
| billing_address | JSON | Yes | Customer billing address |
| customer_gstin | String | No | Customer's GSTIN (if B2B) |
| place_of_supply | String | Yes | State code for GST |
| invoice_type | Enum | Yes | B2C, B2B, CREDIT_NOTE |
| status | Enum | Yes | DRAFT, ISSUED, CANCELLED, VOID |
| issued_at | Timestamp | No | Invoice issue date |
| due_date | Date | No | Payment due date |
| created_at | Timestamp | Yes | Creation timestamp |

#### 3.2.3 Refund
Represents a full or partial refund against a payment.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique refund identifier |
| payment_id | UUID | Yes | Reference to original payment |
| invoice_id | UUID | Yes | Reference to original invoice |
| amount | Decimal | Yes | Refund amount |
| refund_type | Enum | Yes | FULL, PARTIAL |
| reason | Enum | Yes | CUSTOMER_REQUEST, SERVICE_ISSUE, DUPLICATE, FRAUD, OTHER |
| reason_details | Text | No | Detailed refund reason |
| status | Enum | Yes | INITIATED, PROCESSING, SUCCESS, FAILED |
| gateway_refund_id | String | No | External refund reference |
| initiated_by | UUID | Yes | User/admin who initiated |
| approved_by | UUID | No | Admin who approved (if required) |
| credit_note_id | UUID | No | Associated credit note |
| created_at | Timestamp | Yes | Refund initiation time |
| processed_at | Timestamp | No | Refund completion time |

#### 3.2.4 Transaction
Represents an atomic financial transaction for ledger purposes.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique transaction identifier |
| payment_id | UUID | No | Reference to payment (if applicable) |
| refund_id | UUID | No | Reference to refund (if applicable) |
| transaction_type | Enum | Yes | CREDIT, DEBIT |
| amount | Decimal | Yes | Transaction amount |
| currency | String | Yes | Currency code |
| revenue_category_id | UUID | Yes | Reference to revenue category |
| description | String | Yes | Transaction description |
| reference_type | String | Yes | Source entity type |
| reference_id | UUID | Yes | Source entity ID |
| ledger_status | Enum | Yes | PENDING, POSTED, RECONCILED |
| created_at | Timestamp | Yes | Transaction timestamp |
| posted_at | Timestamp | No | Ledger posting time |

#### 3.2.5 RevenueCategory
Defines revenue classification for financial reporting.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique category identifier |
| code | String | Yes | Category code (e.g., PLAN_TENANT) |
| name | String | Yes | Display name |
| parent_category_id | UUID | No | Parent category for hierarchy |
| category_type | Enum | Yes | PLANS, SERVICES, SOCIETY, FINANCE, OTHER |
| gl_account_code | String | No | General ledger account mapping |
| hsn_sac_code | String | Yes | HSN/SAC code for GST |
| default_gst_rate | Decimal | Yes | Default GST percentage |
| is_active | Boolean | Yes | Category active status |
| created_at | Timestamp | Yes | Creation timestamp |

---

## 4. Functional Requirements

### 4.1 Checkout Flows

#### FR-BIL-001: Payment Initiation
**Priority:** P0

**Description:** Users must be able to initiate payments through multiple payment methods.

**Acceptance Criteria:**
- Support UPI payment flow with QR code and VPA input
- Support card payments (credit/debit) with tokenization
- Support netbanking with bank selection
- Support wallet payments (Paytm, PhonePe, etc.)
- Display estimated processing time per method
- Show saved payment methods for returning users
- Validate payment amount before initiation
- Generate unique payment reference for tracking

**Business Rules:**
- Minimum payment amount: INR 1
- Maximum payment amount: INR 10,00,000 (configurable)
- Payment session expires after 15 minutes of inactivity
- Only one active payment session per order allowed

#### FR-BIL-002: Payment Processing
**Priority:** P0

**Description:** Process payments through integrated payment gateways.

**Acceptance Criteria:**
- Route payments to appropriate gateway based on method and amount
- Handle gateway callbacks and webhooks securely
- Update payment status in real-time
- Retry failed payments with exponential backoff (max 3 attempts)
- Log all gateway interactions for debugging
- Handle timeout scenarios gracefully
- Support idempotent payment processing

**Business Rules:**
- Payment status must be verified with gateway before marking success
- Duplicate payment detection within 5-minute window
- Auto-expire pending payments after 30 minutes

#### FR-BIL-003: Payment Confirmation
**Priority:** P0

**Description:** Confirm successful payments and trigger downstream actions.

**Acceptance Criteria:**
- Display payment success screen with transaction details
- Send payment confirmation via SMS and email
- Generate and attach invoice automatically
- Trigger entitlement activation (for plan purchases)
- Emit payment success event for downstream systems
- Provide downloadable receipt option

### 4.2 Invoice and Receipt Generation

#### FR-BIL-004: Invoice Generation
**Priority:** P0

**Description:** Generate GST-compliant invoices for all successful payments.

**Acceptance Criteria:**
- Auto-generate invoice on payment success
- Include all mandatory fields as per GST regulations
- Support B2B invoices with customer GSTIN
- Support B2C invoices without GSTIN
- Calculate CGST/SGST or IGST based on place of supply
- Generate unique sequential invoice numbers
- Support multiple line items per invoice
- Include HSN/SAC codes for each item

**Business Rules:**
- Invoice number format: MSQFT/{FY}/{SEQUENCE}
- Invoice must be generated within 24 hours of payment
- Invoices cannot be edited after issuance (only cancelled/credited)

#### FR-BIL-005: Receipt Generation
**Priority:** P0

**Description:** Generate payment receipts for user records.

**Acceptance Criteria:**
- Generate receipt immediately on payment success
- Include payment method details (masked)
- Include transaction reference numbers
- Support PDF download
- Support email delivery
- Make receipts accessible from user account

#### FR-BIL-006: Credit Note Generation
**Priority:** P1

**Description:** Generate credit notes for refunds and adjustments.

**Acceptance Criteria:**
- Link credit note to original invoice
- Include reason for credit
- Maintain sequential credit note numbering
- Calculate tax reversal correctly
- Support partial credit notes

### 4.3 GST Field Management

#### FR-BIL-007: GSTIN Capture and Validation
**Priority:** P0

**Description:** Capture and validate customer GSTIN for B2B transactions.

**Acceptance Criteria:**
- Validate GSTIN format (15 characters, checksum)
- Verify GSTIN against government database (optional)
- Auto-populate business name and address from GSTIN
- Store validated GSTIN with user profile
- Allow GSTIN to be added post-payment for B2B invoices
- Support multiple GSTINs per user (different branches)

#### FR-BIL-008: GST Rate Management
**Priority:** P0

**Description:** Apply correct GST rates based on service type and location.

**Acceptance Criteria:**
- Maintain GST rate master for all services
- Determine CGST+SGST vs IGST based on supply place
- Support GST rate changes with effective dates
- Handle exempt and nil-rated supplies
- Support composite and mixed supplies

**Business Rules:**
- Default GST rate for platform services: 18%
- Determine place of supply from user's registered address
- Inter-state supplies attract IGST
- Intra-state supplies attract CGST + SGST (equal split)

### 4.4 Refunds

#### FR-BIL-009: Refund Initiation
**Priority:** P0

**Description:** Allow refund requests for eligible payments.

**Acceptance Criteria:**
- Support customer-initiated refund requests
- Support admin-initiated refunds
- Validate refund eligibility based on policies
- Calculate maximum refundable amount
- Support full refund for entire payment
- Support partial refund with amount specification
- Require reason selection and optional details
- Show estimated refund processing time

**Business Rules:**
- Refunds allowed within 7 days of payment (configurable per product)
- Partial refund minimum: INR 1
- Total refunds cannot exceed original payment amount
- Service usage may reduce refundable amount

#### FR-BIL-010: Refund Processing
**Priority:** P0

**Description:** Process approved refunds through payment gateways.

**Acceptance Criteria:**
- Route refund to original payment method
- Handle gateway refund API calls
- Track refund status from gateway
- Update refund status in real-time
- Handle refund failures with retry logic
- Emit refund events for downstream systems

**Business Rules:**
- Refunds processed to original payment method only
- Card refunds: 5-7 business days
- UPI refunds: 2-3 business days
- Netbanking refunds: 5-7 business days

#### FR-BIL-011: Refund Approval Workflow
**Priority:** P1

**Description:** Implement approval workflow for refunds above threshold.

**Acceptance Criteria:**
- Auto-approve refunds below threshold (configurable)
- Route high-value refunds for manual approval
- Support multi-level approval for large amounts
- Notify approvers of pending requests
- Track approval/rejection with audit trail
- Support bulk refund approvals

**Business Rules:**
- Auto-approval threshold: INR 1,000
- L1 approval: INR 1,001 - 10,000
- L2 approval: Above INR 10,000

### 4.5 Chargeback Handling

#### FR-BIL-012: Chargeback Reception
**Priority:** P1

**Description:** Receive and process chargeback notifications from payment gateways.

**Acceptance Criteria:**
- Receive chargeback webhooks from all gateways
- Parse and store chargeback details
- Link chargeback to original payment
- Notify relevant teams immediately
- Create support ticket automatically
- Update payment/order status

#### FR-BIL-013: Chargeback Response
**Priority:** P1

**Description:** Manage chargeback dispute response workflow.

**Acceptance Criteria:**
- Collect evidence for dispute response
- Support document upload for evidence
- Track response deadlines
- Submit response to gateway
- Track dispute resolution status
- Handle won/lost outcomes appropriately

**Business Rules:**
- Chargeback response deadline: 7 days (gateway dependent)
- Evidence types: Invoice, delivery proof, communication logs
- Auto-flag user account for multiple chargebacks

#### FR-BIL-014: Chargeback Prevention
**Priority:** P2

**Description:** Implement measures to prevent chargebacks.

**Acceptance Criteria:**
- Display clear billing descriptor
- Send payment reminders before due dates
- Implement 3D Secure for card payments
- Validate card details before processing
- Flag suspicious transactions for review

### 4.6 Revenue Categorization

#### FR-BIL-015: Revenue Category Management
**Priority:** P1

**Description:** Maintain revenue categories for financial reporting.

**Acceptance Criteria:**
- Support hierarchical category structure
- Map categories to GL accounts
- Associate HSN/SAC codes with categories
- Support category activation/deactivation
- Track category changes with audit trail

**Revenue Categories:**
```
PLANS
  - PLAN_TENANT (Tenant subscription plans)
  - PLAN_OWNER (Owner subscription plans)
  - PLAN_PREMIUM (Premium features)

SERVICES
  - SERVICE_LEGAL (Rental agreements)
  - SERVICE_HOME (Home services - movers, cleaning)
  - SERVICE_PM (Property management fees)

SOCIETY
  - SOCIETY_MAINTENANCE (Maintenance billing)
  - SOCIETY_AMENITY (Amenity bookings)
  - SOCIETY_PENALTY (Late payment penalties)

FINANCE
  - FINANCE_REFERRAL (Loan referral commissions)
  - FINANCE_PROCESSING (Processing fees)
```

#### FR-BIL-016: Automatic Categorization
**Priority:** P1

**Description:** Automatically categorize payments based on source.

**Acceptance Criteria:**
- Determine category from payment source type
- Support manual category override
- Validate category assignment
- Generate categorization reports

### 4.7 Ledger-Ready Event Generation

#### FR-BIL-017: Financial Event Emission
**Priority:** P1

**Description:** Emit ledger-ready events for accounting integration.

**Acceptance Criteria:**
- Emit events for all financial transactions
- Include complete transaction details
- Support event replay for reconciliation
- Ensure event ordering and idempotency
- Include audit fields (timestamp, actor, source)

**Event Types:**
- `billing.payment.completed`
- `billing.payment.failed`
- `billing.refund.completed`
- `billing.invoice.issued`
- `billing.creditnote.issued`
- `billing.chargeback.received`
- `billing.chargeback.resolved`

#### FR-BIL-018: Reconciliation Support
**Priority:** P1

**Description:** Support reconciliation with payment gateways and ledgers.

**Acceptance Criteria:**
- Generate daily settlement reports
- Match gateway settlements with payments
- Flag discrepancies for review
- Support manual reconciliation adjustments
- Generate reconciliation audit trail

---

## 5. Non-Functional Requirements

### 5.1 Performance

| Requirement | Target | Measurement |
|-------------|--------|-------------|
| Payment initiation response time | < 2 seconds | P95 latency |
| Invoice generation time | < 5 seconds | P95 latency |
| Checkout page load time | < 3 seconds | P95 latency |
| Concurrent payment processing | 1000 TPS | Load testing |
| Payment status check | < 500ms | P95 latency |

### 5.2 Availability

| Requirement | Target |
|-------------|--------|
| Service availability | 99.95% |
| Planned maintenance window | < 4 hours/month |
| Recovery Time Objective (RTO) | < 15 minutes |
| Recovery Point Objective (RPO) | < 1 minute |

### 5.3 Security

| Requirement | Implementation |
|-------------|----------------|
| PCI DSS Compliance | Level 1 compliance for card data handling |
| Data encryption at rest | AES-256 encryption |
| Data encryption in transit | TLS 1.3 |
| Payment tokenization | No raw card data stored |
| Access control | Role-based with audit logging |
| Sensitive data masking | Mask card numbers, UPI IDs in logs |

### 5.4 Scalability

| Requirement | Target |
|-------------|--------|
| Horizontal scaling | Auto-scale based on load |
| Database scaling | Read replicas for reports |
| Event processing | Async processing with queues |
| Peak load handling | 3x normal capacity |

### 5.5 Compliance

| Requirement | Standard |
|-------------|----------|
| GST Compliance | As per GST Act 2017 |
| Invoice format | GST Invoice Rules |
| Data retention | 8 years for financial records |
| Audit trail | Complete for all transactions |
| RBI Guidelines | Payment aggregator compliance |

---

## 6. Integration Points

### 6.1 Upstream Dependencies

| Domain | Integration Type | Purpose |
|--------|------------------|---------|
| Auth | API | User authentication for payments |
| UserManagement | API | User profile, addresses, GSTIN |
| Entitlements | API | Plan details, pricing, activation |
| Sales | Events | Subscription purchases |
| HomeServices | Events | Service booking payments |
| Society | Events | Maintenance fee payments |
| FinancialServices | Events | Commission processing |

### 6.2 Downstream Consumers

| Domain | Integration Type | Purpose |
|--------|------------------|---------|
| Entitlements | Events | Activate entitlements on payment |
| Communications | Events | Send payment notifications |
| Analytics | Events | Revenue tracking and reporting |
| Support | API | Payment history for support tickets |
| Ops | API | Admin payment management |

### 6.3 External Integrations

| System | Type | Purpose |
|--------|------|---------|
| Razorpay | Payment Gateway | Primary payment processing |
| PayU | Payment Gateway | Backup/specific use cases |
| GST Portal | API (Optional) | GSTIN verification |
| Accounting System | Events | Ledger synchronization |
| Bank APIs | Settlement | Reconciliation data |

---

## 7. User Stories

### 7.1 Tenant/Buyer Stories

**US-BIL-001:** As a tenant, I want to purchase a subscription plan using UPI so that I can unlock contact details of property owners.

**US-BIL-002:** As a buyer, I want to save my card details securely so that I can make future payments quickly.

**US-BIL-003:** As a user, I want to download my payment invoice so that I can claim it for tax purposes.

**US-BIL-004:** As a user, I want to request a refund for unused services so that I can get my money back.

**US-BIL-005:** As a business user, I want to add my GSTIN so that I receive proper B2B invoices with GST credit.

### 7.2 Owner Stories

**US-BIL-006:** As a property owner, I want to purchase a premium listing plan so that my property gets more visibility.

**US-BIL-007:** As an owner, I want to view all my payment history in one place so that I can track my expenses.

### 7.3 Admin Stories

**US-BIL-008:** As a support agent, I want to process refunds for customers so that I can resolve their issues.

**US-BIL-009:** As a finance admin, I want to view daily settlement reports so that I can reconcile payments.

**US-BIL-010:** As an admin, I want to respond to chargebacks with evidence so that we can dispute invalid claims.

**US-BIL-011:** As a finance manager, I want to categorize revenue correctly so that financial reports are accurate.

---

## 8. API Specifications

### 8.1 Core APIs

#### Payment APIs
```
POST   /api/v1/payments                    # Initiate payment
GET    /api/v1/payments/{id}               # Get payment details
GET    /api/v1/payments/{id}/status        # Get payment status
POST   /api/v1/payments/{id}/verify        # Verify payment with gateway
GET    /api/v1/users/{id}/payments         # List user's payments
```

#### Invoice APIs
```
GET    /api/v1/invoices/{id}               # Get invoice details
GET    /api/v1/invoices/{id}/download      # Download invoice PDF
GET    /api/v1/users/{id}/invoices         # List user's invoices
POST   /api/v1/invoices/{id}/resend        # Resend invoice email
```

#### Refund APIs
```
POST   /api/v1/refunds                     # Initiate refund
GET    /api/v1/refunds/{id}                # Get refund details
GET    /api/v1/payments/{id}/refunds       # List refunds for payment
POST   /api/v1/refunds/{id}/approve        # Approve refund (admin)
POST   /api/v1/refunds/{id}/reject         # Reject refund (admin)
```

#### Admin APIs
```
GET    /api/v1/admin/payments              # Search/list payments
GET    /api/v1/admin/settlements           # View settlements
GET    /api/v1/admin/chargebacks           # List chargebacks
POST   /api/v1/admin/chargebacks/{id}/respond  # Respond to chargeback
GET    /api/v1/admin/revenue/summary       # Revenue summary report
```

### 8.2 Webhook Endpoints
```
POST   /webhooks/razorpay                  # Razorpay payment callbacks
POST   /webhooks/payu                      # PayU payment callbacks
```

---

## 9. Domain Events

### 9.1 Published Events

| Event | Trigger | Payload |
|-------|---------|---------|
| `billing.payment.initiated` | Payment creation | payment_id, user_id, amount, source |
| `billing.payment.completed` | Payment success | payment_id, user_id, amount, source, invoice_id |
| `billing.payment.failed` | Payment failure | payment_id, user_id, reason |
| `billing.invoice.issued` | Invoice generation | invoice_id, user_id, amount, items |
| `billing.refund.initiated` | Refund request | refund_id, payment_id, amount, reason |
| `billing.refund.completed` | Refund processed | refund_id, payment_id, amount |
| `billing.chargeback.received` | Chargeback notification | chargeback_id, payment_id, amount |
| `billing.chargeback.resolved` | Dispute resolution | chargeback_id, outcome |

### 9.2 Subscribed Events

| Event | Source | Action |
|-------|--------|--------|
| `sales.subscription.created` | Sales | Create pending payment |
| `homeservices.booking.confirmed` | HomeServices | Create pending payment |
| `society.maintenance.due` | Society | Generate maintenance invoice |
| `entitlements.plan.renewed` | Entitlements | Process renewal payment |

---

## 10. Data Flow Diagrams

### 10.1 Payment Flow

```
+--------+    +----------+    +---------+    +----------+    +--------+
|  User  |--->| Checkout |--->| Payment |--->| Gateway  |--->|  Bank  |
+--------+    +----------+    +---------+    +----------+    +--------+
                  |               |               |
                  v               v               v
              +-------+      +--------+      +--------+
              | Cart  |      | Events |      |Webhook |
              +-------+      +--------+      +--------+
                                 |               |
                                 v               v
                            +---------+    +---------+
                            |Entitle- |    | Invoice |
                            | ments   |    |   Gen   |
                            +---------+    +---------+
```

### 10.2 Refund Flow

```
+--------+    +---------+    +----------+    +---------+    +--------+
|  User  |--->| Request |--->| Approval |--->| Process |--->| Gateway|
+--------+    +---------+    +----------+    +---------+    +--------+
                                  |              |
                                  v              v
                             +--------+    +--------+
                             | Admin  |    | Credit |
                             | Review |    |  Note  |
                             +--------+    +--------+
```

---

## 11. Acceptance Criteria Summary

### 11.1 MVP Acceptance Criteria

- [ ] Users can complete payments via UPI, cards, and netbanking
- [ ] GST-compliant invoices are generated for all payments
- [ ] Users can view and download their payment history
- [ ] Full and partial refunds can be processed
- [ ] Payment confirmation notifications are sent
- [ ] Admin can view and manage payments
- [ ] All transactions are logged with audit trail

### 11.2 Phase 2 Acceptance Criteria

- [ ] Chargeback handling workflow is operational
- [ ] Revenue categorization is accurate
- [ ] Ledger events are emitted for all transactions
- [ ] Reconciliation reports are available
- [ ] B2B invoices support GSTIN input

---

## 12. Risks and Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Payment gateway downtime | High | Medium | Multi-gateway failover setup |
| GST rate changes | Medium | Medium | Configurable rate management |
| Chargeback fraud | High | Low | 3D Secure, fraud detection |
| Data breach | Critical | Low | PCI compliance, encryption |
| Reconciliation errors | High | Medium | Automated matching, alerts |
| Refund abuse | Medium | Medium | Refund policy enforcement, limits |

---

## 13. Glossary

| Term | Definition |
|------|------------|
| UPI | Unified Payments Interface - India's real-time payment system |
| GSTIN | Goods and Services Tax Identification Number |
| HSN | Harmonized System of Nomenclature - product classification |
| SAC | Services Accounting Code - service classification |
| CGST | Central Goods and Services Tax |
| SGST | State Goods and Services Tax |
| IGST | Integrated Goods and Services Tax |
| PCI DSS | Payment Card Industry Data Security Standard |
| Chargeback | Dispute raised by cardholder with issuing bank |
| Settlement | Transfer of funds from gateway to merchant account |
| Tokenization | Replacing sensitive data with non-sensitive tokens |

---

## 14. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | Product Team | Initial draft |

---

## 15. Appendices

### Appendix A: GST Rate Reference

| Service Category | HSN/SAC Code | GST Rate |
|------------------|--------------|----------|
| Platform subscription | 998314 | 18% |
| Rental agreement service | 998213 | 18% |
| Home services (cleaning) | 998533 | 18% |
| Home services (movers) | 996511 | 18% |
| Property management | 998315 | 18% |

### Appendix B: Payment Gateway Comparison

| Feature | Razorpay | PayU |
|---------|----------|------|
| UPI | Yes | Yes |
| Cards | Yes | Yes |
| Netbanking | Yes | Yes |
| Settlement cycle | T+2 | T+2 |
| Refund timeline | 5-7 days | 5-7 days |
| Chargeback support | Yes | Yes |

### Appendix C: Invoice Number Format

Format: `MSQFT/{FYEAR}/{TYPE}/{SEQUENCE}`

Examples:
- `MSQFT/2526/INV/000001` - Invoice
- `MSQFT/2526/CN/000001` - Credit Note
- `MSQFT/2526/RCP/000001` - Receipt
