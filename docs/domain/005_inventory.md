# Inventory Domain - Product Requirements Document

## Document Information

| Field | Value |
|-------|-------|
| Domain | Inventory |
| Version | 2.0 |
| Status | Approved |
| Last Updated | 2026-01-25 |
| Owner | Product Team |

---

## 1. Overview

### 1.1 Purpose

The Inventory domain is the core supply engine of the MySqrft marketplace. It manages the two fundamental entities of real estate supply: **Properties** (the persistent physical assets) and **Listings** (the temporal market intent). 

By decoupling the physical property from the transaction (Posting/Listing), we enable a lifecycle where a property is created once (verified, photographed, mapped) and can be listed multiple times over its lifetime (e.g., for rent every year) without re-entering static data. This architecture ensures higher data quality, stickier owner retention, and a streamlined "re-list" experience.

### 1.2 Scope

This PRD covers two main sub-domains:

1.  **Property Management (Asset Layer)**
    *   Creation/Management of physical assets (Apartments, Villas, etc.)
    *   Integration with **Geography** for precise location binding.
    *   Media Vault (storing high-quality master images).
    *   Asset Verification (Ownership/Physical existence).

2.  **Listing Management (Market Layer)**
    *   Creation of "Postings" (Rent/Sale/Lease) linked to a Property.
    *   Listing Lifecycle (Active, Paused, Expired, Archived).
    *   Market-specific attributes (Price, Availability Date, Tenant Preferences).
    *   Quality Scoring & Freshness rules.

### 1.3 Goals & Objectives

*   **Asset Reusability**: Enable owners to define a property once and create multiple listings over time.
*   **Data Quality**: Maintain a "Golden Record" of the property validated against the Geography domain.
*   **Marketplace Liquidity**: Ensure listings are fresh, verified, and active.
*   **Owner Retention**: Reduce friction for returning owners by retaining their property data.

---

## 2. Key Features

### 2.1 Property Management (The Asset)

*   **Property Repository**: A persistent database of physical assets owned by a user.
*   **Property Types**: Support for distinct schemas:
    *   **Residential**: Apartment, Independent House/Villa, Builder Floor, Studio.
    *   **Commercial**: Office Space, Shop/Showroom, Co-working, Warehouse.
    *   **Land**: Plot/Land.
    *   **Managed**: PG/Co-living (Hostel).
*   **Geography Integration**: Deep binding with Domain 024 (Geography):
    *   City/Locality selection from governed hierarchy.
    *   Map-pin precision (Lat/Long).
    *   Address normalization.
*   **Media Vault**: Permanent storage of property photos/videos/floor-plans associated with the Asset, not just the Listing.
*   **Ownership Proof**: Secure upload and verification of ownership documents (Electricity Bill, Property Tax, Sale Deed).

### 2.2 Listing Management (The Posting)

*   **Transaction Modes**: Support for:
    *   **Rent**: Residential/Commercial rental.
    *   **Resale**: Selling a property.
    *   **PG/Co-living**: Per-bed/room inventory.
*   **One-Click Post**: Generate a new listing from an existing Property asset.
*   **Lifecycle Engine**:
    *   **Draft**: Work in progress.
    *   **Pending Review**: Verification in progress.
    *   **Active**: Live on marketplace.
    *   **Paused**: Temporarily hidden (e.g., painting in progress).
    *   **Expired**: Auto-expiry after inactivity (configurable, e.g., 60 days).
    *   **Closed**: Successfully Rented/Sold.
*   **Listing Attributes**: Temporal data like Ask Price, Diet Preference (Veg/Non-veg), Tenant Type (Family/Bachelor), Available From Date.

### 2.3 Quality & Freshness

*   **Golden Record Scoring**: Scoring the *Property* data quality (completeness of specs, media).
*   **Market Readiness Score**: Scoring the *Listing* attractiveness (competitive price, freshness).
*   **Duplicate Detection**:
    *   **Asset Level**: Preventing multiple Asset entries for the same physical unit.
    *   **Listing Level**: Preventing multiple active listings for the same Asset.

---

## 3. User Stories

| ID | Persona | Story | Benefit |
|----|---------|-------|---------|
| US-1 | Property Owner | As an Owner, I want to create a "Property Profile" for my apartment once. | I don't have to re-enter details like floor plan, amenities, and location when I rent it out again next year. |
| US-2 | Property Owner | As an Owner, I want to "Post for Rent" using my existing Property Profile. | I can launch a listing in seconds by just updating the expected Rent and Availability Date. |
| US-3 | Property Owner | As an Owner, I want to manage multiple properties in my portfolio. | I have a single dashboard to view all my assets and their current listing status (Rented, Vacant, For Sale). |
| US-4 | Seeker | As a Seeker, I want to see verified location data for a property. | I know the location is accurate because it's validated against the platform's Geography database. |
| US-5 | Admin | As an Admin, I want to verify the Property Ownership independent of the Listing. | Once verified, the asset remains "Verified" for future listings, reducing operational verification costs. |
| US-6 | Broker | As a Broker, I want to post multiple listings for different units in the same building. | I can structure inventory efficiently without creating duplicate building data. |

---

## 4. Acceptance Criteria

### 4.1 Property Creation
1.  **Geography Binding**: User MUST select City and Locality from the Geography domain service. Free text is not allowed for core location fields.
2.  **Asset Specifics**:
    *   If Type=Apartment: Must capture Project Name (Society), Floor, Total Floors, Configuration (BHK).
    *   If Type=Villa: Must capture Plot Area, Built-up Area, Land Facing.
3.  **Media**: User can upload up to 20 photos. System stores them against the `PropertyID`.

### 4.2 Posting a Listing
1.  **Selection**: User must select a valid `PropertyID` to create a `Listing`.
2.  **Validation**: A Property cannot have two *Active* listings of the same Transaction Type (e.g., cannot be "For Rent" twice simultaneously).
3.  **Expiry**: Listing MUST auto-expire after 60 days if not refreshed.
4.  **Price**: Listing MUST have a price > 0.

---

## 5. Functional Requirements

### FR1: Property Asset Management
*   **FR1.1**: System SHALL provide APIs to CRUD `Property` entities.
*   **FR1.2**: System SHALL enforce valid `geography_id` (Locality/City) linkage during Property creation.
*   **FR1.3**: System SHALL support polymorphism for Property Attributes based on `property_type` (JSONB or separate tables).

### FR2: Listing Lifecycle Management
*   **FR2.1**: System SHALL provide APIs to CRUD `Listing` entities linked to a parent `Property`.
*   **FR2.2**: System SHALL implement a State Machine for Listing Status (Draft->Review->Active->Paused->Expired->Closed).
*   **FR2.3**: System SHALL allow "Reposting" (Cloning) updates from a Closed listing to a new Active listing.

### FR3: Inventory Search & Indexing
*   **FR3.1**: System SHALL sync Active Listings + Property Details to the **Search** domain (Elasticsearch) in real-time.
*   **FR3.2**: System SHALL archive Closed listings but retain the viewing history for Analytics.

---

## 6. Non-Functional Requirements

### NFR1: Performance
*   **Listing Creation Latency**: < 500ms.
*   **Search Sync Latency**: < 2 seconds (Time from "Publish" to "Visible in Search").

### NFR2: Scalability
*   System SHALL support > 10 Million Property Assets.
*   System SHALL support > 50 Million Historical Listings.

### NFR3: Security
*   **Ownership Access**: Only the Creator (or Admin) can modify Property details.
*   **PII Protection**: Listing Contact Details (Owner Phone) detailed masking logic is handled by **Leads** domain, but Inventory must store generic contact preferences.

### NFR4: Data Integrity
*   **Geography**: Property location data must stay synchronized with Geography domain updates (e.g., if a Locality name changes).

---

## 7. Integration Points

*   **Geography (Domain 024)**:
    *   **In**: Address validation, Lat/Long binding, Locality Hierarchy.
*   **Search (Domain 006)**:
    *   **Out**: Publishing Listing Document (Property Data + Listing Data) for indexing.
*   **Leads (Domain 007)**:
    *   **Out**: Inventory provides the "Item" context for a Lead.
*   **UserManagement (Domain 003)**:
    *   **In**: Owner Profile verification status impacts Listing Trust Score.

---

## 8. Dependencies
*   **PostGIS**: For storing Property Coordinates.
*   **Tigris Object Storage**: For Media Vault storage (S3-compatible).
*   **Elasticsearch (via Search Domain)**: For querying inventory.

---

## 9. Success Metrics
*   **Inventory Utilization**: % of Properties with at least 1 Historical Listing.
*   **Re-list Rate**: % of Owners who create a 2nd listing using the same Property Asset.
*   **Data Completeness**: % of Properties with precise Geocodes.
