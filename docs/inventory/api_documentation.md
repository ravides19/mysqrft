# Inventory Domain API Documentation

Complete API reference for the MySqrft Inventory domain, covering Properties and Listings contexts.

---

## Table of Contents

1. [Properties Context](#properties-context)
2. [Listings Context](#listings-context)
3. [Search Integration](#search-integration)
4. [Scoring & Analytics](#scoring--analytics)

---

## Properties Context

Module: `MySqrft.Properties`

### Property CRUD

#### `create_property/2`

Creates a new property.

**Parameters**:
- `owner` - `%Profile{}` - Property owner profile
- `attrs` - `map` - Property attributes

**Returns**: `{:ok, %Property{}}` | `{:error, %Ecto.Changeset{}}`

**Example**:
```elixir
{:ok, property} = Properties.create_property(owner, %{
  "type" => "apartment",
  "configuration" => %{
    "bhk" => 2,
    "bathrooms" => 2,
    "built_up_area" => 1200
  },
  "address_text" => "123 Main Street",
  "city_id" => city_id,
  "locality_id" => locality_id
})
```

---

#### `get_property!/1`

Gets a property by ID (raises if not found).

**Parameters**:
- `id` - `binary_id` - Property ID

**Returns**: `%Property{}`

**Raises**: `Ecto.NoResultsError`

---

#### `list_user_properties/1`

Lists all properties owned by a user.

**Parameters**:
- `user_id` - `binary_id` - User ID

**Returns**: `[%Property{}]`

---

#### `update_property/2`

Updates a property.

**Parameters**:
- `property` - `%Property{}`
- `attrs` - `map`

**Returns**: `{:ok, %Property{}}` | `{:error, %Ecto.Changeset{}}`

---

#### `delete_property/1`

Deletes a property.

**Parameters**:
- `property` - `%Property{}`

**Returns**: `{:ok, %Property{}}` | `{:error, %Ecto.Changeset{}}`

---

### Property Documents

#### `create_property_document/2`

Uploads a document for a property.

**Parameters**:
- `property` - `%Property{}`
- `attrs` - `map` with keys:
  - `document_type` - string (required): "sale_deed", "property_tax", "electricity_bill", etc.
  - `s3_key` - string (required): S3 object key
  - `file_name` - string (optional): Original filename

**Returns**: `{:ok, %PropertyDocument{}}` | `{:error, %Ecto.Changeset{}}`

**Example**:
```elixir
{:ok, document} = Properties.create_property_document(property, %{
  "document_type" => "sale_deed",
  "s3_key" => "documents/property_123/sale_deed.pdf",
  "file_name" => "sale_deed.pdf"
})
```

---

#### `verify_document/2`

Verifies a property document (admin only).

**Parameters**:
- `document` - `%PropertyDocument{}`
- `verifier_id` - `binary_id` - ID of admin verifying

**Returns**: `{:ok, %PropertyDocument{}}` | `{:error, %Ecto.Changeset{}}`

**Side Effects**:
- May auto-verify property if ownership documents are verified

---

#### `reject_document/2`

Rejects a property document.

**Parameters**:
- `document` - `%PropertyDocument{}`
- `reason` - `string` - Rejection reason

**Returns**: `{:ok, %PropertyDocument{}}` | `{:error, %Ecto.Changeset{}}`

---

### Property Images

#### `create_property_image/2`

Uploads an image for a property.

**Parameters**:
- `property` - `%Property{}`
- `attrs` - `map` with keys:
  - `s3_key` - string (required)
  - `type` - string (optional): "exterior", "interior", "floor_plan", "site_plan"
  - `is_primary` - boolean (optional)
  - `caption` - string (optional)

**Returns**: `{:ok, %PropertyImage{}}` | `{:error, %Ecto.Changeset{}}`

---

#### `create_property_image_with_validation/2`

Creates image with 20-image limit validation.

**Parameters**: Same as `create_property_image/2`

**Returns**: `{:ok, %PropertyImage{}}` | `{:error, string}`

---

#### `get_property_media_stats/1`

Gets media statistics for a property.

**Parameters**:
- `property_id` - `binary_id`

**Returns**: `map` with keys:
- `total_images` - integer
- `images_by_type` - map
- `has_primary` - boolean
- `remaining_slots` - integer

---

### Quality & Scoring

#### `update_quality_scores/1`

Calculates and updates quality scores.

**Parameters**:
- `property` - `%Property{}`

**Returns**: `{:ok, %Property{}}`

**Updates**:
- `quality_score` (0-100)
- `data_completeness_score` (0-100)

---

### Duplicate Detection

#### `find_potential_duplicates/1`

Finds potential duplicate properties.

**Parameters**:
- `attrs` - `map` with keys:
  - `locality_id` - binary_id (required)
  - `address_text` - string (optional)
  - `type` - string (optional)
  - `location` - geometry (optional)

**Returns**: `[%{property: %Property{}, similarity_score: integer}]`

**Example**:
```elixir
duplicates = Properties.find_potential_duplicates(%{
  "locality_id" => locality_id,
  "address_text" => "123 Main Street",
  "type" => "apartment"
})
# Returns properties with similarity_score > 50
```

---

### Geography Integration

#### `validate_address_binding/1`

Validates city-locality relationship.

**Parameters**:
- `attrs` - `map` with `city_id` and `locality_id`

**Returns**: `:ok` | `{:error, string}`

---

## Listings Context

Module: `MySqrft.Listings`

### Listing CRUD

#### `create_listing/2`

Creates a new listing (draft state).

**Parameters**:
- `property` - `%Property{}`
- `attrs` - `map` with keys:
  - `transaction_type` - string (required): "rent" or "sale"
  - `ask_price` - string/Decimal (required)
  - `available_from` - Date (optional)
  - `tenant_preference` - string (optional)
  - `diet_preference` - string (optional)
  - `furnishing_status` - string (optional)
  - `security_deposit` - string/Decimal (optional, for rent)

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

**Example**:
```elixir
{:ok, listing} = Listings.create_listing(property, %{
  "transaction_type" => "rent",
  "ask_price" => "25000",
  "available_from" => ~D[2026-02-01],
  "tenant_preference" => "family",
  "diet_preference" => "vegetarian"
})
```

---

#### `get_listing!/1`

Gets a listing by ID.

**Parameters**:
- `id` - `binary_id`

**Returns**: `%Listing{}`

**Raises**: `Ecto.NoResultsError`

---

#### `list_listings/1`

Lists listings with optional filters.

**Parameters**:
- `opts` - keyword list with optional keys:
  - `:status` - string
  - `:transaction_type` - string
  - `:property_id` - binary_id

**Returns**: `[%Listing{}]`

**Example**:
```elixir
active_rent = Listings.list_listings(status: "active", transaction_type: "rent")
```

---

### State Transitions

#### `publish_listing/1`

Publishes a draft listing (draft → active).

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

**Effects**:
- Sets status to "active"
- Sets expires_at to 60 days from now
- Syncs to search index

**Constraints**:
- Only one active listing per property-transaction type

---

#### `pause_listing/1`

Pauses an active listing (active → paused).

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

---

#### `resume_listing/1`

Resumes a paused listing (paused → active).

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

---

#### `close_listing/2`

Closes a listing permanently.

**Parameters**:
- `listing` - `%Listing{}`
- `attrs` - `map` with keys:
  - `closure_reason` - string (required): "rented", "sold", "withdrawn", "other"
  - `final_price` - string/Decimal (optional)

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

**Effects**:
- Creates listing price history entry
- Creates property price history entry
- Removes from search index

---

#### `repost_listing/2`

Creates a new listing from a closed one.

**Parameters**:
- `closed_listing` - `%Listing{}`
- `attrs` - `map` (optional) - Can override ask_price

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

---

### Listing Management

#### `refresh_listing/1`

Refreshes a listing (extends expiry).

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

**Effects**:
- Extends expires_at by 60 days
- Updates last_refreshed_at
- Recalculates freshness score

**Frequency Limit**: Once every 7 days

---

#### `update_listing_price/2`

Updates listing price.

**Parameters**:
- `listing` - `%Listing{}`
- `new_price` - string/Decimal

**Returns**: `{:ok, %Listing{}}` | `{:error, %Ecto.Changeset{}}`

**Effects**:
- Creates price history entry
- Updates freshness score

---

#### `expire_stale_listings/0`

Auto-expires listings past expiry date (Oban job).

**Parameters**: None

**Returns**: `{:ok, count}` where count is number of expired listings

**Runs**: Daily via Oban cron

---

### Price History

#### `list_listing_price_history/1`

Gets price history for a listing.

**Parameters**:
- `listing_id` - `binary_id`

**Returns**: `[%ListingPriceHistory{}]`

---

#### `list_property_price_history/2`

Gets historical prices for a property.

**Parameters**:
- `property_id` - `binary_id`
- `transaction_type` - string

**Returns**: `[%PropertyPriceHistory{}]`

---

## Scoring & Analytics

### Freshness Scoring

#### `update_freshness_score/1`

Calculates and updates freshness score.

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}`

**Score Range**: 0-100

---

#### `is_fresh?/1`

Checks if listing is fresh (score >= 70).

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `boolean`

---

### Market Readiness Scoring

#### `update_market_readiness_score/1`

Calculates and updates market readiness score.

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}`

**Score Range**: 0-100

---

#### `is_market_ready?/1`

Checks if listing is market-ready (score >= 70).

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `boolean`

---

#### `get_improvement_suggestions/1`

Gets actionable improvement suggestions.

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `[string]` - List of suggestions

**Example**:
```elixir
suggestions = Listings.get_improvement_suggestions(listing)
# ["Upload ownership documents and get property verified",
#  "Add more property images (minimum 5 recommended)",
#  "Complete tenant and diet preferences"]
```

---

#### `update_all_scores/1`

Updates both freshness and market readiness scores.

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, %Listing{}}`

---

## Search Integration

### Search Sync

#### `sync_to_search/1`

Manually syncs a listing to search index.

**Parameters**:
- `listing` - `%Listing{}`

**Returns**: `{:ok, :synced}` | `{:ok, :skipped}`

---

#### `reindex_all_listings/0`

Re-indexes all active listings.

**Parameters**: None

**Returns**: `{:ok, %{success: integer, total: integer}}`

---

## Error Handling

All functions return either:
- `{:ok, result}` on success
- `{:error, %Ecto.Changeset{}}` on validation errors
- `{:error, reason}` on business logic errors

### Common Error Patterns

```elixir
case Listings.publish_listing(listing) do
  {:ok, published} ->
    # Success
    published

  {:error, %Ecto.Changeset{} = changeset} ->
    # Validation error
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)

  {:error, :invalid_transition} ->
    # Business logic error
    :invalid_state
end
```

---

## Best Practices

1. **Always preload associations** when needed:
   ```elixir
   property = Properties.get_property!(id) |> Repo.preload([:images, :documents])
   ```

2. **Use transactions** for multi-step operations:
   ```elixir
   Repo.transaction(fn ->
     {:ok, listing} = Listings.create_listing(property, attrs)
     {:ok, _} = Listings.update_all_scores(listing)
     {:ok, published} = Listings.publish_listing(listing)
     published
   end)
   ```

3. **Handle state transitions carefully**:
   - Check current state before transitions
   - Use specific transition functions
   - Don't update status directly

4. **Update scores after significant changes**:
   ```elixir
   {:ok, property} = Properties.update_property(property, attrs)
   {:ok, _} = Properties.update_quality_scores(property)
   ```

5. **Validate before publishing**:
   ```elixir
   suggestions = Listings.get_improvement_suggestions(listing)
   if Enum.empty?(suggestions) do
     Listings.publish_listing(listing)
   else
     # Show suggestions to user
   end
   ```

---

## Rate Limits & Constraints

| Operation | Limit | Enforcement |
|-----------|-------|-------------|
| Refresh listing | Once per 7 days | Soft (recommended) |
| Property images | 20 per property | Hard (enforced) |
| Active listings | 1 per property-transaction type | Hard (enforced) |
| Price updates | Unlimited | None |

---

## Webhooks & Events (Future)

Planned event hooks for external integrations:

- `listing.published` - When listing goes active
- `listing.closed` - When listing is closed
- `property.verified` - When property verification completes
- `price.changed` - When listing price changes

---

For more information, see:
- [Property Types Guide](./property_types_guide.md)
- [Listing Lifecycle Guide](./listing_lifecycle_guide.md)
