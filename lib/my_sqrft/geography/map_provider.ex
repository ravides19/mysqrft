defmodule MySqrft.Geography.MapProvider do
  @moduledoc """
  Abstract behaviour for map provider services.

  This behaviour defines the contract that all map providers must implement,
  allowing easy switching between providers (Ola Maps, Google Maps, Mapbox, etc.)

  ## Language Support

  All methods accept an optional `language` parameter (ISO 639-1 code, e.g., "en", "hi", "ta")
  to support multilingual responses. Defaults to "en" if not specified.

  ## Example Usage

      # Get the configured provider
      provider = MySqrft.Geography.MapProvider.get_provider()

      # Use geocoding
      {:ok, result} = provider.geocode("Koramangala, Bangalore", language: "en")

      # Use places autocomplete
      {:ok, suggestions} = provider.autocomplete("Kora", language: "hi")
  """

  @type language :: String.t()
  @type coordinates :: %{latitude: float(), longitude: float()}
  @type address_components :: map()
  @type place_id :: String.t()

  @type geocode_result :: %{
          latitude: Decimal.t(),
          longitude: Decimal.t(),
          formatted_address: String.t() | nil,
          confidence_score: Decimal.t() | nil,
          source: String.t(),
          metadata: map() | nil,
          address_components: address_components | nil
        }

  @type reverse_geocode_result :: %{
          formatted_address: String.t(),
          source: String.t(),
          metadata: map() | nil,
          address_components: address_components | nil
        }

  @type autocomplete_suggestion :: %{
          place_id: place_id(),
          description: String.t(),
          main_text: String.t(),
          secondary_text: String.t() | nil,
          types: [String.t()] | nil,
          structured_formatting: map() | nil
        }

  @type place_details :: %{
          place_id: place_id(),
          name: String.t(),
          formatted_address: String.t(),
          location: coordinates(),
          types: [String.t()],
          rating: float() | nil,
          user_ratings_total: integer() | nil,
          opening_hours: map() | nil,
          photos: [map()] | nil,
          phone_number: String.t() | nil,
          website: String.t() | nil,
          address_components: address_components(),
          viewport: map() | nil,
          metadata: map() | nil
        }

  @type nearby_search_result :: %{
          place_id: place_id(),
          name: String.t(),
          location: coordinates(),
          types: [String.t()],
          rating: float() | nil,
          distance: float() | nil
        }

  @type text_search_result :: nearby_search_result()

  @doc """
  Geocodes an address (converts address to coordinates).

  Returns `{:ok, geocode_result}` or `{:error, reason}`

  ## Options

    * `:language` - Language code for response (default: "en")

  ## Examples

      geocode("123 Main St, Koramangala, Bangalore", language: "en")
  """
  @callback geocode(address :: String.t(), opts :: keyword()) ::
              {:ok, geocode_result()} | {:error, atom()}

  @doc """
  Reverse geocodes coordinates (converts coordinates to address).

  Returns `{:ok, reverse_geocode_result}` or `{:error, reason}`

  ## Options

    * `:language` - Language code for response (default: "en")

  ## Examples

      reverse_geocode(12.9352, 77.6245, language: "hi")
  """
  @callback reverse_geocode(latitude :: float(), longitude :: float(), opts :: keyword()) ::
              {:ok, reverse_geocode_result()} | {:error, atom()}

  @doc """
  Gets place autocomplete suggestions for a partial input.

  Returns `{:ok, [autocomplete_suggestion]}` or `{:error, reason}`

  ## Options

    * `:language` - Language code for response (default: "en")
    * `:location` - `{latitude, longitude}` bias for results
    * `:radius` - Bias radius in meters
    * `:types` - Filter by place types (e.g., ["locality", "establishment"])

  ## Examples

      autocomplete("Kora", language: "en", location: {12.9716, 77.5946})
  """
  @callback autocomplete(input :: String.t(), opts :: keyword()) ::
              {:ok, [autocomplete_suggestion()]} | {:error, atom()}

  @doc """
  Gets detailed information about a place by place_id.

  Returns `{:ok, place_details}` or `{:error, reason}`

  ## Options

    * `:language` - Language code for response (default: "en")
    * `:fields` - Specific fields to return (optional)

  ## Examples

      get_place_details("place_id_123", language: "hi")
  """
  @callback get_place_details(place_id :: place_id(), opts :: keyword()) ::
              {:ok, place_details()} | {:error, atom()}

  @doc """
  Searches for places near a location.

  Returns `{:ok, [nearby_search_result]}` or `{:error, reason}`

  ## Options

    * `:language` - Language code for response (default: "en")
    * `:radius` - Search radius in meters (default: 5000)
    * `:type` - Filter by place type (e.g., "restaurant", "hospital")
    * `:keyword` - Text query to filter results
    * `:rankby` - Rank results by "distance" or "prominence" (default: "prominence")

  ## Examples

      nearby_search(12.9716, 77.5946, language: "en", type: "restaurant", radius: 1000)
  """
  @callback nearby_search(latitude :: float(), longitude :: float(), opts :: keyword()) ::
              {:ok, [nearby_search_result()]} | {:error, atom()}

  @doc """
  Searches for places using a text query.

  Returns `{:ok, [text_search_result]}` or `{:error, reason}`

  ## Options

    * `:language` - Language code for response (default: "en")
    * `:location` - `{latitude, longitude}` bias for results
    * `:radius` - Bias radius in meters
    * `:type` - Filter by place type

  ## Examples

      text_search("restaurants in Koramangala", language: "hi")
  """
  @callback text_search(query :: String.t(), opts :: keyword()) ::
              {:ok, [text_search_result()]} | {:error, atom()}

  # Internal function - Geography contexts use this to get the configured provider
  # Other contexts should not call this directly. Use Geography or Geography.Places instead.
  @doc false
  @spec get_provider() :: module()
  def get_provider do
    provider_name = Application.get_env(:my_sqrft, :map_provider, :ola_maps)

    case provider_name do
      :ola_maps ->
        MySqrft.Geography.Providers.OlaMapsProvider

      # Future providers can be added here
      # :google_maps -> MySqrft.Geography.Providers.GoogleMapsProvider
      # :mapbox -> MySqrft.Geography.Providers.MapboxProvider
      _ ->
        raise ArgumentError, "Unknown map provider: #{provider_name}"
    end
  end
end
