# KYC Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | KYC (Know Your Customer) |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Product Team |
| **Last Updated** | January 2026 |
| **Platform** | MySqrft |

---

## 1. Overview

The KYC (Know Your Customer) domain serves as the identity verification and compliance backbone of the MySqrft platform. In the Indian real estate market, establishing trust between property owners, tenants, buyers, and service vendors is paramount. This domain provides a comprehensive identity verification system that ensures all platform participants are who they claim to be, enabling secure and trustworthy property transactions.

The KYC domain implements a multi-tiered verification approach tailored to Indian regulatory requirements and market practices. Starting with basic self-service verification (email and phone), the system progressively supports more rigorous verification methods including government-issued ID documents (Aadhaar, PAN, Driving License), and advanced biometric verification with face match and liveness detection. Each user type on the platform—property owners, tenants/buyers, and service vendors—has specific verification requirements aligned with their intended activities and associated risk levels.

Beyond initial verification, this domain manages the complete verification lifecycle including status tracking, renewal workflows, expiration handling, and compliance audit logging. The system maintains detailed consent records for all identity verification activities and is architected to integrate with external KYC providers in future phases. This comprehensive approach ensures MySqrft maintains regulatory compliance while providing a seamless user experience that builds trust across the platform ecosystem.

---

## 2. Goals & Objectives

- **Establish Platform Trust:** Create a verified user ecosystem where property owners, tenants, buyers, and service vendors can transact with confidence in each other's identities.

- **Ensure Regulatory Compliance:** Meet Indian regulatory requirements for identity verification in real estate transactions, including RBI guidelines and state-specific rental regulations.

- **Minimize Fraud and Risk:** Prevent identity fraud, fake listings, and malicious actors from operating on the platform through robust verification mechanisms.

- **Optimize User Experience:** Balance security requirements with user convenience by implementing progressive verification levels and streamlined document upload workflows.

- **Enable Scalable Verification:** Build a verification infrastructure that can handle growing user volumes while maintaining verification accuracy and turnaround times.

- **Maintain Audit Readiness:** Ensure complete traceability of all verification activities for compliance audits and dispute resolution.

---

## 3. Key Features

### **Multi-Level Identity Verification**
A tiered verification system supporting basic (email/phone), standard (ID documents), and comprehensive (biometric) verification levels. Each user type has defined minimum verification requirements, with the ability to upgrade verification levels for enhanced platform privileges.

### **Indian Identity Document Processing**
Native support for Indian government-issued identity documents including Aadhaar, PAN Card, and Driving License. The system validates document authenticity, extracts relevant information, and cross-references data for consistency checks.

### **Biometric Verification with Liveness Detection**
Advanced verification capability combining face match technology with liveness detection to prevent spoofing attempts. This feature ensures the person submitting documents is physically present and matches their submitted identity documents.

### **Verification Lifecycle Management**
Complete management of verification states from initiation through completion, including pending reviews, approvals, rejections, expirations, and renewals. Automated notifications keep users informed of their verification status and upcoming renewal requirements.

### **Consent and Compliance Framework**
Comprehensive consent capture and management for all identity verification activities. Includes detailed audit logging of verification events, data access, and compliance-related actions to support regulatory requirements and internal audits.

---

## 4. User Stories

### US-KYC-001: Basic Email Verification
**As a** new MySqrft user,
**I want to** verify my email address through a verification link,
**So that** I can create my account and receive platform communications.

### US-KYC-002: Phone Number Verification
**As a** registered user,
**I want to** verify my phone number via OTP,
**So that** I can enable two-factor authentication and receive transaction alerts.

### US-KYC-003: Property Owner Document Verification
**As a** property owner,
**I want to** upload my identity documents (Aadhaar/PAN) for verification,
**So that** I can list my properties on MySqrft and attract verified tenants/buyers.

### US-KYC-004: Tenant Identity Verification
**As a** prospective tenant,
**I want to** complete identity verification with my government ID,
**So that** property owners can trust my rental application.

### US-KYC-005: Service Vendor Comprehensive Verification
**As a** home service vendor,
**I want to** complete comprehensive verification including face match,
**So that** homeowners can trust me to enter their homes for service delivery.

### US-KYC-006: Verification Status Tracking
**As a** platform user,
**I want to** view my current verification status and any pending requirements,
**So that** I understand what actions I need to take to access platform features.

### US-KYC-007: Verification Renewal
**As a** verified user approaching document expiration,
**I want to** receive renewal reminders and easily update my documents,
**So that** my verification status remains active without platform access interruption.

---

## 5. Acceptance Criteria

### Multi-Level Identity Verification
- [ ] System supports three verification levels: Basic, Standard, and Comprehensive
- [ ] Each user type has clearly defined minimum verification requirements
- [ ] Users can view their current verification level and upgrade path
- [ ] Verification level changes trigger appropriate notifications
- [ ] Platform features are correctly gated by verification level

### Indian Identity Document Processing
- [ ] System accepts Aadhaar, PAN Card, and Driving License uploads
- [ ] Document images are validated for quality (resolution, clarity, completeness)
- [ ] Document data extraction achieves 95% accuracy for standard documents
- [ ] Cross-reference checks identify mismatched information across documents
- [ ] Invalid or tampered documents are flagged for manual review

### Biometric Verification with Liveness Detection
- [ ] Face match compares selfie against ID document photo with 98% accuracy
- [ ] Liveness detection prevents photo/video spoofing attempts
- [ ] System provides clear guidance for successful biometric capture
- [ ] Failed attempts allow retry with helpful error messaging
- [ ] Biometric data is processed in compliance with privacy regulations

### Verification Lifecycle Management
- [ ] Verification requests transition through defined states (Pending, In Review, Verified, Rejected, Expired)
- [ ] Rejection includes reason codes and resubmission guidance
- [ ] Expiration dates are tracked with 30/15/7 day advance notifications
- [ ] Renewal workflow allows document update without losing verification history
- [ ] Manual review queue is available for edge cases and escalations

### Consent and Compliance Framework
- [ ] Explicit consent is captured before any identity verification activity
- [ ] Consent records include timestamp, scope, and user acknowledgment
- [ ] Users can view their consent history and data processing activities
- [ ] All verification events are logged with actor, action, and timestamp
- [ ] Audit logs are immutable and retained per compliance requirements

---

## 6. Functional Requirements

### Verification Initiation

**FR1:** The system SHALL provide email verification through unique, time-limited verification links sent to user-provided email addresses.

**FR2:** The system SHALL support phone number verification through OTP delivery via SMS with configurable expiration (default: 10 minutes).

**FR3:** The system SHALL allow users to initiate document verification by uploading government-issued identity documents in supported formats (JPEG, PNG, PDF).

**FR4:** The system SHALL capture explicit user consent before initiating any identity verification process, storing consent records with timestamp and scope.

### Document Processing

**FR5:** The system SHALL validate uploaded document images for minimum quality requirements including resolution (minimum 300 DPI equivalent), clarity, and completeness.

**FR6:** The system SHALL extract relevant identity information from Aadhaar cards including name, date of birth, gender, and masked Aadhaar number.

**FR7:** The system SHALL extract relevant identity information from PAN cards including name, date of birth, and PAN number.

**FR8:** The system SHALL extract relevant identity information from Driving Licenses including name, date of birth, license number, and validity period.

**FR9:** The system SHALL perform cross-reference validation when multiple documents are submitted by the same user to ensure data consistency.

### Biometric Verification

**FR10:** The system SHALL capture user selfie images for face match verification against submitted identity document photos.

**FR11:** The system SHALL perform liveness detection during selfie capture to ensure physical presence of the user.

**FR12:** The system SHALL achieve minimum 98% accuracy in face match comparisons under standard lighting and image quality conditions.

**FR13:** The system SHALL provide real-time guidance to users during biometric capture to optimize image quality and success rates.

### Verification Status Management

**FR14:** The system SHALL maintain verification status for each user with defined states: Pending, In Review, Verified, Rejected, and Expired.

**FR15:** The system SHALL record rejection reasons using standardized reason codes and provide user-facing guidance for resubmission.

**FR16:** The system SHALL track document expiration dates and trigger automated renewal notifications at 30, 15, and 7 days before expiration.

**FR17:** The system SHALL support manual verification review workflows with assignment, escalation, and resolution tracking.

### User Type Requirements

**FR18:** The system SHALL enforce minimum Standard verification level for Property Owners before enabling property listing capabilities.

**FR19:** The system SHALL enforce minimum Basic verification level for Tenants/Buyers before enabling rental/purchase inquiry capabilities.

**FR20:** The system SHALL enforce Comprehensive verification level for Service Vendors before enabling service listing and booking acceptance.

### Audit and Compliance

**FR21:** The system SHALL log all verification-related events including initiation, document uploads, status changes, and data access with timestamp and actor identification.

**FR22:** The system SHALL maintain immutable audit logs that cannot be modified or deleted by any user including system administrators.

**FR23:** The system SHALL provide verification history reports for individual users and aggregate compliance reporting for platform administrators.

---

## 7. Non-Functional Requirements

### NFR1: Performance

- Email verification links SHALL be delivered within 30 seconds of user request
- OTP messages SHALL be delivered within 15 seconds of user request
- Document upload processing SHALL complete initial validation within 5 seconds
- Face match and liveness detection SHALL return results within 10 seconds
- Verification status queries SHALL respond within 200 milliseconds

### NFR2: Scalability

- The system SHALL support concurrent document uploads from 10,000 users
- The system SHALL process minimum 50,000 verification requests per day
- Document processing queue SHALL scale horizontally based on demand
- The system SHALL maintain performance SLAs during 3x traffic spikes
- Storage architecture SHALL accommodate 10TB of verification documents with linear cost scaling

### NFR3: Reliability

- Verification services SHALL maintain 99.9% uptime availability
- Document storage SHALL implement geographic redundancy with 99.999999999% durability
- Failed verification attempts SHALL be retryable without data loss
- System SHALL gracefully degrade during external service outages
- Automated failover SHALL complete within 60 seconds for critical components

### NFR4: Security

- All identity documents SHALL be encrypted at rest using AES-256 encryption
- All verification data in transit SHALL use TLS 1.3 encryption minimum
- Access to verification documents SHALL require role-based authorization
- Biometric data SHALL be processed in memory and not persisted in raw form
- System SHALL implement rate limiting to prevent brute force and enumeration attacks
- Sensitive data access SHALL be logged and monitored for anomalous patterns

### NFR5: Compliance

- The system SHALL comply with India's Information Technology Act, 2000 and IT Rules, 2011
- The system SHALL implement data protection measures aligned with Personal Data Protection requirements
- Aadhaar usage SHALL comply with UIDAI guidelines including consent and purpose limitation
- Verification data retention SHALL follow defined retention policies (active: indefinite, rejected: 1 year, expired: 3 years)
- The system SHALL support data subject access requests and right to erasure where legally permitted

---

## 8. Integration Points

### Internal Platform Integrations

| Integration | Direction | Purpose |
|------------|-----------|---------|
| User Domain | Bidirectional | User profile data, verification status sync |
| Property Listing Domain | Outbound | Verification status checks for listing permissions |
| Rental/Sales Domain | Outbound | Verification status checks for transaction eligibility |
| HomeServices Domain | Outbound | Verification status checks for vendor activation |
| Notification Domain | Outbound | Verification status updates, renewal reminders |
| Audit Domain | Outbound | Compliance event logging |

### External Service Integrations (Post-MVP)

| Provider Type | Purpose | Priority |
|--------------|---------|----------|
| Aadhaar e-KYC Provider | Real-time Aadhaar verification via UIDAI APIs | High |
| PAN Verification Service | PAN card validation via NSDL/UTI APIs | High |
| Driving License Verification | DL validation via Vahan/state RTO APIs | Medium |
| Document OCR Service | Automated document data extraction | High |
| Face Match Provider | Biometric face comparison service | High |
| Liveness Detection Provider | Anti-spoofing verification service | High |
| Background Check Provider | Criminal/civil record verification | Low |

---

## 9. Dependencies

### Technical Dependencies

- **Document Storage Service:** Secure, compliant object storage for identity documents
- **OCR Processing Engine:** Text extraction from identity document images
- **Image Processing Service:** Document quality validation and preprocessing
- **Biometric SDK:** Face detection, matching, and liveness capabilities
- **SMS Gateway:** OTP delivery for phone verification
- **Email Service:** Verification link delivery and notifications
- **Encryption Service:** Key management for document encryption

### Domain Dependencies

- **User Domain:** Must be operational for user identity association
- **Notification Domain:** Required for verification status communications
- **Audit Domain:** Required for compliance logging

### External Dependencies

- **UIDAI APIs:** For Aadhaar e-KYC (post-MVP)
- **NSDL/UTI APIs:** For PAN verification (post-MVP)
- **State RTO APIs:** For Driving License verification (post-MVP)
- **Third-party KYC Provider:** Selected vendor for comprehensive verification services

### Regulatory Dependencies

- UIDAI compliance certification for Aadhaar usage
- RBI compliance for financial service integrations (if applicable)
- State-specific rental regulation compliance

---

## 10. Success Metrics

### Verification Funnel Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Email verification completion rate | > 85% | Verified / Initiated |
| Phone verification completion rate | > 90% | Verified / Initiated |
| Document verification completion rate | > 75% | Verified / Initiated |
| First-attempt verification success rate | > 70% | Success on first submission |
| Average verification turnaround time | < 24 hours | Initiation to completion |

### Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Document OCR accuracy | > 95% | Correct extractions / Total |
| Face match accuracy | > 98% | Correct matches / Total |
| False rejection rate | < 2% | Incorrect rejections / Total |
| False acceptance rate | < 0.1% | Fraudulent acceptances / Total |
| Manual review rate | < 15% | Manual reviews / Total verifications |

### Operational Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| System uptime | > 99.9% | Available time / Total time |
| Average API response time | < 500ms | P95 latency |
| Document processing queue depth | < 1000 | Peak queue size |
| Support ticket rate (KYC-related) | < 5% | Tickets / Verifications |
| Renewal completion rate | > 80% | Renewed / Expiring |

### Business Impact Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Verified property owner percentage | > 90% | Verified / Active listers |
| Verified service vendor percentage | 100% | Verified / Active vendors |
| Fraud incident rate | < 0.01% | Fraud cases / Transactions |
| Verification-related user churn | < 3% | Churned during verification / Total |
| Time to first listing (verified owner) | < 48 hours | Registration to first listing |

---

## Appendix A: Verification Level Matrix

| User Type | Basic (Email + Phone) | Standard (ID Documents) | Comprehensive (Biometric) |
|-----------|----------------------|------------------------|---------------------------|
| Property Owner | Required | Required | Optional |
| Tenant/Buyer | Required | Recommended | Optional |
| Service Vendor | Required | Required | Required |

## Appendix B: Document Type Support

| Document Type | Data Extracted | Validity Tracking | Auto-Verification |
|--------------|----------------|-------------------|-------------------|
| Aadhaar Card | Name, DOB, Gender, Address, Masked Number | N/A (No expiry) | Post-MVP |
| PAN Card | Name, DOB, PAN Number | N/A (No expiry) | Post-MVP |
| Driving License | Name, DOB, License Number, Address, Validity | Yes | Post-MVP |
| Passport | Name, DOB, Passport Number, Validity | Yes | Phase 2 |
| Voter ID | Name, DOB, Voter ID Number | N/A | Phase 2 |

## Appendix C: Verification Status State Machine

```
[Not Started] --> [Pending] --> [In Review] --> [Verified]
                      |              |              |
                      v              v              v
                 [Rejected]    [Rejected]     [Expired]
                      |              |              |
                      v              v              v
                 [Pending]     [Pending]      [Pending]
                 (Resubmit)    (Resubmit)     (Renewal)
```

---

*Document End*
