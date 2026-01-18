# IEx Test Commands for OLA Maps APIs
# Copy and paste these commands into IEx to test each API
#
# Start IEx with: iex -S mix

alias MySqrft.Geography.Providers.OlaMapsProvider
alias MySqrft.Geography.Places

# =============================================================================
# 1. REGULAR GEOCODING API (POST with Bearer token)
# =============================================================================
OlaMapsProvider.geocode("Koramangala, Bangalore", language: "en")

# =============================================================================
# 2. REGULAR REVERSE GEOCODING API (POST with Bearer token)
# =============================================================================
OlaMapsProvider.reverse_geocode(12.9352, 77.6245, language: "en")

# =============================================================================
# 3. PLACES API - AUTOCOMPLETE
# =============================================================================
OlaMapsProvider.autocomplete("kempegowda international airport",
  language: "hi",
  location: {12.931316595874005, 77.61649243443775},
  radius: 1000
)

# =============================================================================
# 4. PLACES API - PLACE DETAILS
# =============================================================================
OlaMapsProvider.get_place_details("ola-platform:5000039498427", language: "hi")

# =============================================================================
# 5. PLACES API - ADVANCED PLACE DETAILS
# =============================================================================
OlaMapsProvider.get_advanced_place_details("ola-platform:5000039498427", language: "hi")

# =============================================================================
# 6. PLACES API - NEARBY SEARCH
# =============================================================================
OlaMapsProvider.nearby_search(12.931316595874005, 77.61649243443775,
  language: "hi",
  radius: 10000,
  types: "cafe",
  rankby: "popular",
  limit: 5
)

# =============================================================================
# 7. PLACES API - ADVANCED NEARBY SEARCH
# =============================================================================
OlaMapsProvider.get_advanced_nearby_search(12.931316595874005, 77.61649243443775,
  language: "hi",
  radius: 10000,
  types: "cafe",
  rankby: "popular",
  limit: 5
)

# =============================================================================
# 8. PLACES API - TEXT SEARCH
# =============================================================================
OlaMapsProvider.text_search("McDonald's",
  language: "hi",
  location: {12.93538, 77.61545},
  radius: 5000,
  size: 5
)

# =============================================================================
# 9. PLACES API - ADDRESS VALIDATION
# =============================================================================
OlaMapsProvider.validate_address("7, Lok Kalyan Marg, New Delhi, Delhi, 110011, India")

# =============================================================================
# 10. PLACES API - PHOTO
# =============================================================================
# Note: You'll need a valid photo_reference from place details first
OlaMapsProvider.get_photo("c3ae78ac452ec049f67b3cf9aee2b2e8")

# =============================================================================
# 11. PLACES API - GEOCODE
# =============================================================================
OlaMapsProvider.geocode_address("7, Lok Kalyan Marg, New Delhi, Delhi, 110011", language: "en")

# =============================================================================
# 12. PLACES API - REVERSE GEOCODE
# =============================================================================
OlaMapsProvider.reverse_geocode_address(12.92381, 77.55271, language: "hi")

# =============================================================================
# USING GEOGRAPHY.PLACES CONTEXT (High-level abstraction)
# =============================================================================

# Autocomplete via Places context
Places.autocomplete("Kora", language: "en")

# Place details via Places context
Places.get_details("ola-platform:5000039498427", language: "hi")

# Nearby search via Places context
Places.nearby_search(12.9716, 77.5946, type: "restaurant", radius: 1000, language: "en")

# Text search via Places context
Places.text_search("restaurants in Koramangala", language: "hi")
