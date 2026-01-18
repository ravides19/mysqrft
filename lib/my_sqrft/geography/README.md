# Geography Domain - Ola Maps Integration

## Overview

The Geography domain now supports Ola Maps Geocoding API as an external service provider for geocoding and reverse geocoding operations.

## Configuration

### 1. Get API Key

1. Sign up at [Ola Maps Developer Portal](https://maps.olakrutrim.com)
2. Get your API key from the dashboard
3. Set the API key as an environment variable:

```bash
export OLA_MAPS_API_KEY="your-api-key-here"
```

Or configure it in `config/config.exs` or `config/runtime.exs`:

```elixir
config :my_sqrft, :ola_maps_api_key, "your-api-key-here"
```

### 2. Enable/Disable Ola Maps

Control whether Ola Maps is used as a fallback:

```elixir
# In config/config.exs or config/runtime.exs
config :my_sqrft, :ola_maps_enabled, true  # or false to disable
```

## How It Works

The geocoding system uses a **fallback strategy**:

1. **Internal Geocoding (Primary)**
   - Tries pincode-based geocoding first
   - Falls back to locality name matching
   - Uses your internal database

2. **Ola Maps (Fallback)**
   - Only used if internal geocoding fails
   - Only used if `ola_maps_enabled` is `true`
   - Requires valid API key

## Usage

### Geocoding

```elixir
# This will try internal geocoding first, then Ola Maps if needed
MySqrft.Geography.geocode_address("123 Main St, Koramangala, Bangalore")
# => {:ok, %{latitude: ..., longitude: ..., ...}}
```

### Reverse Geocoding

```elixir
# This will try internal reverse geocoding first, then Ola Maps if needed
MySqrft.Geography.reverse_geocode(12.9352, 77.6245)
# => {:ok, %{formatted_address: "Koramangala, Bangalore", ...}}
```

## Caching

All geocoding results (both internal and Ola Maps) are cached in the database for **90 days** to:
- Reduce API calls
- Improve performance
- Stay within rate limits

## Data Persistence

Ola Maps geocoding results are automatically persisted to the database for frequently used items, including the complete geographic hierarchy:

### Geographic Hierarchy Persistence

When Ola Maps returns geocoding results, the system automatically extracts and persists:

1. **Country**: Creates or updates country records from `country` and `country_code` fields
2. **State**: Creates or updates state records from `state` and `state_code` fields (linked to country)
3. **City**: Creates or updates city records from `city` field (linked to state) with coordinates
4. **Locality**: Creates or updates locality records with coordinates
5. **Pincode**: Creates or updates pincode records linked to localities

### Persistence Logic

- **Locality Updates**: If a geocoding result matches an existing locality (within 1km), the coordinates are updated if missing or significantly different (>500m)
- **New Locality Creation**: If no matching locality exists, a new locality entry is created from the Ola Maps result
- **Hierarchy Building**: The complete hierarchy (country → state → city → locality → pincode) is built automatically from API responses
- **Smart Matching**: The system uses spatial queries to find nearest localities and avoids duplicates
- **Coordinate Updates**: Missing coordinates are filled in from Ola Maps results

### Address Component Extraction

The system extracts structured address components from Ola Maps API responses:
- Country name and code
- State name and code  
- City name
- Locality/neighborhood name
- Pincode/postal code
- Street name and number (stored in metadata)

This helps build your internal geographic database over time, reducing dependency on external APIs for frequently accessed locations. The database grows organically as users geocode addresses, creating a comprehensive geographic reference system.

## Rate Limits

Ola Maps provides:
- **Free tier**: 500,000 API calls per month
- **Rate limiting**: 429 responses if limits exceeded
- **Pricing**: ₹0.015 per call after free tier

The system handles rate limit errors gracefully and logs warnings.

## Error Handling

The integration handles:
- API key not configured → returns `{:error, :api_key_not_configured}`
- Rate limit exceeded → returns `{:error, :rate_limit_exceeded}`
- API errors → returns `{:error, {:api_error, status}}`
- Network failures → returns `{:error, :request_failed}`

## Documentation

- [Ola Maps Geocoding API](https://maps.olakrutrim.com/docs/geocoding/geocoding-api)
- [Ola Maps Pricing](https://maps.olakrutrim.com/pricing)
