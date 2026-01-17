Always use mishka_chelekom components library for UI components, if there is no relevant component exisiting then compose one from the exisiting components or try to create a new component following the design of the existing components.

Components are located in lib/my_sqrft_web/components
Layout are located in lib/my_sqrft_web/components/layouts
Create new layouts when needed and always use liveview for creating the webpages

## Domain Documentation & Architecture

### Domain Model Reference
- **Primary Domain Definition**: [`docs/domains.md`](docs/domains.md) - Complete domain architecture with all 22 domains, implementation phases, and status tracking
- **Domain Status Summary**: See Status & Summary section in `docs/domains.md` for current implementation status of all domains

### Product Requirements Documents (PRDs)
All domain PRDs are located in `docs/domain/` directory. Each domain has a comprehensive Product Requirements Document:

**Core Foundation Domains (Phase 1 - MVP):**
- [`docs/domain/auth.md`](docs/domain/auth.md) - Authentication & Identity Proof
- [`docs/domain/kyc.md`](docs/domain/kyc.md) - User Identity Verification & Compliance
- [`docs/domain/user-management.md`](docs/domain/user-management.md) - Profiles, Roles & Lifecycle
- [`docs/domain/authorization.md`](docs/domain/authorization.md) - Access Control Everywhere
- [`docs/domain/inventory.md`](docs/domain/inventory.md) - Property Supply & Lifecycle
- [`docs/domain/search.md`](docs/domain/search.md) - Discovery Experience
- [`docs/domain/leads.md`](docs/domain/leads.md) - Direct Connect & Lead Lifecycle
- [`docs/domain/communications.md`](docs/domain/communications.md) - Messaging, Calling & Notifications

**Monetization Domains (Phase 2):**
- [`docs/domain/entitlements.md`](docs/domain/entitlements.md) - Plan-Based Access Control
- [`docs/domain/billing.md`](docs/domain/billing.md) - Money Movement & Invoices
- [`docs/domain/sales.md`](docs/domain/sales.md) - Monetization Conversion & Assisted Selling

**Assisted Sales Domains (Phase 3):**
- [`docs/domain/crm.md`](docs/domain/crm.md) - Relationship Management & Pipeline
- [`docs/domain/scheduling.md`](docs/domain/scheduling.md) - Visits & Appointments

**Service Expansion Domains (Phase 4):**
- [`docs/domain/legal-docs.md`](docs/domain/legal-docs.md) - Rental Agreement & Documentation
- [`docs/domain/home-services.md`](docs/domain/home-services.md) - Movers/Painting/Cleaning & Fulfillment
- [`docs/domain/property-management.md`](docs/domain/property-management.md) - Recurring Owner Services

**Platform Expansion Domains (Phase 5):**
- [`docs/domain/society.md`](docs/domain/society.md) - Community Management SaaS
- [`docs/domain/financial-services.md`](docs/domain/financial-services.md) - Loan/Finance Referrals

**Operations & Scale Domains (Phase 6):**
- [`docs/domain/support.md`](docs/domain/support.md) - Customer Support & Dispute Resolution
- [`docs/domain/trust-safety.md`](docs/domain/trust-safety.md) - Platform Integrity
- [`docs/domain/ops.md`](docs/domain/ops.md) - Internal Admin & Partner Operations
- [`docs/domain/analytics.md`](docs/domain/analytics.md) - Measurement & Decision Support

**Supporting Domains:**
- [`docs/domain/marketing.md`](docs/domain/marketing.md) - Growth Loops & Lifecycle Campaigns

### Documentation Guidelines
- **Product Requirements Template**: See `.cursor/rules/product-agent.mdc` for PRD generation guidelines and standards
- **Domain Status**: All domains have status tracking in their Document Information section (Complete, Draft, In Progress, etc.)
- **Domain Relationships**: See `docs/domains.md` for critical dependencies and integration points between domains

### Usage Notes
- When implementing features, always reference the relevant domain PRD for functional requirements, acceptance criteria, and integration points
- Check domain status in `docs/domains.md` before starting work to understand current implementation phase
- Follow the guidelines in `.cursor/rules/product-agent.mdc` when updating or creating domain documentation


# Design System

## Typography
Typography of MySqrft library design system offers a comprehensive set of carefully designed text styles, ensuring consistency and readability across your application. From headings to body text, each typography element has been crafted with attention to font size, weight, and spacing. Values are extra_small, small, medium, large, extra_large, double_large, triple_large, and quadruple_large

## Size values

MySqrft UI offers predefined size options: extra_small, small, medium, large, extra_large which can be easily applied to components. In some components, we also offer larger sizes, such as double_large, triple_large, and quadruple_large.

These predefined values cover borders, text sizes, border radius, and other properties. For each element, you can refer to the documentation of the desired component to find the correct sizes for each property.


## Shadow Values
Mishka Chelekom offers predefined size options: extra_small, small, medium, large, extra_large which can be easily applied to components. In some components, we also offer larger sizes, such as double_large, triple_large, and quadruple_large.

## Font Weights
Font weight control in Mishka Chelekom is straightforward - simply add any Tailwind font weight class to your components by using font_weight prop to adjust text thickness. Available classes include font-text-thin, font-light, font-normal, font-medium, font-semibold, font-bold, and font-extrabold.
