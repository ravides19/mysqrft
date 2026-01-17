# Platform Domain Definitions

## Overview
This document defines the 22 core domains for the rental/real estate marketplace platform, organized by their primary business capabilities and suggested implementation phases.

---

## Core Domains

### 1. Auth
**Primary Goal:** Login + Identity Proof

**Responsibilities:**
- Register as a user with firstname, lastname, email, mobile_number (*required)
- Password management to set the password
- Magic link based email login
- Multi-factor authentication (optional)
- Account recovery workflows like reset password

**Key Entities:** User, Session, Device, OTP, AuthProvider

---

### 2. UserManagement
**Primary Goal:** Profiles + Roles + Lifecycle

**Responsibilities:**
- User profile management across all roles:
  - Tenant, Buyer, Owner, SocietyAdmin, Resident, Guard, Vendor
  - RM (Relationship Manager), SupportAgent, Admin
- KYC-lite verification flows
- ID verification and owner verification badges
- User status management (active/suspended/blocked/deleted)
- User preferences (budget, locality, move-in date, family/bachelor)
- Consent management (data sharing, partner consent)

**Key Entities:** UserProfile, Role, Preference, Consent, VerificationBadge

---

### 3. Authorization
**Primary Goal:** Access Control Everywhere

**Responsibilities:**
- Role-Based Access Control (RBAC)
- Attribute-Based Access Control (ABAC) - city/society/team scoping
- Tenant-based access scoping
- Admin impersonation with strict controls
- Privileged action audit logs
- Permission evaluation engine

**Key Entities:** Permission, Policy, Role, AuditLog, ImpersonationSession

---

### 4. Inventory
**Primary Goal:** Property Supply + Lifecycle

**Responsibilities:**
- Listing creation, editing, pause, expiration, relisting
- Media upload, validation, and moderation
- Duplicate detection and listing merge
- Listing quality scoring
- Freshness rules enforcement
- Verification workflows (owner/property validation)

**Key Entities:** Listing, PropertyMedia, VerificationStatus, QualityScore, ListingHistory

---

### 5. Search
**Primary Goal:** Discovery Experience

**Responsibilities:**
- Property search with filters and sorting
- Map view integration (optional)
- Commute/distance layers (optional)
- Recommendation engine
- Similar listings suggestions
- Saved searches and alerts
- Locality guides and pricing insights (optional)

**Key Entities:** SearchQuery, Filter, SavedSearch, SearchAlert, Recommendation

---

### 6. Leads
**Primary Goal:** Direct Connect + Lead Lifecycle (Core Marketplace Engine)

**Responsibilities:**
- Lead creation ("contact owner", "request callback")
- Lead qualification and match rules
- Lead state management: new → contacted → scheduled → closed/lost
- Owner response handling
- Lead throttling mechanisms
- Anti-abuse controls:
  - Contact reveal limits
  - Cooldown periods
  - Spam detection and prevention

**Key Entities:** Lead, LeadState, ContactReveal, LeadThrottle, MatchRule

---

### 7. CRM
**Primary Goal:** Relationship Management + Pipeline

**Responsibilities:**
- Unified contact timeline (calls, chats, visits, notes)
- Requirements capture (tenant/buyer profiles)
- Follow-ups, reminders, and task management
- Pipeline views (by RM/team/city)
- Customer satisfaction tracking (NPS/feedback)
- Interaction history across all touchpoints

**Key Entities:** Contact, Interaction, Requirement, Task, Pipeline, FeedbackScore

---

### 8. Sales
**Primary Goal:** Monetization Conversion + Assisted Selling

**Responsibilities:**
- Plan upsell flows (tenant/owner subscription plans)
- RM-assisted workflows (requirements → shortlist → visit planning)
- Guarantee/refund policy handling
- Lead allocation rules and RM workload balancing
- Sales performance dashboards
- Commission tracking

**Key Entities:** SalesPipeline, Upsell, RMAllocation, SalesTarget, Commission

---

### 9. Marketing
**Primary Goal:** Growth Loops + Lifecycle Campaigns

**Responsibilities:**
- Referral program with credits and fraud detection
- Promotions, coupons, and pricing experiments
- Campaign landing pages (SEO/locality pages)
- Multi-channel campaign orchestration (push/SMS/WhatsApp/email)
- Attribution tracking and UTM parameter management
- A/B testing infrastructure

**Key Entities:** Campaign, Referral, Promotion, Coupon, Attribution, Experiment

---

### 10. Billing
**Primary Goal:** Money Movement + Invoices

**Responsibilities:**
- Checkout flows (UPI/cards/netbanking)
- Invoice and receipt generation
- GST field management
- Refunds (full and partial)
- Chargeback handling
- Revenue categorization (plans/services/society/finance)
- Ledger-ready event generation

**Key Entities:** Payment, Invoice, Refund, Transaction, RevenueCategory

---

### 11. Entitlements
**Primary Goal:** Plan-Based Access Control

**Responsibilities:**
- Plan catalog and add-on management
- Quota enforcement:
  - Contact unlock counts
  - Lead priority levels
  - RM assistance eligibility
- Expiry and renewal rules
- Credit wallet management (referral credits)
- Feature flags by plan (paywall gating)

**Key Entities:** Plan, Addon, Quota, Entitlement, CreditWallet, FeatureFlag

---

### 12. Communications
**Primary Goal:** Messaging + Calling + Notifications

**Responsibilities:**
- In-app chat (optional)
- Masked calling functionality (optional)
- Multi-channel notifications (SMS/WhatsApp/email/push)
- Message templates and localization
- User notification preferences
- Do-not-disturb settings
- Delivery tracking and retry logic

**Key Entities:** Message, Notification, Template, Channel, DeliveryStatus

---

### 13. Scheduling
**Primary Goal:** Visits + Appointments

**Responsibilities:**
- Visit scheduling and confirmations
- Reschedule and cancellation handling
- Calendar coordination (owner/tenant/RM)
- Post-visit feedback capture
- Visit history and outcomes tracking
- Availability management

**Key Entities:** Visit, Appointment, Calendar, Availability, VisitFeedback

---

### 14. LegalDocs
**Primary Goal:** Rental Agreement + Documentation

**Responsibilities:**
- Rental agreement generation from templates
- eSign/stamp/registration workflows (state-dependent)
- Police verification and background checks (optional)
- Document vault with sharing controls
- Template management
- Compliance tracking

**Key Entities:** Agreement, Template, eSignature, Document, Verification

---

### 15. HomeServices
**Primary Goal:** Movers/Painting/Cleaning + Fulfillment

**Responsibilities:**
- Service catalog, quotes, and bookings
- Partner allocation and dispatch
- Service tracking and status updates
- SLA management
- Service completion and ratings
- Dispute and refund workflows
- Partner payout coordination

**Key Entities:** Service, Booking, ServiceProvider, Quote, Rating, Dispatch

---

### 16. PropertyManagement
**Primary Goal:** Recurring Owner Services

**Responsibilities:**
- Property management onboarding and contracts
- Rent collection tracking and receipts
- Maintenance ticket management
- Vendor coordination
- Owner statement generation
- Audit trail maintenance
- PM fee calculation (fixed/percentage)
- Contract renewals

**Key Entities:** PMContract, RentCollection, MaintenanceTicket, OwnerStatement, PMFee

---

### 17. Society
**Primary Goal:** Community Management SaaS (NoBrokerHood)

**Responsibilities:**
- Role management (admin/committee/resident/guard/vendor)
- Visitor management and approvals
- Maintenance billing and collections
- Complaints/helpdesk system
- Announcements and polls
- Staff onboarding and training workflows
- Future: Hardware integration (gates, intercoms)

**Key Entities:** Society, Resident, Visitor, MaintenanceBill, Complaint, Announcement

---

### 18. FinancialServices
**Primary Goal:** Loan/Finance Referrals

**Responsibilities:**
- Loan eligibility capture and assessment
- Consent logging for financial data
- Partner routing (banks/DSAs)
- Application status tracking (applied → approved → disbursed)
- Commission reconciliation
- Compliance logging (data sharing, regulatory consent)

**Key Entities:** LoanApplication, Eligibility, LenderPartner, Commission, Consent

---

### 19. Support
**Primary Goal:** Customer Support + Dispute Resolution

**Responsibilities:**
- Ticket creation and categorization
- Help center and guided resolution flows
- SLA tracking and escalation management
- Dispute handling (services, refunds, fraud)
- Quality assurance
- Macros and internal notes
- Agent performance tracking

**Key Entities:** Ticket, Category, SLA, Dispute, Resolution, Macro

---

### 20. TrustSafety
**Primary Goal:** Platform Integrity

**Responsibilities:**
- Content moderation queues (listings/users/media)
- Fraud detection signals and automated actions
- User reports and blocking mechanisms
- Investigation workflows
- Rate limiting and throttling
- Device fingerprinting (optional)
- Compliance and data retention rules

**Key Entities:** ModerationQueue, FraudSignal, Report, Investigation, RateLimit

---

### 21. Ops
**Primary Goal:** Internal Admin + Partner Operations

**Responsibilities:**
- Admin console (users/listings/leads/payments management)
- RM management (rosters, allocation, targets)
- Partner management (service vendors, societies, lenders)
- Pricing and configuration management
- Plan and entitlement configuration
- Promotion management
- Feature flags and experiment controls
- Operational dashboards

**Key Entities:** AdminAction, RMRoster, PartnerConfig, PricingRule, ConfigSetting

---

### 22. Analytics
**Primary Goal:** Measurement + Decision Support

**Responsibilities:**
- Funnel analysis (search → lead → visit → close → revenue)
- Cohort analysis (by city/locality/channel/plan)
- Unit economics (CAC, ARPU, churn, attach rates)
- RM performance and quality metrics
- Fraud/abuse analytics
- Anomaly detection and alerts
- Custom reporting and dashboards

**Key Entities:** Metric, Funnel, Cohort, Report, Alert, Dashboard

---

## Implementation Phases

### Phase 1: MVP Foundation
**Goal:** Core marketplace functionality
- Auth
- UserManagement
- Authorization
- Inventory
- Search
- Leads
- Communications

### Phase 2: Monetization
**Goal:** Revenue generation capabilities
- Entitlements
- Billing
- Sales (subscription flows)

### Phase 3: Assisted Sales
**Goal:** High-touch workflows
- Scheduling
- CRM (deepened)

### Phase 4: Service Expansion
**Goal:** Adjacent revenue streams
- LegalDocs
- HomeServices
- PropertyManagement

### Phase 5: Platform Expansion
**Goal:** New business lines
- Society
- FinancialServices

### Phase 6: Operations & Scale
**Goal:** Platform maturity
- Support
- TrustSafety
- Ops (admin tooling)
- Analytics (comprehensive)

**Note:** Support, TrustSafety, and basic Analytics should be implemented in parallel with early phases, then deepened over time.

---

## Domain Relationships

### Critical Dependencies
1. **Auth → UserManagement → Authorization** (foundation for all)
2. **Inventory → Search → Leads** (core marketplace flow)
3. **Entitlements → Billing** (monetization backbone)
4. **Leads → CRM → Sales** (conversion pipeline)
5. **Communications** (cross-cutting, needed by most domains)

### Integration Points
- **Billing** integrates with: Sales, HomeServices, Society, FinancialServices
- **Analytics** consumes events from: all domains
- **Communications** serves: Leads, CRM, Scheduling, Support, Society
- **TrustSafety** monitors: Inventory, Leads, UserManagement, Communications
- **Ops** manages configuration for: all domains

---

## Cross-Cutting Concerns

### Shared Infrastructure
- Event bus for domain events
- Audit logging framework
- Rate limiting and throttling
- Feature flag system
- Configuration management
- Multi-tenancy support (city/society scoping)

### Data Privacy & Compliance
- Consent management (UserManagement)
- Data retention policies (TrustSafety)
- PII handling standards
- GDPR/local compliance requirements

### Quality Attributes
- High availability for: Auth, Search, Leads
- Strong consistency for: Billing, Entitlements
- Eventual consistency acceptable for: Analytics, Marketing campaigns
- Real-time requirements: Communications, visitor management (Society)

---

## Next Steps

1. Define domain boundaries and ownership
2. Establish communication patterns between domains
3. Design event schemas for domain events
4. Create API contracts for domain services
5. Set up monitoring and observability per domain
6. Define data ownership and sharing policies