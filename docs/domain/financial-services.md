# FinancialServices - Product Requirements

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | FinancialServices |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | January 2026 |
| **Platform** | MySqrft |

---

## Overview

The FinancialServices domain is the financial empowerment layer of the MySqrft platform, responsible for facilitating loan and finance referrals to partner banks and Direct Selling Agents (DSAs). This domain enables users to explore financing options for their property purchases, renovations, and related needs by capturing eligibility information, managing regulatory consents, and routing applications to appropriate lending partners.

As a referral-focused domain, FinancialServices acts as a bridge between MySqrft users and financial institutions. It handles the complete lifecycle of loan applications from initial eligibility assessment through application submission, approval tracking, and disbursement confirmation. The domain maintains strict compliance with financial regulations by ensuring proper consent capture for data sharing and maintaining comprehensive audit trails of all financial data processing activities.

The FinancialServices domain generates revenue through commission-based partnerships with banks and DSAs, requiring robust reconciliation capabilities to track referral performance and commission payouts. It balances user experience considerations with regulatory compliance requirements, providing transparency into application status while ensuring that all data sharing adheres to user consent preferences and regulatory mandates.

## Goals & Objectives

- Enable users to assess their loan eligibility and connect with appropriate lending partners based on their financial profile and property requirements
- Capture and maintain explicit, auditable consent for all financial data sharing in compliance with regulatory requirements (RBI guidelines, DPDP Act)
- Build and maintain a network of banking partners and DSAs with intelligent routing based on user eligibility, loan type, and partner capabilities
- Provide real-time visibility into loan application status from submission through disbursement
- Implement accurate commission tracking and reconciliation to ensure timely partner settlements and revenue recognition
- Maintain comprehensive compliance logging for regulatory audits and dispute resolution

## Key Features

- **Loan Eligibility Assessment**: Capture user financial information including income, employment details, existing obligations, and property information to calculate preliminary eligibility and loan amount estimates across partner lenders.

- **Consent Management for Financial Data**: Explicit consent capture workflow for sharing financial and personal data with lending partners, with granular consent options, consent versioning, and easy withdrawal mechanisms.

- **Partner Routing Engine**: Intelligent matching of loan applications to banking partners and DSAs based on eligibility criteria, loan type, property location, partner capacity, and historical approval rates.

- **Application Status Tracking**: Real-time status updates for loan applications through the complete lifecycle including applied, document collection, verification, sanctioned, approved, and disbursed stages.

- **Commission Management**: Tracking of referral commissions from partner agreements through application completion to commission disbursement, including reconciliation with partner statements.

- **Compliance and Audit Logging**: Comprehensive logging of all data access, sharing events, consent changes, and partner communications for regulatory compliance and audit readiness.

## User Stories

1. **As a home buyer**, I want to check my loan eligibility without affecting my credit score so that I can understand my financing options before committing to a property.

2. **As a user applying for a home loan**, I want to see which banks and DSAs are best suited for my profile so that I can choose a partner with the highest likelihood of approval.

3. **As a user**, I want to provide explicit consent before my financial data is shared with any lending partner so that I maintain control over my personal information.

4. **As a loan applicant**, I want to track the status of my loan application in real-time so that I know what stage my application is in and what actions are required from me.

5. **As a user with an approved loan**, I want to receive notifications when my loan is disbursed so that I can proceed with my property transaction.

6. **As a returning user**, I want to view my loan application history and previous eligibility assessments so that I can reference past applications or reapply with updated information.

7. **As a platform administrator**, I want to view commission reconciliation reports so that I can verify partner payouts and track revenue performance.

8. **As a compliance officer**, I want to access complete audit trails of data sharing events so that I can respond to regulatory inquiries and ensure compliance.

## Acceptance Criteria

1. **Eligibility Assessment**
   - System collects income, employment type, employer details, existing EMIs, and desired loan amount
   - Eligibility calculation completes within 5 seconds without hard credit inquiry
   - System displays estimated loan amount, tentative interest rate range, and EMI projection
   - Eligibility results include matched lender partners with approval probability indicators
   - Assessment results are stored for 90 days and can be refreshed with updated information

2. **Consent Capture**
   - System presents clear, readable consent text before any data sharing with partners
   - User must explicitly opt-in (no pre-checked boxes) for each data sharing category
   - Consent timestamp, IP address, device information, and consent version are recorded
   - Users can withdraw consent at any time with immediate effect on future data sharing
   - System maintains complete consent history including all grants and withdrawals

3. **Partner Routing**
   - System matches applications to partners within 30 seconds of submission
   - Routing considers user eligibility, partner acceptance criteria, and partner capacity
   - Users can view matched partners and select preferred options
   - System distributes load across partners based on configured allocation percentages
   - Failed routing attempts are logged and escalated for manual review

4. **Application Status Tracking**
   - Status updates are reflected within 5 minutes of partner system updates
   - Users receive push notifications and emails for significant status changes
   - Status history is maintained with timestamps and any partner-provided notes
   - Users can view required documents and pending actions at each stage
   - Estimated timelines are displayed based on historical processing times

5. **Commission Reconciliation**
   - Commission events are logged at each milestone (applied, approved, disbursed)
   - System calculates expected commission based on partner agreement terms
   - Reconciliation reports compare expected vs. actual commission receipts
   - Discrepancies are flagged automatically for investigation
   - Monthly reconciliation reports are generated for finance team review

## Functional Requirements

### FR1: Loan Eligibility Capture
- System SHALL collect applicant income details including gross monthly income, income source type, and proof documents
- System SHALL capture employment information including employer name, employment tenure, and employment type (salaried/self-employed)
- System SHALL record existing financial obligations including current EMIs, credit card outstanding, and other loans
- System SHALL collect property details including property type, location, estimated value, and construction status
- System SHALL calculate debt-to-income ratio and other eligibility metrics based on collected information
- System SHALL store eligibility assessments with timestamp and calculation parameters for audit purposes

### FR2: Eligibility Assessment Engine
- System SHALL evaluate eligibility against multiple lender criteria simultaneously
- System SHALL generate preliminary eligible loan amount based on income and obligation data
- System SHALL calculate indicative interest rate range based on user profile and market rates
- System SHALL produce EMI projections for different loan tenures (10, 15, 20, 25, 30 years)
- System SHALL rank lending partners by estimated approval probability for the user profile
- System SHALL refresh eligibility calculations when user updates financial information

### FR3: Consent Management
- System SHALL present consent requests in clear, non-technical language before data collection
- System SHALL implement separate consent flows for: (a) credit bureau inquiry, (b) data sharing with lenders, (c) marketing communications
- System SHALL capture consent with cryptographic signature including timestamp, consent text version, and user identifier
- System SHALL enforce consent verification before any data transmission to partners
- System SHALL provide consent withdrawal mechanism accessible from user profile settings
- System SHALL notify partners of consent withdrawal and cease data sharing within 24 hours

### FR4: Lender Partner Management
- System SHALL maintain partner registry with partner details, integration endpoints, and service level agreements
- System SHALL store partner acceptance criteria including income thresholds, property types, and geographic coverage
- System SHALL track partner capacity and current queue depth for load balancing
- System SHALL support partner-specific data mapping and transformation requirements
- System SHALL monitor partner API availability and response times
- System SHALL maintain commission rate configurations per partner and product type

### FR5: Application Routing
- System SHALL evaluate user eligibility against all active partner criteria
- System SHALL rank matching partners by approval probability, interest rates, and processing time
- System SHALL apply load balancing rules based on partner capacity configurations
- System SHALL transmit application data to selected partner via secure API integration
- System SHALL obtain and store partner reference number upon successful submission
- System SHALL queue applications for retry on transient partner API failures

### FR6: Application Status Management
- System SHALL define standard status lifecycle: draft, submitted, document_pending, under_review, sanctioned, approved, disbursed, rejected, cancelled
- System SHALL receive status updates from partners via webhook or polling mechanisms
- System SHALL map partner-specific statuses to standard status codes
- System SHALL trigger notifications to users on status transitions
- System SHALL calculate and display estimated time to next status based on historical data
- System SHALL support manual status updates by operations team with audit logging

### FR7: Commission Tracking
- System SHALL log commission-triggering events (application submission, approval, disbursement)
- System SHALL calculate expected commission based on partner agreement (flat fee, percentage, or hybrid)
- System SHALL track commission payment receipts and reconcile against expected amounts
- System SHALL flag commission discrepancies exceeding configurable threshold (default: 5%)
- System SHALL generate commission reports by partner, time period, and product type
- System SHALL support commission adjustments for chargebacks and reversals

### FR8: Compliance Logging
- System SHALL log all data access events with accessor identity, data categories accessed, and purpose
- System SHALL log all external data transmissions with recipient, data categories, and legal basis
- System SHALL maintain immutable audit trail that cannot be modified or deleted
- System SHALL support log export in standard formats for regulatory submission
- System SHALL retain compliance logs for minimum 7 years per regulatory requirements
- System SHALL generate compliance reports on data sharing activities by consent type and partner

## Non-Functional Requirements

### NFR1: Performance
- Eligibility calculation response time: <5 seconds (95th percentile)
- Partner matching response time: <3 seconds (95th percentile)
- Status lookup response time: <500ms (95th percentile)
- Consent capture response time: <1 second (95th percentile)
- Application submission to partner response time: <10 seconds (95th percentile)
- Peak throughput: 1,000 eligibility assessments per hour

### NFR2: Scalability
- System SHALL scale horizontally to handle increasing loan application volumes
- System SHALL support processing 10,000 active loan applications concurrently
- System SHALL handle peak traffic during property sale seasons (3x normal load)
- System SHALL partition application data by region for efficient scaling
- System SHALL use message queues for asynchronous partner communications

### NFR3: Reliability
- System SHALL maintain 99.9% uptime for user-facing eligibility and status endpoints
- System SHALL implement circuit breakers for partner API integrations
- System SHALL queue failed partner transmissions for automatic retry
- System SHALL maintain application data integrity during partner system outages
- System SHALL replicate critical data across availability zones

### NFR4: Security
- System SHALL encrypt all financial data in transit using TLS 1.3
- System SHALL encrypt sensitive financial data at rest using AES-256
- System SHALL mask PAN, Aadhaar, and account numbers in logs and displays
- System SHALL implement role-based access control for financial data
- System SHALL enforce secure API authentication (OAuth 2.0) for partner integrations
- System SHALL validate all input against injection and manipulation attacks
- System SHALL implement rate limiting on eligibility endpoints (10 requests per user per hour)

### NFR5: Compliance
- System SHALL comply with RBI digital lending guidelines
- System SHALL comply with DPDP Act requirements for personal data processing
- System SHALL support right to access, correction, and deletion requests
- System SHALL maintain data localization for financial data within India
- System SHALL support regulatory audit data extraction within 48 hours of request

## Integration Points

- **User Profile Domain**: Retrieves user identity and contact information for loan applications; pre-fills application forms with verified user data

- **Property Domain**: Retrieves property details for loan applications including property value, type, and location for collateral assessment

- **Auth Domain**: Validates user identity and session for financial data access; enforces step-up authentication for sensitive operations

- **Notification Domain**: Publishes events for loan status updates, document requests, and approval notifications via email, SMS, and push

- **Consent & Privacy Domain**: Integrates for consent preference retrieval and honors data processing restrictions based on user preferences

- **Audit & Compliance Domain**: Publishes financial data access events and compliance logs for centralized audit management

- **Payment Domain**: Coordinates for commission receipt tracking and reconciliation with partner payments

- **Analytics Domain**: Publishes anonymized loan application data for conversion funnel analysis and partner performance metrics

- **Partner Systems (Banks/DSAs)**: Bidirectional integration for application submission, status updates, and commission reconciliation via REST APIs and webhooks

## Dependencies

- PostgreSQL or equivalent relational database for loan applications and eligibility data
- Redis or equivalent distributed cache for session data and rate limiting
- Message queue (RabbitMQ/Kafka) for asynchronous partner communications and event processing
- Document storage service (S3/equivalent) for loan document management
- Partner API integrations with authentication credentials and endpoint configurations
- Credit bureau integration for soft inquiry eligibility checks
- Email and SMS gateway for status notifications
- Encryption key management service for financial data protection

## Success Metrics

- **Eligibility Completion Rate**: Percentage of users who complete eligibility assessment (target: >70%)
- **Partner Match Rate**: Percentage of eligible users matched to at least one lending partner (target: >85%)
- **Application Submission Rate**: Percentage of matched users who submit loan applications (target: >40%)
- **Approval Rate**: Percentage of submitted applications that receive approval (target: >60%)
- **Disbursement Rate**: Percentage of approved loans that complete disbursement (target: >90%)
- **Average Time to Approval**: Mean time from application submission to approval (target: <7 days)
- **Average Time to Disbursement**: Mean time from approval to disbursement (target: <14 days)
- **Consent Grant Rate**: Percentage of users who grant data sharing consent when prompted (target: >80%)
- **Commission Reconciliation Accuracy**: Percentage of commission payments matching expected amounts (target: >98%)
- **Partner API Uptime**: Availability of partner integration endpoints (target: >99.5%)
- **Compliance Audit Pass Rate**: Percentage of audit findings with no material issues (target: 100%)
