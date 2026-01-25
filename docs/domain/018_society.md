# Society - Product Requirements

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Society |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | January 2026 |
| **Platform** | MySqrft |

---

## Overview

The Society domain is the comprehensive community management layer of the MySqrft platform, providing a complete SaaS solution for residential societies and gated communities. Inspired by leading community management platforms like NoBrokerHood, this domain enables efficient administration of residential complexes through digital transformation of traditionally manual processes including visitor management, maintenance billing, complaint resolution, and community communication.

As the central hub for community operations, the Society domain orchestrates interactions between multiple stakeholder roles including society administrators, committee members, residents, security guards, and vendors. It manages the complete lifecycle of community activities from resident onboarding and visitor approvals to maintenance fee collection and complaint resolution. The domain supports both day-to-day operational workflows and strategic community governance through announcements and polls.

The Society domain serves as a critical touchpoint for residential community engagement within MySqrft, providing self-service capabilities that reduce administrative burden while improving transparency and communication. It establishes the foundation for future smart community features including hardware integration with access gates and intercom systems, enabling a seamless blend of physical and digital community management experiences.

## Goals & Objectives

- Provide a unified platform for managing all aspects of residential community operations, reducing reliance on manual processes and paper-based systems
- Enable efficient role-based access control that empowers different stakeholder types (admin, committee, resident, guard, vendor) with appropriate capabilities
- Streamline visitor management with pre-approvals, real-time notifications, and comprehensive visitor logs for enhanced security
- Automate maintenance billing and collections with transparent tracking, payment reminders, and receipt generation
- Establish an effective complaints and helpdesk system that ensures timely resolution and accountability
- Facilitate community engagement through announcements, polls, and transparent communication channels
- Support staff onboarding and training workflows to maintain service quality standards
- Build extensible architecture for future hardware integration with gates, intercoms, and IoT devices

## Key Features

- **Role Management System**: Comprehensive role-based access control supporting admin, committee member, resident, security guard, and vendor roles with granular permissions and approval workflows for role assignments.

- **Visitor Management**: End-to-end visitor lifecycle management including pre-approval by residents, guard verification at entry, visitor passes (daily, recurring, expected delivery), real-time notifications, and comprehensive visitor logs.

- **Maintenance Billing and Collections**: Automated generation of maintenance bills based on configurable fee structures, support for multiple payment methods, payment tracking, overdue reminders, receipt generation, and financial reporting.

- **Complaints and Helpdesk**: Structured complaint submission with categorization, assignment to responsible parties, SLA tracking, status updates, resolution workflows, and satisfaction feedback collection.

- **Announcements and Polls**: Community-wide broadcast capabilities for announcements with read receipts, and democratic decision-making through polls with voting, results transparency, and deadline management.

- **Staff Onboarding and Training**: Workflows for adding society staff (guards, housekeeping, maintenance), document verification, training module assignments, and performance tracking.

## User Stories

1. **As a society administrator**, I want to create and manage different roles within the society so that each member has appropriate access to relevant features and information.

2. **As a resident**, I want to pre-approve expected visitors through the app so that they can enter the premises smoothly without delays at the gate.

3. **As a security guard**, I want to verify visitor details and approvals on my device so that I can efficiently manage entry while maintaining security protocols.

4. **As a resident**, I want to view my maintenance bills and payment history so that I can track my dues and make timely payments.

5. **As a society treasurer**, I want to generate and send maintenance bills to all residents so that collection can be streamlined and tracked systematically.

6. **As a resident**, I want to raise complaints about common area issues so that they can be addressed by the relevant maintenance staff.

7. **As an admin**, I want to assign complaints to appropriate vendors or staff so that issues are resolved within defined SLAs.

8. **As a committee member**, I want to post announcements to all residents so that important information reaches everyone promptly.

9. **As a resident**, I want to vote on community polls so that I can participate in society decisions that affect me.

10. **As an admin**, I want to onboard new security staff with proper documentation so that our society maintains security standards.

11. **As a vendor**, I want to receive service requests and update their status so that residents and admins can track progress.

## Acceptance Criteria

1. **Role Management**
   - System supports five distinct roles: admin, committee member, resident, guard, and vendor
   - Admin can create, modify, and revoke role assignments for all users
   - Committee members require admin approval for role assignment
   - Role changes trigger notification to affected users
   - Audit log captures all role assignment changes with timestamp and actor

2. **Visitor Management**
   - Residents can create visitor pre-approvals with visitor name, phone, expected date/time, and purpose
   - System generates unique visitor pass code for pre-approved visitors
   - Guards can search and verify visitors by pass code or phone number within 3 seconds
   - Real-time push notification sent to resident when visitor checks in
   - Visitor log captures entry time, exit time, vehicle details, and accompanying persons
   - Support for recurring visitor passes (daily help, regular vendors) with configurable validity

3. **Maintenance Billing**
   - Admin can configure fee structure with base amount, square footage rates, and additional charges
   - System auto-generates monthly bills on configured date with itemized breakdown
   - Residents receive bill notification via push notification, SMS, and email
   - Payment status tracks pending, partial, paid, and overdue states
   - Automatic reminders sent at 7 days, 3 days, and 1 day before due date
   - Overdue bills trigger escalation notifications to committee members
   - Payment receipt generated automatically upon successful payment

4. **Complaints and Helpdesk**
   - Residents can submit complaints with category, description, photos, and priority
   - System auto-assigns complaints based on category to default assignee
   - Admin can reassign complaints to specific staff or vendors
   - SLA clock starts on complaint creation with configurable resolution targets per category
   - Status transitions (open, assigned, in-progress, resolved, closed) require notes
   - Resident receives notification on every status change
   - Resolved complaints prompt satisfaction rating collection

5. **Announcements and Polls**
   - Admins and committee members can create announcements with title, body, attachments, and target audience
   - Announcements support scheduling for future publication
   - Read receipts track which residents have viewed each announcement
   - Polls support multiple choice (single and multi-select) and yes/no question types
   - Polls have configurable start date, end date, and eligible voter criteria
   - Vote counting maintains anonymity while preventing duplicate votes
   - Poll results visible to all eligible voters after deadline

## Functional Requirements

### FR1: Society Setup and Configuration
- System SHALL allow creation of society profiles with name, address, total units, and common amenities
- System SHALL support multi-tower/block configuration within a single society
- System SHALL maintain unit directory with flat number, floor, block, and area information
- System SHALL support configurable society rules and policies document storage
- System SHALL allow customization of fee structures, payment schedules, and penalty rules
- System SHALL support society logo, branding, and contact information configuration

### FR2: Role Management
- System SHALL enforce role hierarchy: super-admin > admin > committee > resident > guard/vendor
- System SHALL support multiple admins per society with equal privileges
- System SHALL require identity verification for admin and committee role assignments
- System SHALL allow residents to have multiple units associated with single account
- System SHALL support guard accounts with restricted access to visitor management features only
- System SHALL support vendor accounts with access limited to assigned service categories
- System SHALL maintain role assignment history with effective dates

### FR3: Resident Management
- System SHALL support resident registration with unit association and verification
- System SHALL track owner vs tenant status for each resident
- System SHALL support primary and secondary contacts per unit
- System SHALL maintain move-in and move-out records with dates
- System SHALL support family member profiles under primary resident account
- System SHALL allow residents to update contact information and emergency contacts

### FR4: Visitor Management
- System SHALL support visitor pre-approval with name, phone, expected arrival window, and purpose
- System SHALL generate unique 6-digit alphanumeric pass codes for approved visitors
- System SHALL support visitor categories: guest, delivery, cab, service provider, and other
- System SHALL allow bulk visitor approval for events with guest list upload
- System SHALL support recurring visitor passes with start date, end date, and allowed days/times
- System SHALL capture visitor photo at check-in via guard device camera
- System SHALL record vehicle details including type, number plate, and parking slot
- System SHALL track check-in and check-out timestamps with automatic overstay alerts
- System SHALL support emergency contact notification if visitor does not check out within expected duration

### FR5: Maintenance Billing
- System SHALL support configurable billing components: base charge, area-based charge, parking, utilities
- System SHALL generate bills on scheduled date with automatic calculation of all components
- System SHALL support pro-rata billing for mid-month move-ins
- System SHALL calculate late payment penalties based on configured rules
- System SHALL integrate with payment gateway for online payment collection
- System SHALL support manual payment recording for cash, cheque, and bank transfer
- System SHALL generate payment receipts with unique receipt numbers
- System SHALL support partial payments with balance tracking
- System SHALL provide downloadable statements with payment history
- System SHALL generate aging reports showing outstanding amounts by duration buckets

### FR6: Complaints and Helpdesk
- System SHALL support complaint categories: plumbing, electrical, civil, cleaning, security, other
- System SHALL allow photo and document attachments with complaints
- System SHALL assign unique ticket numbers to all complaints
- System SHALL support complaint priority levels: low, medium, high, urgent
- System SHALL define SLA targets per category and priority combination
- System SHALL auto-escalate complaints approaching or breaching SLA
- System SHALL support internal notes visible only to staff and admins
- System SHALL track resolution time and calculate SLA compliance metrics
- System SHALL support complaint reopening within 7 days of closure if issue recurs
- System SHALL collect satisfaction rating (1-5) and feedback upon closure

### FR7: Announcements
- System SHALL support announcement creation with rich text formatting and attachments
- System SHALL allow targeting announcements to specific blocks, floors, or all residents
- System SHALL support announcement scheduling with future publish date/time
- System SHALL send push notification, email, and SMS for high-priority announcements
- System SHALL track read status and timestamp for each recipient
- System SHALL support pinning important announcements to top of list
- System SHALL maintain announcement archive with search capability

### FR8: Polls and Voting
- System SHALL support poll creation with question, options, and voting rules
- System SHALL enforce one vote per unit for ownership-based polls
- System SHALL enforce one vote per adult resident for resident-based polls
- System SHALL support anonymous voting with cryptographic vote verification
- System SHALL prevent vote changes after submission unless explicitly allowed
- System SHALL display live results or hide until deadline based on configuration
- System SHALL calculate and display final results with vote counts and percentages
- System SHALL support quorum requirements for valid poll completion

### FR9: Staff Management
- System SHALL support staff profiles with name, role, contact, and identity documents
- System SHALL track staff working hours and shift assignments
- System SHALL support attendance marking via guard app with geo-fencing
- System SHALL maintain training records and certification expiry tracking
- System SHALL support staff performance ratings and review history
- System SHALL allow staff account suspension with immediate access revocation

### FR10: Hardware Integration Preparation
- System SHALL define API contracts for gate access control integration
- System SHALL support webhook events for visitor check-in/check-out for intercom integration
- System SHALL maintain device registry for future hardware enrollment
- System SHALL support QR code generation for contactless visitor entry
- System SHALL provide real-time visitor status API for display board integration

## Non-Functional Requirements

### NFR1: Performance
- Visitor search and verification response time: <3 seconds (95th percentile)
- Bill generation for 500-unit society: <5 minutes
- Announcement delivery to 1000 residents: <2 minutes
- Dashboard loading time: <2 seconds (95th percentile)
- Real-time notification delivery: <5 seconds from trigger event
- API response time for mobile app: <500ms (95th percentile)

### NFR2: Scalability
- System SHALL support societies with up to 5000 units per installation
- System SHALL handle 10,000 visitor check-ins per day per society
- System SHALL support 50 concurrent guard devices per society
- System SHALL scale horizontally to onboard 1000+ societies
- System SHALL partition data by society for performance isolation
- System SHALL support 100,000 active residents on the platform

### NFR3: Reliability
- System SHALL maintain 99.9% uptime for visitor management features
- System SHALL queue notifications for retry if delivery fails
- System SHALL support offline mode for guard app with sync on connectivity
- System SHALL backup all financial data with point-in-time recovery capability
- System SHALL maintain data consistency across distributed operations
- System SHALL implement circuit breakers for payment gateway integration

### NFR4: Security
- System SHALL encrypt all sensitive resident data at rest using AES-256
- System SHALL enforce HTTPS for all API communications
- System SHALL implement rate limiting on visitor approval endpoints
- System SHALL validate guard device identity before allowing operations
- System SHALL audit log all financial transactions and role changes
- System SHALL implement data access controls based on society membership
- System SHALL support data export for residents upon request (GDPR compliance)
- System SHALL implement visitor data retention policy with automatic purging

### NFR5: Usability
- Guard app SHALL function with minimal training (< 30 minutes)
- Resident app SHALL support multiple Indian languages
- System SHALL provide guided setup wizard for new society onboarding
- System SHALL offer in-app help and tutorials for all major features
- System SHALL maintain consistent UI patterns across web and mobile interfaces

## Integration Points

- **Auth Domain**: Leverages authentication services for user login, session management, and role-based access control verification

- **User Profile Domain**: Synchronizes resident profile information and maintains user-society associations

- **Payment Domain**: Integrates for maintenance payment processing, payment gateway connections, and financial transaction management

- **Notification Domain**: Publishes events for visitor alerts, bill reminders, complaint updates, and announcement broadcasts across push, SMS, and email channels

- **Document Domain**: Stores and retrieves society documents, complaint attachments, and staff identity documents

- **Audit Domain**: Publishes security events, financial transactions, and administrative actions for compliance logging

- **Analytics Domain**: Provides data feeds for society dashboards, collection reports, and complaint resolution metrics

- **CRM Domain**: Shares resident information for property-related communications and cross-sell opportunities

## Dependencies

- PostgreSQL or equivalent relational database for transactional data storage
- Redis or equivalent cache for session data and real-time visitor status
- Payment gateway integration (Razorpay, PayU) for online maintenance payments
- Push notification service (Firebase, OneSignal) for real-time alerts
- SMS gateway (MSG91, Twilio) for OTP and critical notifications
- Tigris Object Storage (S3-compatible) for document and image attachments
- Geolocation service for guard attendance geo-fencing
- QR code generation library for visitor passes
- PDF generation service for bills and receipts

## Success Metrics

- **Visitor Pre-Approval Adoption**: Percentage of visitors with pre-approval (target: >70% within 3 months)
- **Digital Payment Adoption**: Percentage of maintenance payments made online (target: >60% within 6 months)
- **Complaint Resolution Time**: Average time to resolve complaints (target: <48 hours for medium priority)
- **SLA Compliance Rate**: Percentage of complaints resolved within SLA (target: >90%)
- **Announcement Read Rate**: Percentage of residents who read announcements within 24 hours (target: >80%)
- **Poll Participation Rate**: Average percentage of eligible voters participating in polls (target: >50%)
- **Resident App Adoption**: Percentage of units with at least one active app user (target: >85% within 6 months)
- **Guard Efficiency**: Average visitor processing time at gate (target: <90 seconds)
- **Collection Efficiency**: Percentage of dues collected within 30 days of billing (target: >95%)
- **Resident Satisfaction Score**: Average satisfaction rating on resolved complaints (target: >4.0/5.0)
