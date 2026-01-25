# UserManagement Domain - Product Requirements Document

## Document Information
| Field | Value |
|-------|-------|
| Domain | UserManagement |
| Version | 1.0 |
| Status | Complete |
| Last Updated | 2026-01-17 |
| Platform | MySqrft |

---

## 1. Overview

### 1.1 Purpose
The UserManagement domain is responsible for managing user profiles, roles, and lifecycle across the MySqrft platform. It provides comprehensive profile management capabilities for all user types, handles multi-role support, manages user states throughout their journey, and maintains trust and verification systems.

### 1.2 Primary Goal
**Profiles + Roles + Lifecycle** - Enable complete user identity management from onboarding through the entire user journey, supporting multiple concurrent roles and maintaining trust within the MySqrft ecosystem.

### 1.3 Scope
This domain covers:
- User profile creation, management, and deletion
- Role assignment, activation, and deactivation
- User lifecycle state management
- Verification and trust scoring
- Preferences and consent management
- Profile completeness and quality tracking

### 1.4 Target Users
| Role | Description |
|------|-------------|
| Tenant | Users seeking rental properties |
| Buyer | Users looking to purchase properties |
| Owner | Property owners listing on MySqrft |
| SocietyAdmin | Administrators managing residential societies |
| Resident | Verified residents of properties/societies |
| Guard | Security personnel at gated communities |
| Vendor | Service providers (maintenance, cleaning, etc.) |
| RM | Relationship Managers handling client accounts |
| SupportAgent | Customer support team members |
| Admin | Platform administrators |

---

## 2. Goals

### 2.1 Business Goals
| ID | Goal | Success Indicator |
|----|------|-------------------|
| BG-01 | Increase user trust and platform credibility | Trust score adoption > 80% of active users |
| BG-02 | Streamline user onboarding across all roles | Onboarding completion rate > 85% |
| BG-03 | Enable multi-role user engagement | 30% of users have 2+ active roles |
| BG-04 | Maintain data compliance and user privacy | Zero privacy violations, 100% consent tracking |
| BG-05 | Reduce account-related support tickets | 40% reduction in profile/account issues |

### 2.2 User Goals
| ID | Goal | Benefit |
|----|------|---------|
| UG-01 | Easy profile setup and management | Quick onboarding, minimal friction |
| UG-02 | Clear understanding of profile completeness | Guided completion, better visibility |
| UG-03 | Flexible role management | Seamless switching between user types |
| UG-04 | Control over personal data and privacy | Trust in platform, GDPR compliance |
| UG-05 | Visible trust and verification status | Credibility in transactions |

### 2.3 Technical Goals
| ID | Goal | Measure |
|----|------|---------|
| TG-01 | Profile operations < 200ms response time | P95 latency monitoring |
| TG-02 | Support 1M+ user profiles | Horizontal scalability |
| TG-03 | Real-time profile sync across services | Event-driven updates < 100ms |
| TG-04 | Secure PII handling | Encryption at rest and transit |
| TG-05 | Audit trail for all profile changes | 100% change logging |

---

## 3. Key Features

### 3.1 Profile Management
| Feature | Description | Priority |
|---------|-------------|----------|
| Profile Creation | Create user profiles with basic and extended information | P0 |
| Profile Editing | Update profile fields with validation | P0 |
| Profile Photo Management | Upload, crop, validate, and moderate profile photos | P0 |
| Address Management | Add, edit, and manage multiple addresses with locality support | P0 |
| Emergency Contacts | Store and manage emergency contact information | P1 |
| Profile Completeness | Track and display profile completion percentage | P1 |
| Profile Scoring | Calculate profile quality score based on completeness and verification | P1 |

### 3.2 Role Management
| Feature | Description | Priority |
|---------|-------------|----------|
| Role Assignment | Assign roles to users based on eligibility | P0 |
| Multi-Role Support | Allow users to hold multiple roles simultaneously | P0 |
| Role Activation/Deactivation | Enable or disable specific roles for a user | P0 |
| Role-Specific Fields | Manage custom fields per role type | P1 |
| Role Switching | Seamless context switching between active roles | P1 |
| Role History | Track role changes over time | P2 |

### 3.3 User Lifecycle
| Feature | Description | Priority |
|---------|-------------|----------|
| User Onboarding | Role-specific onboarding flows | P0 |
| Status Management | Manage active/suspended/blocked/deleted states | P0 |
| Account Suspension | Suspend accounts with reason tracking | P0 |
| Account Reactivation | Reactivate suspended accounts | P0 |
| Account Deletion | Soft delete with data retention policies | P0 |
| Lifecycle Events | Emit events for state transitions | P1 |

### 3.4 Trust and Verification
| Feature | Description | Priority |
|---------|-------------|----------|
| Verification Badge Display | Show verification badges on profiles | P0 |
| Trust Score Calculation | Compute trust scores from multiple signals | P1 |
| Trust Score Display | Display trust scores appropriately per context | P1 |
| Badge Management | Admin tools to grant/revoke badges | P1 |

### 3.5 Preferences and Consent
| Feature | Description | Priority |
|---------|-------------|----------|
| Search Preferences | Store property search preferences | P1 |
| Lifestyle Preferences | Capture lifestyle and community preferences | P1 |
| Move-in Timeline | Track expected move-in dates | P1 |
| Communication Preferences | Manage notification and communication channels | P0 |
| Consent Management | Track and manage data sharing consents | P0 |
| Consent History | Maintain audit trail of consent changes | P0 |

### 3.6 Privacy Controls
| Feature | Description | Priority |
|---------|-------------|----------|
| Profile Visibility | Control who can view profile information | P1 |
| Field-Level Privacy | Set visibility per profile field | P2 |
| Data Export | Allow users to export their data | P1 |
| Privacy Dashboard | Central view of all privacy settings | P2 |

---

## 4. User Stories

### 4.1 Profile Management Stories

#### US-PM-001: Create User Profile
**As a** new user
**I want to** create my profile with basic information
**So that** I can start using MySqrft services

**Acceptance Criteria:**
- User can enter name, email, phone number, and password
- Profile photo upload is optional but encouraged
- Basic validation on all required fields
- Profile is created with "active" status
- Welcome notification is sent upon creation
- Profile completeness score is calculated

#### US-PM-002: Upload Profile Photo
**As a** registered user
**I want to** upload and manage my profile photo
**So that** other users can identify me

**Acceptance Criteria:**
- Support for JPG, PNG, and WebP formats
- Maximum file size of 5MB
- Automatic image cropping tool provided
- Photo is validated for appropriate content
- Previous photos are retained in history
- Photo displays across all platform contexts

#### US-PM-003: Manage Addresses
**As a** user
**I want to** add and manage multiple addresses
**So that** I can receive services at different locations

**Acceptance Criteria:**
- Add up to 5 addresses per user
- Each address includes street, city, locality, landmark, and PIN code
- Set one address as primary/default
- Address autocomplete using location services
- Addresses can be edited or deleted
- Address changes trigger relevant notifications

#### US-PM-004: Track Profile Completeness
**As a** user
**I want to** see my profile completeness score
**So that** I know what information I still need to provide

**Acceptance Criteria:**
- Completeness percentage displayed on profile page
- Breakdown of missing fields shown
- Actionable prompts to complete missing sections
- Score updates in real-time as fields are added
- Role-specific completeness tracking
- Incentives displayed for reaching completion milestones

#### US-PM-005: Manage Emergency Contacts
**As a** user
**I want to** add emergency contact information
**So that** I can be reached in urgent situations

**Acceptance Criteria:**
- Add up to 3 emergency contacts
- Capture name, relationship, and phone number
- Optionally add email address
- Set priority order for contacts
- Emergency contacts visible to authorized personnel only

### 4.2 Role Management Stories

#### US-RM-001: Add New Role
**As a** user with an existing account
**I want to** add a new role to my profile
**So that** I can access additional MySqrft features

**Acceptance Criteria:**
- User can request a new role from available options
- Role-specific eligibility checks are performed
- Required role-specific fields are prompted
- Role is added in "pending" or "active" state based on type
- User receives confirmation of role addition
- Existing roles remain unaffected

#### US-RM-002: Switch Between Roles
**As a** multi-role user
**I want to** switch between my active roles
**So that** I can access role-specific features

**Acceptance Criteria:**
- Role switcher visible in app header/navigation
- Current active role clearly indicated
- Switching is instant with no page reload
- Context and permissions update immediately
- Last used role is remembered for next session

#### US-RM-003: Deactivate a Role
**As a** multi-role user
**I want to** deactivate a role I no longer need
**So that** my profile reflects my current usage

**Acceptance Criteria:**
- User can deactivate non-primary roles
- Confirmation required before deactivation
- Role-specific data is retained but hidden
- Role can be reactivated later
- Other active roles remain unaffected
- Notification sent confirming deactivation

### 4.3 User Lifecycle Stories

#### US-UL-001: Complete Onboarding Flow
**As a** new user
**I want to** complete a guided onboarding flow
**So that** I can set up my account correctly for my use case

**Acceptance Criteria:**
- Onboarding flow varies by primary role
- Progress indicator shows current step
- User can skip optional steps
- Mandatory steps must be completed
- Onboarding can be resumed if interrupted
- Completion triggers celebration and next steps

#### US-UL-002: Request Account Deletion
**As a** user
**I want to** delete my account
**So that** my data is removed from MySqrft

**Acceptance Criteria:**
- Deletion request requires password confirmation
- 30-day grace period before permanent deletion
- User can cancel deletion during grace period
- User is informed of data retention policies
- Active transactions must be resolved first
- Confirmation email sent upon request

#### US-UL-003: Reactivate Suspended Account
**As a** suspended user
**I want to** understand why my account was suspended and request reactivation
**So that** I can continue using MySqrft

**Acceptance Criteria:**
- Suspension reason is clearly displayed
- Steps to resolve suspension are provided
- User can submit reactivation request
- Supporting documents can be uploaded
- Request is reviewed within 48 hours
- User is notified of reactivation decision

### 4.4 Trust and Verification Stories

#### US-TV-001: View My Trust Score
**As a** user
**I want to** see my trust score and contributing factors
**So that** I understand my credibility on the platform

**Acceptance Criteria:**
- Trust score displayed as numerical value (0-100)
- Visual indicator (stars, badges, or meter)
- Breakdown of contributing factors shown
- Tips to improve trust score provided
- Score updates reflected within 24 hours
- Historical trend available

#### US-TV-002: Display Verification Badges
**As a** user
**I want to** see my verification badges on my profile
**So that** others can trust my identity

**Acceptance Criteria:**
- Badges displayed prominently on profile
- Each badge type has distinct visual design
- Badge details shown on hover/tap
- Verification date displayed
- Expired verifications handled gracefully
- Badges visible in search results and listings

### 4.5 Preferences and Consent Stories

#### US-PC-001: Set Communication Preferences
**As a** user
**I want to** control how and when MySqrft contacts me
**So that** I receive only relevant communications

**Acceptance Criteria:**
- Toggle preferences for email, SMS, push, and WhatsApp
- Set quiet hours for notifications
- Choose frequency for digest emails
- Opt in/out of marketing communications
- Transaction notifications cannot be disabled
- Changes take effect immediately

#### US-PC-002: Manage Data Sharing Consent
**As a** user
**I want to** control what data is shared and with whom
**So that** my privacy is protected

**Acceptance Criteria:**
- Clear list of data sharing contexts
- Individual toggles per consent type
- Consent history is accessible
- Impact of declining consent explained
- Third-party sharing clearly identified
- Consent can be modified anytime

#### US-PC-003: Set Search Preferences
**As a** Tenant or Buyer
**I want to** save my property search preferences
**So that** I receive relevant property recommendations

**Acceptance Criteria:**
- Save preferred locations and localities
- Set budget range and property type
- Specify bedroom/bathroom requirements
- Add amenity preferences
- Set move-in timeline
- Preferences used in recommendation engine

---

## 5. Functional Requirements

### 5.1 Profile Management

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-PM-001 | System shall create user profiles with unique identifiers | P0 | UUID v4 format |
| FR-PM-002 | System shall validate email format and uniqueness | P0 | Case-insensitive comparison |
| FR-PM-003 | System shall validate phone number format per country | P0 | Support Indian numbers primarily |
| FR-PM-004 | System shall store profile photos in CDN with multiple resolutions | P0 | 64px, 128px, 256px, 512px |
| FR-PM-005 | System shall moderate profile photos using AI and manual review | P0 | Flag inappropriate content |
| FR-PM-006 | System shall validate addresses using geocoding services | P1 | Google Maps integration |
| FR-PM-007 | System shall calculate profile completeness score (0-100%) | P1 | Weighted by field importance |
| FR-PM-008 | System shall track all profile changes in audit log | P0 | Include before/after values |
| FR-PM-009 | System shall encrypt sensitive PII at rest | P0 | AES-256 encryption |
| FR-PM-010 | System shall support profile photo history (last 5 photos) | P2 | Soft delete old photos |

### 5.2 Role Management

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-RM-001 | System shall support assignment of multiple roles per user | P0 | No upper limit |
| FR-RM-002 | System shall enforce role-specific validation rules | P0 | Per role type |
| FR-RM-003 | System shall track role activation/deactivation timestamps | P0 | UTC timestamps |
| FR-RM-004 | System shall maintain role-specific profile fields | P1 | JSON schema per role |
| FR-RM-005 | System shall prevent deletion of the last active role | P0 | At least one role required |
| FR-RM-006 | System shall emit events on role state changes | P1 | For downstream consumers |
| FR-RM-007 | System shall support role inheritance hierarchies | P2 | Admin > SupportAgent pattern |
| FR-RM-008 | System shall validate role eligibility before assignment | P0 | Business rules engine |

### 5.3 User Lifecycle

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-UL-001 | System shall support user states: active, suspended, blocked, deleted | P0 | State machine pattern |
| FR-UL-002 | System shall enforce state transition rules | P0 | Only valid transitions allowed |
| FR-UL-003 | System shall require suspension reason and duration | P0 | Mandatory fields |
| FR-UL-004 | System shall auto-reactivate after suspension period | P1 | Scheduled job |
| FR-UL-005 | System shall implement soft delete with 30-day retention | P0 | GDPR compliance |
| FR-UL-006 | System shall purge deleted data after retention period | P0 | Automated process |
| FR-UL-007 | System shall support configurable onboarding flows per role | P1 | Admin-configurable |
| FR-UL-008 | System shall track onboarding progress and completion | P1 | Resumable flows |
| FR-UL-009 | System shall notify users of status changes | P0 | Email and push notification |
| FR-UL-010 | System shall block all access for blocked/deleted users | P0 | Immediate effect |

### 5.4 Trust and Verification

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-TV-001 | System shall calculate trust score from verification signals | P1 | Weighted algorithm |
| FR-TV-002 | System shall update trust score within 24 hours of changes | P1 | Async processing |
| FR-TV-003 | System shall display verification badges received from Verification domain | P0 | Read-only integration |
| FR-TV-004 | System shall support badge types: Identity, Phone, Email, Address, Background | P0 | Extensible list |
| FR-TV-005 | System shall show trust score breakdown on user request | P1 | Transparency requirement |
| FR-TV-006 | System shall handle expired verifications gracefully | P1 | Show expiry, prompt renewal |

### 5.5 Preferences and Consent

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-PC-001 | System shall store user communication preferences | P0 | Per channel granularity |
| FR-PC-002 | System shall enforce consent before data collection | P0 | GDPR/privacy compliance |
| FR-PC-003 | System shall maintain immutable consent history | P0 | Audit requirement |
| FR-PC-004 | System shall support consent versioning | P1 | Policy updates |
| FR-PC-005 | System shall allow users to export consent records | P1 | GDPR right |
| FR-PC-006 | System shall store search preferences per user-role combination | P1 | Role-specific |
| FR-PC-007 | System shall sync preferences across devices | P1 | Real-time sync |
| FR-PC-008 | System shall validate preference values against allowed options | P0 | Enum validation |

---

## 6. Non-Functional Requirements

### 6.1 Performance

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-P-001 | Profile read operations latency | < 100ms P95 | P0 |
| NFR-P-002 | Profile write operations latency | < 200ms P95 | P0 |
| NFR-P-003 | Profile photo upload time | < 3 seconds for 5MB | P0 |
| NFR-P-004 | Trust score calculation time | < 5 seconds | P1 |
| NFR-P-005 | Bulk profile operations throughput | 1000 profiles/minute | P1 |
| NFR-P-006 | Concurrent profile updates supported | 10,000/second | P0 |

### 6.2 Scalability

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-S-001 | Maximum user profiles supported | 10 million | P0 |
| NFR-S-002 | Profile photos storage | 100TB capacity | P1 |
| NFR-S-003 | Horizontal scaling for read replicas | Auto-scale based on load | P1 |
| NFR-S-004 | Event processing throughput | 100,000 events/second | P1 |

### 6.3 Availability

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-A-001 | System uptime | 99.9% (8.76 hours downtime/year) | P0 |
| NFR-A-002 | Recovery Time Objective (RTO) | < 15 minutes | P0 |
| NFR-A-003 | Recovery Point Objective (RPO) | < 1 minute | P0 |
| NFR-A-004 | Graceful degradation during partial outages | Core features available | P1 |

### 6.4 Security

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-SEC-001 | PII encryption at rest | AES-256 | P0 |
| NFR-SEC-002 | PII encryption in transit | TLS 1.3 | P0 |
| NFR-SEC-003 | Access control | Role-based (RBAC) | P0 |
| NFR-SEC-004 | Audit logging coverage | 100% of mutations | P0 |
| NFR-SEC-005 | Password hashing | bcrypt with cost factor 12 | P0 |
| NFR-SEC-006 | Session management | JWT with 24-hour expiry | P0 |
| NFR-SEC-007 | Rate limiting on profile APIs | 100 requests/minute/user | P0 |
| NFR-SEC-008 | PII masking in logs | Phone, email, address | P0 |

### 6.5 Compliance

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-C-001 | GDPR data subject rights | Full compliance | P0 |
| NFR-C-002 | Data retention policies | 30-day soft delete, 90-day purge | P0 |
| NFR-C-003 | Consent tracking | Version-controlled, auditable | P0 |
| NFR-C-004 | Right to data portability | Export within 72 hours | P1 |
| NFR-C-005 | Indian IT Act compliance | Data localization where required | P0 |

### 6.6 Maintainability

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| NFR-M-001 | Code test coverage | > 80% | P1 |
| NFR-M-002 | API documentation | OpenAPI 3.0 spec | P0 |
| NFR-M-003 | Database migration strategy | Zero-downtime migrations | P0 |
| NFR-M-004 | Feature flag support | All new features flagged | P1 |

---

## 7. Integration Points

### 7.1 Inbound Integrations (Consumed by UserManagement)

| Source Domain | Integration Type | Purpose | Priority |
|---------------|------------------|---------|----------|
| Auth | Sync API | Receive user creation events, validate sessions | P0 |
| Verification | Events | Receive verification status updates for badges | P0 |
| Media | Sync API | Upload and retrieve profile photos | P0 |
| Notification | Async | Trigger notifications via preference settings | P0 |
| Location | Sync API | Address validation and geocoding | P1 |

### 7.2 Outbound Integrations (Provided by UserManagement)

| Target Domain | Integration Type | Purpose | Priority |
|---------------|------------------|---------|----------|
| Property | Events | User profile updates, preferences for matching | P0 |
| Booking | Sync API | Profile data for booking context | P0 |
| Transaction | Sync API | User identity for transaction records | P0 |
| Search | Events | Index user profiles for discovery | P1 |
| Society | Events | Resident profile updates | P1 |
| Support | Sync API | User context for support tickets | P1 |
| Analytics | Events | User lifecycle events for analytics | P2 |
| Marketing | Events | Consent changes, preference updates | P2 |

### 7.3 External Integrations

| System | Purpose | Integration Method | Priority |
|--------|---------|-------------------|----------|
| Google Maps API | Address autocomplete and validation | REST API | P1 |
| Tigris Object Storage | Profile photo storage and CDN (S3-compatible) | SDK | P0 |
| AWS Rekognition | Profile photo moderation | SDK | P1 |
| SendGrid/SNS | Email and SMS delivery | SDK | P0 |

### 7.4 Integration Events Published

| Event Name | Trigger | Payload | Consumers |
|------------|---------|---------|-----------|
| `user.profile.created` | New profile created | userId, roles, email | All domains |
| `user.profile.updated` | Profile fields updated | userId, changedFields | Property, Search |
| `user.status.changed` | Status transition | userId, oldStatus, newStatus, reason | All domains |
| `user.role.added` | New role assigned | userId, roleType, roleData | Property, Society |
| `user.role.removed` | Role deactivated | userId, roleType | Property, Society |
| `user.preferences.updated` | Preferences changed | userId, preferenceType, values | Search, Marketing |
| `user.consent.changed` | Consent updated | userId, consentType, granted, version | Marketing, Analytics |
| `user.deleted` | Account deleted | userId, deletionDate | All domains |

---

## 8. Dependencies

### 8.1 Upstream Dependencies

| Domain/Service | Dependency Type | Impact if Unavailable | Mitigation |
|----------------|-----------------|----------------------|------------|
| Auth | Hard | Cannot create or authenticate users | Circuit breaker, retry |
| Verification | Soft | Badges won't update, cached data used | Show stale data with indicator |
| Media | Soft | Photo upload fails | Queue uploads for retry |
| Location | Soft | Address validation skipped | Allow manual entry, validate later |

### 8.2 Downstream Dependents

| Domain/Service | Impact of UserManagement Failure |
|----------------|----------------------------------|
| Property | Cannot display owner profiles, matching affected |
| Booking | Cannot validate user identity for bookings |
| Transaction | Transaction records lack user context |
| Society | Resident management degraded |
| Support | Support agents lack user context |

### 8.3 Infrastructure Dependencies

| Component | Purpose | SLA Required |
|-----------|---------|--------------|
| PostgreSQL | Primary data store | 99.99% |
| Redis | Caching, session store | 99.9% |
| Kafka | Event streaming | 99.9% |
| Tigris Object Storage | Photo storage and CDN | 99.99% |

---

## 9. Success Metrics

### 9.1 Business Metrics

| Metric | Definition | Target | Measurement Frequency |
|--------|------------|--------|----------------------|
| Profile Completion Rate | % of users with 80%+ complete profiles | > 70% | Weekly |
| Multi-Role Adoption | % of users with 2+ roles | > 25% | Monthly |
| Onboarding Completion Rate | % of users completing onboarding | > 85% | Weekly |
| Account Retention Rate | % of users not deleting accounts after 30 days | > 95% | Monthly |
| Trust Score Adoption | % of active users with calculated trust score | > 80% | Monthly |
| Consent Grant Rate | % of users granting data sharing consent | > 60% | Monthly |

### 9.2 Technical Metrics

| Metric | Definition | Target | Alert Threshold |
|--------|------------|--------|-----------------|
| API Response Time (P95) | 95th percentile latency for profile APIs | < 150ms | > 300ms |
| API Error Rate | % of failed API requests | < 0.1% | > 1% |
| Photo Upload Success Rate | % of successful photo uploads | > 99% | < 95% |
| Event Processing Lag | Delay in processing profile events | < 1 second | > 5 seconds |
| Database Query Time (P95) | 95th percentile query execution time | < 50ms | > 100ms |
| Cache Hit Rate | % of profile reads served from cache | > 90% | < 80% |

### 9.3 User Experience Metrics

| Metric | Definition | Target | Measurement Method |
|--------|------------|--------|-------------------|
| Profile Setup Time | Time to complete initial profile | < 3 minutes | Analytics |
| Role Switch Time | Time to switch between roles | < 1 second | Performance monitoring |
| Photo Upload Time | Time from selection to display | < 5 seconds | Analytics |
| Preference Save Confirmation | Time to save and confirm preferences | < 2 seconds | Analytics |

### 9.4 Compliance Metrics

| Metric | Definition | Target | Measurement Frequency |
|--------|------------|--------|----------------------|
| Consent Tracking Coverage | % of data collection with tracked consent | 100% | Continuous |
| Data Export Request Completion | % of exports completed within SLA | 100% | Per request |
| Audit Log Coverage | % of mutations with audit entries | 100% | Daily |
| PII Encryption Coverage | % of PII fields encrypted at rest | 100% | Weekly audit |

---

## 10. Key Entities

### 10.1 Entity Definitions

#### UserProfile
The core entity representing a user's identity and personal information on MySqrft.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userId | UUID | Yes | Reference to Auth user |
| displayName | String | Yes | Public display name |
| firstName | String | Yes | Legal first name |
| lastName | String | Yes | Legal last name |
| email | String | Yes | Primary email address |
| phone | String | Yes | Primary phone number |
| bio | Text | No | User biography (500 chars max) |
| dateOfBirth | Date | No | Date of birth |
| gender | Enum | No | Gender identity |
| status | Enum | Yes | active, suspended, blocked, deleted |
| completenessScore | Integer | Yes | 0-100 percentage |
| createdAt | Timestamp | Yes | Profile creation time |
| updatedAt | Timestamp | Yes | Last update time |

#### Role
Defines the available roles a user can have on the platform.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| name | String | Yes | Role name (e.g., Tenant, Owner) |
| description | Text | Yes | Role description |
| requiredFields | JSON | Yes | Fields required for this role |
| permissions | JSON | Yes | Permission set for this role |
| isActive | Boolean | Yes | Whether role is currently available |

#### UserRole
Junction entity linking users to their assigned roles.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| roleId | UUID | Yes | Reference to Role |
| roleSpecificData | JSON | No | Role-specific profile fields |
| status | Enum | Yes | active, inactive, pending |
| activatedAt | Timestamp | No | When role was activated |
| deactivatedAt | Timestamp | No | When role was deactivated |

#### Address
Stores user addresses with location details.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| type | Enum | Yes | home, work, other |
| line1 | String | Yes | Street address line 1 |
| line2 | String | No | Street address line 2 |
| city | String | Yes | City name |
| locality | String | No | Locality/neighborhood |
| landmark | String | No | Nearby landmark |
| pinCode | String | Yes | Postal code |
| state | String | Yes | State/province |
| country | String | Yes | Country code |
| latitude | Decimal | No | Geocoded latitude |
| longitude | Decimal | No | Geocoded longitude |
| isPrimary | Boolean | Yes | Is primary address |

#### ProfilePhoto
Manages user profile photos and their versions.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| originalUrl | String | Yes | Original image URL |
| thumbnailUrl | String | Yes | Thumbnail URL (64px) |
| mediumUrl | String | Yes | Medium URL (256px) |
| largeUrl | String | Yes | Large URL (512px) |
| moderationStatus | Enum | Yes | pending, approved, rejected |
| isCurrent | Boolean | Yes | Is current profile photo |
| uploadedAt | Timestamp | Yes | Upload timestamp |

#### Preference
Stores user preferences of various types.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| roleId | UUID | No | Role-specific preference (optional) |
| category | String | Yes | search, lifestyle, communication, notification |
| key | String | Yes | Preference key |
| value | JSON | Yes | Preference value |
| updatedAt | Timestamp | Yes | Last update time |

#### Consent
Tracks user consent for data processing activities.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| consentType | String | Yes | Type of consent |
| granted | Boolean | Yes | Whether consent is granted |
| version | String | Yes | Policy version |
| grantedAt | Timestamp | No | When consent was granted |
| revokedAt | Timestamp | No | When consent was revoked |
| expiresAt | Timestamp | No | When consent expires |

#### ConsentHistory
Immutable audit log of consent changes.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| consentId | UUID | Yes | Reference to Consent |
| action | Enum | Yes | granted, revoked, expired |
| version | String | Yes | Policy version at time of action |
| ipAddress | String | No | IP address of action |
| userAgent | String | No | User agent of action |
| timestamp | Timestamp | Yes | When action occurred |

#### TrustScore
Calculated trust score for users.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| score | Integer | Yes | Trust score 0-100 |
| factors | JSON | Yes | Contributing factors and weights |
| calculatedAt | Timestamp | Yes | When score was calculated |
| validUntil | Timestamp | Yes | Score validity period |

#### VerificationBadge
Display of verification badges on user profiles.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| badgeType | Enum | Yes | identity, phone, email, address, background |
| verificationId | UUID | Yes | Reference to Verification domain record |
| displayName | String | Yes | Badge display name |
| grantedAt | Timestamp | Yes | When badge was granted |
| expiresAt | Timestamp | No | When badge expires |
| isActive | Boolean | Yes | Whether badge is currently active |

#### ProfileCompleteness
Tracks profile completeness calculation details.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| totalScore | Integer | Yes | Overall completeness 0-100 |
| breakdown | JSON | Yes | Score per section |
| missingFields | JSON | Yes | List of incomplete fields |
| calculatedAt | Timestamp | Yes | When calculated |

#### OnboardingFlow
Tracks user progress through onboarding.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | UUID | Yes | Unique identifier |
| userProfileId | UUID | Yes | Reference to UserProfile |
| roleId | UUID | Yes | Role being onboarded for |
| flowType | String | Yes | Type of onboarding flow |
| currentStep | Integer | Yes | Current step number |
| totalSteps | Integer | Yes | Total steps in flow |
| completedSteps | JSON | Yes | List of completed step IDs |
| status | Enum | Yes | in_progress, completed, abandoned |
| startedAt | Timestamp | Yes | When onboarding started |
| completedAt | Timestamp | No | When onboarding completed |

---

## 11. API Endpoints (Reference)

### 11.1 Profile APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/profiles` | Create new user profile |
| GET | `/api/v1/profiles/{id}` | Get profile by ID |
| GET | `/api/v1/profiles/me` | Get current user's profile |
| PATCH | `/api/v1/profiles/{id}` | Update profile fields |
| DELETE | `/api/v1/profiles/{id}` | Request profile deletion |
| GET | `/api/v1/profiles/{id}/completeness` | Get profile completeness |

### 11.2 Photo APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/profiles/{id}/photos` | Upload profile photo |
| GET | `/api/v1/profiles/{id}/photos` | List profile photos |
| DELETE | `/api/v1/profiles/{id}/photos/{photoId}` | Delete a photo |
| PUT | `/api/v1/profiles/{id}/photos/{photoId}/current` | Set as current photo |

### 11.3 Role APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/profiles/{id}/roles` | List user roles |
| POST | `/api/v1/profiles/{id}/roles` | Add role to user |
| PATCH | `/api/v1/profiles/{id}/roles/{roleId}` | Update role status |
| DELETE | `/api/v1/profiles/{id}/roles/{roleId}` | Deactivate role |

### 11.4 Address APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/profiles/{id}/addresses` | List user addresses |
| POST | `/api/v1/profiles/{id}/addresses` | Add new address |
| PATCH | `/api/v1/profiles/{id}/addresses/{addressId}` | Update address |
| DELETE | `/api/v1/profiles/{id}/addresses/{addressId}` | Delete address |

### 11.5 Preference APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/profiles/{id}/preferences` | Get all preferences |
| GET | `/api/v1/profiles/{id}/preferences/{category}` | Get preferences by category |
| PUT | `/api/v1/profiles/{id}/preferences/{category}` | Update preferences |

### 11.6 Consent APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/profiles/{id}/consents` | List all consents |
| PUT | `/api/v1/profiles/{id}/consents/{type}` | Update consent |
| GET | `/api/v1/profiles/{id}/consents/history` | Get consent history |

### 11.7 Trust APIs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/profiles/{id}/trust-score` | Get trust score |
| GET | `/api/v1/profiles/{id}/badges` | Get verification badges |

---

## 12. Appendix

### 12.1 User Status State Machine

```
                    ┌─────────────┐
                    │   Created   │
                    └──────┬──────┘
                           │
                           ▼
    ┌──────────────────────────────────────────┐
    │                                          │
    │                 ACTIVE                   │◄────────────────┐
    │                                          │                 │
    └──────────┬───────────────────┬───────────┘                 │
               │                   │                             │
               ▼                   ▼                             │
    ┌──────────────────┐ ┌─────────────────────┐                 │
    │    SUSPENDED     │ │      BLOCKED        │                 │
    │  (Temporary)     │ │    (Permanent)      │                 │
    └────────┬─────────┘ └─────────┬───────────┘                 │
             │                     │                             │
             │ (Reactivate)        │                             │
             └─────────────────────┼─────────────────────────────┘
                                   │
                                   ▼
                          ┌──────────────┐
                          │   DELETED    │
                          │ (Soft, 30d)  │
                          └──────┬───────┘
                                 │
                                 ▼
                          ┌──────────────┐
                          │   PURGED     │
                          │ (Permanent)  │
                          └──────────────┘
```

### 12.2 Trust Score Calculation Factors

| Factor | Weight | Description |
|--------|--------|-------------|
| Email Verified | 10% | Email address verified |
| Phone Verified | 15% | Phone number verified via OTP |
| Identity Verified | 25% | Government ID verified |
| Address Verified | 15% | Physical address verified |
| Profile Complete | 10% | Profile 100% complete |
| Account Age | 10% | Longer account age = higher score |
| Transaction History | 10% | Successful past transactions |
| Reviews Received | 5% | Positive reviews from other users |

### 12.3 Glossary

| Term | Definition |
|------|------------|
| PII | Personally Identifiable Information |
| GDPR | General Data Protection Regulation |
| RBAC | Role-Based Access Control |
| OTP | One-Time Password |
| CDN | Content Delivery Network |
| SLA | Service Level Agreement |
| RTO | Recovery Time Objective |
| RPO | Recovery Point Objective |

---

## 13. Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | MySqrft Product Team | Initial draft |

---

*This document is maintained by the MySqrft Product Team. For questions or updates, contact the domain owner.*
