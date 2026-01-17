# Communications Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Communications |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | 2026-01-17 |
| **Platform** | MySqrft |

---

## 1. Executive Summary

### 1.1 Purpose

The Communications domain provides the foundational messaging, calling, and notification infrastructure for the MySqrft platform. It enables reliable, multi-channel communication between users (tenants, owners, buyers, sellers, RMs, and support agents) while respecting user preferences and regulatory requirements.

### 1.2 Primary Goal

**Messaging + Calling + Notifications**

Enable seamless, secure, and trackable communication across all MySqrft platform interactions through multiple channels while providing users with granular control over their communication preferences.

### 1.3 Business Value

- **User Engagement:** Timely notifications drive user actions (lead responses, visit confirmations, payment reminders)
- **Conversion Optimization:** Multi-channel reach increases response rates and reduces lead drop-off
- **Trust Building:** Masked calling protects user privacy while enabling direct communication
- **Operational Efficiency:** Automated notifications reduce manual follow-up burden on RMs and support
- **Compliance:** Centralized preference management ensures regulatory compliance (TRAI DND, GDPR)

---

## 2. Scope

### 2.1 In Scope

| Feature | Priority | Phase |
|---------|----------|-------|
| Multi-channel notifications (SMS, WhatsApp, Email, Push) | P0 | MVP |
| Message templates and localization | P0 | MVP |
| User notification preferences | P0 | MVP |
| Delivery tracking and retry logic | P0 | MVP |
| Do-not-disturb settings | P1 | MVP |
| In-app chat | P2 | Post-MVP (Optional) |
| Masked calling functionality | P2 | Post-MVP (Optional) |

### 2.2 Out of Scope

- Video calling/conferencing
- Voice message transcription
- AI-powered chatbots (handled by Support domain)
- Marketing campaign orchestration (handled by Marketing domain)
- Transactional email content design (provided by consuming domains)

### 2.3 Dependencies

| Domain | Dependency Type | Description |
|--------|-----------------|-------------|
| Auth | Upstream | User identity verification for message delivery |
| UserManagement | Upstream | User contact details, roles, and consent status |
| Entitlements | Upstream | Plan-based communication feature gating |
| Leads | Consumer | Lead notifications, contact reveal alerts |
| CRM | Consumer | Follow-up reminders, interaction logging |
| Scheduling | Consumer | Visit confirmations, reminders, cancellations |
| Billing | Consumer | Payment confirmations, invoice delivery |
| Support | Consumer | Ticket updates, resolution notifications |
| Society | Consumer | Visitor approvals, announcements |
| Analytics | Downstream | Delivery metrics, engagement tracking |

---

## 3. Key Entities

### 3.1 Entity Definitions

#### Message

Represents a communication unit sent through any channel.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| sender_id | UUID | User or system ID initiating the message |
| recipient_id | UUID | Target user ID |
| channel | Enum | SMS, WHATSAPP, EMAIL, PUSH, IN_APP |
| content | Text | Message body (may be templated) |
| template_id | UUID | Reference to template used (nullable) |
| status | Enum | QUEUED, SENT, DELIVERED, READ, FAILED |
| metadata | JSON | Channel-specific metadata |
| created_at | Timestamp | Creation timestamp |
| sent_at | Timestamp | Actual send timestamp |
| delivered_at | Timestamp | Delivery confirmation timestamp |

#### Notification

Represents a system-generated alert or update to a user.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| user_id | UUID | Target user ID |
| type | Enum | TRANSACTIONAL, PROMOTIONAL, SYSTEM |
| category | String | Notification category (lead, visit, payment, etc.) |
| title | String | Notification title |
| body | Text | Notification content |
| action_url | String | Deep link or action URL |
| channels | Array | Channels to deliver through |
| priority | Enum | LOW, NORMAL, HIGH, URGENT |
| read_at | Timestamp | When user read the notification |
| expires_at | Timestamp | Notification expiry time |
| created_at | Timestamp | Creation timestamp |

#### Template

Reusable message templates with localization support.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Template identifier name |
| channel | Enum | Target channel |
| locale | String | Language/locale code (en-IN, hi-IN, etc.) |
| subject | String | Email subject or notification title |
| body | Text | Template body with placeholders |
| variables | Array | Required variable definitions |
| category | String | Template category |
| status | Enum | DRAFT, ACTIVE, DEPRECATED |
| version | Integer | Template version number |
| approved_at | Timestamp | Approval timestamp (for WhatsApp) |
| created_at | Timestamp | Creation timestamp |
| updated_at | Timestamp | Last update timestamp |

#### Channel

Communication channel configuration.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| type | Enum | SMS, WHATSAPP, EMAIL, PUSH |
| provider | String | Service provider name |
| config | JSON | Provider-specific configuration |
| priority | Integer | Channel priority for failover |
| rate_limit | Integer | Messages per minute limit |
| status | Enum | ACTIVE, DEGRADED, INACTIVE |
| health_check_at | Timestamp | Last health check timestamp |

#### DeliveryStatus

Tracks message delivery lifecycle.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| message_id | UUID | Reference to Message |
| channel | Enum | Delivery channel |
| status | Enum | PENDING, SENT, DELIVERED, READ, BOUNCED, FAILED |
| provider_id | String | External provider message ID |
| error_code | String | Error code if failed |
| error_message | String | Error description |
| retry_count | Integer | Number of retry attempts |
| next_retry_at | Timestamp | Next scheduled retry |
| updated_at | Timestamp | Last status update |

### 3.2 Entity Relationships

```
User (from UserManagement)
  |
  +-- has many --> Notification
  |
  +-- has many --> Message (as sender or recipient)
  |
  +-- has one --> NotificationPreference
  |
  +-- has one --> DNDSettings

Message
  |
  +-- uses one --> Template (optional)
  |
  +-- sent via --> Channel
  |
  +-- has many --> DeliveryStatus

Template
  |
  +-- belongs to --> Channel
  |
  +-- has many --> LocalizedVariant
```

---

## 4. Functional Requirements

### 4.1 Multi-Channel Notifications

#### FR-COMM-001: Channel Selection

**Priority:** P0

The system shall support sending notifications through multiple channels:

| Channel | Use Cases | Provider Examples |
|---------|-----------|-------------------|
| SMS | OTP, urgent alerts, lead notifications | Twilio, MSG91, Gupshup |
| WhatsApp | Rich notifications, document sharing | WhatsApp Business API |
| Email | Invoices, agreements, detailed updates | SendGrid, SES, Mailgun |
| Push | Real-time alerts, engagement prompts | FCM, APNs |

**Acceptance Criteria:**
- [ ] System can send messages through all four channels
- [ ] Channel selection based on notification type and user preference
- [ ] Automatic fallback to alternate channel on primary failure
- [ ] Channel health monitoring with automatic failover

#### FR-COMM-002: Notification Routing

**Priority:** P0

The system shall intelligently route notifications based on:

1. **User Preferences:** Respect channel preferences per notification category
2. **Priority Level:** Urgent notifications may bypass certain preferences
3. **Channel Availability:** Route to available channels during outages
4. **Time of Day:** Respect DND settings and timezone

**Routing Logic:**
```
1. Check user notification preferences
2. Apply DND rules
3. Select preferred channel(s)
4. Check channel health
5. Apply rate limiting
6. Queue for delivery
7. Track and retry on failure
```

#### FR-COMM-003: Batch Notifications

**Priority:** P1

The system shall support bulk notification sending for:

- Society announcements
- Marketing campaigns (via Marketing domain)
- System maintenance notices
- Feature rollout announcements

**Constraints:**
- Maximum batch size: 10,000 recipients
- Rate limiting per channel
- Staggered delivery to prevent system overload

### 4.2 Message Templates and Localization

#### FR-COMM-004: Template Management

**Priority:** P0

The system shall provide template management capabilities:

| Feature | Description |
|---------|-------------|
| Create/Edit | WYSIWYG editor with variable placeholders |
| Version Control | Track template versions with rollback capability |
| Preview | Preview with sample data before activation |
| Approval Workflow | Required for WhatsApp Business templates |
| A/B Testing | Support for variant testing |

**Template Variable Syntax:**
```
Hello {{user.first_name}},

Your visit to {{property.address}} is confirmed for {{visit.date}} at {{visit.time}}.

Property Owner: {{owner.name}}
Contact: {{owner.masked_phone}}
```

#### FR-COMM-005: Localization Support

**Priority:** P0

The system shall support multi-language templates:

| Language | Locale Code | Status |
|----------|-------------|--------|
| English | en-IN | Required |
| Hindi | hi-IN | Required |
| Marathi | mr-IN | Phase 2 |
| Tamil | ta-IN | Phase 2 |
| Telugu | te-IN | Phase 2 |
| Kannada | kn-IN | Phase 2 |
| Bengali | bn-IN | Phase 2 |

**Localization Rules:**
- Default to user's preferred language
- Fallback to English if translation unavailable
- Support RTL languages in future phases
- Handle number and date formatting per locale

### 4.3 User Notification Preferences

#### FR-COMM-006: Preference Management

**Priority:** P0

Users shall be able to configure notification preferences:

| Category | Channels | Default |
|----------|----------|---------|
| Lead Alerts | Push, SMS, WhatsApp, Email | All enabled |
| Visit Updates | Push, SMS, WhatsApp | All enabled |
| Payment Reminders | Push, SMS, Email | All enabled |
| Marketing | Push, Email | Push only |
| Society Updates | Push, WhatsApp | All enabled |
| Account Security | SMS, Email | All enabled (non-optional) |

**Preference Levels:**
1. **Global:** Enable/disable all non-essential notifications
2. **Category:** Enable/disable by notification category
3. **Channel:** Enable/disable specific channels per category
4. **Frequency:** Immediate, digest, or weekly summary

#### FR-COMM-007: Preference Sync

**Priority:** P1

Preferences shall sync across:
- Mobile app (iOS, Android)
- Web application
- Account settings via API

### 4.4 Do-Not-Disturb Settings

#### FR-COMM-008: DND Configuration

**Priority:** P1

Users shall configure quiet hours:

| Setting | Description | Default |
|---------|-------------|---------|
| Enable DND | Toggle DND mode | Off |
| Start Time | Quiet hours start | 22:00 |
| End Time | Quiet hours end | 08:00 |
| Days | Days to apply DND | All days |
| Timezone | User's timezone | Auto-detected |

**DND Behavior:**
- **Queued:** Non-urgent notifications queued until DND ends
- **Bypass:** Security alerts and urgent notifications bypass DND
- **Delivery:** Queued notifications delivered in priority order when DND ends

#### FR-COMM-009: Smart DND

**Priority:** P2

The system may intelligently manage notification delivery:

- Detect user activity patterns
- Suggest optimal notification times
- Bundle non-urgent notifications
- Respect national holidays

### 4.5 Delivery Tracking and Retry Logic

#### FR-COMM-010: Delivery Tracking

**Priority:** P0

The system shall track message delivery status:

| Status | Description | Trigger |
|--------|-------------|---------|
| QUEUED | Message accepted for delivery | Initial creation |
| SENT | Message sent to provider | Provider acknowledgment |
| DELIVERED | Message delivered to device | Provider callback |
| READ | Message read by recipient | Read receipt (if available) |
| FAILED | Delivery failed permanently | Max retries exceeded |
| BOUNCED | Email bounced | Bounce notification |

**Tracking Events:**
- Provider webhook callbacks
- Read receipts (email, WhatsApp)
- Push notification delivery confirmation
- Bounce and complaint handling

#### FR-COMM-011: Retry Logic

**Priority:** P0

The system shall implement intelligent retry:

| Attempt | Delay | Backoff |
|---------|-------|---------|
| 1 | Immediate | - |
| 2 | 1 minute | Linear |
| 3 | 5 minutes | Linear |
| 4 | 30 minutes | Exponential |
| 5 | 2 hours | Exponential |
| 6 | 6 hours | Exponential |

**Retry Rules:**
- Max retry attempts: 6
- Total retry window: 24 hours
- Retry on: Temporary failures, rate limits, provider errors
- No retry on: Invalid recipient, permanent failures, unsubscribe
- Fallback to alternate channel after 3 failures on primary

### 4.6 In-App Chat (Optional)

#### FR-COMM-012: Chat Functionality

**Priority:** P2

The system may provide in-app messaging:

| Feature | Description |
|---------|-------------|
| Direct Messages | One-on-one chat between users |
| Thread Support | Organize conversations by topic |
| Media Sharing | Images, documents, location |
| Read Receipts | Show message read status |
| Typing Indicators | Show when user is typing |
| Message History | Persistent chat history |
| Search | Search within conversations |

**Chat Participants:**
- Tenant/Buyer <-> Owner/Seller
- User <-> RM (Relationship Manager)
- User <-> Support Agent
- Resident <-> Society Admin

### 4.7 Masked Calling (Optional)

#### FR-COMM-013: Masked Calling

**Priority:** P2

The system may provide privacy-protected calling:

| Feature | Description |
|---------|-------------|
| Number Masking | Virtual number hides real phone numbers |
| Call Recording | Optional recording for quality/dispute |
| Call Duration Limits | Configurable call duration limits |
| Call Logs | Track call history and outcomes |
| IVR Integration | Pre-call prompts and options |

**Masked Call Flow:**
```
1. User A initiates call to User B via MySqrft
2. System assigns virtual number
3. Call routes through virtual number
4. Real numbers hidden from both parties
5. Call logged with duration and outcome
6. Virtual number released after timeout
```

**Call Limits:**
- Free users: 3 calls per day
- Premium users: Unlimited calls
- Call duration: Configurable per plan (default: 10 minutes)

---

## 5. Non-Functional Requirements

### 5.1 Performance

| Metric | Requirement | Notes |
|--------|-------------|-------|
| Message Throughput | 10,000 messages/minute | Across all channels |
| API Latency (P95) | < 200ms | Message submission |
| Delivery Latency (P95) | < 5 seconds | Push, SMS |
| Delivery Latency (P95) | < 30 seconds | WhatsApp, Email |
| Queue Processing | < 1 minute backlog | Under normal load |

### 5.2 Availability

| Metric | Requirement |
|--------|-------------|
| Uptime SLA | 99.9% |
| RTO (Recovery Time) | < 15 minutes |
| RPO (Recovery Point) | < 1 minute |

### 5.3 Scalability

- Horizontal scaling of message workers
- Partitioned message queues by channel
- Database sharding by user_id for high-volume tables
- CDN caching for email assets

### 5.4 Security

| Requirement | Implementation |
|-------------|----------------|
| Data Encryption | TLS 1.3 in transit, AES-256 at rest |
| PII Protection | Mask phone numbers in logs |
| Access Control | Role-based API access |
| Audit Trail | Log all message operations |
| Rate Limiting | Per-user, per-channel limits |

### 5.5 Compliance

| Regulation | Requirement |
|------------|-------------|
| TRAI DND | Respect Do Not Disturb registry |
| GDPR | Data retention, right to erasure |
| CAN-SPAM | Unsubscribe handling for emails |
| WhatsApp Policy | Template approval, opt-in requirements |

---

## 6. API Specifications

### 6.1 Core Endpoints

#### Send Notification

```
POST /api/v1/notifications
```

**Request:**
```json
{
  "recipient_id": "uuid",
  "type": "TRANSACTIONAL",
  "category": "lead_alert",
  "template_id": "uuid",
  "variables": {
    "property_name": "2BHK in Koramangala",
    "owner_name": "John Doe"
  },
  "channels": ["PUSH", "SMS"],
  "priority": "HIGH"
}
```

**Response:**
```json
{
  "notification_id": "uuid",
  "status": "QUEUED",
  "channels_queued": ["PUSH", "SMS"],
  "created_at": "2026-01-17T10:30:00Z"
}
```

#### Get Notification Status

```
GET /api/v1/notifications/{notification_id}/status
```

**Response:**
```json
{
  "notification_id": "uuid",
  "overall_status": "DELIVERED",
  "channels": [
    {
      "channel": "PUSH",
      "status": "DELIVERED",
      "delivered_at": "2026-01-17T10:30:05Z"
    },
    {
      "channel": "SMS",
      "status": "DELIVERED",
      "delivered_at": "2026-01-17T10:30:03Z"
    }
  ]
}
```

#### Update User Preferences

```
PUT /api/v1/users/{user_id}/notification-preferences
```

**Request:**
```json
{
  "global_enabled": true,
  "categories": {
    "lead_alerts": {
      "enabled": true,
      "channels": ["PUSH", "SMS", "WHATSAPP"]
    },
    "marketing": {
      "enabled": false,
      "channels": []
    }
  },
  "dnd": {
    "enabled": true,
    "start_time": "22:00",
    "end_time": "08:00",
    "timezone": "Asia/Kolkata"
  }
}
```

### 6.2 Internal Events

#### Events Published

| Event | Trigger | Consumers |
|-------|---------|-----------|
| notification.sent | Message sent | Analytics |
| notification.delivered | Delivery confirmed | Analytics, CRM |
| notification.failed | Delivery failed | Support, Ops |
| notification.read | User read notification | Analytics, CRM |
| preference.updated | User changed preferences | Analytics |

#### Events Consumed

| Event | Source | Action |
|-------|--------|--------|
| lead.created | Leads | Send lead notification to owner |
| visit.scheduled | Scheduling | Send confirmation to parties |
| payment.completed | Billing | Send receipt notification |
| ticket.updated | Support | Send status update |

---

## 7. User Stories

### 7.1 MVP User Stories

#### US-COMM-001: Receive Lead Notification

**As a** property owner
**I want to** receive immediate notification when someone expresses interest in my property
**So that** I can respond quickly and not lose potential tenants

**Acceptance Criteria:**
- [ ] Notification sent within 5 seconds of lead creation
- [ ] Notification includes property details and lead contact method
- [ ] Notification respects user's channel preferences
- [ ] Owner can click through to view lead details

#### US-COMM-002: Manage Notification Preferences

**As a** MySqrft user
**I want to** control which notifications I receive and through which channels
**So that** I only receive relevant communications

**Acceptance Criteria:**
- [ ] Can enable/disable notifications by category
- [ ] Can choose preferred channels per category
- [ ] Changes take effect immediately
- [ ] Security notifications cannot be disabled

#### US-COMM-003: Set Do-Not-Disturb Hours

**As a** MySqrft user
**I want to** set quiet hours when I don't want to be disturbed
**So that** I have uninterrupted personal time

**Acceptance Criteria:**
- [ ] Can set custom start and end times
- [ ] Can select which days DND applies
- [ ] Urgent notifications bypass DND with user consent
- [ ] Notifications queue and deliver after DND ends

#### US-COMM-004: Receive Visit Confirmation

**As a** tenant/buyer
**I want to** receive confirmation of my scheduled property visit
**So that** I have all details readily available

**Acceptance Criteria:**
- [ ] Confirmation sent immediately after scheduling
- [ ] Includes property address, date, time, and owner details
- [ ] Reminder sent 24 hours and 1 hour before visit
- [ ] Contains option to reschedule or cancel

### 7.2 Post-MVP User Stories

#### US-COMM-005: Chat with Property Owner

**As a** potential tenant
**I want to** chat with the property owner within the app
**So that** I can ask questions without sharing my phone number

**Acceptance Criteria:**
- [ ] Can initiate chat from listing page
- [ ] Messages delivered in real-time
- [ ] Chat history persisted
- [ ] Notifications for new messages

#### US-COMM-006: Make Masked Call

**As a** MySqrft user
**I want to** call another user without revealing my phone number
**So that** my privacy is protected

**Acceptance Criteria:**
- [ ] Call connects through virtual number
- [ ] Neither party sees the other's real number
- [ ] Call quality comparable to direct call
- [ ] Call duration tracked in system

---

## 8. Wireframes and Mockups

### 8.1 Notification Preferences Screen

```
+------------------------------------------+
|  Notification Settings                    |
+------------------------------------------+
|                                          |
|  [Toggle] Enable All Notifications       |
|                                          |
|  ----------------------------------------|
|  PROPERTY ALERTS                         |
|  ----------------------------------------|
|  New Lead Alerts        [ON]             |
|    Channels: [x]Push [x]SMS [x]WhatsApp  |
|                                          |
|  Price Drop Alerts      [ON]             |
|    Channels: [x]Push [ ]SMS [x]Email     |
|                                          |
|  ----------------------------------------|
|  VISITS                                  |
|  ----------------------------------------|
|  Visit Confirmations    [ON]             |
|    Channels: [x]Push [x]SMS [x]WhatsApp  |
|                                          |
|  Visit Reminders        [ON]             |
|    Channels: [x]Push [ ]SMS              |
|                                          |
|  ----------------------------------------|
|  DO NOT DISTURB                          |
|  ----------------------------------------|
|  Enable DND             [ON]             |
|  Quiet Hours: 22:00 - 08:00              |
|  Days: Mon Tue Wed Thu Fri Sat Sun       |
|                                          |
|  [Save Preferences]                      |
+------------------------------------------+
```

### 8.2 Notification Center

```
+------------------------------------------+
|  Notifications                     [...]  |
+------------------------------------------+
|  Today                                   |
|  ----------------------------------------|
|  [!] New Lead - 2BHK Koramangala         |
|      Rahul is interested in your...      |
|      10:30 AM                    [View]  |
|  ----------------------------------------|
|  Visit Confirmed                         |
|      Your visit to 3BHK HSR Layout       |
|      is scheduled for tomorrow...        |
|      9:15 AM                     [View]  |
|  ----------------------------------------|
|  Yesterday                               |
|  ----------------------------------------|
|  Payment Received                        |
|      Your premium plan payment of        |
|      Rs 4,999 was successful.            |
|      3:45 PM                     [View]  |
|  ----------------------------------------|
|  [Mark All as Read]                      |
+------------------------------------------+
```

---

## 9. Success Metrics

### 9.1 Key Performance Indicators (KPIs)

| Metric | Definition | Target |
|--------|------------|--------|
| Delivery Rate | % of messages successfully delivered | > 98% |
| Time to Deliver (P95) | 95th percentile delivery time | < 10 seconds |
| Notification Open Rate | % of push notifications opened | > 30% |
| Email Open Rate | % of emails opened | > 25% |
| Preference Opt-out Rate | % of users disabling notifications | < 5% |
| Channel Failover Rate | % of messages requiring failover | < 2% |
| User Satisfaction (CSAT) | Rating of notification experience | > 4.0/5 |

### 9.2 Monitoring Dashboards

**Real-time Dashboard:**
- Messages queued/sent/delivered per minute
- Channel health status
- Error rates by channel and type
- Provider latency

**Daily Dashboard:**
- Delivery success rate by channel
- Top notification categories
- User preference changes
- DND usage patterns

---

## 10. Risks and Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Provider Outage | Medium | High | Multi-provider setup, automatic failover |
| Rate Limiting | Medium | Medium | Queue management, priority routing |
| Spam Complaints | Low | High | Strict opt-in, easy unsubscribe, content moderation |
| DND Violations | Low | Medium | Robust DND check before every send |
| Template Rejection | Medium | Medium | Pre-validation, approval workflow, fallback templates |
| Cost Overrun | Medium | Medium | Usage monitoring, budget alerts, channel optimization |
| Data Breach | Low | Critical | Encryption, access controls, audit logging |

---

## 11. Implementation Phases

### Phase 1: MVP Foundation (Weeks 1-4)

| Week | Deliverables |
|------|--------------|
| 1 | Core entities, database schema, basic API structure |
| 2 | SMS and Email integration, template engine |
| 3 | Push notification setup (FCM/APNs), preference management |
| 4 | Delivery tracking, retry logic, basic dashboard |

### Phase 2: Enhanced Capabilities (Weeks 5-8)

| Week | Deliverables |
|------|--------------|
| 5 | WhatsApp Business API integration |
| 6 | DND settings, timezone handling, localization framework |
| 7 | Multi-language templates (Hindi support) |
| 8 | Advanced analytics, performance optimization |

### Phase 3: Optional Features (Weeks 9-12)

| Week | Deliverables |
|------|--------------|
| 9-10 | In-app chat infrastructure |
| 11-12 | Masked calling integration |

---

## 12. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Which SMS provider for primary integration? | Engineering | Open |
| 2 | WhatsApp Business API approval timeline? | Product | Open |
| 3 | Budget allocation per channel? | Finance | Open |
| 4 | Message retention period for compliance? | Legal | Open |
| 5 | Priority for regional language support? | Product | Open |
| 6 | Masked calling provider selection? | Engineering | Open |
| 7 | In-app chat real-time infrastructure (WebSocket vs Polling)? | Engineering | Open |

---

## 13. Appendix

### 13.1 Glossary

| Term | Definition |
|------|------------|
| DND | Do Not Disturb - quiet hours when notifications are suppressed |
| FCM | Firebase Cloud Messaging - Google's push notification service |
| APNs | Apple Push Notification service |
| TRAI | Telecom Regulatory Authority of India |
| OTP | One-Time Password |
| Template | Pre-approved message format with variable placeholders |
| Channel | Communication medium (SMS, Email, Push, WhatsApp) |
| Masked Calling | Phone call routing through virtual number to hide real numbers |

### 13.2 Related Documents

- [MySqrft Domain Definitions](/Users/ravides/Projects/my_sqrft/docs/domains.md)
- UserManagement Domain PRD (pending)
- Auth Domain PRD (pending)
- Entitlements Domain PRD (pending)

### 13.3 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | Product Team | Initial draft |

---

*This document is part of the MySqrft platform domain documentation.*
