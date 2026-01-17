# Scheduling Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | Scheduling |
| Version | 1.0 |
| Status | Complete |
| Platform | MySqrft |
| Phase | Phase 3: Assisted Sales |

---

## 1. Overview

### 1.1 Primary Goal
**Visits + Appointments**

The Scheduling domain manages all visit and appointment-related functionality within the MySqrft platform. It enables seamless coordination between property owners, tenants/buyers, and Relationship Managers (RMs) to schedule, track, and complete property visits.

### 1.2 Domain Summary
The Scheduling domain serves as the critical bridge between lead generation and deal closure. By providing robust scheduling, calendar management, and feedback capture capabilities, it ensures that interested parties can efficiently view properties while maintaining a complete audit trail of all visit activities and outcomes.

### 1.3 Business Value
- Reduces friction in the property viewing process
- Increases conversion rates from leads to closed deals
- Provides visibility into visit outcomes for analytics and optimization
- Enables RM-assisted workflows for premium users
- Captures valuable feedback for property and service improvement

---

## 2. Responsibilities

### 2.1 Visit Scheduling and Confirmations
- Enable tenants/buyers to request property visits through the platform
- Allow owners to propose available time slots for visits
- Support RM-initiated visit scheduling for assisted sales workflows
- Send multi-channel confirmations (SMS, WhatsApp, email, push notifications)
- Provide visit reminders at configurable intervals before the scheduled time
- Handle timezone considerations for all parties

### 2.2 Reschedule and Cancellation Handling
- Allow any party (owner, tenant, RM) to request reschedule
- Implement cancellation workflows with reason capture
- Track cancellation patterns for analytics and fraud detection
- Support automatic rescheduling suggestions based on availability
- Enforce cancellation policies (e.g., minimum notice periods)
- Notify all affected parties of schedule changes in real-time

### 2.3 Calendar Coordination (Owner/Tenant/RM)
- Maintain individual calendars for owners, tenants, and RMs
- Detect and prevent scheduling conflicts
- Support recurring availability patterns for owners
- Enable calendar sync with external providers (Google Calendar, Outlook) - optional
- Provide calendar views (daily, weekly, monthly) for all user types
- Handle multi-property owner scheduling efficiently

### 2.4 Post-Visit Feedback Capture
- Prompt tenants/buyers for feedback immediately after visit completion
- Capture structured feedback (rating, property condition, interest level)
- Allow free-form comments and suggestions
- Collect owner feedback on tenant/buyer behavior
- Enable RM feedback capture for assisted visits
- Support photo/media attachments in feedback (optional)

### 2.5 Visit History and Outcomes Tracking
- Maintain complete visit history per property, user, and RM
- Track visit outcomes (interested, not interested, follow-up needed, deal closed)
- Generate visit reports for analytics consumption
- Support outcome-based lead progression
- Enable visit pattern analysis for fraud detection
- Provide audit trail for compliance and dispute resolution

### 2.6 Availability Management
- Allow owners to set general availability windows
- Support exception dates (holidays, blocked dates)
- Enable instant availability updates
- Implement availability inference from visit history
- Support buffer time between consecutive visits
- Handle availability for RM-assisted visits separately

---

## 3. Key Entities

### 3.1 Visit
The core entity representing a scheduled property viewing.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| listing_id | UUID | Reference to the property listing |
| tenant_id | UUID | Reference to the tenant/buyer |
| owner_id | UUID | Reference to the property owner |
| rm_id | UUID | Reference to the assigned RM (optional) |
| scheduled_at | DateTime | Scheduled visit date and time |
| duration_minutes | Integer | Expected visit duration |
| status | Enum | Status of the visit |
| visit_type | Enum | Type of visit (self-guided, owner-assisted, RM-assisted) |
| address | Object | Visit location details |
| notes | Text | Additional notes for the visit |
| created_at | DateTime | Record creation timestamp |
| updated_at | DateTime | Last update timestamp |

**Visit Status Values:**
- `requested` - Visit requested by tenant
- `proposed` - Owner proposed time slots
- `confirmed` - Visit confirmed by all parties
- `in_progress` - Visit currently happening
- `completed` - Visit finished
- `cancelled` - Visit cancelled
- `no_show` - One or more parties did not attend
- `rescheduled` - Visit moved to new time

**Visit Type Values:**
- `self_guided` - Tenant visits without owner/RM presence
- `owner_assisted` - Owner or representative present
- `rm_assisted` - RM facilitates the visit
- `virtual` - Video call or virtual tour

### 3.2 Appointment
Generic appointment entity for non-visit scheduling needs.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| type | Enum | Appointment type |
| organizer_id | UUID | User who created the appointment |
| participants | Array | List of participant user IDs |
| scheduled_at | DateTime | Scheduled date and time |
| duration_minutes | Integer | Expected duration |
| location | Object | Meeting location or virtual link |
| status | Enum | Appointment status |
| reference_type | String | Related entity type (e.g., Lead, Agreement) |
| reference_id | UUID | Related entity ID |
| notes | Text | Appointment notes |
| created_at | DateTime | Record creation timestamp |
| updated_at | DateTime | Last update timestamp |

**Appointment Type Values:**
- `property_visit` - Property viewing (links to Visit entity)
- `document_signing` - Legal document signing session
- `consultation` - RM consultation meeting
- `inspection` - Property inspection
- `handover` - Key handover ceremony
- `other` - Other appointment types

### 3.3 Calendar
User calendar management entity.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| user_id | UUID | Reference to the user |
| user_type | Enum | User type (owner, tenant, rm) |
| timezone | String | User's timezone |
| default_duration | Integer | Default appointment duration |
| buffer_minutes | Integer | Buffer between appointments |
| external_sync_enabled | Boolean | External calendar sync status |
| external_provider | String | External calendar provider |
| sync_token | String | Encrypted sync token |
| settings | Object | Calendar preferences |
| created_at | DateTime | Record creation timestamp |
| updated_at | DateTime | Last update timestamp |

### 3.4 Availability
Availability windows for scheduling.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| user_id | UUID | Reference to the user |
| listing_id | UUID | Reference to specific listing (optional) |
| day_of_week | Integer | Day of week (0-6, null for specific date) |
| specific_date | Date | Specific date (null for recurring) |
| start_time | Time | Start time of availability |
| end_time | Time | End time of availability |
| is_available | Boolean | True for available, false for blocked |
| recurrence_type | Enum | Recurrence pattern |
| valid_from | Date | Start date for this availability rule |
| valid_until | Date | End date for this availability rule |
| created_at | DateTime | Record creation timestamp |
| updated_at | DateTime | Last update timestamp |

**Recurrence Type Values:**
- `none` - One-time availability
- `daily` - Repeats daily
- `weekly` - Repeats weekly
- `biweekly` - Repeats every two weeks
- `monthly` - Repeats monthly

### 3.5 VisitFeedback
Feedback captured after visit completion.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| visit_id | UUID | Reference to the visit |
| submitted_by | UUID | User who submitted feedback |
| submitter_type | Enum | Type of user (tenant, owner, rm) |
| overall_rating | Integer | Overall rating (1-5) |
| property_condition | Integer | Property condition rating (1-5) |
| accuracy_rating | Integer | Listing accuracy rating (1-5) |
| interest_level | Enum | Interest level after visit |
| would_recommend | Boolean | Would recommend this property |
| pros | Array | List of positive aspects |
| cons | Array | List of negative aspects |
| comments | Text | Free-form feedback |
| outcome | Enum | Visit outcome |
| follow_up_required | Boolean | Follow-up needed flag |
| follow_up_notes | Text | Notes for follow-up |
| media_attachments | Array | Photo/video attachments |
| created_at | DateTime | Record creation timestamp |

**Interest Level Values:**
- `very_interested` - Ready to proceed
- `interested` - Wants to consider
- `neutral` - Neither interested nor disinterested
- `not_interested` - Not proceeding
- `already_decided` - Decided on another property

**Outcome Values:**
- `positive` - Positive outcome, may proceed
- `negative` - Not interested
- `follow_up` - Needs follow-up discussion
- `negotiation` - Price/terms negotiation needed
- `deal_closed` - Deal finalized during/after visit

---

## 4. User Stories

### 4.1 Tenant/Buyer Stories

| ID | Story | Priority |
|----|-------|----------|
| T-001 | As a tenant, I want to request a visit for a property I'm interested in, so that I can view it in person | P0 |
| T-002 | As a tenant, I want to see available time slots for a property, so that I can choose a convenient time | P0 |
| T-003 | As a tenant, I want to receive confirmation when my visit is scheduled, so that I know when to arrive | P0 |
| T-004 | As a tenant, I want to reschedule my visit if my plans change, so that I don't miss the opportunity | P0 |
| T-005 | As a tenant, I want to cancel a visit with reason, so that the owner knows why I can't make it | P0 |
| T-006 | As a tenant, I want to receive reminders before my visit, so that I don't forget | P1 |
| T-007 | As a tenant, I want to provide feedback after my visit, so that I can share my experience | P1 |
| T-008 | As a tenant, I want to view my visit history, so that I can track properties I've seen | P1 |
| T-009 | As a tenant, I want to see my upcoming visits in a calendar view, so that I can plan my schedule | P2 |
| T-010 | As a tenant, I want to sync my visits to my personal calendar, so that I have all appointments in one place | P2 |

### 4.2 Owner Stories

| ID | Story | Priority |
|----|-------|----------|
| O-001 | As an owner, I want to receive visit requests from interested tenants, so that I can schedule viewings | P0 |
| O-002 | As an owner, I want to set my availability for property visits, so that I only receive requests for convenient times | P0 |
| O-003 | As an owner, I want to confirm or propose alternative times for visit requests, so that I can manage my schedule | P0 |
| O-004 | As an owner, I want to cancel or reschedule visits when necessary, so that I can handle unexpected situations | P0 |
| O-005 | As an owner, I want to receive reminders before scheduled visits, so that I can prepare the property | P1 |
| O-006 | As an owner, I want to mark visits as completed and record outcomes, so that I can track progress | P1 |
| O-007 | As an owner, I want to view feedback from tenants who visited, so that I can improve my listing | P1 |
| O-008 | As an owner, I want to see visit history for my properties, so that I can analyze interest levels | P2 |
| O-009 | As an owner, I want to block specific dates when I'm unavailable, so that I don't receive requests | P2 |
| O-010 | As an owner, I want to set different availability for different properties, so that I can manage multiple listings | P2 |

### 4.3 Relationship Manager (RM) Stories

| ID | Story | Priority |
|----|-------|----------|
| R-001 | As an RM, I want to schedule visits on behalf of tenants, so that I can provide assisted service | P0 |
| R-002 | As an RM, I want to view all visits assigned to me, so that I can plan my day | P0 |
| R-003 | As an RM, I want to coordinate between multiple parties for visit scheduling, so that I can ensure all parties are available | P0 |
| R-004 | As an RM, I want to reschedule visits when conflicts arise, so that I can handle changes efficiently | P0 |
| R-005 | As an RM, I want to capture visit outcomes and feedback, so that I can update lead status | P1 |
| R-006 | As an RM, I want to view my calendar with all scheduled visits, so that I can manage my workload | P1 |
| R-007 | As an RM, I want to receive notifications for visit changes, so that I'm always informed | P1 |
| R-008 | As an RM, I want to see tenant visit history before accompanying them, so that I can provide better service | P2 |
| R-009 | As an RM, I want to generate visit reports for my team, so that we can track performance | P2 |
| R-010 | As an RM, I want to set my availability for assisted visits, so that visits are scheduled when I'm free | P2 |

---

## 5. Functional Requirements

### 5.1 Visit Request Flow

**FR-001: Visit Request Creation**
- System shall allow authenticated tenants to request visits for active listings
- System shall capture preferred date/time slots (minimum 2, maximum 5)
- System shall validate that requested times are within owner's availability
- System shall check for scheduling conflicts with tenant's existing visits
- System shall require acceptance of visit terms before confirmation

**FR-002: Visit Request Processing**
- System shall notify owner of new visit requests within 30 seconds
- System shall allow owner to confirm, propose alternatives, or decline
- System shall auto-expire unresponded requests after 24 hours (configurable)
- System shall support automatic confirmation for instant-bookable listings

**FR-003: Visit Confirmation**
- System shall send confirmation to all parties upon scheduling
- System shall include visit details: address, date, time, contact information
- System shall generate unique visit codes for verification (optional)
- System shall create calendar entries for all participants

### 5.2 Calendar Management

**FR-004: Availability Configuration**
- System shall support recurring weekly availability patterns
- System shall allow exception dates (holidays, blocked periods)
- System shall support different availability per property for multi-property owners
- System shall enforce minimum lead time for visit requests (configurable)
- System shall enforce maximum advance booking period (configurable)

**FR-005: Conflict Detection**
- System shall prevent double-booking for all parties
- System shall enforce buffer time between consecutive visits
- System shall warn users of potential conflicts during scheduling
- System shall suggest alternative times when conflicts exist

**FR-006: Calendar Views**
- System shall provide daily, weekly, and monthly calendar views
- System shall display visits with status-based color coding
- System shall allow filtering by property, status, and visit type
- System shall support calendar export (ICS format)

### 5.3 Notifications and Reminders

**FR-007: Visit Reminders**
- System shall send reminders 24 hours before scheduled visit
- System shall send reminders 2 hours before scheduled visit
- System shall support user-configurable reminder preferences
- System shall use preferred notification channel per user

**FR-008: Real-time Notifications**
- System shall notify all parties of schedule changes within 30 seconds
- System shall notify of cancellations with reason
- System shall notify when feedback is submitted
- System shall support notification preferences and DND settings

### 5.4 Feedback and Outcomes

**FR-009: Feedback Collection**
- System shall prompt for feedback within 2 hours of visit completion
- System shall support structured rating scales (1-5)
- System shall capture interest level and outcome
- System shall allow photo attachments (maximum 5, max 5MB each)
- System shall support anonymous feedback option for sensitive comments

**FR-010: Outcome Tracking**
- System shall track visit outcomes for analytics
- System shall update lead status based on visit outcomes
- System shall support follow-up task creation from visit outcomes
- System shall generate outcome reports by property, user, and time period

### 5.5 RM-Assisted Workflows

**FR-011: RM Visit Management**
- System shall allow RMs to schedule visits on behalf of tenants
- System shall allocate visits to RMs based on workload and availability
- System shall support RM reassignment for visits
- System shall track RM performance metrics (visits completed, outcomes)

**FR-012: RM Calendar Integration**
- System shall maintain RM availability calendar
- System shall prevent over-allocation of visits to RMs
- System shall support territory-based RM allocation
- System shall integrate with CRM for lead context

---

## 6. Non-Functional Requirements

### 6.1 Performance

| Requirement | Target | Notes |
|-------------|--------|-------|
| Visit request creation | < 500ms | 95th percentile |
| Availability lookup | < 200ms | 95th percentile |
| Calendar view loading | < 1s | 95th percentile |
| Notification delivery | < 30s | End-to-end |
| Concurrent visit requests | 1000/minute | Peak load |

### 6.2 Availability

| Requirement | Target |
|-------------|--------|
| Service uptime | 99.9% |
| Notification delivery rate | 99.5% |
| Scheduled job reliability | 99.9% |
| Data durability | 99.999% |

### 6.3 Scalability

- Support 100,000 daily active users
- Handle 50,000 visits scheduled per day
- Support 1 million availability records
- Scale horizontally for increased load

### 6.4 Security

- All visit data encrypted at rest (AES-256)
- All API calls over TLS 1.3
- PII handling compliant with data protection policies
- Audit logging for all visit modifications
- Rate limiting to prevent abuse

### 6.5 Data Retention

| Data Type | Retention Period |
|-----------|------------------|
| Active visits | Indefinite |
| Completed visits | 3 years |
| Cancelled visits | 1 year |
| Visit feedback | 3 years |
| Availability records | Until deleted by user |
| Calendar sync tokens | Until revoked |

---

## 7. API Specifications

### 7.1 Core Endpoints

#### Visits API

```
POST   /api/v1/visits                    # Create visit request
GET    /api/v1/visits                    # List visits (with filters)
GET    /api/v1/visits/{id}               # Get visit details
PATCH  /api/v1/visits/{id}               # Update visit
POST   /api/v1/visits/{id}/confirm       # Confirm visit
POST   /api/v1/visits/{id}/cancel        # Cancel visit
POST   /api/v1/visits/{id}/reschedule    # Reschedule visit
POST   /api/v1/visits/{id}/complete      # Mark visit complete
GET    /api/v1/visits/{id}/feedback      # Get visit feedback
POST   /api/v1/visits/{id}/feedback      # Submit visit feedback
```

#### Availability API

```
GET    /api/v1/availability              # Get user availability
POST   /api/v1/availability              # Set availability
PUT    /api/v1/availability/{id}         # Update availability rule
DELETE /api/v1/availability/{id}         # Delete availability rule
GET    /api/v1/availability/slots        # Get available slots for listing
POST   /api/v1/availability/block        # Block specific dates
```

#### Calendar API

```
GET    /api/v1/calendar                  # Get calendar settings
PUT    /api/v1/calendar                  # Update calendar settings
GET    /api/v1/calendar/events           # Get calendar events
POST   /api/v1/calendar/sync             # Trigger external sync
GET    /api/v1/calendar/export           # Export calendar (ICS)
```

#### Appointments API

```
POST   /api/v1/appointments              # Create appointment
GET    /api/v1/appointments              # List appointments
GET    /api/v1/appointments/{id}         # Get appointment details
PATCH  /api/v1/appointments/{id}         # Update appointment
DELETE /api/v1/appointments/{id}         # Cancel appointment
```

### 7.2 Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| status | string | Filter by visit status |
| from_date | date | Start date filter |
| to_date | date | End date filter |
| listing_id | uuid | Filter by listing |
| user_id | uuid | Filter by user |
| visit_type | string | Filter by visit type |
| page | integer | Page number |
| limit | integer | Items per page (max 100) |
| sort | string | Sort field |
| order | string | Sort order (asc/desc) |

### 7.3 Webhook Events

| Event | Trigger | Payload |
|-------|---------|---------|
| visit.requested | New visit request | Visit object |
| visit.confirmed | Visit confirmed | Visit object |
| visit.cancelled | Visit cancelled | Visit object with reason |
| visit.rescheduled | Visit rescheduled | Visit object with old/new times |
| visit.completed | Visit marked complete | Visit object |
| visit.feedback_submitted | Feedback submitted | VisitFeedback object |
| visit.reminder | Reminder triggered | Visit object with reminder type |

---

## 8. Domain Events

### 8.1 Published Events

| Event Name | Description | Consumers |
|------------|-------------|-----------|
| VisitRequested | New visit request created | Communications, CRM, Analytics |
| VisitConfirmed | Visit confirmed by owner | Communications, CRM, Analytics |
| VisitCancelled | Visit cancelled by any party | Communications, CRM, Analytics |
| VisitRescheduled | Visit time changed | Communications, CRM, Analytics |
| VisitCompleted | Visit marked as completed | CRM, Leads, Analytics |
| VisitNoShow | Party marked as no-show | TrustSafety, CRM, Analytics |
| FeedbackSubmitted | Feedback captured | Analytics, Inventory, TrustSafety |
| AvailabilityUpdated | Owner availability changed | Search (for instant booking) |

### 8.2 Consumed Events

| Event Name | Source Domain | Action |
|------------|---------------|--------|
| LeadCreated | Leads | Enable visit scheduling for lead |
| LeadClosed | Leads | Cancel pending visits |
| ListingPaused | Inventory | Cancel/hold pending visits |
| ListingExpired | Inventory | Cancel pending visits |
| UserBlocked | TrustSafety | Cancel pending visits |
| RMAssigned | Sales | Update RM assignment on visits |

---

## 9. Integration Points

### 9.1 Upstream Dependencies

| Domain | Integration Type | Purpose |
|--------|-----------------|---------|
| Auth | Sync | User authentication and authorization |
| UserManagement | Sync | User profile and preferences |
| Authorization | Sync | Permission checks |
| Inventory | Sync | Listing details and status |
| Leads | Sync | Lead context and status |

### 9.2 Downstream Integrations

| Domain | Integration Type | Purpose |
|--------|-----------------|---------|
| Communications | Async | Send notifications and reminders |
| CRM | Async | Update contact timeline |
| Analytics | Async | Event streaming for reporting |
| Sales | Async | RM workload updates |
| TrustSafety | Async | Fraud signal reporting |

### 9.3 External Integrations

| System | Purpose | Priority |
|--------|---------|----------|
| Google Calendar | Calendar sync | P2 |
| Microsoft Outlook | Calendar sync | P2 |
| Apple Calendar | Calendar sync (ICS) | P3 |
| Maps/Geocoding | Address validation | P1 |

---

## 10. UI/UX Requirements

### 10.1 Tenant Experience

- **Property Detail Page**: Prominent "Schedule Visit" CTA
- **Visit Request Flow**: 3-step wizard (select dates, confirm details, submit)
- **My Visits Page**: List view with filters, calendar toggle
- **Visit Detail Page**: Full details, actions, map, feedback form
- **Feedback Modal**: Post-visit rating and feedback collection

### 10.2 Owner Experience

- **Dashboard Widget**: Pending visit requests count, upcoming visits
- **Visit Requests Page**: Action-oriented list with quick confirm/decline
- **Availability Manager**: Weekly schedule grid, exception dates
- **Visit History**: Property-wise visit analytics

### 10.3 RM Experience

- **RM Dashboard**: Daily schedule, pending actions, workload view
- **Visit Scheduling Tool**: Multi-party coordination interface
- **Calendar View**: Full calendar with all assigned visits
- **Feedback Capture**: Quick outcome recording interface

### 10.4 Mobile Considerations

- Push notification support for all visit events
- Offline-capable visit details viewing
- One-tap actions for confirm/cancel
- Location-based check-in for visits (optional)

---

## 11. Success Metrics

### 11.1 Primary Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| Visit Request Rate | Visits requested / Listing views | > 5% |
| Visit Confirmation Rate | Confirmed visits / Requested visits | > 70% |
| Visit Completion Rate | Completed visits / Confirmed visits | > 80% |
| Time to Confirmation | Median time from request to confirmation | < 4 hours |
| Visit-to-Deal Conversion | Deals closed / Visits completed | > 10% |

### 11.2 Secondary Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| Feedback Submission Rate | Feedback submitted / Visits completed | > 60% |
| Reschedule Rate | Rescheduled visits / Confirmed visits | < 20% |
| Cancellation Rate | Cancelled visits / Confirmed visits | < 15% |
| No-Show Rate | No-shows / Confirmed visits | < 10% |
| Average Rating | Mean visit experience rating | > 4.0 |

### 11.3 Operational Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| RM Visits per Day | Average visits per RM | 6-8 |
| Notification Delivery Rate | Delivered / Sent notifications | > 99% |
| API Latency (p95) | 95th percentile response time | < 500ms |
| System Uptime | Available time / Total time | 99.9% |

---

## 12. Risks and Mitigations

### 12.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Calendar sync failures | Medium | Medium | Retry mechanisms, manual sync option |
| Notification delivery delays | Medium | High | Multi-channel fallback, queue monitoring |
| High load during peak hours | Medium | High | Auto-scaling, caching, rate limiting |
| Data inconsistency across services | Low | High | Saga pattern, eventual consistency |

### 12.2 Business Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Low visit confirmation rate | Medium | High | Auto-reminders, incentives for quick response |
| High no-show rate | Medium | High | Reminders, confirmation requirements, reputation system |
| Poor feedback quality | Medium | Medium | Structured feedback forms, incentivized reviews |
| RM overallocation | Medium | Medium | Workload balancing algorithms, capacity alerts |

### 12.3 User Experience Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Complex scheduling flow | Medium | High | Simplified UI, smart defaults |
| Notification fatigue | Medium | Medium | Configurable preferences, smart bundling |
| Timezone confusion | Low | Medium | Clear timezone display, local time conversion |

---

## 13. Implementation Phases

### Phase 1: MVP (P0 Features)
**Timeline: 6-8 weeks**

- Basic visit request and confirmation flow
- Simple availability management (weekly recurring)
- Visit status tracking (requested, confirmed, completed, cancelled)
- Basic notifications (SMS, email)
- Visit list views for all user types

### Phase 2: Enhanced Scheduling (P1 Features)
**Timeline: 4-6 weeks**

- Advanced availability management (exceptions, per-property)
- Reschedule workflows
- Reminder system
- Feedback collection
- Calendar views
- RM-assisted visit scheduling

### Phase 3: Advanced Features (P2 Features)
**Timeline: 4-6 weeks**

- External calendar sync (Google, Outlook)
- Advanced analytics and reporting
- Visit outcome tracking
- Automated follow-up triggers
- Mobile optimizations

### Phase 4: Optimization (P3 Features)
**Timeline: Ongoing**

- AI-powered scheduling suggestions
- Predictive availability
- Advanced fraud detection
- Virtual visit support
- Performance optimizations

---

## 14. Appendix

### 14.1 Glossary

| Term | Definition |
|------|------------|
| Visit | A scheduled property viewing by a prospective tenant/buyer |
| Appointment | A generic scheduled meeting (may or may not be a property visit) |
| Availability | Time windows when a user is available for visits |
| RM | Relationship Manager - MySqrft staff who assist with visits |
| Instant Booking | Properties that allow immediate visit confirmation without owner approval |
| No-Show | When a party fails to attend a confirmed visit |
| Buffer Time | Minimum gap between consecutive visits |

### 14.2 Related Documents

- Platform Domain Definitions: `/docs/domains.md`
- Leads Domain PRD: `/docs/domain/leads.md`
- CRM Domain PRD: `/docs/domain/crm.md`
- Communications Domain PRD: `/docs/domain/communications.md`

### 14.3 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | MySqrft Team | Initial draft |

---

*This document is part of the MySqrft Platform Domain Documentation.*
