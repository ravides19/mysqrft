# Platform Domain Definitions

## Status & Summary

**Document Status:** Active  
**Last Updated:** January 2026  
**Total Domains:** 23  
**Implementation Phase:** Phase 1 - MVP Foundation

### Documentation Status Overview

| # | Domain | PRD Status | Implementation Status | Phase |
|---|--------|-----------|---------------------|-------|
| 001 | Auth | ✅ Complete | 📋 Tasks Created | Phase 1 |
| 002 | KYC | ✅ Complete | Not Started | Phase 1 |
| 003 | UserManagement | ✅ Complete | Not Started | Phase 1 |
| 004 | Authorization | ✅ Complete | Not Started | Phase 1 |
| 005 | Inventory | ✅ Complete | Not Started | Phase 1 |
| 006 | Search | ✅ Complete | Not Started | Phase 1 |
| 007 | Leads | ✅ Complete | Not Started | Phase 1 |
| 008 | Communications | ✅ Complete | Not Started | Phase 1 |
| 009 | Entitlements | ✅ Complete | Not Started | Phase 2 |
| 010 | Billing | ✅ Complete | Not Started | Phase 2 |
| 011 | Sales | ✅ Complete | Not Started | Phase 2 |
| 012 | Marketing | ✅ Complete | Not Started | Phase 2+ |
| 013 | Scheduling | ✅ Complete | Not Started | Phase 3 |
| 014 | CRM | ✅ Complete | Not Started | Phase 3 |
| 015 | LegalDocs | ✅ Complete | Not Started | Phase 4 |
| 016 | HomeServices | ✅ Complete | Not Started | Phase 4 |
| 017 | PropertyManagement | ✅ Complete | Not Started | Phase 4 |
| 018 | Society | ✅ Complete | Not Started | Phase 5 |
| 019 | FinancialServices | ✅ Complete | Not Started | Phase 5 |
| 020 | Support | ✅ Complete | Not Started | Phase 6 |
| 021 | TrustSafety | ✅ Complete | Not Started | Phase 6 |
| 022 | Ops | ✅ Complete | Not Started | Phase 6 |
| 023 | Analytics | ✅ Complete | Not Started | Phase 6 |
| 024 | Geography | ✅ Complete | Not Started | Phase 1 |

**Legend:**
- ✅ Complete: Product Requirements Document completed
- 🚧 In Progress: PRD or implementation in progress
- ⏸️ On Hold: Work paused
- 📋 Draft: PRD in draft/review state
- ❌ Not Started: PRD not yet created

### Summary

This document defines the 23 core domains for the MySqrft rental/real estate marketplace platform, organized by their primary business capabilities and suggested implementation phases. All domains have completed Product Requirements Documents (PRDs) located in `docs/domain/` directory.

**Phase 1 (MVP Foundation)** includes 8 domains: Auth, UserManagement, Authorization, Geography, Inventory, Search, Leads, and Communications - forming the core marketplace functionality.

**Phase 2 (Monetization)** includes 3 domains: Entitlements, Billing, and Sales - enabling revenue generation.

**Phase 3 (Assisted Sales)** includes 2 domains: Scheduling and CRM - supporting high-touch workflows.

**Phase 4 (Service Expansion)** includes 3 domains: LegalDocs, HomeServices, and PropertyManagement - adjacent revenue streams.

**Phase 5 (Platform Expansion)** includes 2 domains: Society and FinancialServices - new business lines.

**Phase 6 (Operations & Scale)** includes 4 domains: Support, TrustSafety, Ops, and Analytics - platform maturity.

Additional supporting domains (KYC, Marketing) are integrated throughout the phases as needed.

---

## Overview
This document defines the 22 core domains for the rental/real estate marketplace platform, organized by their primary business capabilities and suggested implementation phases.

---

## Core Domains

### 001. Auth
**Primary Goal:** Login + Identity Proof  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/001_auth.md`](docs/domain/001_auth.md)

**Responsibilities:**
- User registration with required fields (firstname, lastname, email, mobile_number)
- Password-based authentication with strength policies and secure hashing
- Magic link based email login (passwordless authentication)
- OAuth/social login integration (Google, Facebook, Apple) (optional)
- Multi-factor authentication (MFA) with TOTP/OTP support
- Account recovery workflows (password reset via email/SMS)
- Email verification for account activation (basic verification for auth)
- Phone verification via OTP for account activation (basic verification for auth)
- Session management (creation, refresh, expiration, revocation)
- Device management and trusted device tracking
- Remember me functionality with secure token storage
- Account locking after failed login attempts
- Logout and session termination (single and all devices)
- Token management (JWT, refresh tokens, access tokens)
- OTP generation and validation for MFA and account recovery
- Authentication audit logging and security event tracking

**Key Entities:** User, Session, Device, OTP, AuthProvider, AuthToken, LoginAttempt, SecurityEvent

### 002. KYC
**Primary Goal:** User Identity Verification + Compliance  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/002_kyc.md`](docs/domain/002_kyc.md)

**Responsibilities:**
- Email and phone number verification (basic, self-service)
- ID document upload and verification (manual/automated)
- Indian identity verification (Aadhaar, PAN, Driving License)
- Comprehensive verification with face match and liveness detection
- Multi-level KYC requirements by user type:
  - Property Owners (for listing properties)
  - Tenants/Buyers (for renting/buying)
  - Service Vendors (for HomeServices)
- Verification status management (pending, verified, expired, rejected)
- Verification renewal and expiration tracking
- Compliance tracking and audit logging
- Consent management for identity verification
- Integration with external KYC providers (post-MVP)

**Key Entities:** KYCVerification, VerificationDocument, VerificationLevel, KYCProvider, VerificationStatus, VerificationConsent

**Note:** KYC provider integration can be added after MVP.

---

### 003. UserManagement
**Primary Goal:** Profiles + Roles + Lifecycle  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/003_user-management.md`](docs/domain/003_user-management.md)

**Responsibilities:**
- User profile management across all roles:
  - Tenant, Buyer, Owner, SocietyAdmin, Resident, Guard, Vendor
  - RM (Relationship Manager), SupportAgent, Admin
- Detailed profile fields (photo, bio, contact information, address)
- Role-specific profile fields and customizations per user type
- Profile completeness tracking and scoring
- Profile photo upload, validation, and moderation
- Address management with city/locality/landmark support
- Emergency contact information management
- Profile visibility and privacy settings
- Profile search and discovery settings
- Multi-role support (users can have multiple roles simultaneously)
- Role activation and deactivation workflows
- Role-based profile switching
- User status management (active/suspended/blocked/deleted)
- User onboarding flows for different user types
- Profile completion workflows and guided tours
- User activation and first-time setup
- Profile update and edit workflows
- Account suspension and reactivation
- Account deletion and data retention policies
- Inactive user management and re-engagement
- Integration with KYC domain for verification status
- Verification badge display and management
- Owner verification badges (property ownership verification)
- Profile verification indicators
- Trust score calculation and display
- Search preferences (budget range, locality preferences, property types)
- Lifestyle preferences (family/bachelor, pets allowed, furnished/unfurnished)
- Move-in timeline and urgency preferences
- Communication preferences (channel, frequency, do-not-disturb)
- Notification preferences (push, email, SMS, WhatsApp)
- Language and localization preferences
- Consent management for data sharing (with partners, advertisers)
- Communication consent management (marketing, transactional)
- Third-party service consent
- Consent withdrawal and opt-out workflows
- Consent history and audit trail
- GDPR/local compliance consent tracking

**Key Entities:** UserProfile, Role, Preference, Consent, VerificationBadge, Address, ProfilePhoto, ProfileCompleteness, UserRole, TrustScore, ConsentHistory, OnboardingFlow

---

### 004. Authorization
**Primary Goal:** Access Control Everywhere  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/004_authorization.md`](docs/domain/004_authorization.md)

**Responsibilities:**
- Role-Based Access Control (RBAC) with hierarchical role inheritance
- Attribute-Based Access Control (ABAC) with city/society/team scoping
- Tenant-based access scoping and multi-tenant isolation
- Permission management with granular resource-level controls
- Policy definition, versioning, and enforcement
- Permission evaluation engine with caching and optimization
- Resource-level permissions (listings, leads, users, properties)
- API endpoint access control and rate limiting
- Feature flag integration with permission checks
- Entitlement-based access control (plan-based feature gating)
- Context-based permissions (time, location, IP-based restrictions)
- Permission inheritance and role hierarchies
- Access delegation and temporary permissions
- Admin impersonation with strict controls and audit trails
- Impersonation session management with timeout and approval workflows
- Privileged action audit logs and compliance tracking
- Access request workflows and approval processes
- Permission revocation and cleanup on role changes
- Resource ownership verification and transfer
- Cross-tenant access prevention and validation
- Permission testing and simulation for policy validation
- Access control list (ACL) management for shared resources
- Dynamic permission calculation based on user attributes
- Integration with Auth domain for identity verification
- Integration with UserManagement domain for role assignments
- Integration with Entitlements domain for plan-based access

**Key Entities:** Permission, Policy, Role, AuditLog, ImpersonationSession, ResourcePermission, AccessPolicy, PermissionGrant, AccessRequest, PolicyVersion, PermissionCache, ResourceOwner

---

### 005. Inventory
**Primary Goal:** Property Supply + Lifecycle  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/005_inventory.md`](docs/domain/005_inventory.md)

**Responsibilities:**
- Listing creation, editing, pause, expiration, relisting
- Media upload, validation, and moderation
- Duplicate detection and listing merge
- Listing quality scoring
- Freshness rules enforcement
- Verification workflows (owner/property validation)

**Key Entities:** Listing, PropertyMedia, VerificationStatus, QualityScore, ListingHistory

---

### 006. Search
**Primary Goal:** Discovery Experience  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/006_search.md`](docs/domain/006_search.md)

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

### 007. Leads
**Primary Goal:** Direct Connect + Lead Lifecycle (Core Marketplace Engine)  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/007_leads.md`](docs/domain/007_leads.md)

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

### 014. CRM
**Primary Goal:** Relationship Management + Pipeline  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/014_crm.md`](docs/domain/014_crm.md)

**Responsibilities:**
- Unified contact timeline (calls, chats, visits, notes)
- Requirements capture (tenant/buyer profiles)
- Follow-ups, reminders, and task management
- Pipeline views (by RM/team/city)
- Customer satisfaction tracking (NPS/feedback)
- Interaction history across all touchpoints

**Key Entities:** Contact, Interaction, Requirement, Task, Pipeline, FeedbackScore

---

### 011. Sales
**Primary Goal:** Monetization Conversion + Assisted Selling  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/011_sales.md`](docs/domain/011_sales.md)

**Responsibilities:**
- Plan upsell flows (tenant/owner subscription plans)
- RM-assisted workflows (requirements → shortlist → visit planning)
- Guarantee/refund policy handling
- Lead allocation rules and RM workload balancing
- Sales performance dashboards
- Commission tracking

**Key Entities:** SalesPipeline, Upsell, RMAllocation, SalesTarget, Commission

---

### 012. Marketing
**Primary Goal:** Growth Loops + Lifecycle Campaigns  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/012_marketing.md`](docs/domain/012_marketing.md)

**Responsibilities:**
- Referral program with credits and fraud detection
- Promotions, coupons, and pricing experiments
- Campaign landing pages (SEO/locality pages)
- Multi-channel campaign orchestration (push/SMS/WhatsApp/email)
- Attribution tracking and UTM parameter management
- A/B testing infrastructure

**Key Entities:** Campaign, Referral, Promotion, Coupon, Attribution, Experiment

---

### 010. Billing
**Primary Goal:** Money Movement + Invoices  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/010_billing.md`](docs/domain/010_billing.md)

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

### 009. Entitlements
**Primary Goal:** Plan-Based Access Control  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/009_entitlements.md`](docs/domain/009_entitlements.md)

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

### 008. Communications
**Primary Goal:** Messaging + Calling + Notifications  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/008_communications.md`](docs/domain/008_communications.md)

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

### 013. Scheduling
**Primary Goal:** Visits + Appointments  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/013_scheduling.md`](docs/domain/013_scheduling.md)

**Responsibilities:**
- Visit scheduling and confirmations
- Reschedule and cancellation handling
- Calendar coordination (owner/tenant/RM)
- Post-visit feedback capture
- Visit history and outcomes tracking
- Availability management

**Key Entities:** Visit, Appointment, Calendar, Availability, VisitFeedback

---

### 015. LegalDocs
**Primary Goal:** Rental Agreement + Documentation  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/015_legal-docs.md`](docs/domain/015_legal-docs.md)

**Responsibilities:**
- Rental agreement generation from templates
- eSign/stamp/registration workflows (state-dependent)
- Police verification and background checks (optional)
- Document vault with sharing controls
- Template management
- Compliance tracking

**Key Entities:** Agreement, Template, eSignature, Document, Verification

---

### 016. HomeServices
**Primary Goal:** Movers/Painting/Cleaning + Fulfillment  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/016_home-services.md`](docs/domain/016_home-services.md)

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

### 017. PropertyManagement
**Primary Goal:** Recurring Owner Services  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/017_property-management.md`](docs/domain/017_property-management.md)

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

### 018. Society
**Primary Goal:** Community Management SaaS (NoBrokerHood)  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/018_society.md`](docs/domain/018_society.md)

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

### 019. FinancialServices
**Primary Goal:** Loan/Finance Referrals  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/019_financial-services.md`](docs/domain/019_financial-services.md)

**Responsibilities:**
- Loan eligibility capture and assessment
- Consent logging for financial data
- Partner routing (banks/DSAs)
- Application status tracking (applied → approved → disbursed)
- Commission reconciliation
- Compliance logging (data sharing, regulatory consent)

**Key Entities:** LoanApplication, Eligibility, LenderPartner, Commission, Consent

---

### 020. Support
**Primary Goal:** Customer Support + Dispute Resolution  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/020_support.md`](docs/domain/020_support.md)

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

### 021. TrustSafety
**Primary Goal:** Platform Integrity  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/021_trust-safety.md`](docs/domain/021_trust-safety.md)

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

### 022. Ops
**Primary Goal:** Internal Admin + Partner Operations  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/022_ops.md`](docs/domain/022_ops.md)

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

### 023. Analytics
**Primary Goal:** Measurement + Decision Support  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/023_analytics.md`](docs/domain/023_analytics.md)

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

### 024. Geography
**Primary Goal:** Location Data + Geospatial Services  
**Status:** ✅ PRD Complete | 📋 Implementation: Not Started  
**PRD:** [`docs/domain/024_geography.md`](docs/domain/024_geography.md)

**Responsibilities:**
- Country, state, city, and locality hierarchy management
- Geospatial data storage and indexing (coordinates, boundaries, polygons)
- Location-based search and filtering (radius, proximity, boundaries)
- Address validation and geocoding (address → coordinates)
- Reverse geocoding (coordinates → address)
- Locality metadata (pincodes, landmarks, neighborhoods)
- Geographic boundary management (city limits, locality boundaries)
- Location-based recommendations and insights
- Multi-city and multi-country support
- Geographic data import and synchronization

**Key Entities:** Country, State, City, Locality, Address, Geocode, Boundary, Landmark, Pincode, GeographicHierarchy

---

## Implementation Phases

### Phase 1: MVP Foundation
**Goal:** Core marketplace functionality
- Auth
- UserManagement
- Authorization
- Geography
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
2. **Geography** (foundation for location-based features across all domains)
3. **Inventory → Search → Leads** (core marketplace flow)
4. **Entitlements → Billing** (monetization backbone)
5. **Leads → CRM → Sales** (conversion pipeline)
6. **Communications** (cross-cutting, needed by most domains)

### Integration Points
- **Geography** provides location data to: Inventory, Search, Leads, UserManagement, Scheduling, Society, HomeServices
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