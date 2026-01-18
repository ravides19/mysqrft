defmodule MySqrft.Geography.OlaMapsGeocoder do
  @moduledoc """
  Ola Maps Geocoding API integration.

  Provides geocoding and reverse geocoding services using Ola Maps API.
  Documentation: https://maps.olakrutrim.com/docs/geocoding/geocoding-api
  """

  require Logger

  @base_url "https://maps.olakrutrim.com/api/v1"
  @geocoding_endpoint "/geocoding"
  @reverse_geocoding_endpoint "/reverse-geocoding"

  @doc """
  Geocodes an address using Ola Maps API.

  Returns {:ok, result} or {:error, reason}

  ## Examples

      iex> geocode("123 Main St, Koramangala, Bangalore")
      {:ok, %{latitude: 12.9352, longitude: 77.6245, ...}}

  """
  def geocode(address) when is_binary(address) do
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{@base_url}#{@geocoding_endpoint}"
      headers = [{"Authorization", "Bearer #{api_key}"}, {"Content-Type", "application/json"}]

      body = %{
        address: address
      }

      case Req.post(url, json: body, headers: headers, receive_timeout: 5_000) do
        {:ok, %{status: 200, body: response}} ->
          parse_geocoding_response(response)

        {:ok, %{status: 429}} ->
          Logger.warning("Ola Maps API rate limit exceeded")
          {:error, :rate_limit_exceeded}

        {:ok, %{status: status, body: body}} ->
          Logger.error("Ola Maps geocoding failed: #{status} - #{inspect(body)}")
          {:error, {:api_error, status}}

        {:error, reason} ->
          Logger.error("Ola Maps geocoding request failed: #{inspect(reason)}")
          {:error, :request_failed}
      end
    end
  end

  @doc """
  Reverse geocodes coordinates using Ola Maps API.

  Returns {:ok, result} or {:error, reason}

  ## Examples

      iex> reverse_geocode(12.9352, 77.6245)
      {:ok, %{formatted_address: "Koramangala, Bangalore", ...}}

  """
  def reverse_geocode(latitude, longitude) when is_number(latitude) and is_number(longitude) do
    api_key = get_api_key()

    if is_nil(api_key) do
      {:error, :api_key_not_configured}
    else
      url = "#{@base_url}#{@reverse_geocoding_endpoint}"
      headers = [{"Authorization", "Bearer #{api_key}"}, {"Content-Type", "application/json"}]

      body = %{
        latitude: latitude,
        longitude: longitude
      }

      case Req.post(url, json: body, headers: headers, receive_timeout: 5_000) do
        {:ok, %{status: 200, body: response}} ->
          parse_reverse_geocoding_response(response)

        {:ok, %{status: 429}} ->
          Logger.warning("Ola Maps API rate limit exceeded")
          {:error, :rate_limit_exceeded}

        {:ok, %{status: status, body: body}} ->
          Logger.error("Ola Maps reverse geocoding failed: #{status} - #{inspect(body)}")
          {:error, {:api_error, status}}

        {:error, reason} ->
          Logger.error("Ola Maps reverse geocoding request failed: #{inspect(reason)}")
          {:error, :request_failed}
      end
    end
  end

  # Private functions

  defp get_api_key do
    Application.get_env(:my_sqrft, :ola_maps_api_key) ||
      System.get_env("OLA_MAPS_API_KEY")
  end

  defp parse_geocoding_response(response) do
    # Parse Ola Maps geocoding response
    # Response format may vary - adjust based on actual API response structure
    case response do
      %{"latitude" => lat, "longitude" => lon} = data ->
        # Extract structured address components
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
        # Handle array response format
        parse_geocoding_response(result)

      _ ->
        {:error, :invalid_response_format}
    end
  end

  defp extract_address_components(data) do
    # Extract structured address components from Ola Maps response
    # Common fields: country, state, city, locality, pincode/postal_code
    %{
      country: extract_component(data, ["country", "country_name", "countryCode"]),
      country_code: extract_component(data, ["country_code", "countryCode", "country"]),
      state: extract_component(data, ["state", "state_name", "administrative_area_level_1"]),
      state_code: extract_component(data, ["state_code", "administrative_area_level_1_short"]),
      city: extract_component(data, ["city", "city_name", "locality", "administrative_area_level_2"]),
      locality: extract_component(data, ["locality", "neighborhood", "sublocality", "sublocality_level_1"]),
      neighborhood: extract_component(data, ["neighborhood", "sublocality_level_2"]),
      pincode: extract_component(data, ["pincode", "postal_code", "postalCode", "postcode"]),
      street: extract_component(data, ["street", "street_name", "route"]),
      street_number: extract_component(data, ["street_number", "streetNumber", "premise_number"]),
      building: extract_component(data, ["building", "premise", "building_name"]),
      # Administrative boundaries
      ward: extract_component(data, ["ward", "administrative_area_level_3"]),
      zone: extract_component(data, ["zone", "administrative_area_level_4"]),
      district: extract_component(data, ["district", "administrative_area_level_2"]),
      # Place information
      place_name: extract_component(data, ["place_name", "name", "establishment"]),
      place_type: extract_component(data, ["place_type", "types", "category"]),
      place_types: extract_types_array(data),
      # Viewport/bounding box
      viewport: extract_viewport(data),
      # Metadata
      timezone: extract_component(data, ["timezone", "time_zone"]),
      currency: extract_component(data, ["currency", "currency_code"]),
      locale: extract_component(data, ["locale", "language"])
    }
  end

  defp extract_types_array(data) do
    # Extract array of place types (e.g., ["establishment", "restaurant"])
    case data do
      %{"types" => types} when is_list(types) -> types
      %{"place_types" => types} when is_list(types) -> types
      _ -> []
    end
  end

  defp extract_viewport(data) do
    # Extract viewport/bounding box coordinates
    case data do
      %{"viewport" => viewport} when is_map(viewport) ->
        %{
          northeast: %{
            lat: Map.get(viewport, "northeast") |> get_coord(:lat) || Map.get(viewport, "ne") |> get_coord(:lat),
            lng: Map.get(viewport, "northeast") |> get_coord(:lng) || Map.get(viewport, "ne") |> get_coord(:lng)
          },
          southwest: %{
            lat: Map.get(viewport, "southwest") |> get_coord(:lat) || Map.get(viewport, "sw") |> get_coord(:lat),
            lng: Map.get(viewport, "southwest") |> get_coord(:lng) || Map.get(viewport, "sw") |> get_coord(:lng)
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
      %{^key => value} when not is_nil(value) -> value
      %{"address_components" => components} when is_list(components) -> find_in_components(components, key)
      _ -> nil
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

  defp parse_reverse_geocoding_response(response) do
    # Parse Ola Maps reverse geocoding response
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
        # Handle array response format
        parse_reverse_geocoding_response(result)

      _ ->
        {:error, :invalid_response_format}
    end
  end
end
