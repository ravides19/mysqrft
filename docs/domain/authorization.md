# Authorization Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| **Domain** | Authorization |
| **Version** | 1.0 |
| **Status** | Complete |
| **Owner** | Platform Team |
| **Last Updated** | January 2026 |
| **Platform** | MySqrft |

---

## 1. Executive Summary

### 1.1 Purpose

The Authorization domain provides comprehensive access control capabilities for the MySqrft platform. It ensures that users, services, and systems can only access resources and perform actions that they are explicitly permitted to, while maintaining security, compliance, and auditability across the entire platform.

### 1.2 Primary Goal

**Access Control Everywhere** - Implement a unified, scalable, and flexible authorization system that supports role-based, attribute-based, and resource-level access control across all MySqrft platform services.

### 1.3 Business Value

- **Security**: Prevent unauthorized access to sensitive data and operations
- **Compliance**: Meet regulatory requirements with comprehensive audit trails
- **Scalability**: Support multi-tenant architecture with proper isolation
- **Flexibility**: Enable complex permission models for diverse user types
- **Trust**: Build user confidence through transparent and reliable access controls

---

## 2. Domain Overview

### 2.1 Scope

The Authorization domain is responsible for:

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
- Privileged action audit logs and compliance tracking
- Access request workflows and approval processes
- Permission revocation and cleanup on role changes
- Resource ownership verification and transfer
- Cross-tenant access prevention and validation
- Permission testing and simulation for policy validation

### 2.2 Out of Scope

- User authentication (handled by Auth domain)
- User profile and role assignment UI (handled by UserManagement domain)
- Subscription plan management (handled by Entitlements domain)
- Feature flag definitions (handled by Ops domain)

### 2.3 Key Entities

| Entity | Description |
|--------|-------------|
| **Permission** | Atomic access right for a specific action on a resource type |
| **Policy** | Collection of rules that define access control logic |
| **Role** | Named collection of permissions that can be assigned to users |
| **AuditLog** | Record of authorization decisions and privileged actions |
| **ImpersonationSession** | Controlled session where admin acts as another user |
| **ResourcePermission** | Permission grant for a specific resource instance |
| **AccessPolicy** | Attribute-based policy for complex access decisions |
| **PermissionGrant** | Assignment of permission to a principal (user/role/group) |
| **AccessRequest** | Workflow request for elevated or temporary access |
| **PolicyVersion** | Versioned snapshot of policy for rollback and audit |
| **PermissionCache** | Cached permission evaluation results for performance |
| **ResourceOwner** | Ownership relationship between users and resources |

---

## 3. User Stories & Requirements

### 3.1 Role-Based Access Control (RBAC)

#### US-AUTH-001: Role Assignment
**As a** platform administrator
**I want to** assign roles to users
**So that** they receive appropriate permissions for their responsibilities

**Acceptance Criteria:**
- Admin can assign one or multiple roles to a user
- Role assignment is immediately effective
- Role changes are logged in the audit trail
- Users can view their assigned roles in their profile

#### US-AUTH-002: Hierarchical Roles
**As a** system architect
**I want to** define role hierarchies where higher roles inherit lower role permissions
**So that** permission management is simplified and consistent

**Acceptance Criteria:**
- Roles can be configured with parent-child relationships
- Child roles automatically inherit parent permissions
- Permission inheritance is computed in real-time
- Hierarchy changes propagate to all affected users

#### US-AUTH-003: Role-Specific Dashboards
**As a** user with multiple roles (e.g., Owner and Tenant)
**I want to** switch between role contexts
**So that** I can access role-specific features and views

**Acceptance Criteria:**
- Users can switch active role context in the UI
- Permission evaluation uses the active role context
- Recent role context is remembered across sessions

### 3.2 Attribute-Based Access Control (ABAC)

#### US-AUTH-004: City-Scoped Access
**As a** Relationship Manager (RM)
**I want to** access only leads and listings in my assigned city
**So that** I can focus on my territory without seeing irrelevant data

**Acceptance Criteria:**
- RM sees only resources matching their city assignment
- City assignment can be changed by admin
- Multi-city access is supported for regional managers
- City filter is applied automatically on all queries

#### US-AUTH-005: Society-Scoped Access
**As a** Society Admin
**I want to** manage only my assigned society
**So that** I cannot accidentally modify other societies' data

**Acceptance Criteria:**
- Society admin actions are limited to their society
- Cross-society access is prevented at the API level
- Society assignment is visible in the admin profile

#### US-AUTH-006: Team-Based Access
**As a** Team Lead
**I want to** access resources belonging to my team members
**So that** I can monitor and assist with their work

**Acceptance Criteria:**
- Team membership hierarchy is defined
- Team leads inherit visibility of team member resources
- Team changes update access in real-time

### 3.3 Multi-Tenant Isolation

#### US-AUTH-007: Tenant Data Isolation
**As a** platform security officer
**I want to** ensure complete data isolation between tenants
**So that** tenant data is never leaked to other tenants

**Acceptance Criteria:**
- Every data query includes tenant context
- Cross-tenant data access is blocked at API and database levels
- Tenant isolation is verified through automated tests
- Security audit logs capture any isolation violations

#### US-AUTH-008: Tenant Context Propagation
**As a** backend service
**I want to** receive tenant context in all requests
**So that** I can apply proper data filtering

**Acceptance Criteria:**
- Tenant ID is included in all authenticated requests
- Services validate tenant context before data access
- Missing tenant context results in access denial

### 3.4 Resource-Level Permissions

#### US-AUTH-009: Listing Access Control
**As a** property owner
**I want to** control who can view and edit my listings
**So that** my property information is protected

**Acceptance Criteria:**
- Owner has full control over their listings
- RM assigned to the listing has read/update access
- Public users have read-only access to published listings
- Draft listings are visible only to owner and assigned RM

#### US-AUTH-010: Lead Access Control
**As a** lead owner (tenant/buyer)
**I want to** ensure only relevant parties can access my lead
**So that** my contact information is protected

**Acceptance Criteria:**
- Lead creator has full access to their leads
- Property owner sees leads for their properties
- Assigned RM has lead access for their assignments
- Unrelated users cannot access the lead

#### US-AUTH-011: Resource Sharing
**As a** property owner
**I want to** share access to my property with my co-owner
**So that** they can also manage the listing

**Acceptance Criteria:**
- Owner can grant specific permissions to other users
- Shared access can be time-limited
- Sharing grants are logged and auditable
- Owner can revoke shared access at any time

### 3.5 Permission Evaluation & Performance

#### US-AUTH-012: Fast Permission Checks
**As a** platform user
**I want** permission checks to not slow down my experience
**So that** I can use the platform efficiently

**Acceptance Criteria:**
- Permission evaluation completes in < 10ms (P95)
- Frequently used permissions are cached
- Cache invalidation occurs on permission changes
- Performance metrics are monitored and alerted

#### US-AUTH-013: Bulk Permission Evaluation
**As a** search service
**I want to** evaluate permissions for multiple resources efficiently
**So that** filtered results are returned quickly

**Acceptance Criteria:**
- Batch permission API supports 100+ resources per call
- Batch evaluation is optimized for common patterns
- Results are returned within acceptable latency (< 100ms)

### 3.6 API Access Control

#### US-AUTH-014: Endpoint Protection
**As a** API gateway
**I want to** enforce permission requirements for each endpoint
**So that** unauthorized access is prevented

**Acceptance Criteria:**
- Every API endpoint has defined permission requirements
- Permission check occurs before request processing
- Unauthorized requests return 403 Forbidden
- Permission requirements are documented in API specs

#### US-AUTH-015: Rate Limiting
**As a** platform operations team
**I want to** enforce rate limits based on user roles and plans
**So that** platform resources are protected from abuse

**Acceptance Criteria:**
- Rate limits vary by user role and subscription plan
- Rate limit headers are included in responses
- Exceeded limits return 429 Too Many Requests
- Rate limit configuration is manageable without deployment

### 3.7 Feature & Entitlement Integration

#### US-AUTH-016: Feature Flag Checks
**As a** product manager
**I want to** gate features behind permissions
**So that** I can control feature rollout

**Acceptance Criteria:**
- Features can be linked to permission checks
- Permission system integrates with feature flag service
- Feature access is evaluated in real-time
- Feature access can be role or user-specific

#### US-AUTH-017: Plan-Based Access
**As a** free tier user
**I want to** understand which features require upgrade
**So that** I can make informed subscription decisions

**Acceptance Criteria:**
- Permission denials include entitlement information
- UI displays upgrade prompts for restricted features
- Entitlement changes immediately affect permissions
- Plan-based restrictions are consistently enforced

### 3.8 Context-Based Permissions

#### US-AUTH-018: Time-Based Access
**As a** temporary contractor
**I want to** have access only during my contract period
**So that** my access automatically expires

**Acceptance Criteria:**
- Permissions can have start and end dates
- Expired permissions are automatically revoked
- Upcoming expirations trigger notifications
- Time-based access is visible in admin panel

#### US-AUTH-019: IP-Based Restrictions
**As a** security administrator
**I want to** restrict admin access to office IP ranges
**So that** admin functions are protected from remote threats

**Acceptance Criteria:**
- Admin roles can require specific IP ranges
- IP restrictions are configurable per role
- Blocked access attempts are logged
- VPN access can be whitelisted

#### US-AUTH-020: Location-Based Access
**As a** field RM
**I want to** access certain features only when on-site
**So that** sensitive operations are location-verified

**Acceptance Criteria:**
- Location can be a permission condition
- Location verification uses GPS with accuracy threshold
- Location-restricted actions are clearly indicated
- Location bypass requires supervisor approval

### 3.9 Access Delegation

#### US-AUTH-021: Temporary Permission Grant
**As a** team lead on vacation
**I want to** temporarily delegate my approval permissions
**So that** work can continue in my absence

**Acceptance Criteria:**
- Delegation specifies permissions, delegate, and duration
- Delegated permissions are marked as such in audit logs
- Delegation can be revoked early
- Delegate receives notification of delegation

#### US-AUTH-022: On-Behalf-Of Actions
**As a** customer support agent
**I want to** perform actions on behalf of a user
**So that** I can assist with their issues

**Acceptance Criteria:**
- On-behalf-of actions require explicit permission
- All actions are logged with the acting user
- User is notified of actions taken on their behalf
- Sensitive actions require additional approval

### 3.10 Admin Impersonation

#### US-AUTH-023: User Impersonation
**As a** support administrator
**I want to** view the platform as a specific user sees it
**So that** I can troubleshoot their issues effectively

**Acceptance Criteria:**
- Impersonation requires elevated permission
- Impersonation sessions are time-limited (max 1 hour)
- All actions during impersonation are logged
- Impersonated user is notified of the session
- Impersonation cannot access payment methods or change passwords

#### US-AUTH-024: Impersonation Approval
**As a** security officer
**I want** impersonation to require real-time approval
**So that** impersonation is controlled and justified

**Acceptance Criteria:**
- Impersonation request includes reason/ticket reference
- Approval workflow notifies designated approvers
- Approved impersonation has limited scope and duration
- Denied requests are logged and reporter is notified

### 3.11 Audit & Compliance

#### US-AUTH-025: Comprehensive Audit Logging
**As a** compliance officer
**I want** all authorization decisions logged
**So that** I can audit access for compliance

**Acceptance Criteria:**
- Every permission check is logged with decision
- Logs include user, resource, permission, decision, and timestamp
- Logs are immutable and tamper-evident
- Log retention meets compliance requirements (7 years)

#### US-AUTH-026: Privileged Action Tracking
**As a** security auditor
**I want to** track all privileged actions
**So that** I can detect and investigate security incidents

**Acceptance Criteria:**
- Privileged actions are flagged and specially tracked
- Real-time alerts for suspicious privileged activity
- Privileged action reports are available on-demand
- Actions include full context (IP, device, location)

#### US-AUTH-027: Access Reports
**As a** department manager
**I want to** review access reports for my team
**So that** I can ensure appropriate access levels

**Acceptance Criteria:**
- Reports show permissions per user
- Reports highlight unusual access patterns
- Reports can be exported for review
- Report generation is scheduled and on-demand

### 3.12 Access Request Workflows

#### US-AUTH-028: Access Request Submission
**As a** employee needing temporary elevated access
**I want to** submit an access request
**So that** I can get approval for the access I need

**Acceptance Criteria:**
- Request form captures permission, duration, and justification
- Requests are routed to appropriate approvers
- Request status is visible to requester
- Requests expire if not acted upon

#### US-AUTH-029: Access Request Approval
**As a** approver
**I want to** review and approve/deny access requests
**So that** I can control access to sensitive resources

**Acceptance Criteria:**
- Approvers are notified of pending requests
- Approval UI shows full request context
- Approval can be partial (reduced scope/duration)
- Approval actions are logged

### 3.13 Permission Lifecycle

#### US-AUTH-030: Permission Revocation on Role Change
**As a** HR system
**I want to** trigger permission revocation when an employee changes roles
**So that** access is promptly removed when no longer needed

**Acceptance Criteria:**
- Role change events trigger permission review
- Permissions not valid for new role are revoked
- Grace period allows for transition (configurable)
- Revocation is logged and user is notified

#### US-AUTH-031: Permission Cleanup
**As a** system administrator
**I want** orphaned permissions to be automatically cleaned up
**So that** the permission system stays maintainable

**Acceptance Criteria:**
- Permissions for deleted users are removed
- Permissions for deleted resources are removed
- Cleanup runs on schedule and on-demand
- Cleanup actions are logged

### 3.14 Resource Ownership

#### US-AUTH-032: Ownership Verification
**As a** platform
**I want to** verify resource ownership before granting owner permissions
**So that** only legitimate owners have full control

**Acceptance Criteria:**
- Ownership claims require verification
- Verification integrates with KYC domain
- Unverified owners have limited permissions
- Verification status is visible on resources

#### US-AUTH-033: Ownership Transfer
**As a** property owner selling my property
**I want to** transfer listing ownership to the new owner
**So that** they can manage the property

**Acceptance Criteria:**
- Transfer requires consent from both parties
- Transfer updates all permission grants
- Transfer history is maintained
- Original owner loses access upon transfer

### 3.15 Policy Management

#### US-AUTH-034: Policy Definition
**As a** security architect
**I want to** define access policies in a structured format
**So that** policies are consistent and auditable

**Acceptance Criteria:**
- Policy language supports RBAC and ABAC rules
- Policies are version-controlled
- Policy changes require approval workflow
- Policy syntax is validated before deployment

#### US-AUTH-035: Policy Versioning
**As a** compliance officer
**I want to** track policy changes over time
**So that** I can audit historical access decisions

**Acceptance Criteria:**
- Every policy change creates a new version
- Previous versions are retained
- Rollback to previous version is supported
- Version history includes change author and reason

#### US-AUTH-036: Policy Testing
**As a** security engineer
**I want to** test policy changes before deployment
**So that** I can verify they work as intended

**Acceptance Criteria:**
- Simulation mode evaluates policy without enforcement
- Test scenarios can be defined and saved
- Test results show affected users and resources
- Comparison between current and proposed policy

---

## 4. Functional Requirements

### 4.1 Core Authorization Engine

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-001 | System shall evaluate permissions in < 10ms (P95) | P0 |
| FR-002 | System shall support RBAC with role hierarchies | P0 |
| FR-003 | System shall support ABAC with custom attributes | P0 |
| FR-004 | System shall cache permission decisions with configurable TTL | P0 |
| FR-005 | System shall invalidate cache on permission changes | P0 |
| FR-006 | System shall support batch permission evaluation | P1 |
| FR-007 | System shall log all authorization decisions | P0 |

### 4.2 Role Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-008 | System shall support predefined platform roles | P0 |
| FR-009 | System shall support custom role creation | P1 |
| FR-010 | System shall support role hierarchies with inheritance | P0 |
| FR-011 | System shall allow multiple roles per user | P0 |
| FR-012 | System shall support role scoping (city/society/team) | P0 |

### 4.3 Permission Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-013 | System shall support resource-type permissions | P0 |
| FR-014 | System shall support resource-instance permissions | P0 |
| FR-015 | System shall support permission inheritance | P1 |
| FR-016 | System shall support time-bound permissions | P1 |
| FR-017 | System shall support conditional permissions (context-based) | P2 |

### 4.4 Policy Engine

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-018 | System shall support policy definition in structured format | P1 |
| FR-019 | System shall version all policy changes | P1 |
| FR-020 | System shall support policy simulation/testing | P2 |
| FR-021 | System shall support policy rollback | P2 |

### 4.5 Multi-Tenant Support

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-022 | System shall enforce tenant isolation at all layers | P0 |
| FR-023 | System shall include tenant context in all permission checks | P0 |
| FR-024 | System shall prevent cross-tenant resource access | P0 |
| FR-025 | System shall support tenant-specific role definitions | P2 |

### 4.6 Audit & Compliance

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-026 | System shall log all permission grants and revocations | P0 |
| FR-027 | System shall log all privileged actions | P0 |
| FR-028 | System shall support audit log retention for 7 years | P0 |
| FR-029 | System shall generate access reports on-demand | P1 |
| FR-030 | System shall support compliance export formats | P2 |

### 4.7 Impersonation & Delegation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-031 | System shall support admin impersonation with approval | P1 |
| FR-032 | System shall enforce impersonation session limits | P1 |
| FR-033 | System shall support permission delegation | P2 |
| FR-034 | System shall notify users of impersonation sessions | P1 |

### 4.8 Access Requests

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-035 | System shall support access request submission | P2 |
| FR-036 | System shall route requests to appropriate approvers | P2 |
| FR-037 | System shall track request status and history | P2 |
| FR-038 | System shall auto-expire unfulfilled requests | P2 |

---

## 5. Non-Functional Requirements

### 5.1 Performance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-001 | Permission evaluation latency | < 10ms (P95), < 50ms (P99) |
| NFR-002 | Batch permission evaluation (100 resources) | < 100ms (P95) |
| NFR-003 | Cache hit ratio | > 95% for repeated checks |
| NFR-004 | Permission check throughput | > 10,000 requests/second |

### 5.2 Availability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-005 | Service availability | 99.99% uptime |
| NFR-006 | Graceful degradation | Fail-closed on errors |
| NFR-007 | Recovery time objective (RTO) | < 5 minutes |
| NFR-008 | Recovery point objective (RPO) | < 1 minute |

### 5.3 Security

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-009 | Audit log integrity | Tamper-evident logging |
| NFR-010 | Encryption at rest | AES-256 for sensitive data |
| NFR-011 | Encryption in transit | TLS 1.3 |
| NFR-012 | Secret management | Vault/KMS integration |

### 5.4 Scalability

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-013 | Horizontal scalability | Linear scaling to 10x load |
| NFR-014 | Multi-region support | Active-active deployment |
| NFR-015 | Data partitioning | By tenant for isolation |

### 5.5 Compliance

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-016 | Audit log retention | 7 years minimum |
| NFR-017 | GDPR compliance | Right to access, erasure |
| NFR-018 | SOC 2 compliance | Type II certification ready |

---

## 6. Platform Roles Definition

### 6.1 Consumer Roles

| Role | Description | Base Permissions |
|------|-------------|------------------|
| **Tenant** | User searching for rental properties | Search, view listings, create leads, manage own profile |
| **Buyer** | User searching for properties to purchase | Search, view listings, create leads, manage own profile |
| **Owner** | Property owner listing properties | Create/manage listings, view leads, manage own profile |
| **Resident** | Society member | View society info, visitor management, complaints |

### 6.2 Operations Roles

| Role | Description | Base Permissions |
|------|-------------|------------------|
| **RM** | Relationship Manager | City-scoped lead/listing access, client management |
| **TeamLead** | RM Team Lead | Team member access + RM permissions |
| **CityManager** | City Operations Head | City-wide access + TeamLead permissions |
| **SupportAgent** | Customer Support | Read access to tickets, user profiles, limited actions |
| **SupportSupervisor** | Support Team Lead | Full ticket access, escalation handling |

### 6.3 Society Roles

| Role | Description | Base Permissions |
|------|-------------|------------------|
| **SocietyAdmin** | Society Administrator | Society-scoped full management |
| **Committee** | Society Committee Member | Limited society management |
| **Guard** | Society Security | Visitor management, gate access |
| **Vendor** | Society Service Vendor | Limited access to work orders |

### 6.4 Administrative Roles

| Role | Description | Base Permissions |
|------|-------------|------------------|
| **Admin** | Platform Administrator | Full platform access |
| **SuperAdmin** | Super Administrator | Admin + impersonation + policy management |
| **SecurityAdmin** | Security Administrator | Audit logs, security settings, impersonation approval |
| **ComplianceOfficer** | Compliance Team | Audit access, reports, data export |

---

## 7. API Specifications

### 7.1 Permission Check API

```
POST /api/v1/authorization/check
```

**Request:**
```json
{
  "principal": {
    "user_id": "usr_123",
    "tenant_id": "tenant_456",
    "roles": ["owner", "tenant"],
    "attributes": {
      "city": "bangalore",
      "society_id": "soc_789"
    }
  },
  "resource": {
    "type": "listing",
    "id": "lst_abc",
    "attributes": {
      "owner_id": "usr_123",
      "city": "bangalore"
    }
  },
  "action": "update",
  "context": {
    "ip_address": "192.168.1.1",
    "timestamp": "2026-01-17T10:00:00Z"
  }
}
```

**Response:**
```json
{
  "allowed": true,
  "reason": "Owner has full access to own listings",
  "policy_version": "v2.3.1",
  "cached": false,
  "evaluation_time_ms": 3
}
```

### 7.2 Batch Permission Check API

```
POST /api/v1/authorization/check-batch
```

**Request:**
```json
{
  "principal": { ... },
  "checks": [
    { "resource": { "type": "listing", "id": "lst_1" }, "action": "view" },
    { "resource": { "type": "listing", "id": "lst_2" }, "action": "view" },
    { "resource": { "type": "lead", "id": "lead_1" }, "action": "contact" }
  ],
  "context": { ... }
}
```

**Response:**
```json
{
  "results": [
    { "resource_id": "lst_1", "action": "view", "allowed": true },
    { "resource_id": "lst_2", "action": "view", "allowed": false },
    { "resource_id": "lead_1", "action": "contact", "allowed": true }
  ],
  "evaluation_time_ms": 12
}
```

### 7.3 Role Management API

```
GET    /api/v1/authorization/roles
POST   /api/v1/authorization/roles
GET    /api/v1/authorization/roles/{role_id}
PUT    /api/v1/authorization/roles/{role_id}
DELETE /api/v1/authorization/roles/{role_id}

POST   /api/v1/authorization/users/{user_id}/roles
DELETE /api/v1/authorization/users/{user_id}/roles/{role_id}
GET    /api/v1/authorization/users/{user_id}/permissions
```

### 7.4 Impersonation API

```
POST   /api/v1/authorization/impersonation/request
GET    /api/v1/authorization/impersonation/requests/{request_id}
POST   /api/v1/authorization/impersonation/requests/{request_id}/approve
POST   /api/v1/authorization/impersonation/requests/{request_id}/deny
POST   /api/v1/authorization/impersonation/sessions
DELETE /api/v1/authorization/impersonation/sessions/{session_id}
```

### 7.5 Audit API

```
GET    /api/v1/authorization/audit/logs
GET    /api/v1/authorization/audit/logs/{log_id}
POST   /api/v1/authorization/audit/reports
GET    /api/v1/authorization/audit/reports/{report_id}
```

---

## 8. Data Models

### 8.1 Permission

```typescript
interface Permission {
  id: string;
  name: string;                    // e.g., "listing:update"
  resource_type: string;           // e.g., "listing"
  action: string;                  // e.g., "update"
  description: string;
  is_sensitive: boolean;           // Requires additional logging
  created_at: timestamp;
  updated_at: timestamp;
}
```

### 8.2 Role

```typescript
interface Role {
  id: string;
  name: string;                    // e.g., "owner", "rm"
  display_name: string;            // e.g., "Property Owner"
  description: string;
  parent_role_id: string | null;   // For hierarchy
  permissions: Permission[];
  scope_type: 'global' | 'tenant' | 'city' | 'society' | 'team';
  is_system_role: boolean;         // Cannot be deleted
  created_at: timestamp;
  updated_at: timestamp;
}
```

### 8.3 Policy

```typescript
interface Policy {
  id: string;
  name: string;
  version: string;
  rules: PolicyRule[];
  priority: number;                // Higher = evaluated first
  is_active: boolean;
  created_by: string;
  created_at: timestamp;
  activated_at: timestamp | null;
}

interface PolicyRule {
  id: string;
  effect: 'allow' | 'deny';
  principals: PrincipalMatcher[];
  resources: ResourceMatcher[];
  actions: string[];
  conditions: Condition[];
}
```

### 8.4 AuditLog

```typescript
interface AuditLog {
  id: string;
  timestamp: timestamp;
  event_type: 'permission_check' | 'role_change' | 'policy_change' | 'impersonation' | 'privileged_action';
  principal_id: string;
  principal_type: 'user' | 'service' | 'system';
  resource_type: string | null;
  resource_id: string | null;
  action: string;
  decision: 'allow' | 'deny';
  reason: string;
  policy_version: string;
  context: {
    ip_address: string;
    user_agent: string;
    device_id: string | null;
    location: GeoLocation | null;
  };
  metadata: Record<string, any>;
}
```

### 8.5 ImpersonationSession

```typescript
interface ImpersonationSession {
  id: string;
  impersonator_id: string;         // Admin doing the impersonation
  target_user_id: string;          // User being impersonated
  reason: string;
  ticket_reference: string | null;
  approved_by: string;
  approved_at: timestamp;
  started_at: timestamp;
  expires_at: timestamp;
  ended_at: timestamp | null;
  restricted_permissions: string[];  // Permissions excluded during impersonation
  status: 'pending' | 'approved' | 'denied' | 'active' | 'expired' | 'ended';
}
```

### 8.6 AccessRequest

```typescript
interface AccessRequest {
  id: string;
  requester_id: string;
  requested_permissions: string[];
  requested_roles: string[];
  resource_scope: ResourceScope | null;
  reason: string;
  ticket_reference: string | null;
  duration_hours: number;
  status: 'pending' | 'approved' | 'denied' | 'expired' | 'revoked';
  approver_id: string | null;
  approved_at: timestamp | null;
  denied_reason: string | null;
  created_at: timestamp;
  expires_at: timestamp;
}
```

---

## 9. Integration Points

### 9.1 Dependencies

| Domain | Integration Type | Purpose |
|--------|------------------|---------|
| **Auth** | Sync | Identity verification, session validation |
| **UserManagement** | Sync | Role assignments, user attributes |
| **Entitlements** | Sync | Plan-based feature access |
| **Ops** | Sync | Feature flags, configuration |

### 9.2 Consumers

| Domain | Integration Type | Purpose |
|--------|------------------|---------|
| **All Domains** | Sync | Permission checks for all operations |
| **Inventory** | Sync | Listing access control |
| **Leads** | Sync | Lead visibility and actions |
| **Society** | Sync | Society-scoped access |
| **Support** | Sync | Ticket access control |
| **Analytics** | Async | Access patterns and reports |

### 9.3 Events Published

| Event | Description | Consumers |
|-------|-------------|-----------|
| `permission.granted` | Permission granted to user | Analytics, Audit |
| `permission.revoked` | Permission revoked from user | Analytics, Audit |
| `role.assigned` | Role assigned to user | UserManagement, Audit |
| `role.removed` | Role removed from user | UserManagement, Audit |
| `policy.activated` | New policy version activated | Audit, Ops |
| `impersonation.started` | Impersonation session started | Audit, Notifications |
| `impersonation.ended` | Impersonation session ended | Audit |
| `access_request.submitted` | Access request created | Notifications |
| `access_request.decided` | Access request approved/denied | Notifications |

### 9.4 Events Consumed

| Event | Source | Purpose |
|-------|--------|---------|
| `user.created` | UserManagement | Initialize default permissions |
| `user.deleted` | UserManagement | Cleanup permissions |
| `user.role_changed` | UserManagement | Update role-based permissions |
| `entitlement.changed` | Entitlements | Update plan-based access |
| `feature_flag.changed` | Ops | Update feature access |

---

## 10. Security Considerations

### 10.1 Principle of Least Privilege
- Default to deny all access
- Grant only minimum necessary permissions
- Require justification for elevated access

### 10.2 Defense in Depth
- Enforce authorization at API gateway
- Enforce authorization at service layer
- Enforce authorization at database layer (row-level security)

### 10.3 Audit and Monitoring
- Log all authorization decisions
- Alert on suspicious patterns (bulk access, unusual hours)
- Regular access reviews

### 10.4 Impersonation Controls
- Require explicit approval for impersonation
- Exclude sensitive actions (password change, payment)
- Time-limit all impersonation sessions
- Notify users of impersonation

### 10.5 Policy Change Controls
- Require approval for policy changes
- Test policies before activation
- Maintain policy version history
- Enable rapid rollback

---

## 11. Implementation Phases

### Phase 1: Foundation (MVP)
- Basic RBAC with predefined roles
- Permission check API
- Tenant isolation
- Basic audit logging
- API endpoint protection

### Phase 2: Enhanced Access Control
- Role hierarchies
- ABAC with city/society scoping
- Resource-level permissions
- Permission caching
- Batch permission evaluation

### Phase 3: Compliance & Governance
- Admin impersonation with approval
- Access request workflows
- Comprehensive audit reports
- Policy versioning
- Time-based permissions

### Phase 4: Advanced Features
- Policy simulation/testing
- Context-based permissions (IP, location)
- Permission delegation
- Advanced analytics
- Self-service access management

---

## 12. Success Metrics

### 12.1 Performance Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Permission check latency (P95) | < 10ms | APM monitoring |
| Cache hit ratio | > 95% | Cache metrics |
| Authorization service uptime | 99.99% | Uptime monitoring |

### 12.2 Security Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Unauthorized access attempts | Track trend | Security logs |
| Time to revoke access on offboarding | < 1 hour | Process tracking |
| Impersonation approval rate | Track | Approval logs |

### 12.3 Operational Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Access request fulfillment time | < 4 hours | Workflow tracking |
| Policy change deployment time | < 1 hour | Deployment logs |
| Audit report generation time | < 5 minutes | Report metrics |

---

## 13. Open Questions

1. **Policy Language**: Should we adopt an existing policy language (OPA/Rego, Cedar) or develop custom DSL?

2. **Distributed Caching**: Redis cluster vs. local caching with event-based invalidation?

3. **Emergency Access**: Define process for emergency access bypass with retrospective approval?

4. **Cross-Region**: How to handle permission checks across regions with minimal latency?

5. **Legacy Integration**: Migration strategy for existing hardcoded access checks?

---

## 14. Appendix

### 14.1 Glossary

| Term | Definition |
|------|------------|
| **Principal** | Entity requesting access (user, service, system) |
| **Resource** | Entity being accessed (listing, lead, user) |
| **Action** | Operation being performed (create, read, update, delete) |
| **Policy** | Set of rules defining access control logic |
| **RBAC** | Role-Based Access Control |
| **ABAC** | Attribute-Based Access Control |
| **Tenant** | Isolated organizational unit in multi-tenant system |

### 14.2 References

- [NIST RBAC Model](https://csrc.nist.gov/projects/role-based-access-control)
- [XACML Standard](https://docs.oasis-open.org/xacml/3.0/xacml-3.0-core-spec-os-en.html)
- [AWS Cedar Policy Language](https://www.cedarpolicy.com/)
- [Open Policy Agent](https://www.openpolicyagent.org/)

### 14.3 Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | January 2026 | Platform Team | Initial version |

---

*This document is part of the MySqrft Platform Documentation.*
