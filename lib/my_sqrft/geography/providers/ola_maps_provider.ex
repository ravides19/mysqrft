defmodule MySqrft.Geography.Providers.OlaMapsProvider do
  @moduledoc """
  Ola Maps implementation of the MapProvider behaviour.

  Provides geocoding, reverse geocoding, and Places API services using Ola Maps API.
  Documentation: https://maps.olakrutrim.com/docs

  Supports multilingual responses via the `language` parameter (ISO 639-1 code).
  """

  @behaviour MySqrft.Geography.MapProvider

  require Logger

  # Base URLs for OLA Maps API
  # All APIs use: https://api.olamaps.io (GET with query parameters, api_key in query string)
  # API Documentation: https://maps.olakrutrim.com/apidocs#tag/places-apis
  @places_base_url "https://api.olamaps.io"

  # Legacy geocoding endpoints - now use Places API endpoints
  # Geocoding now uses Places API: /places/v1/geocode (GET with query params)
  # Reverse geocoding now uses Places API: /places/v1/reverse-geocode (GET with query params)

  # Places API endpoints (GET with query parameters, api_key in query string)
  # Example: https://api.olamaps.io/places/v1/details?place_id=xxx&api_key=xxx
  @places_autocomplete_endpoint "/places/v1/autocomplete"
  @places_details_endpoint "/places/v1/details"
  @places_details_advanced_endpoint "/places/v1/details/advanced"
  @places_nearby_search_endpoint "/places/v1/nearbysearch"
  @places_nearby_search_advanced_endpoint "/places/v1/nearbysearch/advanced"
  @places_text_search_endpoint "/places/v1/textsearch"
  @places_address_validation_endpoint "/places/v1/addressvalidation"
  @places_photo_endpoint "/places/v1/photo"
  @places_geocode_endpoint "/places/v1/geocode"
  @places_reverse_geocode_endpoint "/places/v1/reverse-geocode"

  # MapProvider callbacks

  @impl true
  def geocode(address, opts \\ []) when is_binary(address) do
    # Use Places API geocode endpoint, but adapt response to MapProvider format
    case geocode_address(address, opts) do
      {:ok, [first_result | _]} ->
        # Convert Places API format to MapProvider format
        location = first_result.geometry.location
        address_components = first_result.address_components || []

        {:ok,
         %{
           latitude: Decimal.from_float(location.latitude || 0.0),
           longitude: Decimal.from_float(location.longitude || 0.0),
           formatted_address: first_result.formatted_address,
           confidence_score: nil,
           source: "ola_maps",
           metadata: %{
             place_id: first_result.place_id,
             types: first_result.types,
             layer: first_result.layer
           },
           address_components: address_components
         }}

      {:ok, []} ->
        {:error, :no_results}

      error ->
        error
    end
  end

  @impl true
  def reverse_geocode(latitude, longitude, opts \\ [])
      when is_number(latitude) and is_number(longitude) do
    # Use Places API reverse geocode endpoint, but adapt response to MapProvider format
    case reverse_geocode_address(latitude, longitude, opts) do
      {:ok, %{results: [first_result | _]}} ->
        # Convert Places API format to MapProvider format
        address_components = first_result.address_components || []

        {:ok,
         %{
           formatted_address: first_result.formatted_address,
           source: "ola_maps",
           metadata: %{
             place_id: first_result.place_id,
             name: first_result.name,
             types: first_result.types,
             layer: first_result.layer
           },
           address_components: address_components
         }}

      {:ok, %{results: []}} ->
        {:error, :no_results}

      error ->
        error
    end
  end

  @impl true
  def autocomplete(input, opts \\ []) when is_binary(input) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_autocomplete_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params =
        %{
          input: input,
          language: language,
          api_key: api_key
        }
        |> maybe_add_location_to_params(opts)
        |> maybe_add_radius_to_params(opts)
        |> maybe_add_types_to_params(opts)
        |> maybe_add_strictbounds_to_params(opts)

      make_places_request(url, params, &parse_autocomplete_response/1)
    end
  end

  @impl true
  def get_place_details(place_id, opts \\ []) when is_binary(place_id) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_details_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params = %{
        place_id: place_id,
        language: language,
        api_key: api_key
      }

      make_places_request(url, params, &parse_place_details_response/1)
    end
  end

  # Advanced Place Details API (not part of MapProvider behaviour, OLA Maps specific)
  def get_advanced_place_details(place_id, opts \\ []) when is_binary(place_id) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_details_advanced_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params = %{
        place_id: place_id,
        language: language,
        api_key: api_key
      }

      make_places_request(url, params, &parse_advanced_place_details_response/1)
    end
  end

  @impl true
  def nearby_search(latitude, longitude, opts \\ [])
      when is_number(latitude) and is_number(longitude) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_nearby_search_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      # Note: location must be comma-separated "lat,lng" string
      params =
        %{
          location: "#{latitude},#{longitude}",
          language: language,
          api_key: api_key
        }
        |> maybe_add_radius_to_params(opts)
        |> maybe_add_types_to_params(opts)
        |> maybe_add_rankby_to_params(opts)
        |> maybe_add_withcentroid_to_params(opts)
        |> maybe_add_limit_to_params(opts)

      make_places_request(url, params, &parse_nearby_search_response/1)
    end
  end

  # Advanced Nearby Search API (not part of MapProvider behaviour, OLA Maps specific)
  def get_advanced_nearby_search(latitude, longitude, opts \\ [])
      when is_number(latitude) and is_number(longitude) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_nearby_search_advanced_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      # Note: location must be comma-separated "lat,lng" string
      params =
        %{
          location: "#{latitude},#{longitude}",
          language: language,
          api_key: api_key
        }
        |> maybe_add_radius_to_params(opts)
        |> maybe_add_types_to_params(opts)
        |> maybe_add_rankby_to_params(opts)
        |> maybe_add_withcentroid_to_params(opts)
        |> maybe_add_limit_to_params(opts)

      make_places_request(url, params, &parse_advanced_nearby_search_response/1)
    end
  end

  @impl true
  def text_search(query, opts \\ []) when is_binary(query) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_text_search_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      # Note: API uses "input" parameter, not "query"
      params =
        %{
          input: query,
          language: language,
          api_key: api_key
        }
        |> maybe_add_location_to_params(opts)
        |> maybe_add_radius_to_params(opts)
        |> maybe_add_types_to_params(opts)
        |> maybe_add_size_to_params(opts)

      make_places_request(url, params, &parse_text_search_response/1)
    end
  end

  # Address Validation API (not part of MapProvider behaviour, OLA Maps specific)
  def validate_address(address, _opts \\ []) when is_binary(address) do
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_address_validation_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params = %{
        address: address,
        api_key: api_key
      }

      make_places_request(url, params, &parse_address_validation_response/1)
    end
  end

  # Photo API (not part of MapProvider behaviour, OLA Maps specific)
  def get_photo(photo_reference, _opts \\ []) when is_binary(photo_reference) do
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_photo_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params = %{
        photo_reference: photo_reference,
        api_key: api_key
      }

      make_places_request(url, params, &parse_photo_response/1)
    end
  end

  # Places API Geocode (not part of MapProvider behaviour, OLA Maps specific)
  # This is different from the regular geocoding API - uses GET with query params
  def geocode_address(address, opts \\ []) when is_binary(address) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_geocode_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params = %{
        address: address,
        language: language,
        api_key: api_key
      }

      make_places_request(url, params, &parse_places_geocode_response/1)
    end
  end

  # Places API Reverse Geocode (not part of MapProvider behaviour, OLA Maps specific)
  # This is different from the regular reverse geocoding API - uses GET with query params
  def reverse_geocode_address(latitude, longitude, opts \\ [])
      when is_number(latitude) and is_number(longitude) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{get_places_base_url()}#{@places_reverse_geocode_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      # Note: API uses "latlng" parameter as comma-separated string
      params = %{
        latlng: "#{latitude},#{longitude}",
        language: language,
        api_key: api_key
      }

      make_places_request(url, params, &parse_places_reverse_geocode_response/1)
    end
  end

  # Private helper functions

  defp get_api_key do
    Application.get_env(:my_sqrft, :ola_maps_api_key) ||
      System.get_env("OLA_MAPS_API_KEY")
  end

  defp get_places_base_url do
    Application.get_env(:my_sqrft, :ola_maps_places_base_url, @places_base_url)
  end

  defp build_headers(api_key) do
    [
      {"Authorization", "Bearer #{api_key}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp make_request(url, body, headers, parser) do
    Logger.debug("Ola Maps API request: POST #{url}")
    Logger.debug("Request body: #{inspect(body, pretty: true, limit: 5)}")

    case Req.post(url, json: body, headers: headers, receive_timeout: 5_000) do
      {:ok, %{status: 200, body: response}} ->
        parser.(response)

      {:ok, %{status: 404}} ->
        Logger.error("Ola Maps API endpoint not found: #{url}")
        Logger.error("The endpoint might not be available yet. Check OLA Maps documentation.")
        {:error, :endpoint_not_found}

      {:ok, %{status: 429}} ->
        Logger.warning("Ola Maps API rate limit exceeded")
        {:error, :rate_limit_exceeded}

      {:ok, %{status: status, body: body}} ->
        Logger.error("Ola Maps API request failed: #{status}")
        Logger.error("URL: #{url}")
        # Truncate body for logging if it's HTML
        body_preview =
          if is_binary(body) and String.length(body) > 200,
            do: String.slice(body, 0..200) <> "...",
            else: body

        Logger.error("Response body preview: #{inspect(body_preview)}")
        {:error, {:api_error, status}}

      {:error, reason} ->
        Logger.error("Ola Maps API request error: #{inspect(reason)}")
        {:error, :request_failed}
    end
  end

  defp parse_geocoding_response(response) do
    case response do
      %{"latitude" => lat, "longitude" => lon} = data ->
        address_components = extract_address_components(data)

        {:ok,
         %{
           latitude: Decimal.from_float(lat),
           longitude: Decimal.from_float(lon),
           formatted_address: Map.get(data, "formatted_address") || Map.get(data, "address"),
           confidence_score: Decimal.new(Map.get(data, "confidence_score", "85")),
           source: "ola_maps",
           metadata: Map.get(data, "metadata", %{}),
           address_components: address_components
         }}

      %{"results" => [result | _]} ->
        parse_geocoding_response(result)

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_reverse_geocoding_response(response) do
    case response do
      %{"formatted_address" => address} = data ->
        address_components = extract_address_components(data)

        {:ok,
         %{
           formatted_address: address,
           source: "ola_maps",
           metadata: Map.get(data, "metadata", %{}),
           address_components: address_components
         }}

      %{"address" => address} = data ->
        address_components = extract_address_components(data)

        {:ok,
         %{
           formatted_address: address,
           source: "ola_maps",
           metadata: Map.get(data, "metadata", %{}),
           address_components: address_components
         }}

      %{"results" => [result | _]} ->
        parse_reverse_geocoding_response(result)

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_autocomplete_response(response) do
    case response do
      # Handle successful response with predictions
      %{"predictions" => predictions} when is_list(predictions) ->
        suggestions =
          Enum.map(predictions, fn pred ->
            geometry = Map.get(pred, "geometry", %{})
            location = Map.get(geometry, "location", %{})
            structured_formatting = Map.get(pred, "structured_formatting", %{})

            %{
              place_id: Map.get(pred, "place_id", ""),
              reference: Map.get(pred, "reference"),
              description: Map.get(pred, "description", ""),
              main_text: Map.get(structured_formatting, "main_text", ""),
              secondary_text: Map.get(structured_formatting, "secondary_text"),
              types: Map.get(pred, "types", []),
              structured_formatting: structured_formatting,
              distance_meters: Map.get(pred, "distance_meters"),
              matched_substrings: Map.get(pred, "matched_substrings", []),
              terms: Map.get(pred, "terms", []),
              geometry: %{
                location: %{
                  latitude: Map.get(location, "lat"),
                  longitude: Map.get(location, "lng")
                }
              }
            }
          end)

        {:ok, suggestions}

      # Handle zero results (predictions array is empty)
      %{"predictions" => []} = response ->
        error_message = Map.get(response, "error_message", "")
        status = Map.get(response, "status", "")

        if status == "ok" do
          # This is a valid zero results response, not an error
          {:ok, []}
        else
          {:error, {:api_error, error_message}}
        end

      # Alternative response format (if API ever uses this)
      %{"suggestions" => suggestions} when is_list(suggestions) ->
        parsed = Enum.map(suggestions, &parse_suggestion/1)
        {:ok, parsed}

      # Handle error responses (status: "FAILURE")
      %{"status" => "FAILURE"} = response ->
        error_message = Map.get(response, "error_message", "Request failed")
        {:error, {:api_error, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_place_details_response(response) do
    case response do
      # Handle successful response with result
      %{"result" => result} ->
        geometry = Map.get(result, "geometry", %{})
        location = Map.get(geometry, "location", %{})

        # Extract address components (handles both array format and flat format)
        address_components =
          extract_address_components_from_array(result) || extract_address_components(result)

        {:ok,
         %{
           place_id: Map.get(result, "place_id", ""),
           reference: Map.get(result, "reference"),
           name: Map.get(result, "name", ""),
           formatted_address: Map.get(result, "formatted_address") || Map.get(result, "address"),
           adr_address: Map.get(result, "adr_address"),
           location: %{
             latitude:
               Map.get(result, "latitude") ||
                 Map.get(location, "lat"),
             longitude:
               Map.get(result, "longitude") ||
                 Map.get(location, "lng")
           },
           geometry: %{
             location: %{
               latitude: Map.get(location, "lat"),
               longitude: Map.get(location, "lng")
             },
             viewport: extract_viewport(result)
           },
           types: Map.get(result, "types", []),
           layer: Map.get(result, "layer", []),
           rating: Map.get(result, "rating"),
           user_ratings_total: Map.get(result, "user_ratings_total"),
           business_status: Map.get(result, "business_status"),
           opening_hours: Map.get(result, "opening_hours"),
           photos: Map.get(result, "photos", []),
           reviews: Map.get(result, "reviews", []),
           formatted_phone_number: Map.get(result, "formatted_phone_number"),
           international_phone_number: Map.get(result, "international_phone_number"),
           phone_number:
             Map.get(result, "formatted_phone_number") || Map.get(result, "phone_number"),
           website: Map.get(result, "website"),
           url: Map.get(result, "url"),
           icon: Map.get(result, "icon"),
           icon_background_color: Map.get(result, "icon_background_color"),
           icon_mask_base_uri: Map.get(result, "icon_mask_base_uri"),
           plus_code: Map.get(result, "plus_code"),
           vicinity: Map.get(result, "vicinity"),
           price_level: Map.get(result, "price_level"),
           utc_offset: Map.get(result, "utc_offset"),
           address_components: address_components,
           viewport: extract_viewport(result),
           metadata: Map.get(result, "metadata", %{})
         }}

      # Handle error responses (status: "zero_results" or other error statuses)
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Request failed")
        {:error, {:api_error, status, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Parse advanced place details response (includes additional fields like amenities, parking, etc.)
  defp parse_advanced_place_details_response(response) do
    case response do
      # Handle successful response with result
      %{"result" => result} ->
        geometry = Map.get(result, "geometry", %{})
        location = Map.get(geometry, "location", %{})

        # Extract address components (handles both array format and flat format)
        address_components =
          extract_address_components_from_array(result) || extract_address_components(result)

        # Start with all fields from regular place details
        base_details = %{
          place_id: Map.get(result, "place_id", ""),
          reference: Map.get(result, "reference"),
          name: Map.get(result, "name", ""),
          formatted_address: Map.get(result, "formatted_address") || Map.get(result, "address"),
          adr_address: Map.get(result, "adr_address"),
          location: %{
            latitude: Map.get(result, "latitude") || Map.get(location, "lat"),
            longitude: Map.get(result, "longitude") || Map.get(location, "lng")
          },
          geometry: %{
            location: %{
              latitude: Map.get(location, "lat"),
              longitude: Map.get(location, "lng")
            },
            viewport: extract_viewport(result)
          },
          types: Map.get(result, "types", []),
          layer: Map.get(result, "layer", []),
          rating: Map.get(result, "rating"),
          user_ratings_total: Map.get(result, "user_ratings_total"),
          business_status: Map.get(result, "business_status"),
          opening_hours: Map.get(result, "opening_hours"),
          photos: Map.get(result, "photos", []),
          reviews: Map.get(result, "reviews", []),
          formatted_phone_number: Map.get(result, "formatted_phone_number"),
          international_phone_number: Map.get(result, "international_phone_number"),
          phone_number:
            Map.get(result, "formatted_phone_number") || Map.get(result, "phone_number"),
          website: Map.get(result, "website"),
          url: Map.get(result, "url"),
          icon: Map.get(result, "icon"),
          icon_background_color: Map.get(result, "icon_background_color"),
          icon_mask_base_uri: Map.get(result, "icon_mask_base_uri"),
          plus_code: Map.get(result, "plus_code"),
          vicinity: Map.get(result, "vicinity"),
          price_level: Map.get(result, "price_level"),
          utc_offset: Map.get(result, "utc_offset"),
          address_components: address_components,
          viewport: extract_viewport(result),
          metadata: Map.get(result, "metadata", %{})
        }

        # Add advanced-specific fields
        advanced_fields = %{
          amenities_available: Map.get(result, "amenities_available", []),
          wheelchair_accessibility: Map.get(result, "wheelchair_accessibility"),
          parking_available: Map.get(result, "parking_available"),
          is_landmark: Map.get(result, "is_landmark"),
          landmark_type: Map.get(result, "landmark_type"),
          payment_mode: Map.get(result, "payment_mode"),
          popular_items: Map.get(result, "popular_items", []),
          language_spoken: Map.get(result, "language_spoken")
        }

        {:ok, Map.merge(base_details, advanced_fields)}

      # Handle error responses (status: "zero_results" or other error statuses)
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Request failed")
        {:error, {:api_error, status, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Extract address components from array format (as per API spec)
  # Array format: [{long_name, short_name, types}, ...]
  defp extract_address_components_from_array(data) do
    case Map.get(data, "address_components") do
      components when is_list(components) and length(components) > 0 ->
        # Return the array as-is, preserving the API structure
        components

      _ ->
        nil
    end
  end

  defp parse_nearby_search_response(response) do
    case response do
      # Handle successful response with predictions
      %{"predictions" => predictions} when is_list(predictions) ->
        places =
          Enum.map(predictions, fn pred ->
            structured_formatting = Map.get(pred, "structured_formatting", %{})

            %{
              place_id: Map.get(pred, "place_id", ""),
              reference: Map.get(pred, "reference"),
              description: Map.get(pred, "description", ""),
              main_text: Map.get(structured_formatting, "main_text", ""),
              secondary_text: Map.get(structured_formatting, "secondary_text"),
              types: Map.get(pred, "types", []),
              layer: Map.get(pred, "layer", []),
              structured_formatting: structured_formatting,
              matched_substrings: Map.get(pred, "matched_substrings", []),
              terms: Map.get(pred, "terms", []),
              distance_meters: Map.get(pred, "distance_meters")
            }
          end)

        {:ok, places}

      # Handle zero results (predictions array is empty)
      %{"predictions" => []} = response ->
        error_message = Map.get(response, "error_message", "")
        status = Map.get(response, "status", "")

        if status == "ok" do
          # This is a valid zero results response, not an error
          {:ok, []}
        else
          {:error, {:api_error, error_message}}
        end

      # Handle error responses (status: "FAILURE" or "zero_results")
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Request failed")
        {:error, {:api_error, status, error_message}}

      # Fallback for old "results" format (for backward compatibility)
      %{"results" => results} when is_list(results) ->
        places =
          Enum.map(results, fn result ->
            location =
              Map.get(result, "geometry", %{}) |> Map.get("location", %{}) ||
                %{"lat" => Map.get(result, "latitude"), "lng" => Map.get(result, "longitude")}

            %{
              place_id: Map.get(result, "place_id", ""),
              name: Map.get(result, "name", ""),
              location: %{
                latitude: Map.get(location, "lat") || Map.get(location, "latitude"),
                longitude: Map.get(location, "lng") || Map.get(location, "longitude")
              },
              types: Map.get(result, "types", []),
              rating: Map.get(result, "rating"),
              distance: Map.get(result, "distance")
            }
          end)

        {:ok, places}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Parse advanced nearby search response (includes additional fields like opening_hours, ratings, etc.)
  defp parse_advanced_nearby_search_response(response) do
    case response do
      # Handle successful response with predictions
      %{"predictions" => predictions} when is_list(predictions) ->
        places =
          Enum.map(predictions, fn pred ->
            structured_formatting = Map.get(pred, "structured_formatting", %{})

            # Start with all fields from regular nearby search
            base_fields = %{
              place_id: Map.get(pred, "place_id", ""),
              reference: Map.get(pred, "reference"),
              description: Map.get(pred, "description", ""),
              main_text: Map.get(structured_formatting, "main_text", ""),
              secondary_text: Map.get(structured_formatting, "secondary_text"),
              types: Map.get(pred, "types", []),
              layer: Map.get(pred, "layer", []),
              structured_formatting: structured_formatting,
              matched_substrings: Map.get(pred, "matched_substrings", []),
              terms: Map.get(pred, "terms", []),
              distance_meters: Map.get(pred, "distance_meters")
            }

            # Add advanced-specific fields
            advanced_fields = %{
              opening_hours: Map.get(pred, "opening_hours"),
              business_status: Map.get(pred, "business_status"),
              url: Map.get(pred, "url"),
              formatted_phone_number: Map.get(pred, "formatted_phone_number"),
              international_phone_number: Map.get(pred, "international_phone_number"),
              website: Map.get(pred, "website"),
              photos: Map.get(pred, "photos", []),
              rating: Map.get(pred, "rating"),
              amenities_available: Map.get(pred, "amenities_available", []),
              wheelchair_accessibility: Map.get(pred, "wheelchair_accessibility"),
              parking_available: Map.get(pred, "parking_available"),
              is_landmark: Map.get(pred, "is_landmark"),
              landmark_type: Map.get(pred, "landmark_type"),
              payment_mode: Map.get(pred, "payment_mode"),
              popular_items: Map.get(pred, "popular_items", []),
              language_spoken: Map.get(pred, "language_spoken", [])
            }

            Map.merge(base_fields, advanced_fields)
          end)

        {:ok, places}

      # Handle zero results (predictions array is empty)
      %{"predictions" => []} = response ->
        error_message = Map.get(response, "error_message", "")
        status = Map.get(response, "status", "")

        if status == "ok" do
          # This is a valid zero results response, not an error
          {:ok, []}
        else
          {:error, {:api_error, error_message}}
        end

      # Handle error responses (status: "FAILURE" or "zero_results")
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Request failed")
        {:error, {:api_error, status, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_text_search_response(response) do
    case response do
      # Handle successful response with predictions (nested array structure)
      # predictions is an array of arrays: [[{place1}, {place2}, ...], ...]
      %{"predictions" => predictions} when is_list(predictions) ->
        # Flatten nested array structure - predictions is array of arrays
        places =
          predictions
          |> List.flatten()
          |> Enum.map(fn pred ->
            geometry = Map.get(pred, "geometry", %{})
            location = Map.get(geometry, "location", %{})

            %{
              place_id: Map.get(pred, "place_id", ""),
              name: Map.get(pred, "name", ""),
              formatted_address: Map.get(pred, "formatted_address", ""),
              location: %{
                latitude: Map.get(location, "lat"),
                longitude: Map.get(location, "lng")
              },
              geometry: %{
                location: %{
                  latitude: Map.get(location, "lat"),
                  longitude: Map.get(location, "lng")
                }
              },
              types: Map.get(pred, "types", [])
            }
          end)

        {:ok, places}

      # Handle zero results (predictions array is empty)
      %{"predictions" => []} = response ->
        error_message = Map.get(response, "error_message", "")
        status = Map.get(response, "status", "")

        if status == "ok" do
          # This is a valid zero results response, not an error
          {:ok, []}
        else
          {:error, {:api_error, error_message}}
        end

      # Handle error responses (status: "zero_results" or "Internal Server Error")
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Request failed")
        {:error, {:api_error, status, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Parse address validation response
  defp parse_address_validation_response(response) do
    case response do
      # Handle successful validation response
      %{"result" => result} = response ->
        validated = Map.get(result, "validated", false)
        validated_address = Map.get(result, "validated_address")
        address_components = Map.get(result, "address_components", [])
        status = Map.get(response, "status", "")

        if validated and status == "ok" do
          {:ok,
           %{
             validated: true,
             validated_address: validated_address,
             address_components: address_components,
             status: status,
             info_messages: Map.get(response, "info_messages", []),
             error_message: Map.get(response, "error_message", "")
           }}
        else
          # Validation failed
          error_message = Map.get(response, "error_message", "Address validation failed")
          {:error, {:validation_failed, error_message}}
        end

      # Handle error responses
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Address validation failed")
        {:error, {:validation_failed, status, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Parse photo response
  defp parse_photo_response(response) do
    case response do
      # Handle successful response with photos array
      %{"photos" => photos} when is_list(photos) and length(photos) > 0 ->
        # Check if first element is actually a photo object (not error structure)
        first_photo = List.first(photos)

        case first_photo do
          %{"photo_reference" => _} ->
            # Valid photo object
            parsed_photos =
              Enum.map(photos, fn photo ->
                %{
                  height: Map.get(photo, "height"),
                  width: Map.get(photo, "width"),
                  angle: Map.get(photo, "angle"),
                  photo_reference: Map.get(photo, "photo_reference", ""),
                  photo_uri: Map.get(photo, "photoUri")
                }
              end)

            {:ok, parsed_photos}

          %{"error_message" => error_message} ->
            # Error structure nested in photos array (400 response format)
            status = Map.get(first_photo, "status", "zero_results")
            {:error, {:api_error, status, error_message}}

          _ ->
            {:error, :invalid_response_format}
        end

      # Handle empty photos array
      %{"photos" => []} ->
        {:error, :no_photos_found}

      # Handle error responses (500 format)
      %{"status" => status, "error_message" => error_message} when status != "ok" ->
        {:error, {:api_error, status, error_message}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Parse Places API geocode response
  defp parse_places_geocode_response(response) do
    case response do
      # Handle successful response with geocodingResults
      %{"geocodingResults" => results} when is_list(results) ->
        geocoding_results =
          Enum.map(results, fn result ->
            geometry = Map.get(result, "geometry", %{})
            location = Map.get(geometry, "location", %{})
            viewport = Map.get(geometry, "viewport", %{})
            plus_code = Map.get(result, "plus_code", %{})

            %{
              place_id: Map.get(result, "place_id", ""),
              formatted_address: Map.get(result, "formatted_address", ""),
              name: Map.get(result, "name"),
              types: Map.get(result, "types", []),
              layer: Map.get(result, "layer", []),
              geometry: %{
                location: %{
                  latitude: Map.get(location, "lat"),
                  longitude: Map.get(location, "lng")
                },
                location_type: Map.get(geometry, "location_type"),
                viewport: %{
                  northeast: %{
                    latitude: Map.get(viewport, "northeast", %{}) |> Map.get("lat"),
                    longitude: Map.get(viewport, "northeast", %{}) |> Map.get("lng")
                  },
                  southwest: %{
                    latitude: Map.get(viewport, "southwest", %{}) |> Map.get("lat"),
                    longitude: Map.get(viewport, "southwest", %{}) |> Map.get("lng")
                  }
                }
              },
              address_components: Map.get(result, "address_components", []),
              plus_code: %{
                compound_code: Map.get(plus_code, "compound_code"),
                global_code: Map.get(plus_code, "global_code")
              }
            }
          end)

        {:ok, geocoding_results}

      # Handle error responses (status: "error")
      %{"status" => "error"} = response ->
        reason = Map.get(response, "reason", "Geocoding failed")
        request_id = Map.get(response, "request_id")
        {:error, {:api_error, "error", reason, request_id}}

      # Handle other error statuses
      %{"status" => status} = response when status != "ok" ->
        reason = Map.get(response, "reason", "Geocoding failed")
        request_id = Map.get(response, "request_id")
        {:error, {:api_error, status, reason, request_id}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  # Parse Places API reverse geocode response
  defp parse_places_reverse_geocode_response(response) do
    case response do
      # Handle successful response with results
      %{"results" => results} when is_list(results) ->
        status = Map.get(response, "status", "")
        plus_code = Map.get(response, "plus_code", %{})

        if status == "ok" do
          parsed_results =
            Enum.map(results, fn result ->
              geometry = Map.get(result, "geometry", %{})
              location = Map.get(geometry, "location", %{})
              viewport = Map.get(geometry, "viewport", %{})
              result_plus_code = Map.get(result, "plus_code", %{})

              %{
                place_id: Map.get(result, "place_id", ""),
                formatted_address: Map.get(result, "formatted_address", ""),
                name: Map.get(result, "name"),
                types: Map.get(result, "types"),
                layer: Map.get(result, "layer", []),
                geometry: %{
                  location: %{
                    latitude: Map.get(location, "lat"),
                    longitude: Map.get(location, "lng")
                  },
                  location_type: Map.get(geometry, "location_type"),
                  viewport: %{
                    northeast: %{
                      latitude: Map.get(viewport, "northeast", %{}) |> Map.get("lat"),
                      longitude: Map.get(viewport, "northeast", %{}) |> Map.get("lng")
                    },
                    southwest: %{
                      latitude: Map.get(viewport, "southwest", %{}) |> Map.get("lat"),
                      longitude: Map.get(viewport, "southwest", %{}) |> Map.get("lng")
                    }
                  }
                },
                address_components: Map.get(result, "address_components", []),
                plus_code: %{
                  compound_code: Map.get(result_plus_code, "compound_code"),
                  global_code: Map.get(result_plus_code, "global_code")
                }
              }
            end)

          {:ok,
           %{
             results: parsed_results,
             plus_code: %{
               compound_code: Map.get(plus_code, "compound_code"),
               global_code: Map.get(plus_code, "global_code")
             },
             status: status,
             info_messages: Map.get(response, "info_messages", []),
             error_message: Map.get(response, "error_message", "")
           }}
        else
          # Status is not "ok" (e.g., "zero_results")
          error_message = Map.get(response, "error_message", "Reverse geocoding failed")
          request_id = Map.get(response, "request_id")
          {:error, {:api_error, status, error_message, request_id}}
        end

      # Handle error responses (empty results or status != "ok")
      %{"status" => status} = response when status != "ok" ->
        error_message = Map.get(response, "error_message", "Reverse geocoding failed")
        request_id = Map.get(response, "request_id")
        {:error, {:api_error, status, error_message, request_id}}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_suggestion(suggestion) do
    %{
      place_id: Map.get(suggestion, "place_id", ""),
      description: Map.get(suggestion, "description", ""),
      main_text: Map.get(suggestion, "main_text", ""),
      secondary_text: Map.get(suggestion, "secondary_text"),
      types: Map.get(suggestion, "types", []),
      structured_formatting: Map.get(suggestion, "structured_formatting")
    }
  end

  # Places API uses GET requests with query parameters (api_key in query string)
  defp make_places_request(url, params, parser) do
    Logger.debug("Ola Maps Places API request: GET #{url}")
    Logger.debug("Query parameters: #{inspect(params, pretty: true, limit: 5)}")

    # Filter out nil values
    filtered_params = Enum.reject(params, fn {_k, v} -> is_nil(v) end) |> Enum.into(%{})

    # Optional headers for request tracking (as per OLA Maps docs)
    headers = [
      {"X-Request-Id", generate_request_id()},
      {"X-Correlation-Id", generate_request_id()}
    ]

    case Req.get(url, params: filtered_params, headers: headers, receive_timeout: 5_000) do
      {:ok, %{status: 200, body: response}} ->
        parser.(response)

      {:ok, %{status: 400, body: body}} ->
        error_message = extract_error_message(body)
        Logger.error("Ola Maps Places API request failed: 400 - #{error_message}")
        Logger.error("URL: #{url}")
        Logger.error("Params: #{inspect(filtered_params)}")
        {:error, {:api_error, 400, error_message}}

      {:ok, %{status: 404}} ->
        Logger.error("Ola Maps Places API endpoint not found: #{url}")
        Logger.error("Query params: #{inspect(filtered_params)}")
        {:error, :endpoint_not_found}

      {:ok, %{status: 429}} ->
        Logger.warning("Ola Maps Places API rate limit exceeded")
        {:error, :rate_limit_exceeded}

      {:ok, %{status: 500, body: body}} ->
        error_message = extract_error_message(body)
        Logger.error("Ola Maps Places API server error: 500 - #{error_message}")
        Logger.error("URL: #{url}")
        {:error, {:api_error, 500, error_message}}

      {:ok, %{status: 500}} ->
        Logger.error("Ola Maps Places API server error: 500 (no body)")
        Logger.error("URL: #{url}")
        {:error, {:api_error, 500}}

      {:ok, %{status: status, body: body}} ->
        error_message = extract_error_message(body)
        Logger.error("Ola Maps Places API request failed: #{status}")
        Logger.error("URL: #{url}")
        Logger.error("Params: #{inspect(filtered_params)}")
        Logger.error("Error: #{error_message}")
        {:error, {:api_error, status, error_message}}

      {:error, reason} ->
        Logger.error("Ola Maps Places API request error: #{inspect(reason)}")
        {:error, :request_failed}
    end
  end

  defp generate_request_id do
    # Generate a unique request ID for tracking (optional header per OLA Maps docs)
    :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
  end

  defp extract_error_message(body) when is_map(body) do
    Map.get(body, "error_message") || Map.get(body, "error") || "Unknown error"
  end

  defp extract_error_message(_), do: "Unknown error"

  # Helper functions for Places API query parameters (GET requests)

  defp maybe_add_location_to_params(params, opts) do
    case Keyword.get(opts, :location) do
      {lat, lng} when is_number(lat) and is_number(lng) ->
        # Places API expects lat/lng as comma-separated string in query params
        Map.put(params, :location, "#{lat},#{lng}")

      _ ->
        params
    end
  end

  defp maybe_add_radius_to_params(params, opts) do
    case Keyword.get(opts, :radius) do
      radius when is_integer(radius) -> Map.put(params, :radius, radius)
      _ -> params
    end
  end

  defp maybe_add_types_to_params(params, opts) do
    case Keyword.get(opts, :types) do
      types when is_list(types) ->
        # Places API expects types as comma-separated string in query params
        types_str = Enum.join(types, ",")
        Map.put(params, :types, types_str)

      _ ->
        params
    end
  end

  defp maybe_add_type_to_params(params, opts) do
    case Keyword.get(opts, :type) do
      type when is_binary(type) -> Map.put(params, :type, type)
      _ -> params
    end
  end

  defp maybe_add_keyword_to_params(params, opts) do
    case Keyword.get(opts, :keyword) do
      keyword when is_binary(keyword) -> Map.put(params, :keyword, keyword)
      _ -> params
    end
  end

  defp maybe_add_rankby_to_params(params, opts) do
    case Keyword.get(opts, :rankby) do
      rankby when is_binary(rankby) -> Map.put(params, :rankBy, rankby)
      _ -> params
    end
  end

  defp maybe_add_withcentroid_to_params(params, opts) do
    case Keyword.get(opts, :with_centroid) do
      with_centroid when is_boolean(with_centroid) ->
        Map.put(params, :withCentroid, with_centroid)

      _ ->
        params
    end
  end

  defp maybe_add_limit_to_params(params, opts) do
    case Keyword.get(opts, :limit) do
      limit when is_integer(limit) and limit > 0 -> Map.put(params, :limit, limit)
      _ -> params
    end
  end

  defp maybe_add_size_to_params(params, opts) do
    case Keyword.get(opts, :size) do
      size when is_integer(size) and size > 0 -> Map.put(params, :size, size)
      _ -> params
    end
  end

  defp maybe_add_strictbounds_to_params(params, opts) do
    case Keyword.get(opts, :strictbounds) do
      strictbounds when is_boolean(strictbounds) ->
        # API expects "true" or "false" as string, or true/false as boolean
        Map.put(params, :strictbounds, strictbounds)

      _ ->
        params
    end
  end

  # Address component extraction (reused from original geocoder)

  defp extract_address_components(data) do
    %{
      country: extract_component(data, ["country", "country_name", "countryCode"]),
      country_code: extract_component(data, ["country_code", "countryCode", "country"]),
      state: extract_component(data, ["state", "state_name", "administrative_area_level_1"]),
      state_code: extract_component(data, ["state_code", "administrative_area_level_1_short"]),
      city:
        extract_component(data, ["city", "city_name", "locality", "administrative_area_level_2"]),
      locality:
        extract_component(data, ["locality", "neighborhood", "sublocality", "sublocality_level_1"]),
      neighborhood: extract_component(data, ["neighborhood", "sublocality_level_2"]),
      pincode: extract_component(data, ["pincode", "postal_code", "postalCode", "postcode"]),
      street: extract_component(data, ["street", "street_name", "route"]),
      street_number: extract_component(data, ["street_number", "streetNumber", "premise_number"]),
      building: extract_component(data, ["building", "premise", "building_name"]),
      ward: extract_component(data, ["ward", "administrative_area_level_3"]),
      zone: extract_component(data, ["zone", "administrative_area_level_4"]),
      district: extract_component(data, ["district", "administrative_area_level_2"]),
      place_name: extract_component(data, ["place_name", "name", "establishment"]),
      place_type: extract_component(data, ["place_type", "types", "category"]),
      place_types: extract_types_array(data),
      viewport: extract_viewport(data),
      timezone: extract_component(data, ["timezone", "time_zone"]),
      currency: extract_component(data, ["currency", "currency_code"]),
      locale: extract_component(data, ["locale", "language"])
    }
  end

  defp extract_types_array(data) do
    case data do
      %{"types" => types} when is_list(types) -> types
      %{"place_types" => types} when is_list(types) -> types
      _ -> []
    end
  end

  defp extract_viewport(data) do
    case data do
      %{"viewport" => viewport} when is_map(viewport) ->
        %{
          northeast: %{
            lat:
              Map.get(viewport, "northeast") |> get_coord(:lat) ||
                Map.get(viewport, "ne") |> get_coord(:lat),
            lng:
              Map.get(viewport, "northeast") |> get_coord(:lng) ||
                Map.get(viewport, "ne") |> get_coord(:lng)
          },
          southwest: %{
            lat:
              Map.get(viewport, "southwest") |> get_coord(:lat) ||
                Map.get(viewport, "sw") |> get_coord(:lat),
            lng:
              Map.get(viewport, "southwest") |> get_coord(:lng) ||
                Map.get(viewport, "sw") |> get_coord(:lng)
          }
        }

      %{"bounds" => bounds} when is_map(bounds) ->
        extract_viewport(%{"viewport" => bounds})

      _ ->
        nil
    end
  end

  defp get_coord(nil, _), do: nil
  defp get_coord(%{"lat" => lat}, :lat), do: lat
  defp get_coord(%{"lng" => lng}, :lng), do: lng
  defp get_coord(%{"latitude" => lat}, :lat), do: lat
  defp get_coord(%{"longitude" => lng}, :lng), do: lng
  defp get_coord(_, _), do: nil

  defp extract_component(data, keys) do
    Enum.reduce_while(keys, nil, fn key, _acc ->
      value = get_nested_value(data, key)
      if value, do: {:halt, value}, else: {:cont, nil}
    end)
  end

  defp get_nested_value(data, key) when is_binary(key) do
    case data do
      %{^key => value} when not is_nil(value) ->
        value

      %{"address_components" => components} when is_list(components) ->
        find_in_components(components, key)

      _ ->
        nil
    end
  end

  defp get_nested_value(data, key) when is_atom(key) do
    get_nested_value(data, Atom.to_string(key))
  end

  defp find_in_components(components, key) when is_list(components) do
    Enum.find_value(components, fn component ->
      case component do
        %{"types" => types, "long_name" => name} when is_list(types) ->
          if key in types or String.contains?(key, hd(types) || ""), do: name

        %{^key => value} when not is_nil(value) ->
          value

        _ ->
          nil
      end
    end)
  end

  defp find_in_components(_, _), do: nil
end
