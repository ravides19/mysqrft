defmodule MySqrft.Geography.Places do
  @moduledoc """
  Places API context for location-based place searches and details.

  This is a Phoenix context that provides high-level functions for place-related
  operations. It handles map provider abstraction internally, so other contexts
  can call these functions without knowing which provider is configured.

  ## Features

  - Place autocomplete suggestions
  - Place details by place_id
  - Nearby place searches
  - Text-based place searches
  - Multilingual support via `language` parameter

  ## Example Usage

      alias MySqrft.Geography.Places

      # Get autocomplete suggestions
      {:ok, suggestions} = Places.autocomplete("Kora", language: "en")

      # Get place details
      {:ok, details} = Places.get_details("place_id_123", language: "hi")

      # Search nearby places
      {:ok, places} = Places.nearby_search(12.9716, 77.5946, type: "restaurant", radius: 1000)

  ## Provider Abstraction

  This context automatically uses the configured map provider (Ola Maps, Google Maps, etc.)
  based on application configuration. To change providers, update `:map_provider` config.
  See `PROVIDERS.md` for details.

  Other contexts should call functions from this context, not directly from
  `MapProvider` or provider modules.
  """

  # Get provider internally - other contexts should not call MapProvider directly
  alias MySqrft.Geography.MapProvider

  @doc """
  Gets autocomplete suggestions for a partial place input.

  Returns `{:ok, [suggestion]}` or `{:error, reason}`

  ## Options

    * `:language` - Language code (ISO 639-1) for response (default: "en")
    * `:location` - `{latitude, longitude}` tuple to bias results
    * `:radius` - Bias radius in meters
    * `:types` - Filter by place types (e.g., ["locality", "establishment"])

  ## Examples

      iex> Places.autocomplete("Kora")
      {:ok, [%{place_id: "...", description: "Koramangala, Bangalore", ...}, ...]}

      iex> Places.autocomplete("Rest", location: {12.9716, 77.5946}, radius: 5000, language: "hi")
      {:ok, [%{...}, ...]}

  """
  @spec autocomplete(String.t(), keyword()) ::
          {:ok, [map()]} | {:error, atom()}
  def autocomplete(input, opts \\ []) when is_binary(input) do
    # Get configured provider internally - provider abstraction is handled here
    provider = MapProvider.get_provider()
    provider.autocomplete(input, opts)
  end

  @doc """
  Gets detailed information about a place by place_id.

  Returns `{:ok, place_details}` or `{:error, reason}`

  ## Options

    * `:language` - Language code (ISO 639-1) for response (default: "en")
    * `:fields` - Specific fields to return (optional, provider-dependent)

  ## Examples

      iex> Places.get_details("place_id_123")
      {:ok, %{place_id: "...", name: "Koramangala", location: %{...}, ...}}

      iex> Places.get_details("place_id_123", language: "hi")
      {:ok, %{...}}

  """
  @spec get_details(String.t(), keyword()) :: {:ok, map()} | {:error, atom()}
  def get_details(place_id, opts \\ []) when is_binary(place_id) do
    provider = MapProvider.get_provider()
    provider.get_place_details(place_id, opts)
  end

  @doc """
  Searches for places near a location.

  Returns `{:ok, [place]}` or `{:error, reason}`

  ## Options

    * `:language` - Language code (ISO 639-1) for response (default: "en")
    * `:radius` - Search radius in meters (default: 5000)
    * `:type` - Filter by place type (e.g., "restaurant", "hospital")
    * `:keyword` - Text query to filter results
    * `:rankby` - Rank results by "distance" or "prominence" (default: "prominence")

  ## Examples

      iex> Places.nearby_search(12.9716, 77.5946)
      {:ok, [%{place_id: "...", name: "...", location: %{...}, ...}, ...]}

      iex> Places.nearby_search(12.9716, 77.5946, type: "restaurant", radius: 1000, language: "hi")
      {:ok, [%{...}, ...]}

  """
  @spec nearby_search(float(), float(), keyword()) :: {:ok, [map()]} | {:error, atom()}
  def nearby_search(latitude, longitude, opts \\ [])
      when is_number(latitude) and is_number(longitude) do
    provider = MapProvider.get_provider()
    provider.nearby_search(latitude, longitude, opts)
  end

  @doc """
  Searches for places using a text query.

  Returns `{:ok, [place]}` or `{:error, reason}`

  ## Options

    * `:language` - Language code (ISO 639-1) for response (default: "en")
    * `:location` - `{latitude, longitude}` tuple to bias results
    * `:radius` - Bias radius in meters
    * `:type` - Filter by place type

  ## Examples

      iex> Places.text_search("restaurants in Koramangala")
      {:ok, [%{place_id: "...", name: "...", location: %{...}, ...}, ...]}

      iex> Places.text_search("रैस्टोरेंट कोरमंगला", language: "hi")
      {:ok, [%{...}, ...]}

  """
  @spec text_search(String.t(), keyword()) :: {:ok, [map()]} | {:error, atom()}
  def text_search(query, opts \\ []) when is_binary(query) do
    provider = MapProvider.get_provider()
    provider.text_search(query, opts)
  end

  @doc """
  Gets a place_id from a place suggestion (helper function).

  This is a convenience function to extract place_id from autocomplete results.

  ## Examples

      {:ok, suggestions} = Places.autocomplete("Kora")
      place_id = Places.place_id_from_suggestion(hd(suggestions))
      # => "place_id_123"

  """
  @spec place_id_from_suggestion(map()) :: String.t() | nil
  def place_id_from_suggestion(suggestion) when is_map(suggestion) do
    Map.get(suggestion, :place_id) || Map.get(suggestion, "place_id")
  end

  @doc """
  Formats a place suggestion for display (helper function).

  ## Examples

      {:ok, suggestions} = Places.autocomplete("Kora")
      formatted = Places.format_suggestion(hd(suggestions))
      # => "Koramangala, Bangalore"

  """
  @spec format_suggestion(map()) :: String.t()
  def format_suggestion(suggestion) when is_map(suggestion) do
    suggestion
    |> Map.get(:description) ||
      suggestion
      |> Map.get("description") ||
      ""
  end
end
