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
- [`docs/domain/001_auth.md`](docs/domain/001_auth.md) - 001. Authentication & Identity Proof
- [`docs/domain/002_kyc.md`](docs/domain/002_kyc.md) - 002. User Identity Verification & Compliance
- [`docs/domain/003_user-management.md`](docs/domain/003_user-management.md) - 003. Profiles, Roles & Lifecycle
- [`docs/domain/004_authorization.md`](docs/domain/004_authorization.md) - 004. Access Control Everywhere
- [`docs/domain/005_inventory.md`](docs/domain/005_inventory.md) - 005. Property Supply & Lifecycle
- [`docs/domain/006_search.md`](docs/domain/006_search.md) - 006. Discovery Experience
- [`docs/domain/007_leads.md`](docs/domain/007_leads.md) - 007. Direct Connect & Lead Lifecycle
- [`docs/domain/008_communications.md`](docs/domain/008_communications.md) - 008. Messaging, Calling & Notifications

**Monetization Domains (Phase 2):**
- [`docs/domain/009_entitlements.md`](docs/domain/009_entitlements.md) - 009. Plan-Based Access Control
- [`docs/domain/010_billing.md`](docs/domain/010_billing.md) - 010. Money Movement & Invoices
- [`docs/domain/011_sales.md`](docs/domain/011_sales.md) - 011. Monetization Conversion & Assisted Selling

**Assisted Sales Domains (Phase 3):**
- [`docs/domain/013_scheduling.md`](docs/domain/013_scheduling.md) - 013. Visits & Appointments
- [`docs/domain/014_crm.md`](docs/domain/014_crm.md) - 014. Relationship Management & Pipeline

**Service Expansion Domains (Phase 4):**
- [`docs/domain/015_legal-docs.md`](docs/domain/015_legal-docs.md) - 015. Rental Agreement & Documentation
- [`docs/domain/016_home-services.md`](docs/domain/016_home-services.md) - 016. Movers/Painting/Cleaning & Fulfillment
- [`docs/domain/017_property-management.md`](docs/domain/017_property-management.md) - 017. Recurring Owner Services

**Platform Expansion Domains (Phase 5):**
- [`docs/domain/018_society.md`](docs/domain/018_society.md) - 018. Community Management SaaS
- [`docs/domain/019_financial-services.md`](docs/domain/019_financial-services.md) - 019. Loan/Finance Referrals

**Operations & Scale Domains (Phase 6):**
- [`docs/domain/020_support.md`](docs/domain/020_support.md) - 020. Customer Support & Dispute Resolution
- [`docs/domain/021_trust-safety.md`](docs/domain/021_trust-safety.md) - 021. Platform Integrity
- [`docs/domain/022_ops.md`](docs/domain/022_ops.md) - 022. Internal Admin & Partner Operations
- [`docs/domain/023_analytics.md`](docs/domain/023_analytics.md) - 023. Measurement & Decision Support

**Supporting Domains:**
- [`docs/domain/012_marketing.md`](docs/domain/012_marketing.md) - 012. Growth Loops & Lifecycle Campaigns

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
