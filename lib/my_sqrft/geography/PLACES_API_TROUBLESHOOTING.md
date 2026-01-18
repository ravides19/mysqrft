# Places API Troubleshooting Guide

## Implementation Status: ✅ Updated to Match API Spec

The Places API integration has been updated to match the OLA Maps API specification.

## API Documentation

The OLA Maps Places API documentation confirms these APIs exist:
- ✅ [Autocomplete API](https://maps.olakrutrim.com/docs/places-apis/autocomplete-api)
- ✅ [Place Details API](https://maps.olakrutrim.com/docs/places-apis/place-details)
- ✅ [Advanced Place Details API](https://maps.olakrutrim.com/docs/places-apis/placedetails-advanced)
- ✅ [Nearby Search API](https://maps.olakrutrim.com/docs/places-apis/nearby-search)
- ✅ [Advanced Nearby Search API](https://maps.olakrutrim.com/docs/places-apis/nearbysearch-advanced)
- ✅ [Text Search API](https://maps.olakrutrim.com/docs/places-apis/text-search)

**API Reference:** https://maps.olakrutrim.com/apidocs#tag/places-apis

## Current Implementation

All Places APIs now use **POST** requests with Bearer token authentication (same as geocoding):

```
Base URL: https://maps.olakrutrim.com/api/v1
- POST /places/autocomplete (JSON body)
- POST /places/details (JSON body)
- POST /places/nearby-search (JSON body)
- POST /places/text-search (JSON body)
```

**Authentication:** Bearer token in `Authorization` header (same as geocoding endpoints)

## Recent Changes

### Updated Implementation (Per API Spec)

The following changes were made to align with the OLA Maps Places API specification:

1. **Base URL**: Changed from `https://api.olamaps.io` to `https://maps.olakrutrim.com/api/v1` (same as geocoding)
2. **HTTP Method**: Changed from GET with query parameters to POST with JSON body (same as geocoding)
3. **Authentication**: Uses Bearer token in `Authorization` header (consistent with geocoding)
4. **Endpoint Paths**: Updated to `/places/autocomplete`, `/places/details`, etc. (without `/v1/` since it's in base URL)
5. **Request Body**: Parameters are sent as JSON body fields (not query parameters)

### Code Changes

- All Places API methods now use `make_request/4` (same function as geocoding)
- Helper functions updated from `maybe_add_*_to_params` to `maybe_add_*_to_body`
- Location biasing now uses `latitude`/`longitude` fields in JSON body (not comma-separated string)
- Types now sent as JSON array (not comma-separated string)

## Potential Issues

### API Key Permissions

The API key must have Places API permissions enabled.

**To check:** Log into OLA Maps developer portal and verify:
- Places API is enabled for your API key
- Your subscription/plan includes Places API access

## Testing Steps

### Step 1: Enable Debug Logging

```elixir
# In IEx
Logger.configure(level: :debug)

# Test autocomplete
alias MySqrft.Geography.Places
Places.autocomplete("Kora")
```

Check the logs to see the exact URL being called.

### Step 2: Test with curl (Manual Verification)

Try different endpoint variations with curl:

```bash
# Test current endpoint
curl -X POST https://maps.olakrutrim.com/api/v1/places/autocomplete \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input":"Kora","language":"en"}'

# Test without /places/ prefix
curl -X POST https://maps.olakrutrim.com/api/v1/autocomplete \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input":"Kora","language":"en"}'

# Test with GET (if API uses GET)
curl -X GET "https://maps.olakrutrim.com/api/v1/places/autocomplete?input=Kora&language=en" \
  -H "Authorization: Bearer YOUR_API_KEY"
```

### Step 3: Check API Reference Documentation

The overview pages don't show exact URLs. Check the **API Reference** section:

1. Visit https://maps.olakrutrim.com/docs or https://developer.olamaps.io
2. Navigate to "API References" → "Places APIs"
3. Look for the actual endpoint URLs and request formats
4. Compare with our implementation

### Step 4: Contact OLA Maps Support

If the API reference isn't publicly available, contact OLA Maps support:
- Support page: https://maps.olakrutrim.com/support
- Check if Places API documentation is available in the developer portal

## Temporary Workaround

Until we confirm the correct endpoints, you can:

1. **Disable Places API** in config:
   ```elixir
   config :my_sqrft, :ola_maps_enabled, false
   ```

2. **Handle gracefully** - The code already returns `{:error, :endpoint_not_found}` which you can handle in your application.

3. **Use geocoding as fallback** - For place searches, you could use geocoding with address strings as a workaround.

## Next Steps

1. ✅ Check API reference documentation for exact endpoint URLs
2. ✅ Test different endpoint path variations with curl
3. ✅ Verify API key has Places API permissions
4. ✅ Try GET requests instead of POST if applicable
5. ✅ Contact OLA Maps support if documentation is unclear

## Related Documentation

- [Autocomplete API Overview](https://maps.olakrutrim.com/docs/places-apis/autocomplete-api)
- [Place Details API Overview](https://maps.olakrutrim.com/docs/places-apis/place-details)
- [Advanced Place Details API Overview](https://maps.olakrutrim.com/docs/places-apis/placedetails-advanced)
- [Nearby Search API Overview](https://maps.olakrutrim.com/docs/places-apis/nearby-search)
- [Advanced Nearby Search API Overview](https://maps.olakrutrim.com/docs/places-apis/nearbysearch-advanced)
