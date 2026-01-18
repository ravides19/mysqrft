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
  # Geocoding uses: https://maps.olakrutrim.com/api/v1 (POST with Bearer token)
  @geocoding_base_url "https://maps.olakrutrim.com/api/v1"

  # Places API uses: https://api.olamaps.io (GET with query parameters, api_key in query string)
  # API Documentation: https://maps.olakrutrim.com/apidocs#tag/places-apis
  @places_base_url "https://api.olamaps.io"

  # Geocoding endpoints (POST with JSON body, Bearer token in Authorization header)
  @geocoding_endpoint "/geocoding"
  @reverse_geocoding_endpoint "/reverse-geocoding"

  # Places API endpoints (GET with query parameters, api_key in query string)
  # Example: https://api.olamaps.io/places/v1/details?place_id=xxx&api_key=xxx
  @places_autocomplete_endpoint "/places/v1/autocomplete"
  @places_details_endpoint "/places/v1/details"
  @places_nearby_search_endpoint "/places/v1/nearby-search"
  @places_text_search_endpoint "/places/v1/text-search"

  # MapProvider callbacks

  @impl true
  def geocode(address, opts \\ []) when is_binary(address) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{@geocoding_base_url}#{@geocoding_endpoint}"
      headers = build_headers(api_key)

      body = %{
        address: address,
        language: language
      }

      make_request(url, body, headers, &parse_geocoding_response/1)
    end
  end

  @impl true
  def reverse_geocode(latitude, longitude, opts \\ [])
      when is_number(latitude) and is_number(longitude) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{@geocoding_base_url}#{@reverse_geocoding_endpoint}"
      headers = build_headers(api_key)

      body = %{
        latitude: latitude,
        longitude: longitude,
        language: language
      }

      make_request(url, body, headers, &parse_reverse_geocoding_response/1)
    end
  end

  @impl true
  def autocomplete(input, opts \\ []) when is_binary(input) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{@places_base_url}#{@places_autocomplete_endpoint}"

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
      url = "#{@places_base_url}#{@places_details_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params = %{
        place_id: place_id,
        language: language,
        api_key: api_key
      }

      make_places_request(url, params, &parse_place_details_response/1)
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
      url = "#{@places_base_url}#{@places_nearby_search_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params =
        %{
          latitude: latitude,
          longitude: longitude,
          language: language,
          api_key: api_key
        }
        |> maybe_add_radius_to_params(opts)
        |> maybe_add_type_to_params(opts)
        |> maybe_add_keyword_to_params(opts)
        |> maybe_add_rankby_to_params(opts)

      make_places_request(url, params, &parse_nearby_search_response/1)
    end
  end

  @impl true
  def text_search(query, opts \\ []) when is_binary(query) do
    language = Keyword.get(opts, :language, "en")
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{@places_base_url}#{@places_text_search_endpoint}"

      # Build query parameters (Places API uses GET with query params, api_key in query string)
      params =
        %{
          query: query,
          language: language,
          api_key: api_key
        }
        |> maybe_add_location_to_params(opts)
        |> maybe_add_radius_to_params(opts)
        |> maybe_add_type_to_params(opts)

      make_places_request(url, params, &parse_text_search_response/1)
    end
  end

  # Private helper functions

  defp get_api_key do
    Application.get_env(:my_sqrft, :ola_maps_api_key) ||
      System.get_env("OLA_MAPS_API_KEY")
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
      %{"predictions" => predictions} when is_list(predictions) ->
        suggestions =
          Enum.map(predictions, fn pred ->
            %{
              place_id: Map.get(pred, "place_id", ""),
              description: Map.get(pred, "description", ""),
              main_text: Map.get(pred, "structured_formatting", %{}) |> Map.get("main_text", ""),
              secondary_text:
                Map.get(pred, "structured_formatting", %{}) |> Map.get("secondary_text"),
              types: Map.get(pred, "types", []),
              structured_formatting: Map.get(pred, "structured_formatting")
            }
          end)

        {:ok, suggestions}

      %{"suggestions" => suggestions} when is_list(suggestions) ->
        # Alternative response format
        parsed = Enum.map(suggestions, &parse_suggestion/1)
        {:ok, parsed}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_place_details_response(response) do
    case response do
      %{"result" => result} ->
        address_components = extract_address_components(result)

        {:ok,
         %{
           place_id: Map.get(result, "place_id", ""),
           name: Map.get(result, "name", ""),
           formatted_address: Map.get(result, "formatted_address") || Map.get(result, "address"),
           location: %{
             latitude:
               Map.get(result, "latitude") ||
                 Map.get(result, "geometry", %{}) |> Map.get("location", %{}) |> Map.get("lat"),
             longitude:
               Map.get(result, "longitude") ||
                 Map.get(result, "geometry", %{}) |> Map.get("location", %{}) |> Map.get("lng")
           },
           types: Map.get(result, "types", []),
           rating: Map.get(result, "rating"),
           user_ratings_total: Map.get(result, "user_ratings_total"),
           opening_hours: Map.get(result, "opening_hours"),
           photos: Map.get(result, "photos", []),
           phone_number:
             Map.get(result, "formatted_phone_number") || Map.get(result, "phone_number"),
           website: Map.get(result, "website"),
           address_components: address_components,
           viewport: extract_viewport(result),
           metadata: Map.get(result, "metadata", %{})
         }}

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp parse_nearby_search_response(response) do
    case response do
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

  defp parse_text_search_response(response) do
    # Text search response format is similar to nearby search
    parse_nearby_search_response(response)
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

      {:ok, %{status: 500}} ->
        Logger.error("Ola Maps Places API server error: 500")
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
      rankby when is_binary(rankby) -> Map.put(params, :rankby, rankby)
      _ -> params
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
