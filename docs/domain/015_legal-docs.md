# LegalDocs Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | LegalDocs |
| Domain ID | 14 |
| Version | 1.0 |
| Status | Complete |
| Owner | TBD |
| Last Updated | 2026-01-17 |

---

## 1. Overview

### 1.1 Primary Goal
**Rental Agreement + Documentation**

The LegalDocs domain provides comprehensive document management capabilities for the MySqrft platform, enabling users to generate, sign, register, and securely store legal documents related to property rentals and transactions.

### 1.2 Problem Statement
Property rental transactions in India involve complex legal documentation requirements that vary by state. Users face challenges with:
- Creating legally compliant rental agreements
- Understanding state-specific stamp duty and registration requirements
- Managing document signing workflows across multiple parties
- Securely storing and sharing sensitive legal documents
- Completing police verification requirements for tenants
- Tracking compliance with regulatory requirements

### 1.3 Target Users
| User Type | Description |
|-----------|-------------|
| Property Owners | Need to generate and execute rental agreements with tenants |
| Tenants | Need to sign agreements and complete verification processes |
| Relationship Managers (RMs) | Assist in document preparation and workflow coordination |
| Society Admins | May require tenant documentation for community records |
| Support Agents | Handle document-related queries and disputes |

---

## 2. Scope

### 2.1 In Scope
- Rental agreement generation from configurable templates
- Electronic signature (eSign) workflows
- Stamp duty calculation and payment integration
- Agreement registration workflows (state-dependent)
- Police verification and background check integration
- Secure document vault with access controls
- Template management and versioning
- Compliance tracking and audit trails
- Document sharing with controlled access
- Multi-party signature coordination

### 2.2 Out of Scope
- Sale deed or property transfer documents (Phase 2)
- Court filing or legal dispute documentation
- Notarization services (may be added later)
- Physical document courier services
- Legal advice or consultation services

### 2.3 Dependencies
| Domain | Dependency Type | Description |
|--------|-----------------|-------------|
| Auth | Required | User authentication for document access |
| UserManagement | Required | User profiles and role information |
| Authorization | Required | Document access control and permissions |
| KYC | Required | Identity verification for signatories |
| Billing | Required | Payment for stamp duty and services |
| Communications | Required | Notifications for signing requests |
| Inventory | Optional | Property details for agreement generation |
| Leads | Optional | Lead context for agreement initiation |

---

## 3. Key Entities

### 3.1 Agreement
The core entity representing a legal agreement between parties.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| agreement_type | Enum | RENTAL, LEASE, LEAVE_LICENSE |
| template_id | UUID | Reference to template used |
| property_id | UUID | Associated property (if applicable) |
| owner_id | UUID | Property owner user ID |
| tenant_ids | UUID[] | Tenant user IDs |
| status | Enum | DRAFT, PENDING_SIGNATURES, PENDING_STAMP, PENDING_REGISTRATION, ACTIVE, EXPIRED, TERMINATED |
| start_date | Date | Agreement start date |
| end_date | Date | Agreement end date |
| monthly_rent | Decimal | Monthly rent amount |
| security_deposit | Decimal | Security deposit amount |
| notice_period_days | Integer | Notice period in days |
| terms | JSONB | Additional terms and conditions |
| state_code | String | State for compliance rules |
| city | String | City for locality-specific rules |
| created_at | DateTime | Creation timestamp |
| updated_at | DateTime | Last update timestamp |
| finalized_at | DateTime | When all signatures completed |
| registered_at | DateTime | Registration completion (if applicable) |

### 3.2 Template
Reusable document templates for agreement generation.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| name | String | Template name |
| template_type | Enum | RENTAL, LEASE, LEAVE_LICENSE, ADDENDUM |
| state_code | String | State-specific template (null for generic) |
| content | Text | Template content with placeholders |
| variables | JSONB | Required and optional variables |
| version | Integer | Template version number |
| is_active | Boolean | Whether template is currently active |
| is_default | Boolean | Default template for type/state |
| compliance_rules | JSONB | State compliance requirements |
| created_by | UUID | Admin who created template |
| created_at | DateTime | Creation timestamp |
| updated_at | DateTime | Last update timestamp |

### 3.3 eSignature
Electronic signature records for document signing.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| agreement_id | UUID | Associated agreement |
| document_id | UUID | Associated document |
| signer_id | UUID | User who signed |
| signer_role | Enum | OWNER, TENANT, WITNESS |
| signature_data | Text | Encrypted signature data |
| signing_method | Enum | AADHAAR_ESIGN, DSC, DRAW, TYPE |
| ip_address | String | IP address at signing |
| device_info | JSONB | Device information |
| location | JSONB | Geolocation (if available) |
| signed_at | DateTime | Signature timestamp |
| certificate_id | String | eSign certificate reference |
| verification_status | Enum | PENDING, VERIFIED, FAILED |

### 3.4 Document
Stored documents in the vault.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| owner_id | UUID | Document owner user ID |
| document_type | Enum | AGREEMENT, ID_PROOF, ADDRESS_PROOF, POLICE_VERIFICATION, REGISTRATION_CERTIFICATE, OTHER |
| name | String | Document name |
| description | Text | Document description |
| file_path | String | Encrypted storage path |
| file_size | Integer | File size in bytes |
| mime_type | String | File MIME type |
| checksum | String | File integrity checksum |
| encryption_key_id | String | Encryption key reference |
| agreement_id | UUID | Associated agreement (if applicable) |
| metadata | JSONB | Additional metadata |
| is_archived | Boolean | Archive status |
| retention_until | Date | Retention policy date |
| created_at | DateTime | Upload timestamp |
| updated_at | DateTime | Last update timestamp |

### 3.5 Verification
Police verification and background check records.

| Attribute | Type | Description |
|-----------|------|-------------|
| id | UUID | Unique identifier |
| agreement_id | UUID | Associated agreement |
| tenant_id | UUID | Tenant being verified |
| verification_type | Enum | POLICE, BACKGROUND, EMPLOYMENT, REFERENCE |
| status | Enum | INITIATED, IN_PROGRESS, COMPLETED, FAILED, EXPIRED |
| provider | String | Verification service provider |
| provider_reference | String | External reference ID |
| submitted_at | DateTime | Submission timestamp |
| completed_at | DateTime | Completion timestamp |
| result | Enum | CLEAR, FLAGGED, INCONCLUSIVE |
| result_details | JSONB | Detailed verification results |
| documents | UUID[] | Supporting document IDs |
| valid_until | Date | Verification validity period |

---

## 4. Functional Requirements

### 4.1 Rental Agreement Generation

#### FR-LD-001: Template-Based Generation
**Priority:** P0 (Must Have)

The system shall generate rental agreements from configurable templates with the following capabilities:
- Support for multiple agreement types (Rental, Lease, Leave & License)
- State-specific templates with compliance rules
- Variable substitution for property, owner, and tenant details
- Support for custom clauses and addendums
- Preview before finalization
- PDF generation with professional formatting

**Acceptance Criteria:**
- User can select appropriate template based on state and agreement type
- All required fields are validated before generation
- Generated document includes all mandatory legal clauses for the state
- PDF output is print-ready and legally compliant

#### FR-LD-002: Agreement Workflow Management
**Priority:** P0 (Must Have)

The system shall manage the complete agreement lifecycle:
- Draft creation and editing
- Multi-party review and approval
- Signature collection workflow
- Status tracking and notifications
- Agreement activation upon completion
- Renewal and termination workflows

**Acceptance Criteria:**
- Agreement progresses through defined states
- All parties receive notifications at each stage
- Incomplete agreements can be saved and resumed
- Audit trail captures all state changes

### 4.2 Electronic Signature Workflows

#### FR-LD-003: Multi-Method eSign Support
**Priority:** P0 (Must Have)

The system shall support multiple electronic signature methods:
- Aadhaar eSign (for legally binding signatures)
- Digital Signature Certificate (DSC)
- Draw signature (for low-value agreements)
- Type signature with consent

**Acceptance Criteria:**
- Integration with certified eSign providers
- Signature method appropriate for agreement value
- Multi-factor authentication before signing
- Signature captured with timestamp and audit trail

#### FR-LD-004: Multi-Party Signing Coordination
**Priority:** P0 (Must Have)

The system shall coordinate signatures across multiple parties:
- Sequential or parallel signing workflows
- Configurable signing order
- Reminder notifications for pending signatures
- Deadline management and escalation
- Witness signature support

**Acceptance Criteria:**
- All required parties can sign remotely
- Signing status visible to all parties
- Automated reminders at configured intervals
- Expired signing requests can be renewed

### 4.3 Stamp Duty and Registration

#### FR-LD-005: Stamp Duty Calculation
**Priority:** P1 (Should Have)

The system shall calculate stamp duty based on state rules:
- State-specific stamp duty rates
- Calculation based on rent, deposit, and tenure
- Support for e-stamp paper generation
- Integration with state stamp duty portals

**Acceptance Criteria:**
- Accurate calculation for all supported states
- Clear breakdown of stamp duty components
- e-Stamp generation where supported
- Payment integration for stamp duty

#### FR-LD-006: Registration Workflow
**Priority:** P1 (Should Have)

The system shall manage agreement registration (where required):
- Identification of registration requirements by state
- Document preparation for registration
- Appointment scheduling with sub-registrar
- Registration status tracking
- Registration certificate storage

**Acceptance Criteria:**
- System identifies if registration is mandatory
- All required documents compiled for registration
- Integration with state registration portals (where available)
- Registration certificate stored in vault

### 4.4 Police Verification

#### FR-LD-007: Verification Request Initiation
**Priority:** P2 (Nice to Have)

The system shall initiate police verification for tenants:
- Form generation with required details
- Document collection (ID proofs, photos)
- Submission to local police station or online portal
- Status tracking and updates

**Acceptance Criteria:**
- Verification form auto-populated from user profile
- Support for online submission where available
- Status updates communicated to owner and tenant
- Verification certificate stored upon completion

#### FR-LD-008: Background Check Integration
**Priority:** P2 (Nice to Have)

The system shall support third-party background checks:
- Integration with background verification providers
- Consent collection from tenant
- Employment and reference verification
- Criminal record check (where permitted)

**Acceptance Criteria:**
- Clear consent obtained before verification
- Results delivered within SLA
- Privacy-compliant data handling
- Results accessible only to authorized parties

### 4.5 Document Vault

#### FR-LD-009: Secure Document Storage
**Priority:** P0 (Must Have)

The system shall provide secure document storage:
- Encrypted storage at rest
- Document categorization and tagging
- Search and filter capabilities
- Version history for documents
- Retention policy management

**Acceptance Criteria:**
- All documents encrypted with AES-256
- Documents retrievable within 2 seconds
- Audit trail for all document access
- Automatic archival based on retention policy

#### FR-LD-010: Document Sharing Controls
**Priority:** P0 (Must Have)

The system shall enable controlled document sharing:
- Share with specific users or roles
- Time-limited access links
- View-only vs download permissions
- Watermarking for shared documents
- Access revocation capability

**Acceptance Criteria:**
- Granular permission controls per document
- Shared links expire as configured
- Watermarks include recipient identification
- Access can be revoked instantly

### 4.6 Template Management

#### FR-LD-011: Template CRUD Operations
**Priority:** P1 (Should Have)

The system shall support template management:
- Create new templates with variable placeholders
- Edit existing templates with versioning
- Activate/deactivate templates
- Clone templates for customization
- Template preview with sample data

**Acceptance Criteria:**
- Admin users can manage templates
- Version history maintained for all changes
- Variables validated for completeness
- Preview accurately represents final output

#### FR-LD-012: Compliance Rule Configuration
**Priority:** P1 (Should Have)

The system shall manage compliance rules per template:
- State-specific mandatory clauses
- Stamp duty calculation rules
- Registration requirements
- Verification requirements
- Rule versioning for regulatory changes

**Acceptance Criteria:**
- Rules configurable without code changes
- Rules applied automatically during generation
- Compliance violations flagged before finalization
- Historical rules maintained for audit

### 4.7 Compliance Tracking

#### FR-LD-013: Compliance Dashboard
**Priority:** P1 (Should Have)

The system shall provide compliance tracking:
- Agreement compliance status overview
- Expiring agreements alerts
- Missing verification alerts
- Registration deadline tracking
- Compliance reports for audits

**Acceptance Criteria:**
- Dashboard shows compliance status at a glance
- Alerts sent before deadlines
- Export capability for compliance reports
- Drill-down to individual agreement details

---

## 5. Non-Functional Requirements

### 5.1 Security

#### NFR-LD-001: Data Encryption
- All documents encrypted at rest using AES-256
- TLS 1.3 for data in transit
- Encryption keys managed via HSM or KMS
- Key rotation policy enforced

#### NFR-LD-002: Access Control
- Role-based access to documents
- Multi-factor authentication for sensitive operations
- Session management with timeout
- IP-based access restrictions (optional)

#### NFR-LD-003: Audit Logging
- All document access logged
- Signature events logged with full context
- Logs retained for minimum 7 years
- Tamper-evident logging

### 5.2 Performance

#### NFR-LD-004: Response Time
- Document retrieval: < 2 seconds
- Agreement generation: < 5 seconds
- Search results: < 1 second
- eSign initiation: < 3 seconds

#### NFR-LD-005: Throughput
- Support 100 concurrent agreement generations
- Support 1000 concurrent document retrievals
- Handle 10,000 documents per user

### 5.3 Availability

#### NFR-LD-006: Uptime
- 99.9% availability for document vault
- 99.5% availability for eSign services
- Planned maintenance windows communicated 48 hours in advance

#### NFR-LD-007: Disaster Recovery
- RPO: 1 hour for documents
- RTO: 4 hours for full service restoration
- Geographic redundancy for document storage

### 5.4 Compliance

#### NFR-LD-008: Legal Compliance
- IT Act 2000 compliance for electronic signatures
- State-specific rental agreement laws
- GDPR/data protection compliance
- Aadhaar Act compliance for eSign

#### NFR-LD-009: Data Retention
- Active agreements: Retained until 7 years after expiry
- Verification records: 7 years
- Audit logs: 10 years
- User-initiated deletion with compliance checks

### 5.5 Scalability

#### NFR-LD-010: Storage Scalability
- Support for 10TB+ document storage
- Auto-scaling based on demand
- Cost-optimized tiered storage (hot/warm/cold)

---

## 6. API Specifications

### 6.1 Agreement APIs

```
POST   /api/v1/agreements                    # Create new agreement
GET    /api/v1/agreements                    # List agreements with filters
GET    /api/v1/agreements/:id                # Get agreement details
PUT    /api/v1/agreements/:id                # Update draft agreement
DELETE /api/v1/agreements/:id                # Delete draft agreement
POST   /api/v1/agreements/:id/finalize       # Finalize and initiate signing
POST   /api/v1/agreements/:id/terminate      # Terminate active agreement
GET    /api/v1/agreements/:id/preview        # Preview generated document
GET    /api/v1/agreements/:id/download       # Download signed agreement
```

### 6.2 Template APIs

```
POST   /api/v1/templates                     # Create template (admin)
GET    /api/v1/templates                     # List templates
GET    /api/v1/templates/:id                 # Get template details
PUT    /api/v1/templates/:id                 # Update template (admin)
DELETE /api/v1/templates/:id                 # Deactivate template (admin)
GET    /api/v1/templates/:id/preview         # Preview with sample data
POST   /api/v1/templates/:id/clone           # Clone template (admin)
```

### 6.3 eSignature APIs

```
POST   /api/v1/agreements/:id/signatures     # Initiate signing request
GET    /api/v1/agreements/:id/signatures     # Get signature status
POST   /api/v1/signatures/:id/sign           # Submit signature
POST   /api/v1/signatures/:id/remind         # Send reminder
DELETE /api/v1/signatures/:id                # Cancel signing request
```

### 6.4 Document Vault APIs

```
POST   /api/v1/documents                     # Upload document
GET    /api/v1/documents                     # List documents
GET    /api/v1/documents/:id                 # Get document metadata
GET    /api/v1/documents/:id/download        # Download document
DELETE /api/v1/documents/:id                 # Delete document
POST   /api/v1/documents/:id/share           # Create share link
GET    /api/v1/documents/:id/shares          # List shares
DELETE /api/v1/documents/:id/shares/:share_id # Revoke share
```

### 6.5 Verification APIs

```
POST   /api/v1/verifications                 # Initiate verification
GET    /api/v1/verifications                 # List verifications
GET    /api/v1/verifications/:id             # Get verification status
POST   /api/v1/verifications/:id/documents   # Upload verification docs
```

---

## 7. Domain Events

### 7.1 Published Events

| Event | Description | Consumers |
|-------|-------------|-----------|
| `agreement.created` | New agreement draft created | Analytics, CRM |
| `agreement.finalized` | Agreement ready for signing | Communications |
| `agreement.signed` | All parties have signed | Billing, Analytics |
| `agreement.registered` | Agreement registered | Analytics |
| `agreement.activated` | Agreement now active | PropertyManagement, Leads |
| `agreement.expiring` | Agreement expiring soon | Communications, CRM |
| `agreement.expired` | Agreement has expired | PropertyManagement, Analytics |
| `agreement.terminated` | Agreement terminated early | PropertyManagement, Billing |
| `signature.requested` | Signature request sent | Communications |
| `signature.completed` | Party signed document | Analytics |
| `signature.expired` | Signature request expired | Communications |
| `document.uploaded` | Document added to vault | Analytics |
| `document.shared` | Document shared with user | Communications |
| `document.accessed` | Document was accessed | TrustSafety |
| `verification.initiated` | Verification started | Analytics |
| `verification.completed` | Verification completed | Communications, Leads |

### 7.2 Consumed Events

| Event | Source | Action |
|-------|--------|--------|
| `lead.converted` | Leads | Auto-initiate agreement workflow |
| `payment.completed` | Billing | Update stamp duty payment status |
| `user.kyc_verified` | KYC | Enable Aadhaar eSign for user |
| `property.details_updated` | Inventory | Update agreement property details |

---

## 8. User Interface Requirements

### 8.1 Agreement Creation Flow

1. **Step 1: Select Agreement Type**
   - Choose between Rental/Lease/Leave & License
   - Auto-detect based on property and state

2. **Step 2: Property Details**
   - Auto-populate from Inventory if available
   - Manual entry for off-platform properties

3. **Step 3: Party Details**
   - Owner details (auto-filled if logged in)
   - Tenant details (invite or manual entry)
   - Witness details (optional)

4. **Step 4: Agreement Terms**
   - Rent and deposit amounts
   - Duration and notice period
   - Additional clauses selection
   - Custom terms (free text)

5. **Step 5: Review and Finalize**
   - Full document preview
   - Edit capability before finalization
   - Stamp duty calculation display
   - Initiate signing workflow

### 8.2 Signing Experience

- Mobile-first responsive design
- Clear indication of signing locations
- Multiple signature method options
- Progress indicator for multi-party signing
- Confirmation and receipt after signing

### 8.3 Document Vault Interface

- Grid and list view options
- Folder/category organization
- Quick search and filters
- Thumbnail previews
- Bulk operations support

---

## 9. Integration Requirements

### 9.1 External Integrations

| Provider | Purpose | Priority |
|----------|---------|----------|
| NSDL/UIDAI | Aadhaar eSign | P0 |
| eMudhra/Sify | DSC-based eSign | P1 |
| State Stamp Portals | e-Stamp generation | P1 |
| State Registration Portals | Online registration | P2 |
| IDfy/AuthBridge | Background verification | P2 |
| Tigris Object Storage | Document storage (S3-compatible) | P0 |

### 9.2 Internal Integrations

| Domain | Integration Point |
|--------|------------------|
| Auth | User authentication for all operations |
| KYC | Verification status for eSign eligibility |
| Billing | Stamp duty and service payments |
| Communications | Email/SMS/WhatsApp notifications |
| Inventory | Property details for agreements |

---

## 10. Success Metrics

### 10.1 Key Performance Indicators (KPIs)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Agreement completion rate | > 80% | Agreements signed / Agreements initiated |
| Time to sign | < 48 hours | Average time from initiation to completion |
| eSign adoption rate | > 70% | eSign agreements / Total agreements |
| Document vault adoption | > 60% | Users with documents / Total users |
| Customer satisfaction | > 4.2/5 | Post-signing survey |

### 10.2 Business Metrics

| Metric | Description |
|--------|-------------|
| Revenue per agreement | Average revenue from agreement services |
| Agreement volume | Monthly agreements processed |
| Repeat usage | Users creating multiple agreements |
| Cross-sell conversion | Users purchasing additional services |

---

## 11. Risks and Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| eSign provider downtime | High | Medium | Multiple provider fallback |
| State regulation changes | Medium | Medium | Configurable compliance rules |
| Document security breach | Critical | Low | Encryption, access controls, audits |
| User adoption resistance | Medium | Medium | User education, simplified UX |
| Integration complexity | Medium | High | Phased rollout, fallback workflows |

---

## 12. Implementation Phases

### Phase 1: Foundation (MVP)
- Basic agreement generation from templates
- Simple signature workflow (draw/type)
- Document vault with basic sharing
- Karnataka and Maharashtra support

### Phase 2: Enhanced Signing
- Aadhaar eSign integration
- Multi-party signing workflows
- Stamp duty calculation
- Additional state support

### Phase 3: Registration and Verification
- State registration portal integration
- Police verification workflow
- Background check integration
- Compliance dashboard

### Phase 4: Advanced Features
- Template builder for admins
- Bulk agreement generation
- API for partners
- Advanced analytics

---

## 13. Glossary

| Term | Definition |
|------|------------|
| eSign | Electronic signature as per IT Act 2000 |
| Aadhaar eSign | Legally valid eSign using Aadhaar OTP |
| DSC | Digital Signature Certificate |
| Stamp Duty | Government tax on legal documents |
| Leave & License | Agreement type common in Maharashtra |
| Sub-Registrar | Government office for document registration |
| Police Verification | Tenant background check by local police |

---

## 14. Appendix

### A. State-Specific Requirements

| State | Agreement Type | Stamp Duty | Registration Required |
|-------|---------------|------------|----------------------|
| Karnataka | Rental Agreement | 1% of annual rent | > 11 months mandatory |
| Maharashtra | Leave & License | 0.25% of total rent | > 60 months mandatory |
| Delhi | Rental Agreement | 2% of annual rent | > 11 months mandatory |
| Tamil Nadu | Rental Agreement | 1% of annual rent | > 11 months mandatory |
| Telangana | Rental Agreement | 0.5% of annual rent | > 11 months mandatory |

### B. Related Documents
- MySqrft Platform Domain Definitions
- Auth Domain PRD
- Billing Domain PRD
- Communications Domain PRD

---

*This document is maintained by the MySqrft Product Team. For questions or updates, contact the domain owner.*
