# Auth - Product Requirements

## Overview

The Auth domain provides secure, flexible authentication for all Mysqrft users, powered by `ash_authentication` and its Phoenix integration [`ash_authentication_phoenix`](https://hexdocs.pm/ash_authentication/readme.html). It standardizes how users sign up, sign in, and maintain sessions across web and (future) mobile clients, while keeping security controls centralized and consistent.

This domain focuses on three primary strategies: password-based authentication, passwordless magic links, and Google OAuth2 social login. It also owns session and device management, logout flows, and core account recovery so that other domains can assume a reliable, battle-tested identity layer.

## Goals & Objectives

- Provide a secure, standards-compliant authentication layer for all user types.
- Minimize friction for new and returning users through modern, low-friction login options.
- Support multiple strategies (password, magic link, Google) under a unified Ash Authentication configuration.
- Centralize session and device management with clear logout and revocation flows.
- Enable robust account recovery while protecting against takeover and abuse.
- Expose clear hooks and events for downstream domains (Analytics, TrustSafety, Marketing).

## Key Features

- **Password Authentication (AshAuthentication Password strategy)**: Email/password login with secure hashing and optional password reset flows.
- **Magic Link Authentication (Passwordless)**: One-click email-based login for low-friction onboarding and re-entry.
- **Google OAuth2 Login**: Social login using Google as an OAuth2 provider, with safe account linking and creation.
- **Session & Device Management**: Server-side session tracking, logout-all-sessions, and configurable session lifetimes.
- **Account Recovery & Security Controls**: Password reset, magic-link based recovery, suspicious login handling, and optional MFA hooks.

## User Stories

1. **As a new tenant or owner**, I want to sign up with my email and a password so that I can securely access my Mysqrft account from any device.
2. **As a returning user**, I want to log in with a magic link sent to my email so that I can access my account quickly without remembering a password.
3. **As a user who already uses Google**, I want to log in with my Google account so that I don't need to manage another password.
4. **As a security-conscious user**, I want to see active sessions/devices and revoke them so that I can protect my account if a device is lost or compromised.
5. **As a user who forgot my password**, I want a safe password reset flow so that I can regain access to my account without contacting support.
6. **As an admin or security team member**, I want consistent audit trails of authentication events so that I can investigate suspicious activity and meet compliance needs.
7. **As a product engineer**, I want a single, Ash-native way to check the current authenticated user so that I can secure routes and LiveViews without custom auth logic.

## Acceptance Criteria

1. **Password Authentication**
   - Users SHALL be able to register and log in using an email + password combination.
   - Passwords SHALL be stored only as secure hashes using the configured `ash_authentication` password strategy.
   - Failed login attempts SHALL not leak whether an email exists in the system via error messages.
   - Password reset flows SHALL verify user ownership via a time-bound token sent through a trusted channel (e.g., email).

2. **Magic Link Authentication**
   - Users SHALL be able to request a magic login link by providing a verified email address.
   - Magic links SHALL be single-use and time-bound, expiring after a configurable TTL.
   - Successful magic-link login SHALL result in a normal authenticated session, indistinguishable from password-based login for downstream domains.
   - Expired or reused magic links SHALL fail with a safe, non-leaky error and offer a way to request a new link.

3. **Google OAuth2 Login**
   - Users SHALL be able to log in with a Google account via OAuth2 without exposing Google credentials to Mysqrft.
   - First-time Google sign-ins SHALL either create a new user account or link to an existing account based on a unique identifier (e.g., email), following defined merge rules.
   - Revoked or invalid Google tokens SHALL result in a clear error and guidance to re-authenticate.

4. **Session & Device Management**
   - The system SHALL track active sessions per user, including device/browser and last seen timestamp where feasible.
   - Users SHALL be able to log out from the current session and, optionally, "log out from all devices".
   - Session expiration SHALL be configurable (idle timeout and absolute lifetime) and enforced for all strategies.

5. **Account Recovery & Security Controls**
   - Users SHALL be able to initiate account recovery (password reset or magic-link recovery) with verified identifiers.
   - Sensitive operations (e.g., password change) SHALL require recent authentication or re-verification.
   - The system SHALL record authentication-related security events (logins, failures, resets) for later analysis.

## Functional Requirements

### FR1: Password-Based Authentication

- System SHALL support an Ash Authentication password strategy with `identity_field` (e.g., email) and `hashed_password_field` configured.
- System SHALL allow user registration via password, including validation rules (minimum length, complexity if required).
- System SHALL implement a login action that validates the password and issues an authenticated session on success.
- System SHALL include a password reset flow using secure, time-bound tokens and enforce password validation on reset.

### FR2: Magic Link Authentication

- System SHALL support an Ash Authentication magic link strategy for passwordless email-based login.
- System SHALL generate a single-use, time-bound magic-link token tied to the user/identifier and intended action (login or recovery).
- System SHALL validate magic-link tokens, establish an authenticated session on success, and invalidate the token immediately after use.
- System SHALL handle invalid/expired tokens gracefully and provide a way to request a new link.

### FR3: Google OAuth2 Authentication

- System SHALL configure a Google OAuth2 strategy (client ID/secret, redirect URI) using `ash_authentication`'s OAuth2 capabilities.
- System SHALL initiate the OAuth2 flow, redirecting users to Google for authentication and consent.
- System SHALL handle the OAuth2 callback, validate tokens, and either create a new user or link to an existing user based on configuration.
- System SHALL store only the minimum required identity and token metadata to maintain sessions and comply with privacy requirements.

### FR4: Session & Device Management

- System SHALL issue and manage server-side sessions for all strategies (password, magic link, Google) in a consistent way.
- System SHALL support explicit logout from the current session and optional "logout everywhere" capability (e.g., via token store or Ash Authentication add-ons).
- System SHALL support configuration of idle timeout and absolute maximum session age and enforce these limits.
- System SHALL expose APIs/hooks to query and revoke sessions for a given user (for future device-management UI).

### FR5: Account Recovery & Security Events

- System SHALL provide account recovery actions (password reset and/or magic-link-based recovery) that validate user ownership.
- System SHALL throttle recovery and login attempts per identifier/IP to mitigate abuse.
- System SHALL emit structured authentication events (login success/failure, password reset, magic-link usage, Google login) for Analytics and TrustSafety.
- System SHALL provide hooks for enabling MFA or additional verification on high-risk actions in future phases.

## Non-Functional Requirements

### NFR1: Performance

- Interactive authentication flows (login, signup, magic-link consumption) SHALL complete in **<500ms** end-to-end for 95% of requests under normal load.
- OAuth2 callback handling for Google SHALL complete in **<800ms** for 95% of requests under normal load.
- Password hashing SHALL use a configuration that balances security and performance (e.g., bcrypt with a cost that keeps per-hash time under 250ms on production hardware).

### NFR2: Scalability

- System SHALL scale horizontally to support **tens of thousands of concurrent authenticated sessions** across tenants.
- System SHALL handle **3× normal peak login traffic** during spikes (e.g., campaign launches, festivals) without degradation beyond defined latency targets.
- System SHALL support multi-tenant deployments with proper separation of user identities and sessions.

### NFR3: Reliability

- Authentication services SHALL maintain **≥99.9% uptime** over a rolling 30-day period.
- Session validation SHALL be resilient to transient datastore failures, using retries and safe fallbacks where appropriate.
- Recovery and login flows SHALL fail gracefully, preserving system integrity even when email/OAuth providers are temporarily unavailable.

### NFR4: Security

- All authentication endpoints SHALL require HTTPS (TLS 1.2+) and SHALL reject plain HTTP in production.
- Passwords and sensitive tokens SHALL never be logged or exposed in error messages.
- All secrets (password hashing configuration, OAuth2 client secrets, signing keys) SHALL be stored in secure configuration mechanisms and not in source control.
- System SHALL support audit logging of authentication events, including timestamp, user identifier, strategy used, IP (where available), and outcome (success/failure).

### NFR5: Compliance & Privacy

- System SHALL support data export and deletion of authentication-related data in line with privacy regulations applicable to Mysqrft markets.
- System SHALL minimize storage of third-party OAuth provider data (e.g., Google) to only what is required for authentication and account linking.
- System SHALL provide clear hooks for consent and terms-of-service acknowledgements during sign-up for integration with Legal/Compliance domains.

## Integration Points

- **UserManagement**: Uses Auth identities as the primary login handle for profiles and lifecycle state; syncs basic identity fields (email, name) from password and Google strategies.
- **Authorization**: Consumes the authenticated user identity and role/permissions to enforce access control across the app.
- **Communications / Notifications**: Sends magic links, password reset emails, login alerts, and security notifications via the messaging infrastructure.
- **Analytics**: Consumes authentication events (signups, logins, failures, recoveries) for funnel analysis and growth metrics.
- **TrustSafety**: Uses authentication logs, IP/device patterns, and abnormal login signals to detect fraud or account takeovers.
- **Ops / Admin**: Provides admin consoles with visibility into authentication metrics and user login history (with proper access controls).

## Dependencies

- `ash_authentication` and `ash_authentication_phoenix` libraries for core strategy implementation and Phoenix integration ([documentation](https://hexdocs.pm/ash_authentication/readme.html)).
- Email delivery infrastructure (e.g., SMTP provider or transactional email service) for magic links and password resets.
- OAuth2 configuration and credentials for Google (client ID, client secret, redirect URIs).
- Secure configuration storage for secrets and signing keys (e.g., environment variables, secret manager).
- Logging and metrics stack to record authentication events and performance (e.g., Telemetry, Grafana/Prometheus or similar).

## Success Metrics

- **Authentication Success Rate**: Percentage of successful logins over total attempts (target: ≥98% excluding credential errors).
- **Signup Conversion Rate**: Percentage of users who successfully complete authentication during signup (target: ≥80% of initiated signups).
- **Magic Link Adoption**: Share of logins using magic links or Google versus password-only (target: ≥40% within 6 months).
- **Account Recovery Success Rate**: Percentage of initiated recovery flows that result in successful account access (target: ≥90%).
- **Authentication Latency**: P95 end-to-end latency for login and signup flows (target: <500ms).
- **Security Incident Rate**: Number of confirmed authentication-related security incidents per quarter (target: 0; alerts and near-misses tracked separately).

