# PropertyManagement Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | PropertyManagement |
| Version | 1.0 |
| Status | Complete |
| Last Updated | 2026-01-17 |
| Owner | MySqrft Product Team |

---

## 1. Overview

### 1.1 Purpose

The PropertyManagement domain provides comprehensive recurring owner services within the MySqrft platform. It enables property managers to efficiently handle day-to-day operations including rent collection, maintenance coordination, vendor management, and financial reporting for property owners.

### 1.2 Primary Goal

**Recurring Owner Services** - Deliver a complete property management solution that streamlines operations, ensures timely rent collection, coordinates maintenance efficiently, and provides transparent financial reporting to property owners.

### 1.3 Scope

This domain encompasses all functionality related to:
- Property management onboarding and contracts
- Rent collection tracking and receipts
- Maintenance ticket management
- Vendor coordination
- Owner statement generation
- Audit trail maintenance
- PM fee calculation (fixed/percentage)
- Contract renewals

### 1.4 Key Entities

| Entity | Description |
|--------|-------------|
| **PMContract** | Property management agreement between owner and manager defining terms, fees, and responsibilities |
| **RentCollection** | Records of rent payments collected from tenants including status, amounts, and dates |
| **MaintenanceTicket** | Service requests for property repairs and maintenance with tracking and resolution |
| **OwnerStatement** | Monthly/periodic financial reports generated for property owners |
| **PMFee** | Fee structure and calculations for property management services |

---

## 2. Goals and Objectives

### 2.1 Business Goals

| ID | Goal | Success Indicator |
|----|------|-------------------|
| BG-01 | Increase property management service adoption | 25% increase in managed properties within 12 months |
| BG-02 | Reduce rent collection delinquency | Decrease late payments by 40% |
| BG-03 | Improve maintenance response times | Average ticket resolution under 48 hours |
| BG-04 | Enhance owner satisfaction | Owner NPS score above 60 |
| BG-05 | Streamline PM operations | Reduce administrative overhead by 30% |

### 2.2 User Goals

| User Type | Goal |
|-----------|------|
| Property Manager | Efficiently manage multiple properties with minimal manual effort |
| Property Owner | Receive transparent, timely financial reports and property updates |
| Tenant | Submit and track maintenance requests easily |
| Vendor | Receive clear work orders and process payments smoothly |

### 2.3 Technical Goals

| ID | Goal |
|----|------|
| TG-01 | Build scalable architecture supporting 10,000+ managed properties |
| TG-02 | Ensure real-time synchronization of payment data |
| TG-03 | Maintain comprehensive audit trails for compliance |
| TG-04 | Enable seamless integration with accounting systems |

---

## 3. Key Features

### 3.1 Property Management Onboarding and Contracts

Streamlined process for bringing new properties under management with digital contract execution.

**Capabilities:**
- Digital PM contract creation with customizable templates
- Electronic signature integration
- Property inventory and condition documentation
- Owner information and banking setup
- Tenant transition management
- Document storage and retrieval

### 3.2 Rent Collection Tracking and Receipts

Comprehensive rent collection system with automated tracking and receipt generation.

**Capabilities:**
- Multiple payment method support (ACH, credit card, check)
- Automated rent reminders and late notices
- Payment allocation across multiple charges
- Digital receipt generation and delivery
- Partial payment handling
- NSF/bounced payment processing
- Grace period management

### 3.3 Maintenance Ticket Management

End-to-end maintenance request handling from submission to resolution.

**Capabilities:**
- Multi-channel ticket submission (web, mobile, phone)
- Priority classification and SLA tracking
- Photo and document attachments
- Status updates and tenant communication
- Work order generation
- Completion verification
- Historical maintenance records

### 3.4 Vendor Coordination

Centralized vendor management and work assignment system.

**Capabilities:**
- Vendor database with ratings and specialties
- Automated vendor matching based on job type
- Work order dispatch and acceptance
- Scheduling and appointment management
- Invoice processing and approval
- Vendor performance tracking
- Insurance and license verification

### 3.5 Owner Statement Generation

Automated financial reporting for property owners.

**Capabilities:**
- Configurable statement periods (monthly, quarterly)
- Income and expense categorization
- Reserve fund tracking
- Year-end tax document preparation
- Multi-property consolidated statements
- PDF and CSV export options
- Owner portal access

### 3.6 Audit Trail Maintenance

Comprehensive logging of all system activities for compliance and accountability.

**Capabilities:**
- Immutable transaction logs
- User action tracking
- Document version history
- Financial reconciliation records
- Compliance reporting
- Data retention management
- Export for legal/audit purposes

### 3.7 PM Fee Calculation

Flexible fee structure supporting various pricing models.

**Capabilities:**
- Fixed monthly fee configuration
- Percentage-based fee calculation
- Tiered fee structures
- Lease-up and placement fees
- Maintenance markup settings
- Fee adjustment history
- Automated fee deduction from owner disbursements

### 3.8 Contract Renewals

Automated contract renewal workflow management.

**Capabilities:**
- Renewal reminder scheduling
- Term modification proposals
- Digital renewal execution
- Fee adjustment negotiations
- Auto-renewal option handling
- Contract expiration alerts
- Historical contract archive

---

## 4. User Stories

### 4.1 Property Manager Stories

| ID | User Story | Priority |
|----|------------|----------|
| PM-US-01 | As a property manager, I want to onboard new properties digitally so that I can quickly add properties to my portfolio without paperwork delays | High |
| PM-US-02 | As a property manager, I want to view all rent collection statuses in a dashboard so that I can identify delinquent accounts immediately | High |
| PM-US-03 | As a property manager, I want to assign maintenance tickets to vendors automatically so that repairs are addressed without manual intervention | High |
| PM-US-04 | As a property manager, I want to generate owner statements with one click so that I can deliver timely financial reports | High |
| PM-US-05 | As a property manager, I want to track all actions in an audit log so that I can maintain compliance and resolve disputes | Medium |
| PM-US-06 | As a property manager, I want to configure different fee structures per property so that I can accommodate various client agreements | Medium |
| PM-US-07 | As a property manager, I want to receive contract renewal alerts so that I never miss a renewal deadline | Medium |
| PM-US-08 | As a property manager, I want to bulk-process rent receipts so that I can handle high-volume collections efficiently | Medium |

### 4.2 Property Owner Stories

| ID | User Story | Priority |
|----|------------|----------|
| PO-US-01 | As a property owner, I want to view my statements online so that I can access financial information anytime | High |
| PO-US-02 | As a property owner, I want to see maintenance history for my property so that I understand how my property is being maintained | High |
| PO-US-03 | As a property owner, I want to receive notifications when rent is collected so that I have visibility into my cash flow | Medium |
| PO-US-04 | As a property owner, I want to approve large maintenance expenses so that I control significant spending | Medium |
| PO-US-05 | As a property owner, I want to download tax documents so that I can easily file my taxes | Medium |

### 4.3 Tenant Stories

| ID | User Story | Priority |
|----|------------|----------|
| TN-US-01 | As a tenant, I want to submit maintenance requests online so that I can report issues at any time | High |
| TN-US-02 | As a tenant, I want to track my maintenance request status so that I know when to expect repairs | High |
| TN-US-03 | As a tenant, I want to receive rent receipts automatically so that I have payment confirmation | Medium |
| TN-US-04 | As a tenant, I want to pay rent through multiple methods so that I can use my preferred payment option | Medium |

### 4.4 Vendor Stories

| ID | User Story | Priority |
|----|------------|----------|
| VN-US-01 | As a vendor, I want to receive work orders digitally so that I can respond quickly to job assignments | High |
| VN-US-02 | As a vendor, I want to submit invoices through the platform so that I get paid faster | Medium |
| VN-US-03 | As a vendor, I want to update job status in real-time so that all parties stay informed | Medium |

---

## 5. Acceptance Criteria

### 5.1 Property Management Onboarding

| ID | Criteria |
|----|----------|
| AC-01 | System allows creation of PM contracts with all required fields (parties, property, terms, fees, effective dates) |
| AC-02 | Contracts support electronic signature via integrated e-sign provider |
| AC-03 | Property condition documentation accepts photos, videos, and written descriptions |
| AC-04 | Owner banking information is securely stored with encryption |
| AC-05 | Onboarding workflow can be completed in under 15 minutes |

### 5.2 Rent Collection

| ID | Criteria |
|----|----------|
| AC-06 | System supports ACH, credit card, and manual check entry payment methods |
| AC-07 | Automated reminders are sent 5 days before rent due date |
| AC-08 | Late notices are sent automatically after grace period expires |
| AC-09 | Receipts are generated and emailed within 1 minute of payment confirmation |
| AC-10 | Partial payments are properly allocated and tracked |

### 5.3 Maintenance Tickets

| ID | Criteria |
|----|----------|
| AC-11 | Tickets can be submitted via web portal, mobile app, or phone entry |
| AC-12 | Priority levels (Emergency, Urgent, Normal, Low) are properly categorized |
| AC-13 | Photo attachments up to 10MB are supported |
| AC-14 | Status updates trigger notifications to all relevant parties |
| AC-15 | Ticket history is retained for minimum 7 years |

### 5.4 Owner Statements

| ID | Criteria |
|----|----------|
| AC-16 | Statements accurately reflect all income and expenses for the period |
| AC-17 | Statements are available by the 10th of the following month |
| AC-18 | PDF export matches screen display exactly |
| AC-19 | Year-end summary includes all tax-relevant categories |
| AC-20 | Multi-property owners can view consolidated statements |

### 5.5 PM Fees

| ID | Criteria |
|----|----------|
| AC-21 | Fixed fees are charged on the specified day each month |
| AC-22 | Percentage fees are calculated based on actual rent collected |
| AC-23 | Fee changes are applied from the specified effective date forward |
| AC-24 | Fee history is maintained and auditable |
| AC-25 | Fees are automatically deducted before owner disbursement |

---

## 6. Functional Requirements

### 6.1 PMContract Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-01 | System shall support creation, modification, and termination of PM contracts | High |
| FR-02 | System shall maintain contract templates with customizable clauses | High |
| FR-03 | System shall integrate with e-signature providers (DocuSign, HelloSign) | High |
| FR-04 | System shall track contract status (Draft, Active, Expired, Terminated) | High |
| FR-05 | System shall generate renewal notifications 90, 60, and 30 days before expiration | Medium |
| FR-06 | System shall support auto-renewal with configurable terms | Medium |
| FR-07 | System shall maintain complete version history of all contracts | Medium |

### 6.2 RentCollection Processing

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-08 | System shall process rent payments via ACH, credit card, and manual entry | High |
| FR-09 | System shall generate and deliver receipts for all payments | High |
| FR-10 | System shall calculate and apply late fees based on lease terms | High |
| FR-11 | System shall send automated payment reminders on configurable schedule | High |
| FR-12 | System shall handle partial payments with proper allocation | Medium |
| FR-13 | System shall process NSF/bounced payments and associated fees | Medium |
| FR-14 | System shall support recurring payment setup for tenants | Medium |
| FR-15 | System shall provide real-time payment status dashboard | Medium |

### 6.3 MaintenanceTicket Workflow

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-16 | System shall accept maintenance requests from multiple channels | High |
| FR-17 | System shall categorize tickets by type and priority automatically | High |
| FR-18 | System shall route tickets to appropriate vendors based on job type | High |
| FR-19 | System shall track SLA compliance for each priority level | High |
| FR-20 | System shall support photo, video, and document attachments | Medium |
| FR-21 | System shall send status updates to tenants and owners | Medium |
| FR-22 | System shall require completion verification before closing tickets | Medium |
| FR-23 | System shall maintain searchable maintenance history per property | Medium |

### 6.4 Vendor Coordination

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-24 | System shall maintain vendor profiles with contact info, specialties, and rates | High |
| FR-25 | System shall dispatch work orders to selected vendors | High |
| FR-26 | System shall track vendor acceptance and response times | Medium |
| FR-27 | System shall process vendor invoices and track approval workflow | Medium |
| FR-28 | System shall verify vendor insurance and license status | Medium |
| FR-29 | System shall calculate vendor performance metrics | Low |

### 6.5 OwnerStatement Generation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-30 | System shall generate periodic owner statements automatically | High |
| FR-31 | System shall categorize all income and expenses accurately | High |
| FR-32 | System shall support multiple statement formats (detailed, summary) | Medium |
| FR-33 | System shall export statements as PDF and CSV | Medium |
| FR-34 | System shall generate year-end tax summary (1099 data) | Medium |
| FR-35 | System shall support statement delivery via email and portal | Medium |

### 6.6 PMFee Calculation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-36 | System shall support fixed monthly fee configuration | High |
| FR-37 | System shall support percentage-based fee calculation | High |
| FR-38 | System shall calculate fees based on actual rent collected | High |
| FR-39 | System shall support tiered fee structures | Medium |
| FR-40 | System shall track and apply lease-up/placement fees | Medium |
| FR-41 | System shall support maintenance coordination markup fees | Medium |
| FR-42 | System shall automatically deduct fees from owner disbursements | High |

### 6.7 Audit Trail

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-43 | System shall log all financial transactions with timestamps | High |
| FR-44 | System shall record user actions with user identification | High |
| FR-45 | System shall maintain immutable audit records | High |
| FR-46 | System shall support audit log search and filtering | Medium |
| FR-47 | System shall export audit trails for compliance review | Medium |
| FR-48 | System shall retain audit records per data retention policy (7 years minimum) | Medium |

---

## 7. Non-Functional Requirements

### 7.1 Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-01 | Dashboard page load time | < 2 seconds |
| NFR-02 | Payment processing completion | < 5 seconds |
| NFR-03 | Statement generation time | < 30 seconds per property |
| NFR-04 | Search result response time | < 1 second |
| NFR-05 | Concurrent user support | 1,000+ simultaneous users |
| NFR-06 | Payment processing throughput | 100+ transactions per minute |

### 7.2 Scalability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-07 | Support managed properties | 10,000+ properties |
| NFR-08 | Support monthly transactions | 50,000+ rent payments |
| NFR-09 | Support maintenance tickets | 10,000+ open tickets |
| NFR-10 | Horizontal scaling capability | Auto-scale based on load |

### 7.3 Availability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-11 | System uptime | 99.9% availability |
| NFR-12 | Planned maintenance window | < 4 hours monthly |
| NFR-13 | Recovery Time Objective (RTO) | < 1 hour |
| NFR-14 | Recovery Point Objective (RPO) | < 15 minutes |

### 7.4 Security

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-15 | Data encryption at rest | AES-256 encryption |
| NFR-16 | Data encryption in transit | TLS 1.3 |
| NFR-17 | Payment data compliance | PCI-DSS Level 1 |
| NFR-18 | Access control | Role-based access (RBAC) |
| NFR-19 | Session timeout | 30 minutes inactivity |
| NFR-20 | Password requirements | Minimum 12 characters, complexity enforced |
| NFR-21 | Multi-factor authentication | Required for financial operations |

### 7.5 Compliance

| ID | Requirement | Standard |
|----|-------------|----------|
| NFR-22 | Financial reporting | GAAP compliance |
| NFR-23 | Data privacy | CCPA, state-specific requirements |
| NFR-24 | Accessibility | WCAG 2.1 AA |
| NFR-25 | Data retention | 7-year minimum for financial records |

### 7.6 Usability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-26 | Mobile responsiveness | Full functionality on mobile devices |
| NFR-27 | Browser support | Chrome, Firefox, Safari, Edge (latest 2 versions) |
| NFR-28 | Training time for new users | < 2 hours for core functions |
| NFR-29 | Error message clarity | Actionable error messages with resolution steps |

---

## 8. Integration Points

### 8.1 Internal Domain Integrations

| Domain | Integration Type | Description |
|--------|------------------|-------------|
| **Leasing** | Bidirectional | Receive tenant and lease data; update rent schedules |
| **Accounting** | Bidirectional | Send transactions; receive chart of accounts |
| **Owners** | Bidirectional | Receive owner profiles; send statements and reports |
| **Properties** | Read | Access property details and unit information |
| **Tenants** | Bidirectional | Access tenant data; update payment history |
| **Documents** | Bidirectional | Store and retrieve contracts, receipts, statements |
| **Notifications** | Outbound | Trigger alerts, reminders, and communications |
| **Payments** | Bidirectional | Process payments; receive confirmation |

### 8.2 External System Integrations

| System | Integration Type | Purpose |
|--------|------------------|---------|
| **Payment Gateway** (Stripe/Plaid) | API | Process ACH and credit card payments |
| **E-Signature** (DocuSign/HelloSign) | API | Contract and document signing |
| **Banking** (Plaid) | API | Bank account verification and ACH setup |
| **Accounting Software** (QuickBooks/Xero) | API | Sync financial data with external accounting |
| **Email Service** (SendGrid/SES) | API | Transactional email delivery |
| **SMS Service** (Twilio) | API | Text notifications and alerts |
| **Document Storage** (S3/Azure Blob) | API | Secure document storage |

### 8.3 Integration Data Flows

```
Tenant Payment Flow:
Tenants -> Payments -> RentCollection -> Accounting -> OwnerStatement

Maintenance Flow:
Tenants -> MaintenanceTicket -> Vendors -> Accounting -> OwnerStatement

Contract Flow:
Owners -> PMContract -> E-Signature -> Documents -> Notifications
```

---

## 9. Dependencies

### 9.1 Upstream Dependencies

| Dependency | Domain/System | Impact | Mitigation |
|------------|---------------|--------|------------|
| Property data | Properties | Cannot manage properties without property records | Graceful degradation; queue operations |
| Owner profiles | Owners | Cannot generate statements without owner info | Cache owner data locally |
| Lease data | Leasing | Cannot track rent without lease terms | Manual rent amount entry fallback |
| Tenant data | Tenants | Cannot process payments without tenant records | Allow manual tenant creation |
| Payment processing | Payments | Cannot collect rent without payment system | Multiple payment provider support |

### 9.2 Downstream Dependencies

| Dependent | Domain/System | Data Provided |
|-----------|---------------|---------------|
| Accounting | Internal | Transaction records, fee calculations |
| Reporting | Internal | Collection stats, maintenance metrics |
| Owner Portal | Internal | Statements, maintenance updates |
| Tenant Portal | Internal | Payment history, maintenance status |

### 9.3 Technical Dependencies

| Dependency | Type | Version | Purpose |
|------------|------|---------|---------|
| PostgreSQL | Database | 14+ | Primary data storage |
| Redis | Cache | 7+ | Session and data caching |
| Elasticsearch | Search | 8+ | Audit log and search indexing |
| RabbitMQ/Kafka | Message Queue | - | Event-driven communication |
| Node.js/Python | Runtime | LTS | Application runtime |

---

## 10. Success Metrics

### 10.1 Key Performance Indicators (KPIs)

| ID | Metric | Current | Target | Timeline |
|----|--------|---------|--------|----------|
| KPI-01 | On-time rent collection rate | - | 95% | 6 months |
| KPI-02 | Average maintenance ticket resolution time | - | < 48 hours | 6 months |
| KPI-03 | Owner statement delivery on-time rate | - | 99% | 3 months |
| KPI-04 | PM contract renewal rate | - | 85% | 12 months |
| KPI-05 | Owner satisfaction score (NPS) | - | 60+ | 12 months |
| KPI-06 | System availability | - | 99.9% | Ongoing |

### 10.2 Operational Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| Properties under management | Total active managed properties | 1,000 (Year 1) |
| Monthly rent processed | Total rent collected through platform | $5M+ (Year 1) |
| Maintenance tickets processed | Monthly ticket volume | 500+ |
| Vendor network size | Active vendors in network | 200+ |
| Average PM fee revenue | Monthly fee revenue per property | $150 |

### 10.3 Quality Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| Payment processing error rate | Failed/incorrect payments | < 0.1% |
| Statement accuracy rate | Statements without corrections | 99.5% |
| Audit finding rate | Issues found in compliance audits | 0 critical |
| Support ticket volume | PM-related support requests | < 5% of users |

### 10.4 User Adoption Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| PM portal daily active users | Unique PM logins per day | 70% of PMs |
| Owner portal adoption | Owners accessing portal monthly | 80% |
| Mobile app usage | Actions via mobile app | 40% |
| Feature utilization | PMs using all core features | 60% |

---

## 11. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Payment processing failures | Medium | High | Multiple payment providers; retry logic; manual fallback |
| Data security breach | Low | Critical | Encryption; access controls; security audits; incident response plan |
| Integration downtime | Medium | Medium | Circuit breakers; cached data; graceful degradation |
| Compliance violations | Low | High | Regular audits; automated compliance checks; legal review |
| User adoption resistance | Medium | Medium | Training programs; intuitive UX; gradual rollout |

---

## 12. Glossary

| Term | Definition |
|------|------------|
| PM | Property Manager/Management |
| ACH | Automated Clearing House (electronic bank transfer) |
| NSF | Non-Sufficient Funds (bounced payment) |
| SLA | Service Level Agreement |
| NPS | Net Promoter Score |
| RBAC | Role-Based Access Control |
| RTO | Recovery Time Objective |
| RPO | Recovery Point Objective |

---

## 13. Appendix

### 13.1 Related Documents

- MySqrft Platform Architecture
- Accounting Domain PRD
- Leasing Domain PRD
- Payment Processing Integration Guide
- Security and Compliance Standards

### 13.2 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-17 | MySqrft Product Team | Initial document creation |

---

*This document is maintained by the MySqrft Product Team. For questions or updates, contact the domain owner.*
