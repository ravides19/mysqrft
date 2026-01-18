# Map Provider Abstraction Layer

## Overview

The Geography domain now includes an abstract `MapProvider` behaviour that allows easy switching between map service providers (Ola Maps, Google Maps, Mapbox, etc.) without changing application code.

## Architecture

### MapProvider Behaviour

The `MapProvider` behaviour (`lib/my_sqrft/geography/map_provider.ex`) defines a contract for:

- **Geocoding**: Address → Coordinates
- **Reverse Geocoding**: Coordinates → Address
- **Places APIs**:
  - Autocomplete suggestions
  - Place details by place_id
  - Nearby place search
  - Text-based place search

All methods support multilingual responses via the `language` parameter (ISO 639-1 code).

### Provider Implementations

- **OlaMapsProvider** (`lib/my_sqrft/geography/providers/ola_maps_provider.ex`): Ola Maps implementation

Future providers can be added by implementing the `MapProvider` behaviour:
- GoogleMapsProvider
- MapboxProvider
- etc.

### High-Level Phoenix Contexts (Public API)

**Other contexts should call these contexts, not MapProvider directly.**

- **Geography** (`lib/my_sqrft/geography.ex`): 
  - Geocoding and reverse geocoding
  - Geographic hierarchy management
  - Location-based search and filtering
  - Handles provider abstraction internally

- **Geography.Places** (`lib/my_sqrft/geography/places.ex`): 
  - Places API functions (autocomplete, details, nearby, text search)
  - Handles provider abstraction internally

### Internal Abstraction Layer

- **MapProvider** (`lib/my_sqrft/geography/map_provider.ex`): 
  - Behaviour contract for providers
  - Internal function `get_provider/0` used by Geography contexts
  - **Not meant to be called directly by other contexts**

- **Providers** (`lib/my_sqrft/geography/providers/`):
  - Concrete provider implementations (OlaMapsProvider, etc.)
  - **Not meant to be called directly by other contexts**

## Configuration

### Setting Map Provider

Configure which provider to use in `config/config.exs` or `config/runtime.exs`:

```elixir
config :my_sqrft, :map_provider, :ola_maps  # or :google_maps, :mapbox, etc.
```

### Provider-Specific Configuration

Each provider may have its own configuration. For Ola Maps:

```elixir
# Enable/disable provider
config :my_sqrft, :ola_maps_enabled, true

# API key (from environment variable or config)
config :my_sqrft, :ola_maps_api_key, System.get_env("OLA_MAPS_API_KEY")
```

Or set via environment variable:

```bash
export OLA_MAPS_API_KEY="your-api-key-here"
```

## Usage

### Geocoding

```elixir
# Use Geography context - this is the recommended approach for all contexts
alias MySqrft.Geography

# English
{:ok, result} = Geography.geocode_address("Koramangala, Bangalore")

# Hindi
{:ok, result} = Geography.geocode_address("कोरमंगला, बैंगलोर", language: "hi")
```

**Note:** Other contexts should call `Geography.geocode_address/1` and `Geography.geocode_address/2`.
The Geography context handles provider abstraction internally, so you don't need to worry about which provider is configured.

### Reverse Geocoding

```elixir
# Using Geography context
{:ok, result} = Geography.reverse_geocode(12.9352, 77.6245, language: "hi")
```

### Places API - Autocomplete

```elixir
alias MySqrft.Geography.Places

# Basic autocomplete
{:ok, suggestions} = Places.autocomplete("Kora")

# With location bias
{:ok, suggestions} = Places.autocomplete("Rest", 
  location: {12.9716, 77.5946}, 
  radius: 5000,
  language: "hi"
)

# With type filtering
{:ok, suggestions} = Places.autocomplete("Kora",
  types: ["locality", "establishment"],
  language: "en"
)
```

### Places API - Place Details

```elixir
# Get place details
{:ok, details} = Places.get_details("place_id_123", language: "hi")

# Extract information
place_id = details.place_id
name = details.name
location = details.location
address = details.formatted_address
```

### Places API - Nearby Search

```elixir
# Search nearby restaurants
{:ok, places} = Places.nearby_search(12.9716, 77.5946,
  type: "restaurant",
  radius: 1000,
  language: "en"
)

# Search with keyword
{:ok, places} = Places.nearby_search(12.9716, 77.5946,
  keyword: "pizza",
  radius: 2000,
  rankby: "distance"
)
```

### Places API - Text Search

```elixir
# Text-based search
{:ok, places} = Places.text_search("restaurants in Koramangala", language: "en")

# With location bias
{:ok, places} = Places.text_search("रैस्टोरेंट",
  location: {12.9716, 77.5946},
  radius: 5000,
  language: "hi"
)
```

## Language Support

All APIs support multilingual responses. Pass the `language` option with an ISO 639-1 code:

- `"en"` - English (default)
- `"hi"` - Hindi
- `"ta"` - Tamil
- `"te"` - Telugu
- `"kn"` - Kannada
- `"mr"` - Marathi
- `"bn"` - Bengali
- And other supported languages

Example:

```elixir
# English response
{:ok, result} = Places.autocomplete("Kora", language: "en")

# Hindi response
{:ok, result} = Places.autocomplete("कोर", language: "hi")
```

## Adding a New Provider

To add a new map provider:

1. **Create provider module** in `lib/my_sqrft/geography/providers/`:

```elixir
defmodule MySqrft.Geography.Providers.GoogleMapsProvider do
  @behaviour MySqrft.Geography.MapProvider

  @impl true
  def geocode(address, opts \\ []) do
    # Implementation
  end

  @impl true
  def reverse_geocode(latitude, longitude, opts \\ []) do
    # Implementation
  end

  @impl true
  def autocomplete(input, opts \\ []) do
    # Implementation
  end

  @impl true
  def get_place_details(place_id, opts \\ []) do
    # Implementation
  end

  @impl true
  def nearby_search(latitude, longitude, opts \\ []) do
    # Implementation
  end

  @impl true
  def text_search(query, opts \\ []) do
    # Implementation
  end
end
```

2. **Update MapProvider.get_provider/0** to include the new provider:

```elixir
def get_provider do
  provider_name = Application.get_env(:my_sqrft, :map_provider, :ola_maps)

  case provider_name do
    :ola_maps -> MySqrft.Geography.Providers.OlaMapsProvider
    :google_maps -> MySqrft.Geography.Providers.GoogleMapsProvider  # New provider
    _ ->
      raise ArgumentError, "Unknown map provider: #{provider_name}"
  end
end
```

3. **Configure** the new provider in config files.

## Architecture Pattern

This implementation follows the **Phoenix Context Pattern**:

1. **Public API**: `Geography` and `Geography.Places` contexts
   - These are what other contexts should call
   - They provide a clean, stable interface
   - Provider abstraction is handled internally

2. **Internal Abstraction**: `MapProvider` behaviour and provider modules
   - Used internally by Geography contexts
   - Not meant to be called directly by other contexts
   - Allows easy switching between providers via configuration

3. **Benefits**:
   - **Encapsulation**: Provider details are hidden from callers
   - **Testability**: Easy to mock Geography contexts in tests
   - **Flexibility**: Switch providers without changing callers
   - **Consistency**: All contexts follow the same pattern

## Migration from OlaMapsGeocoder

The old `OlaMapsGeocoder` module is still available for backward compatibility, but new code should use:

- **Geography context** for geocoding/reverse geocoding
- **Geography.Places context** for Places APIs
- **Do NOT call MapProvider.get_provider() directly** - use Geography contexts instead

## Error Handling

All provider methods return:

- `{:ok, result}` on success
- `{:error, reason}` on failure

Common error reasons:
- `:api_key_not_configured` - API key missing
- `:rate_limit_exceeded` - Rate limit hit
- `:invalid_response_format` - Invalid API response
- `:request_failed` - Network/request error
- `{:api_error, status_code}` - API returned error status

## Testing

When testing, you can:

1. **Mock the provider** by setting a test provider in config
2. **Use dependency injection** by passing a provider module
3. **Mock external requests** using libraries like `Mox` or `ExVCR`

Example test configuration:

```elixir
# config/test.exs
config :my_sqrft, :map_provider, MySqrft.Geography.Providers.MockProvider
```
