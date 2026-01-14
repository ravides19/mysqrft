# Auth Domain - Beads Tasks

## Implementation Status

### Already Implemented
- Password authentication strategy (register, sign-in, password reset)
- Magic link authentication strategy
- Remember me functionality
- Token resource with storage and revocation
- Log out everywhere add-on
- Email confirmation for new users
- Basic user resource (email, hashed_password, confirmed_at)

### Pending Implementation
- Google OAuth2 integration
- Session & device management (tracking, UI)
- Comprehensive security event logging/audit trails
- Rate limiting for login/recovery attempts
- Session expiration configuration (idle timeout, absolute lifetime)
- MFA hooks (future phases)

---

## EPIC: AUTH-EPIC-1

```yaml
EPIC:
  id: AUTH-EPIC-1
  title: Complete Auth Domain Implementation
  description: |
    Implement the complete authentication layer for Mysqrft as defined in the Auth PRD.
    This includes completing the Google OAuth2 strategy, adding session/device management,
    implementing security event logging, and adding rate limiting for abuse prevention.
    
    The Auth domain provides secure, flexible authentication powered by `ash_authentication`
    and `ash_authentication_phoenix`, supporting password, magic link, and Google OAuth2
    strategies under a unified configuration.
  acceptance_criteria:
    - All three authentication strategies (password, magic link, Google OAuth2) are functional
    - Session and device management allows users to view/revoke active sessions
    - Security events are logged for audit and compliance
    - Rate limiting prevents brute-force and abuse attacks
    - All authentication flows complete in <500ms (P95)
    - Integration hooks exposed for downstream domains (Analytics, TrustSafety)
  user_stories:
    - AUTH-US-1
    - AUTH-US-2
    - AUTH-US-3
    - AUTH-US-4
    - AUTH-US-5
    - AUTH-US-6
    - AUTH-US-7
  notes: |
    Password and magic link strategies are already implemented.
    Focus is on Google OAuth2, session management, and security hardening.
    Reference: https://hexdocs.pm/ash_authentication/readme.html
```

---

## User Stories

### AUTH-US-1: Password Registration & Login

```yaml
USER_STORY:
  id: AUTH-US-1
  title: Password-Based Authentication
  as_a: New tenant or owner
  i_want: To sign up with my email and a password
  so_that: I can securely access my Mysqrft account from any device
  description: |
    Users should be able to register and authenticate using email and password.
    This is already implemented but needs validation that all acceptance criteria
    from the PRD are met, including security requirements.
  acceptance_criteria:
    - Users can register with email + password combination
    - Passwords are stored only as secure hashes (bcrypt)
    - Failed login attempts do not leak whether email exists
    - Password minimum length of 8 characters is enforced
    - Password reset flow uses time-bound tokens via email
    - Email confirmation is required before full account access
  tasks:
    - AUTH-T-1
    - AUTH-T-2
  test_guidance: |
    - Use DataCase for testing User resource validations
    - Use ConnCase for testing auth controller actions
    - Test registration success and validation failures
    - Test login success/failure without leaking email existence
    - Test password reset flow end-to-end
    - Test email confirmation workflow
  notes: |
    Already implemented in `Mysqrft.Accounts.User` with password strategy.
    Task is to verify and document existing implementation meets PRD criteria.
```

### AUTH-US-2: Magic Link Authentication

```yaml
USER_STORY:
  id: AUTH-US-2
  title: Magic Link Authentication
  as_a: Returning user
  i_want: To log in with a magic link sent to my email
  so_that: I can access my account quickly without remembering a password
  description: |
    Passwordless authentication via single-use, time-bound magic links.
    This is already implemented but needs verification of all acceptance criteria.
  acceptance_criteria:
    - Users can request a magic link by providing a verified email
    - Magic links are single-use and time-bound (configurable TTL)
    - Successful magic-link login creates a normal authenticated session
    - Expired or reused magic links fail with safe, non-leaky error
    - Failed links offer a way to request a new link
  tasks:
    - AUTH-T-3
    - AUTH-T-4
  test_guidance: |
    - Test magic link request for existing and non-existing emails
    - Test successful login via magic link
    - Test expired magic link rejection
    - Test reused magic link rejection
    - Verify session is indistinguishable from password login
  notes: |
    Already implemented in `Mysqrft.Accounts.User` with magic_link strategy.
    Verify TTL configuration and error messages meet security requirements.
```

### AUTH-US-3: Google OAuth2 Login

```yaml
USER_STORY:
  id: AUTH-US-3
  title: Google OAuth2 Authentication
  as_a: User who already uses Google
  i_want: To log in with my Google account
  so_that: I don't need to manage another password
  description: |
    Social login using Google as an OAuth2 provider with safe account
    linking and creation based on email matching.
  acceptance_criteria:
    - Users can initiate login via Google OAuth2 flow
    - Google credentials are never exposed to Mysqrft
    - First-time Google sign-ins create new account or link to existing based on email
    - Revoked or invalid Google tokens show clear error with re-auth guidance
    - Only minimum required identity/token metadata is stored
    - UserIdentity resource links Google identity to User
  tasks:
    - AUTH-T-5
    - AUTH-T-6
    - AUTH-T-7
    - AUTH-T-8
  test_guidance: |
    - Test OAuth2 flow initiation (redirect to Google)
    - Test OAuth2 callback handling (mock Google responses)
    - Test new user creation via Google sign-in
    - Test existing user linking via Google sign-in
    - Test invalid/revoked token handling
    - Test that Google credentials are not stored
  notes: |
    NOT YET IMPLEMENTED. Requires UserIdentity resource and Google strategy configuration.
    Reference: https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.OAuth2.html
```

### AUTH-US-4: Session & Device Management

```yaml
USER_STORY:
  id: AUTH-US-4
  title: Session and Device Management
  as_a: Security-conscious user
  i_want: To see active sessions/devices and revoke them
  so_that: I can protect my account if a device is lost or compromised
  description: |
    Users should be able to view their active sessions with device/browser info
    and last seen timestamps, and revoke individual sessions or all sessions.
  acceptance_criteria:
    - System tracks active sessions per user
    - Sessions include device/browser and last seen timestamp where feasible
    - Users can log out from current session
    - Users can "log out from all devices" (already implemented via add-on)
    - Session expiration is configurable (idle timeout, absolute lifetime)
    - APIs/hooks exist to query and revoke sessions for a user
  tasks:
    - AUTH-T-9
    - AUTH-T-10
    - AUTH-T-11
    - AUTH-T-12
  test_guidance: |
    - Test session creation on login (all strategies)
    - Test session listing for a user
    - Test single session revocation
    - Test "log out everywhere" functionality
    - Test session expiration (idle and absolute)
    - Test device/browser metadata capture
  notes: |
    Log out everywhere is already implemented.
    Need to add session tracking resource and UI for device management.
```

### AUTH-US-5: Password Reset & Account Recovery

```yaml
USER_STORY:
  id: AUTH-US-5
  title: Account Recovery
  as_a: User who forgot my password
  i_want: A safe password reset flow
  so_that: I can regain access to my account without contacting support
  description: |
    Secure account recovery via password reset tokens or magic-link-based recovery.
    Must verify user ownership and prevent account takeover.
  acceptance_criteria:
    - Users can initiate password reset with email
    - Reset tokens are time-bound and single-use
    - Password change requires recent authentication or re-verification
    - Recovery attempts are throttled per identifier/IP
    - System does not leak whether email exists during reset request
  tasks:
    - AUTH-T-13
    - AUTH-T-14
  test_guidance: |
    - Test password reset request (existing and non-existing email)
    - Test valid reset token consumption
    - Test expired reset token rejection
    - Test reused reset token rejection
    - Test rate limiting on reset requests
    - Verify error messages do not leak email existence
  notes: |
    Password reset is already implemented.
    Rate limiting needs to be added for security hardening.
```

### AUTH-US-6: Security Audit Trails

```yaml
USER_STORY:
  id: AUTH-US-6
  title: Authentication Audit Trails
  as_a: Admin or security team member
  i_want: Consistent audit trails of authentication events
  so_that: I can investigate suspicious activity and meet compliance needs
  description: |
    Structured logging of all authentication-related security events including
    logins, failures, resets, and strategy used.
  acceptance_criteria:
    - Login success events are logged with timestamp, user, strategy, IP
    - Login failure events are logged without leaking user existence
    - Password reset events are logged
    - Magic link usage events are logged
    - Google OAuth login events are logged
    - Events are structured for downstream Analytics and TrustSafety consumption
  tasks:
    - AUTH-T-15
    - AUTH-T-16
  test_guidance: |
    - Test that login success events are emitted/logged
    - Test that login failure events are emitted/logged
    - Test that reset events are emitted/logged
    - Test event structure matches expected schema
    - Verify sensitive data is not logged
  notes: |
    Implement using Telemetry events or AshEvents for structured event logging.
    Events should be consumable by Analytics and TrustSafety domains.
```

### AUTH-US-7: Ash-Native Authentication Checks

```yaml
USER_STORY:
  id: AUTH-US-7
  title: Ash-Native Authentication for Developers
  as_a: Product engineer
  i_want: A single, Ash-native way to check the current authenticated user
  so_that: I can secure routes and LiveViews without custom auth logic
  description: |
    Provide consistent, ergonomic APIs for checking authentication status
    in controllers, LiveViews, and Ash actions.
  acceptance_criteria:
    - LiveViews can access current_user via assigns (already implemented)
    - Controllers can access current_user via conn assigns
    - Ash actions can check actor for authorization
    - Clear documentation exists for securing routes and LiveViews
    - Unauthenticated access redirects appropriately
  tasks:
    - AUTH-T-17
    - AUTH-T-18
  test_guidance: |
    - Test LiveView authentication via on_mount hooks
    - Test controller authentication via plugs
    - Test redirect behavior for unauthenticated users
    - Test Ash action authorization with actor
  notes: |
    Already implemented via `live_user_auth.ex` and `auth_controller.ex`.
    Task is to verify and document the implementation.
```

---

## Tasks

### AUTH-T-1: Verify Password Strategy Implementation

```yaml
TASK:
  id: AUTH-T-1
  title: Verify Password Strategy Against PRD Requirements
  description: |
    Review existing password authentication implementation against PRD acceptance
    criteria. Ensure all security requirements are met including:
    - Secure password hashing (bcrypt configured)
    - Error messages that don't leak email existence
    - Password validation rules (min 8 chars)
    - Email confirmation workflow
  type: implementation
  related_to: AUTH-US-1
  acceptance_criteria:
    - All PRD acceptance criteria for password auth are verified
    - Any gaps are documented as follow-up tasks
    - Error messages reviewed for information leakage
  testing:
    - Review existing test coverage for password actions
    - Add tests for any uncovered acceptance criteria
  notes: |
    Location: lib/mysqrft/accounts/user.ex (password strategy section)
    Existing tests should be in test/mysqrft/accounts/ or test/mysqrft_web/
```

### AUTH-T-2: Test Password Authentication End-to-End

```yaml
TASK:
  id: AUTH-T-2
  title: Write Comprehensive Password Auth Tests
  description: |
    Create comprehensive test coverage for password authentication including:
    - Registration with valid/invalid data
    - Login success and failure cases
    - Password reset flow
    - Information leakage prevention
  type: test
  related_to: AUTH-US-1
  acceptance_criteria:
    - Tests cover registration, login, and password reset
    - Tests verify error messages don't leak email existence
    - Tests verify password constraints are enforced
    - Tests pass in CI
  testing:
    - Unit tests for User resource password actions (DataCase)
    - Integration tests for auth controller (ConnCase)
    - LiveView tests for auth forms if applicable
  notes: |
    Follow Phoenix testing guidelines: https://hexdocs.pm/phoenix/1.8.3/testing.html
    Use Ash.Test utilities where appropriate
```

### AUTH-T-3: Verify Magic Link Strategy Implementation

```yaml
TASK:
  id: AUTH-T-3
  title: Verify Magic Link Strategy Against PRD Requirements
  description: |
    Review existing magic link implementation against PRD acceptance criteria:
    - Single-use tokens
    - Configurable TTL
    - Safe error messages for expired/reused links
    - Session equivalence with password login
  type: implementation
  related_to: AUTH-US-2
  acceptance_criteria:
    - All PRD acceptance criteria for magic link auth are verified
    - TTL configuration is documented
    - Error messages reviewed for security
  testing:
    - Review existing test coverage
    - Document any gaps
  notes: |
    Location: lib/mysqrft/accounts/user.ex (magic_link strategy section)
    Check SendMagicLinkEmail sender implementation
```

### AUTH-T-4: Test Magic Link Authentication End-to-End

```yaml
TASK:
  id: AUTH-T-4
  title: Write Comprehensive Magic Link Auth Tests
  description: |
    Create comprehensive test coverage for magic link authentication:
    - Request magic link for existing/non-existing email
    - Consume valid magic link
    - Reject expired magic link
    - Reject reused magic link
  type: test
  related_to: AUTH-US-2
  acceptance_criteria:
    - Tests cover all magic link scenarios
    - Tests verify single-use enforcement
    - Tests verify TTL enforcement
    - Tests verify safe error messages
  testing:
    - Unit tests for magic link actions
    - Integration tests for magic link flow
  notes: |
    May need to mock time for TTL testing
```

### AUTH-T-5: Create UserIdentity Resource for OAuth2

```yaml
TASK:
  id: AUTH-T-5
  title: Create UserIdentity Resource
  description: |
    Create an Ash resource to store OAuth2 provider identities linked to users.
    This resource stores the provider (e.g., "google"), provider UID, and
    relationship to the User resource.
    
    Location: lib/mysqrft/accounts/user_identity.ex
  type: implementation
  related_to: AUTH-US-3
  acceptance_criteria:
    - UserIdentity resource created with provider, uid, user relationship
    - Migration generated for user_identities table
    - Resource registered in Accounts domain
    - Only minimum required data is stored (privacy requirement)
  testing:
    - Unit tests for UserIdentity resource
    - Test user-identity relationship
  notes: |
    Reference: AshAuthentication.UserIdentity extension
    https://hexdocs.pm/ash_authentication/AshAuthentication.UserIdentity.html
```

### AUTH-T-6: Implement Google OAuth2 Strategy

```yaml
TASK:
  id: AUTH-T-6
  title: Configure Google OAuth2 Strategy
  description: |
    Add Google OAuth2 strategy to User resource:
    - Configure client_id, client_secret, redirect_uri via secrets
    - Configure identity_resource to UserIdentity
    - Create register_with_google action
    - Handle account linking based on email
    
    Location: lib/mysqrft/accounts/user.ex
  type: implementation
  related_to: AUTH-US-3
  acceptance_criteria:
    - Google strategy configured in User authentication block
    - Secrets configured securely (not in source control)
    - register_with_google action created
    - Account linking logic implemented (email-based)
  testing:
    - Test OAuth flow initiation
    - Test callback handling with mocked Google responses
  notes: |
    Reference: https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.OAuth2.html
    Requires Google OAuth credentials from Google Cloud Console
```

### AUTH-T-7: Create Google OAuth2 Secrets Module

```yaml
TASK:
  id: AUTH-T-7
  title: Configure Google OAuth2 Secrets
  description: |
    Update Mysqrft.Secrets module to provide Google OAuth2 credentials:
    - GOOGLE_CLIENT_ID environment variable
    - GOOGLE_CLIENT_SECRET environment variable
    - GOOGLE_REDIRECT_URI environment variable
    
    Location: lib/mysqrft/secrets.ex and config/runtime.exs
  type: implementation
  related_to: AUTH-US-3
  acceptance_criteria:
    - Secrets module provides Google OAuth credentials
    - Credentials sourced from environment variables
    - No secrets in source control
    - Documentation for required env vars
  testing:
    - Verify secrets are properly loaded
    - Test behavior when secrets are missing
  notes: |
    Follow AshAuthentication secrets pattern used for signing_secret
```

### AUTH-T-8: Test Google OAuth2 Authentication

```yaml
TASK:
  id: AUTH-T-8
  title: Write Google OAuth2 Tests
  description: |
    Create comprehensive tests for Google OAuth2 authentication:
    - Test OAuth flow redirect
    - Test callback with mocked successful response
    - Test new user creation via Google
    - Test existing user linking via Google
    - Test invalid token handling
  type: test
  related_to: AUTH-US-3
  acceptance_criteria:
    - Tests cover OAuth flow initiation
    - Tests cover successful authentication (new and existing users)
    - Tests cover error scenarios
    - Tests use mocked Google responses (no live API calls in tests)
  testing:
    - Use Bypass or similar for mocking OAuth endpoints
    - Test both happy path and error scenarios
  notes: |
    Reference: https://hexdocs.pm/bypass/readme.html for mocking
```

### AUTH-T-9: Create Session Resource

```yaml
TASK:
  id: AUTH-T-9
  title: Create Session Tracking Resource
  description: |
    Create an Ash resource to track active user sessions with metadata:
    - User relationship
    - Device/browser information (user agent parsing)
    - IP address (where available)
    - Last seen timestamp
    - Created at timestamp
    - Authentication strategy used
    
    Location: lib/mysqrft/accounts/session.ex
  type: implementation
  related_to: AUTH-US-4
  acceptance_criteria:
    - Session resource created with required attributes
    - Migration generated
    - Resource registered in Accounts domain
    - Actions for create, read, revoke
  testing:
    - Unit tests for Session resource
    - Test session creation and querying
  notes: |
    Consider using Token resource's extra_data or creating dedicated resource
```

### AUTH-T-10: Implement Session Tracking on Authentication

```yaml
TASK:
  id: AUTH-T-10
  title: Track Sessions on All Auth Actions
  description: |
    Update all authentication actions to create/update session records:
    - Password sign-in creates session
    - Magic link sign-in creates session
    - Google OAuth sign-in creates session
    - Capture device/browser info from request
    - Update last_seen on session refresh
    
    Locations: User resource auth actions, auth controller/plugs
  type: implementation
  related_to: AUTH-US-4
  acceptance_criteria:
    - Sessions created on all successful authentications
    - Device/browser metadata captured
    - IP address captured where available
    - Last seen updated on activity
  testing:
    - Test session creation for each auth strategy
    - Test metadata capture
  notes: |
    May require changes to auth controller or custom plugs
```

### AUTH-T-11: Implement Session Management UI

```yaml
TASK:
  id: AUTH-T-11
  title: Create Session Management LiveView
  description: |
    Create a LiveView for users to manage their active sessions:
    - List active sessions with device info and last seen
    - Highlight current session
    - Button to revoke individual sessions
    - Button to revoke all other sessions
    
    Location: lib/mysqrft_web/live/settings/sessions_live.ex
  type: implementation
  related_to: AUTH-US-4
  acceptance_criteria:
    - LiveView displays active sessions
    - Current session is highlighted
    - Users can revoke individual sessions
    - Users can revoke all sessions except current
    - UI follows project design patterns
  testing:
    - LiveView tests for session listing
    - LiveView tests for revocation actions
  notes: |
    Follow Phoenix LiveView testing guidelines
    Use existing UI components from lib/mysqrft_web/components/
```

### AUTH-T-12: Configure Session Expiration

```yaml
TASK:
  id: AUTH-T-12
  title: Configure Session Timeout Settings
  description: |
    Configure session expiration settings:
    - Idle timeout (configurable, e.g., 30 minutes)
    - Absolute lifetime (configurable, e.g., 7 days)
    - Enforce limits on session refresh
    - Document configuration options
    
    Location: config/runtime.exs, User resource token configuration
  type: implementation
  related_to: AUTH-US-4
  acceptance_criteria:
    - Idle timeout is configurable and enforced
    - Absolute lifetime is configurable and enforced
    - Configuration documented
    - Sensible defaults set
  testing:
    - Test idle timeout enforcement
    - Test absolute lifetime enforcement
  notes: |
    Check ash_authentication token configuration options
```

### AUTH-T-13: Verify Password Reset Implementation

```yaml
TASK:
  id: AUTH-T-13
  title: Verify Password Reset Against PRD Requirements
  description: |
    Review existing password reset implementation:
    - Time-bound tokens
    - Single-use enforcement
    - Safe error messages (no email leak)
    - Re-verification requirement for password change
  type: implementation
  related_to: AUTH-US-5
  acceptance_criteria:
    - Password reset meets all PRD criteria
    - Error messages reviewed for information leakage
    - Token TTL is appropriate
  testing:
    - Review existing tests
    - Document any gaps
  notes: |
    Location: lib/mysqrft/accounts/user.ex (resettable configuration)
```

### AUTH-T-14: Implement Rate Limiting for Auth Actions

```yaml
TASK:
  id: AUTH-T-14
  title: Add Rate Limiting to Authentication Actions
  description: |
    Implement rate limiting to prevent brute-force attacks:
    - Rate limit login attempts per email/IP
    - Rate limit password reset requests per email/IP
    - Rate limit magic link requests per email/IP
    - Configurable limits and windows
    - Clear error messages for rate-limited requests
    
    Options: Hammer, custom Plug, or Ash preparation
  type: implementation
  related_to: AUTH-US-5
  acceptance_criteria:
    - Rate limiting applied to login actions
    - Rate limiting applied to reset actions
    - Rate limiting applied to magic link requests
    - Limits are configurable
    - Clear error response for rate-limited requests
  testing:
    - Test rate limit triggering
    - Test rate limit reset
    - Test configuration changes
  notes: |
    Consider using Hammer (https://github.com/ExHammer/hammer) for rate limiting
    Or implement as Ash preparation/validation
```

### AUTH-T-15: Implement Authentication Event Logging

```yaml
TASK:
  id: AUTH-T-15
  title: Create Authentication Event Resource
  description: |
    Create a resource or Telemetry-based system to log auth events:
    - Login success (user, strategy, IP, timestamp)
    - Login failure (identifier, strategy, IP, timestamp - no user leak)
    - Password reset request
    - Magic link request and consumption
    - Google OAuth authentication
    - Session revocation
    
    Consider: AshEvents extension or custom resource
  type: implementation
  related_to: AUTH-US-6
  acceptance_criteria:
    - All auth events are logged
    - Event structure is consistent
    - Sensitive data not logged (passwords, tokens)
    - Events queryable for audit purposes
  testing:
    - Test event creation for each scenario
    - Verify sensitive data exclusion
  notes: |
    Reference: AshEvents extension for event tracking
    Or use Telemetry with structured logging
```

### AUTH-T-16: Expose Auth Events for Downstream Domains

```yaml
TASK:
  id: AUTH-T-16
  title: Create Auth Event Hooks for Integration
  description: |
    Expose authentication events for downstream domain consumption:
    - Define event schema/contract
    - Publish events to Analytics domain
    - Publish events to TrustSafety domain
    - Document event format and consumption patterns
  type: implementation
  related_to: AUTH-US-6
  acceptance_criteria:
    - Event schema documented
    - Events consumable by Analytics
    - Events consumable by TrustSafety
    - Integration points documented
  testing:
    - Test event publication
    - Test event consumption (mock subscribers)
  notes: |
    Consider PubSub or direct domain integration
```

### AUTH-T-17: Document Authentication Implementation

```yaml
TASK:
  id: AUTH-T-17
  title: Create Auth Implementation Documentation
  description: |
    Create comprehensive documentation for the Auth implementation:
    - Architecture overview
    - Strategy configurations
    - How to secure routes and LiveViews
    - Session management usage
    - Event hooks for integrations
    - Configuration reference
    
    Location: docs/domain/auth/implementation.md
  type: documentation
  related_to: AUTH-US-7
  acceptance_criteria:
    - Architecture documented
    - All strategies documented
    - Route/LiveView security patterns documented
    - Configuration options documented
    - Integration points documented
  testing:
    - Review documentation for accuracy
    - Test code examples from docs
  notes: |
    Reference existing live_user_auth.ex and auth_controller.ex
```

### AUTH-T-18: Verify Auth Helpers and Plugs

```yaml
TASK:
  id: AUTH-T-18
  title: Verify Auth Helpers Implementation
  description: |
    Verify existing auth helpers meet PRD requirements:
    - LiveView on_mount hooks (live_user_auth.ex)
    - Controller auth plugs
    - Current user access patterns
    - Redirect behavior for unauthenticated users
  type: implementation
  related_to: AUTH-US-7
  acceptance_criteria:
    - LiveView hooks verified and documented
    - Controller plugs verified
    - Redirect behavior appropriate
    - Ash actor pattern documented
  testing:
    - Test LiveView authentication
    - Test controller authentication
    - Test redirect flows
  notes: |
    Location: lib/mysqrft_web/live_user_auth.ex
    Location: lib/mysqrft_web/controllers/auth_controller.ex
```

---

## Priority Order

### Phase 1: Verification & Testing (Current Implementation)
1. AUTH-T-1: Verify Password Strategy
2. AUTH-T-2: Test Password Authentication
3. AUTH-T-3: Verify Magic Link Strategy
4. AUTH-T-4: Test Magic Link Authentication
5. AUTH-T-13: Verify Password Reset
6. AUTH-T-18: Verify Auth Helpers

### Phase 2: Google OAuth2 (New Feature)
1. AUTH-T-5: Create UserIdentity Resource
2. AUTH-T-7: Configure Google OAuth Secrets
3. AUTH-T-6: Implement Google OAuth Strategy
4. AUTH-T-8: Test Google OAuth

### Phase 3: Session Management (New Feature)
1. AUTH-T-9: Create Session Resource
2. AUTH-T-10: Implement Session Tracking
3. AUTH-T-12: Configure Session Expiration
4. AUTH-T-11: Implement Session Management UI

### Phase 4: Security Hardening
1. AUTH-T-14: Implement Rate Limiting
2. AUTH-T-15: Implement Auth Event Logging
3. AUTH-T-16: Expose Auth Events for Integration

### Phase 5: Documentation
1. AUTH-T-17: Document Authentication Implementation

---

## Dependencies

```yaml
dependencies:
  - name: ash_authentication
    version: "~> 4.0"
    purpose: Core authentication strategies
    
  - name: ash_authentication_phoenix
    version: "~> 2.0"
    purpose: Phoenix integration for auth

  - name: hammer (proposed)
    version: "~> 6.0"
    purpose: Rate limiting
    note: To be added if rate limiting approach approved

  - name: ash_events (optional)
    version: "~> 0.1"
    purpose: Structured event logging
    note: Alternative to custom Telemetry implementation
```

---

## Notes for LLM Agents

- **Ash-native patterns**: Always use Ash actions, changesets, and code interfaces instead of direct Ecto or custom modules
- **Testing**: Follow Phoenix testing guidelines with ConnCase for controllers, DataCase for resources, and LiveViewTest for LiveViews
- **Security**: Never log passwords, tokens, or other sensitive data. Use `sensitive?: true` on attributes
- **Error messages**: Authentication error messages must not leak whether an email exists in the system
- **Configuration**: All secrets (OAuth credentials, signing keys) must come from environment variables, not source code
- **Reference**: Primary documentation at https://hexdocs.pm/ash_authentication/readme.html
