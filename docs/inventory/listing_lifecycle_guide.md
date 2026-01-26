# Listing Lifecycle Guide

This guide documents the complete lifecycle of a listing in the MySqrft Inventory domain, including state transitions, business rules, and best practices.

---

## Listing States

A listing can be in one of the following states:

| State | Description | Can Transition To |
|-------|-------------|-------------------|
| `draft` | Initial state, not visible to public | `active` |
| `active` | Published and visible to public | `paused`, `expired`, `closed` |
| `paused` | Temporarily hidden from public | `active`, `closed` |
| `expired` | Auto-expired due to inactivity | `active` (via refresh) |
| `closed` | Permanently closed (rented/sold) | N/A (can repost as new listing) |

---

## State Machine Diagram

```
┌─────────┐
│  draft  │
└────┬────┘
     │ publish
     ▼
┌─────────┐     pause      ┌────────┐
│ active  │◄──────────────►│ paused │
└────┬────┘                └────┬───┘
     │                          │
     │ auto-expire              │ close
     ▼                          ▼
┌─────────┐                ┌────────┐
│ expired │                │ closed │
└────┬────┘                └────────┘
     │ refresh                  │
     └──────────────────────────┘ repost (creates new draft)
```

---

## Lifecycle Phases

### Phase 1: Creation (Draft)

**Function**: `Listings.create_listing/2`

```elixir
{:ok, listing} = Listings.create_listing(property, %{
  "transaction_type" => "rent",  # or "sale"
  "ask_price" => "25000",
  "available_from" => ~D[2026-02-01],
  "tenant_preference" => "family",
  "diet_preference" => "vegetarian",
  "furnishing_status" => "semi_furnished"
})
```

**State**: `draft`
**Visibility**: Private (owner only)
**Expiry**: None

**Business Rules**:
- Must have a property
- Must specify transaction type (rent/sale)
- Must have ask_price
- Can have multiple draft listings per property

---

### Phase 2: Publishing (Active)

**Function**: `Listings.publish_listing/1`

```elixir
{:ok, published} = Listings.publish_listing(listing)
```

**State**: `draft` → `active`
**Visibility**: Public
**Expiry**: Set to 60 days from now

**Business Rules**:
- ✅ Only one active listing per property-transaction type
- ✅ Sets `expires_at` to 60 days from now
- ✅ Calculates freshness and market readiness scores
- ✅ Syncs to search index (if configured)

**Validation Checks**:
- Property must exist
- Required fields must be filled
- No other active listing for same property-transaction type

---

### Phase 3: Management (Active State)

#### 3a. Pause Listing

**Function**: `Listings.pause_listing/1`

```elixir
{:ok, paused} = Listings.pause_listing(listing)
```

**State**: `active` → `paused`
**Visibility**: Hidden from public
**Expiry**: Preserved

**Use Cases**:
- Temporarily unavailable
- Under renovation
- Negotiating with potential tenant/buyer

---

#### 3b. Resume Listing

**Function**: `Listings.resume_listing/1`

```elixir
{:ok, resumed} = Listings.resume_listing(paused_listing)
```

**State**: `paused` → `active`
**Visibility**: Public again
**Expiry**: Preserved

---

#### 3c. Refresh Listing

**Function**: `Listings.refresh_listing/1`

```elixir
{:ok, refreshed} = Listings.refresh_listing(listing)
```

**State**: Remains `active` or `expired` → `active`
**Effect**:
- ✅ Extends `expires_at` by 60 days
- ✅ Updates `last_refreshed_at`
- ✅ Recalculates freshness score
- ✅ Boosts search ranking

**Frequency**: Can be done once every 7 days

---

#### 3d. Update Price

**Function**: `Listings.update_listing_price/2`

```elixir
{:ok, updated} = Listings.update_listing_price(listing, "26000")
```

**Effect**:
- ✅ Updates `ask_price`
- ✅ Creates price history entry
- ✅ Updates freshness score
- ✅ Syncs to search index

---

### Phase 4: Auto-Expiry (Expired)

**Function**: `Listings.expire_stale_listings/0` (runs daily via Oban)

**State**: `active` → `expired`
**Trigger**: `expires_at` < current time
**Visibility**: Hidden from public

**Recovery**:
```elixir
{:ok, refreshed} = Listings.refresh_listing(expired_listing)
```

---

### Phase 5: Closure (Closed)

**Function**: `Listings.close_listing/2`

```elixir
{:ok, closed} = Listings.close_listing(listing, %{
  "closure_reason" => "rented",  # or "sold", "withdrawn", "other"
  "final_price" => "24000"       # optional
})
```

**State**: `active`/`paused` → `closed`
**Visibility**: Archived
**Expiry**: Cleared

**Effects**:
- ✅ Creates listing price history entry
- ✅ Creates property price history entry
- ✅ Removes from search index
- ✅ Cannot be reopened (must repost)

**Closure Reasons**:
- `rented`: Successfully rented
- `sold`: Successfully sold
- `withdrawn`: Owner withdrew listing
- `other`: Other reason

---

### Phase 6: Reposting

**Function**: `Listings.repost_listing/2`

```elixir
{:ok, new_listing} = Listings.repost_listing(closed_listing, %{
  "ask_price" => "26000"  # optional, can change price
})
```

**State**: Creates new `draft` listing
**Effect**:
- ✅ Copies all details from closed listing
- ✅ Allows price update
- ✅ Resets all timestamps
- ✅ New listing ID

---

## Price History Tracking

### Listing-Level Price History

Tracks price changes within a single listing:

```elixir
history = Listings.list_listing_price_history(listing_id)
# Returns: [%ListingPriceHistory{old_price, new_price, changed_at}, ...]
```

### Property-Level Price History

Tracks historical prices across all listings for a property:

```elixir
history = Listings.list_property_price_history(property_id, "rent")
# Returns: [%PropertyPriceHistory{ask_price, final_price, listing_id}, ...]
```

**Use Cases**:
- Market trend analysis
- Price recommendations
- Owner insights

---

## Scoring Systems

### Freshness Score (0-100)

Calculated automatically, factors:
- Time since creation (40 points)
- Time since last refresh (30 points)
- Time until expiry (20 points)
- Recent activity (10 points)

```elixir
{:ok, listing} = Listings.update_freshness_score(listing)
is_fresh = Listings.is_fresh?(listing)  # true if score >= 70
```

### Market Readiness Score (0-100)

Calculated automatically, factors:
- Property quality (30 points)
- Listing completeness (25 points)
- Pricing competitiveness (25 points)
- Owner trust (20 points)

```elixir
{:ok, listing} = Listings.update_market_readiness_score(listing)
is_ready = Listings.is_market_ready?(listing)  # true if score >= 70
suggestions = Listings.get_improvement_suggestions(listing)
```

---

## Best Practices

### For Property Owners

1. **Complete all fields** before publishing
2. **Upload quality images** (minimum 5)
3. **Verify ownership** documents for better trust score
4. **Refresh regularly** (every 2-3 weeks) to maintain visibility
5. **Update price** based on market feedback
6. **Close promptly** when rented/sold to maintain accurate analytics

### For Administrators

1. **Monitor expired listings** and remind owners to refresh
2. **Review price history** for market insights
3. **Verify documents** promptly to improve property trust scores
4. **Track closure reasons** for business intelligence

### For Developers

1. **Always use state transition functions** (don't update status directly)
2. **Handle errors gracefully** (state transitions can fail)
3. **Update scores** after significant changes
4. **Sync to search** after state changes
5. **Test state machine** thoroughly

---

## Common Workflows

### Workflow 1: New Listing to Rental

```elixir
# 1. Create listing
{:ok, listing} = Listings.create_listing(property, attrs)

# 2. Update scores
{:ok, listing} = Listings.update_all_scores(listing)

# 3. Publish
{:ok, active} = Listings.publish_listing(listing)

# 4. Refresh periodically (every 2 weeks)
{:ok, refreshed} = Listings.refresh_listing(active)

# 5. Close when rented
{:ok, closed} = Listings.close_listing(refreshed, %{
  "closure_reason" => "rented",
  "final_price" => "24000"
})
```

### Workflow 2: Price Negotiation

```elixir
# 1. Start with initial price
{:ok, listing} = Listings.create_listing(property, %{"ask_price" => "30000"})
{:ok, active} = Listings.publish_listing(listing)

# 2. Reduce price after feedback
{:ok, updated} = Listings.update_listing_price(active, "28000")

# 3. Further reduction
{:ok, updated} = Listings.update_listing_price(updated, "26000")

# 4. Close at negotiated price
{:ok, closed} = Listings.close_listing(updated, %{
  "closure_reason" => "rented",
  "final_price" => "25500"
})

# 5. View price history
history = Listings.list_listing_price_history(listing.id)
# Shows: 30000 → 28000 → 26000 → 25500 (final)
```

### Workflow 3: Seasonal Availability

```elixir
# 1. Publish for summer season
{:ok, active} = Listings.publish_listing(listing)

# 2. Pause during winter
{:ok, paused} = Listings.pause_listing(active)

# 3. Resume for next summer
{:ok, resumed} = Listings.resume_listing(paused)
```

---

## Error Handling

Common errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| `invalid_transition` | Invalid state transition | Check current state, use correct function |
| `unique_constraint` | Duplicate active listing | Close/pause existing listing first |
| `validation_error` | Missing required fields | Fill all required fields before publishing |
| `expired_listing` | Listing expired | Use `refresh_listing/1` to reactivate |

---

## Monitoring & Analytics

### Key Metrics

```elixir
# Active listings count
active_count = Listings.count_listings_by_status("active")

# Expiring soon (< 7 days)
expiring_soon = Listings.list_expiring_listings(7)

# Average time to close
avg_days = Listings.calculate_average_days_to_close("rent")

# Price trends
trends = Listings.get_price_trends(property_id, "rent")
```

### Oban Jobs

- **Daily**: `ExpireStaleListingsWorker` - Auto-expires listings
- **Weekly** (optional): `UpdateScoresWorker` - Bulk update scores
- **Daily** (optional): `SendExpiryRemindersWorker` - Notify owners

---

## API Reference

See [API Documentation](./api_documentation.md) for detailed function signatures and examples.
