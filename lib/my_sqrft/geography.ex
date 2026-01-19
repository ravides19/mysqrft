defmodule MySqrft.Geography do
  @moduledoc """
  The Geography context for managing geographic and geospatial data.

  This is a Phoenix context that provides high-level functions for geographic
  operations. It handles map provider abstraction internally, so other contexts
  can call these functions without knowing which provider is configured.

  ## Features

  - Geographic hierarchy management (Country, State, City, Locality)
  - Geocoding and reverse geocoding services (with provider abstraction)
  - Location-based search and filtering
  - Address validation
  - Geographic metadata management (pincodes, landmarks)

  ## Provider Abstraction

  Geocoding and reverse geocoding functions automatically use the configured
  map provider (Ola Maps, Google Maps, etc.) as a fallback when internal
  geocoding fails. To change providers, update `:map_provider` config.

  For Places API functions, see `MySqrft.Geography.Places` context.

  ## Example Usage

      alias MySqrft.Geography

      # Geocoding (uses internal DB first, then configured provider)
      {:ok, result} = Geography.geocode_address("Koramangala, Bangalore")

      # Reverse geocoding
      {:ok, result} = Geography.reverse_geocode(12.9352, 77.6245)
  """

  import Ecto.Query, warn: false
  alias MySqrft.Repo

  alias MySqrft.Geography.{
    Country,
    State,
    City,
    Locality,
    LocalityAlias,
    Pincode,
    Landmark,
    GeocodingCache,
    ReverseGeocodingCache
  }

  # ============================================================================
  # FR1: Geographic Hierarchy Management
  # ============================================================================

  ## Countries

  @doc """
  Returns the list of countries.

  ## Examples

      iex> list_countries()
      [%Country{}, ...]

  """
  def list_countries(opts \\ []) do
    status = Keyword.get(opts, :status, "active")

    Country
    |> where([c], c.status == ^status)
    |> order_by([c], asc: c.name)
    |> Repo.all()
  end

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Gets a country by code.

  ## Examples

      iex> get_country_by_code("IN")
      %Country{}

      iex> get_country_by_code("XX")
      nil

  """
  def get_country_by_code(code) when is_binary(code) do
    Repo.get_by(Country, code: code)
  end

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{code: "IN", name: "India"})
      {:ok, %Country{}}

      iex> create_country(%{code: "invalid"})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{name: "new name"})
      {:ok, %Country{}}

      iex> update_country(country, %{code: "invalid"})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  ## States

  @doc """
  Returns the list of states for a country.

  ## Examples

      iex> list_states(country_id)
      [%State{}, ...]

  """
  def list_states(country_id, opts \\ []) do
    status = Keyword.get(opts, :status, "active")

    State
    |> where([s], s.country_id == ^country_id and s.status == ^status)
    |> order_by([s], asc: s.name)
    |> Repo.all()
  end

  @doc """
  Gets a single state.

  Raises `Ecto.NoResultsError` if the State does not exist.
  """
  def get_state!(id), do: Repo.get!(State, id)

  @doc """
  Gets a state by country and code.

  ## Examples

      iex> get_state_by_code(country_id, "KA")
      %State{}

  """
  def get_state_by_code(country_id, code) do
    Repo.get_by(State, country_id: country_id, code: code)
  end

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(%{country_id: country_id, code: "KA", name: "Karnataka"})
      {:ok, %State{}}

  """
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a state.
  """
  def update_state(%State{} = state, attrs) do
    state
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a state.
  """
  def delete_state(%State{} = state) do
    Repo.delete(state)
  end

  ## Cities

  @doc """
  Returns the list of cities for a state.

  ## Examples

      iex> list_cities(state_id)
      [%City{}, ...]

  """
  def list_cities(state_id, opts \\ []) do
    status = Keyword.get(opts, :status, "active")

    City
    |> where([c], c.state_id == ^state_id and c.status == ^status)
    |> order_by([c], asc: c.name)
    |> Repo.all()
  end

  @doc """
  Gets a single city.

  Raises `Ecto.NoResultsError` if the City does not exist.
  """
  def get_city!(id), do: Repo.get!(City, id)

  @doc """
  Gets a city with preloaded state and country.
  """
  def get_city_with_hierarchy!(id) do
    City
    |> preload([:state, state: :country])
    |> Repo.get!(id)
  end

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{state_id: state_id, name: "Bangalore", latitude: 12.9716, longitude: 77.5946})
      {:ok, %City{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a city.
  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a city.
  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  ## Localities

  @doc """
  Returns the list of localities for a city.

  ## Examples

      iex> list_localities(city_id)
      [%Locality{}, ...]

  """
  def list_localities(city_id, opts \\ []) do
    status = Keyword.get(opts, :status, "active")

    Locality
    |> where([l], l.city_id == ^city_id and l.status == ^status)
    |> order_by([l], asc: l.name)
    |> Repo.all()
  end

  @doc """
  Gets a single locality.

  Raises `Ecto.NoResultsError` if the Locality does not exist.
  """
  def get_locality!(id), do: Repo.get!(Locality, id)

  @doc """
  Gets a locality with preloaded city, state, and country.
  """
  def get_locality_with_hierarchy!(id) do
    Locality
    |> preload([:city, city: :state, city: [state: :country]])
    |> Repo.get!(id)
  end

  @doc """
  Gets localities by name (supports aliases).

  ## Examples

      iex> get_localities_by_name(city_id, "Koramangala")
      [%Locality{}, ...]

  """
  def get_localities_by_name(city_id, name) do
    name_lower = String.downcase(name)

    # First, get localities matching by name or name_alt
    direct_matches =
      Locality
      |> where([l], l.city_id == ^city_id and l.status == "active")
      |> where(
        [l],
        fragment("LOWER(?) LIKE ?", l.name, ^"%#{name_lower}%") or
          fragment("LOWER(?) LIKE ?", l.name_alt, ^"%#{name_lower}%")
      )
      |> Repo.all()

    # Then, get localities matching by alias
    alias_matches =
      Locality
      |> join(:inner, [l], la in LocalityAlias, on: l.id == la.locality_id)
      |> where([l, la], l.city_id == ^city_id and l.status == "active")
      |> where([l, la], fragment("LOWER(?) LIKE ?", la.alias, ^"%#{name_lower}%"))
      |> Repo.all()

    # Combine and deduplicate
    (direct_matches ++ alias_matches)
    |> Enum.uniq_by(& &1.id)
  end

  @doc """
  Creates a locality.

  ## Examples

      iex> create_locality(%{city_id: city_id, name: "Koramangala", latitude: 12.9352, longitude: 77.6245})
      {:ok, %Locality{}}

  """
  def create_locality(attrs \\ %{}) do
    %Locality{}
    |> Locality.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a locality.
  """
  def update_locality(%Locality{} = locality, attrs) do
    locality
    |> Locality.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a locality.
  """
  def delete_locality(%Locality{} = locality) do
    Repo.delete(locality)
  end

  ## Locality Aliases

  @doc """
  Creates a locality alias.

  ## Examples

      iex> create_locality_alias(%{locality_id: locality_id, alias: "Kormangala"})
      {:ok, %LocalityAlias{}}

  """
  def create_locality_alias(attrs \\ %{}) do
    %LocalityAlias{}
    |> LocalityAlias.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets all aliases for a locality.
  """
  def list_locality_aliases(locality_id) do
    LocalityAlias
    |> where([la], la.locality_id == ^locality_id)
    |> order_by([la], desc: la.is_primary)
    |> Repo.all()
  end

  @doc """
  Deletes a locality alias.
  """
  def delete_locality_alias(%LocalityAlias{} = alias) do
    Repo.delete(alias)
  end

  # ============================================================================
  # FR7: Geographic Metadata Management (Pincodes and Landmarks)
  # ============================================================================

  ## Pincodes

  @doc """
  Returns the list of pincodes for a locality.
  """
  def list_pincodes(locality_id, opts \\ []) do
    status = Keyword.get(opts, :status, "active")

    Pincode
    |> where([p], p.locality_id == ^locality_id and p.status == ^status)
    |> order_by([p], asc: p.code)
    |> Repo.all()
  end

  @doc """
  Gets a pincode by code.

  ## Examples

      iex> get_pincode_by_code("560001")
      %Pincode{}

  """
  def get_pincode_by_code(code) when is_binary(code) do
    Repo.get_by(Pincode, code: code)
  end

  @doc """
  Creates a pincode.
  """
  def create_pincode(attrs \\ %{}) do
    %Pincode{}
    |> Pincode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pincode.
  """
  def update_pincode(%Pincode{} = pincode, attrs) do
    pincode
    |> Pincode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pincode.
  """
  def delete_pincode(%Pincode{} = pincode) do
    Repo.delete(pincode)
  end

  ## Landmarks

  @doc """
  Returns the list of landmarks for a locality.
  """
  def list_landmarks(locality_id, opts \\ []) do
    status = Keyword.get(opts, :status, "active")
    category = Keyword.get(opts, :category, nil)

    Landmark
    |> where([l], l.locality_id == ^locality_id and l.status == ^status)
    |> maybe_filter_by_category(category)
    |> order_by([l], asc: l.name)
    |> Repo.all()
  end

  defp maybe_filter_by_category(query, nil), do: query
  defp maybe_filter_by_category(query, category), do: where(query, [l], l.category == ^category)

  @doc """
  Gets a single landmark.
  """
  def get_landmark!(id), do: Repo.get!(Landmark, id)

  @doc """
  Creates a landmark.
  """
  def create_landmark(attrs \\ %{}) do
    %Landmark{}
    |> Landmark.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a landmark.
  """
  def update_landmark(%Landmark{} = landmark, attrs) do
    landmark
    |> Landmark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a landmark.
  """
  def delete_landmark(%Landmark{} = landmark) do
    Repo.delete(landmark)
  end

  # ============================================================================
  # Helper Functions
  # ============================================================================

  @doc """
  Gets the complete geographic hierarchy for a locality.

  Returns a map with country, state, city, and locality.
  """
  def get_hierarchy_for_locality(locality_id) do
    Locality
    |> where([l], l.id == ^locality_id)
    |> preload([:city, city: :state, city: [state: :country]])
    |> Repo.one()
    |> case do
      nil ->
        nil

      locality ->
        %{
          country: locality.city.state.country,
          state: locality.city.state,
          city: locality.city,
          locality: locality
        }
    end
  end

  @doc """
  Changeset for country.
  """
  def change_country(%Country{} = country, attrs \\ %{}) do
    Country.changeset(country, attrs)
  end

  @doc """
  Changeset for state.
  """
  def change_state(%State{} = state, attrs \\ %{}) do
    State.changeset(state, attrs)
  end

  @doc """
  Changeset for city.
  """
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end

  @doc """
  Changeset for locality.
  """
  def change_locality(%Locality{} = locality, attrs \\ %{}) do
    Locality.changeset(locality, attrs)
  end

  # ============================================================================
  # FR3 & FR4: Geocoding and Reverse Geocoding Services
  # ============================================================================

  @doc """
  Geocodes an address (converts address to coordinates).

  Returns {:ok, %{latitude: decimal, longitude: decimal, locality_id: id, confidence_score: decimal}}
  or {:error, reason}

  ## Examples

      iex> geocode_address("123 Main St, Koramangala, Bangalore")
      {:ok, %{latitude: 12.9352, longitude: 77.6245, ...}}

  """
  def geocode_address(address) when is_binary(address) do
    # Normalize address for cache lookup
    normalized_address = normalize_address(address)
    address_hash = :crypto.hash(:sha256, normalized_address) |> Base.encode16(case: :lower)

    # Check cache first
    case get_cached_geocode(address_hash) do
      nil ->
        # Perform geocoding (internal or external)
        case perform_geocoding(normalized_address) do
          {:ok, result} ->
            # Cache the result
            cache_geocode(address_hash, normalized_address, result)
            {:ok, result}

          error ->
            error
        end

      cached_result ->
        {:ok, cached_result}
    end
  end

  defp normalize_address(address) do
    address
    |> String.trim()
    |> String.downcase()
    |> String.replace(~r/\s+/, " ")
  end

  defp get_cached_geocode(address_hash) do
    cache =
      GeocodingCache
      |> where([g], g.address_hash == ^address_hash)
      |> where([g], is_nil(g.expires_at) or g.expires_at > ^DateTime.utc_now())
      |> Repo.one()

    if cache do
      %{
        latitude: cache.latitude,
        longitude: cache.longitude,
        locality_id: cache.locality_id,
        formatted_address: cache.formatted_address,
        confidence_score: cache.confidence_score,
        source: cache.source
      }
    else
      nil
    end
  end

  defp perform_geocoding(address) do
    # Try internal geocoding first (pincode or locality name)
    case geocode_by_pincode(address) do
      {:ok, result} ->
        {:ok, result}

      {:error, _} ->
        case geocode_by_locality_name(address) do
          {:ok, result} -> {:ok, result}
          {:error, _} -> geocode_with_ola_maps(address)
        end
    end
  end

  defp geocode_with_ola_maps(address), do: geocode_with_ola_maps(address, [])

  defp geocode_with_ola_maps(address, opts) do
    # Use MapProvider abstraction as fallback if enabled
    if Application.get_env(:my_sqrft, :ola_maps_enabled, false) do
      alias MySqrft.Geography.MapProvider

      provider = MapProvider.get_provider()

      case provider.geocode(address, opts) do
        {:ok, result} ->
          # Persist Ola Maps result to database for frequently used items
          persist_ola_maps_geocoding(address, result)

          # Convert provider result to our format
          {:ok,
           %{
             latitude: result.latitude,
             longitude: result.longitude,
             formatted_address: result[:formatted_address],
             confidence_score: result[:confidence_score] || Decimal.new("80"),
             source: result[:source] || "map_provider"
           }}

        error ->
          error
      end
    else
      {:error, :geocoding_not_available}
    end
  end

  @doc false
  def persist_ola_maps_geocoding(address, result) do
    # Try to match or create locality from Ola Maps result
    # This helps build our internal database with frequently used locations
    try do
      lat = result.latitude
      lon = result.longitude
      address_components = result[:address_components] || %{}

      # Build or find the geographic hierarchy (country -> state -> city -> locality)
      country = find_or_create_country_from_components(address_components)
      state = find_or_create_state_from_components(address_components, country)
      city = find_or_create_city_from_components(address_components, state, lat, lon)

      # Find nearest existing locality within 1km
      point = %Geo.Point{coordinates: {Decimal.to_float(lon), Decimal.to_float(lat)}, srid: 4326}
      radius_meters = 1000

      existing_locality =
        if city do
          Locality
          |> where([l], l.city_id == ^city.id and l.status == "active")
          |> where([l], not is_nil(l.location))
          |> where([l], fragment("ST_DWithin(?, ?, ?)", l.location, ^point, ^radius_meters))
          |> order_by([l], fragment("ST_Distance(?, ?)", l.location, ^point))
          |> limit(1)
          |> Repo.one()
        else
          nil
        end

      if existing_locality do
        # Update existing locality coordinates if they're missing or significantly different
        distance_km =
          if existing_locality.location do
            existing_point = existing_locality.location

            query =
              from(
                _ in Locality,
                select:
                  fragment(
                    "ST_Distance(?::geography, ?::geography) / 1000.0",
                    ^point,
                    ^existing_point
                  )
              )

            Repo.one(query) || 0.0
          else
            999.0
          end

        # Update if coordinates are missing or more than 500m away
        updates = %{}

        updates =
          if is_nil(existing_locality.latitude) or is_nil(existing_locality.longitude) or
               distance_km > 0.5 do
            Map.merge(updates, %{
              latitude: lat,
              longitude: lon,
              location: point
            })
          else
            updates
          end

        # Update metadata with street data and administrative boundaries if missing
        metadata_updates = build_locality_metadata_updates(address_components, existing_locality)

        updates =
          if map_size(metadata_updates) > 0 do
            existing_metadata = existing_locality.metadata || %{}
            Map.put(updates, :metadata, Map.merge(existing_metadata, metadata_updates))
          else
            updates
          end

        # Set locality boundary from viewport if missing and viewport is available
        updates =
          if is_nil(existing_locality.boundary) and address_components[:viewport] do
            case viewport_to_polygon(address_components[:viewport]) do
              %Geo.Polygon{} = polygon ->
                Map.put(updates, :boundary, polygon)

              _ ->
                updates
            end
          else
            updates
          end

        if map_size(updates) > 0 do
          update_locality(existing_locality, updates)
        end

        # Create or update pincode if available
        if pincode_code = address_components[:pincode] do
          find_or_create_pincode(pincode_code, existing_locality, lat, lon)
        end

        # Create landmark if this is a POI
        create_landmark_if_poi(address_components, existing_locality, lat, lon)
      else
        # Create new locality from Ola Maps result
        locality_name =
          address_components[:locality] ||
            extract_locality_name_from_address(result[:formatted_address] || address)

        if locality_name && city do
          # Build metadata with street data and administrative boundaries
          metadata = build_locality_metadata(address_components)

          # Set locality boundary from viewport when available
          boundary =
            case address_components[:viewport] do
              nil -> nil
              viewport -> viewport_to_polygon(viewport)
            end

          locality_attrs =
            %{
              city_id: city.id,
              name: locality_name,
              latitude: lat,
              longitude: lon,
              location: point,
              status: "active",
              metadata: metadata
            }
            |> maybe_put_boundary(boundary)

          case create_locality(locality_attrs) do
            {:ok, new_locality} ->
              # Create pincode if available
              if pincode_code = address_components[:pincode] do
                find_or_create_pincode(pincode_code, new_locality, lat, lon)
              end

              # Create landmark if this is a POI
              create_landmark_if_poi(address_components, new_locality, lat, lon)

            error ->
              require Logger
              Logger.warning("Failed to create locality: #{inspect(error)}")
          end
        end
      end
    rescue
      error ->
        # Log but don't fail geocoding if persistence fails
        require Logger
        Logger.warning("Failed to persist Ola Maps geocoding: #{inspect(error)}")
    end
  end

  defp find_or_create_country_from_components(components) do
    country_name = components[:country]
    country_code = components[:country_code]
    timezone = components[:timezone]
    currency = components[:currency]
    locale = components[:locale]

    cond do
      country_code ->
        # Try to find by code first
        case get_country_by_code(String.upcase(country_code)) do
          nil ->
            # Create country if not found with metadata
            attrs = %{
              code: String.upcase(country_code),
              name: country_name || country_code,
              status: "active"
            }

            attrs =
              attrs
              |> maybe_add_timezone(timezone)
              |> maybe_add_currency(currency)
              |> maybe_add_locale(locale)

            case create_country(attrs) do
              {:ok, country} -> country
              _ -> nil
            end

          country ->
            # Update country metadata if missing
            update_country_metadata(country, timezone, currency, locale)
            country
        end

      country_name ->
        # Try to find by name
        country =
          Country
          |> where([c], fragment("LOWER(?) = ?", c.name, ^String.downcase(country_name)))
          |> Repo.one()

        country ||
          case create_country(%{
                 code: extract_country_code_from_name(country_name),
                 name: country_name,
                 status:
                   "active"
                   |> maybe_add_timezone(timezone)
                   |> maybe_add_currency(currency)
                   |> maybe_add_locale(locale)
               }) do
            {:ok, new_country} -> new_country
            _ -> nil
          end

      true ->
        nil
    end
  end

  defp maybe_add_timezone(attrs, nil), do: attrs

  defp maybe_add_timezone(attrs, timezone) when is_binary(timezone),
    do: Map.put(attrs, :timezone, timezone)

  defp maybe_add_timezone(attrs, _), do: attrs

  defp maybe_add_currency(attrs, nil), do: attrs

  defp maybe_add_currency(attrs, currency) when is_binary(currency),
    do: Map.put(attrs, :currency_code, currency)

  defp maybe_add_currency(attrs, _), do: attrs

  defp maybe_add_locale(attrs, nil), do: attrs
  defp maybe_add_locale(attrs, locale) when is_binary(locale), do: Map.put(attrs, :locale, locale)
  defp maybe_add_locale(attrs, _), do: attrs

  defp update_country_metadata(country, timezone, currency, locale) do
    updates = %{}

    updates =
      if timezone && is_nil(country.timezone),
        do: Map.put(updates, :timezone, timezone),
        else: updates

    updates =
      if currency && is_nil(country.currency_code),
        do: Map.put(updates, :currency_code, currency),
        else: updates

    updates =
      if locale && is_nil(country.locale), do: Map.put(updates, :locale, locale), else: updates

    if map_size(updates) > 0 do
      update_country(country, updates)
    end
  end

  defp find_or_create_state_from_components(components, country) do
    if country do
      state_name = components[:state]
      state_code = components[:state_code]

      cond do
        state_code ->
          case get_state_by_code(country.id, state_code) do
            nil ->
              case create_state(%{
                     country_id: country.id,
                     code: state_code,
                     name: state_name || state_code,
                     status: "active"
                   }) do
                {:ok, state} -> state
                _ -> nil
              end

            state ->
              state
          end

        state_name ->
          state =
            State
            |> where([s], s.country_id == ^country.id)
            |> where([s], fragment("LOWER(?) = ?", s.name, ^String.downcase(state_name)))
            |> Repo.one()

          state ||
            case create_state(%{
                   country_id: country.id,
                   code: extract_state_code_from_name(state_name),
                   name: state_name,
                   status: "active"
                 }) do
              {:ok, new_state} -> new_state
              _ -> nil
            end

        true ->
          nil
      end
    else
      nil
    end
  end

  defp find_or_create_city_from_components(components, state, lat, lon) do
    if state do
      city_name = components[:city]
      timezone = components[:timezone]
      viewport = components[:viewport]

      if city_name do
        city =
          City
          |> where([c], c.state_id == ^state.id)
          |> where([c], fragment("LOWER(?) = ?", c.name, ^String.downcase(city_name)))
          |> Repo.one()

        if city do
          # Update city metadata if missing
          updates = %{}

          updates =
            if timezone && is_nil(city.timezone),
              do: Map.put(updates, :timezone, timezone),
              else: updates

          updates =
            if viewport,
              do: Map.put(updates, :boundary, viewport_to_polygon(viewport)),
              else: updates

          if map_size(updates) > 0 do
            update_city(city, updates)
          end

          city
        else
          attrs = %{
            state_id: state.id,
            name: city_name,
            status: "active"
          }

          attrs =
            if lat do
              Map.put(attrs, :latitude, Decimal.from_float(lat))
            else
              attrs
            end

          attrs =
            if lon do
              Map.put(attrs, :longitude, Decimal.from_float(lon))
            else
              attrs
            end

          attrs = if timezone, do: Map.put(attrs, :timezone, timezone), else: attrs

          attrs =
            if viewport, do: Map.put(attrs, :boundary, viewport_to_polygon(viewport)), else: attrs

          case create_city(attrs) do
            {:ok, new_city} -> new_city
            _ -> nil
          end
        end
      else
        nil
      end
    else
      nil
    end
  end

  defp viewport_to_polygon(viewport) do
    # Convert viewport bounding box to PostGIS polygon
    # Format: POLYGON((lng1 lat1, lng2 lat1, lng2 lat2, lng1 lat2, lng1 lat1))
    ne = viewport[:northeast] || viewport["northeast"]
    sw = viewport[:southwest] || viewport["southwest"]

    if ne && sw do
      ne_lat = ne[:lat] || ne["lat"] || ne[:latitude] || ne["latitude"]
      ne_lng = ne[:lng] || ne["lng"] || ne[:longitude] || ne["longitude"]
      sw_lat = sw[:lat] || sw["lat"] || sw[:latitude] || sw["latitude"]
      sw_lng = sw[:lng] || sw["lng"] || sw[:longitude] || sw["longitude"]

      if ne_lat && ne_lng && sw_lat && sw_lng do
        # Create a rectangle polygon from bounding box
        coordinates = [
          {sw_lng, sw_lat},
          {ne_lng, sw_lat},
          {ne_lng, ne_lat},
          {sw_lng, ne_lat},
          {sw_lng, sw_lat}
        ]

        %Geo.Polygon{coordinates: [coordinates], srid: 4326}
      else
        nil
      end
    else
      nil
    end
  end

  defp find_or_create_pincode(pincode_code, locality, lat, lon) do
    # Check if pincode already exists
    case get_pincode_by_code(pincode_code) do
      nil ->
        # Create new pincode
        create_pincode(%{
          locality_id: locality.id,
          code: pincode_code,
          latitude: if(lat, do: Decimal.from_float(lat)),
          longitude: if(lon, do: Decimal.from_float(lon)),
          status: "active"
        })

      existing_pincode ->
        # Update locality association if different
        if existing_pincode.locality_id != locality.id do
          update_pincode(existing_pincode, %{locality_id: locality.id})
        end

        {:ok, existing_pincode}
    end
  end

  defp extract_country_code_from_name(name) do
    # Default to "IN" for India, can be enhanced with a mapping
    # For now, return "IN" as default, can be enhanced with country name to code mapping
    # Acknowledge parameter but use default
    _ = name
    "IN"
  end

  defp extract_state_code_from_name(name) do
    # Generate a simple code from name (first 2 uppercase letters)
    # Can be enhanced with proper state code mapping
    String.slice(String.upcase(name), 0, 2)
  end

  defp build_locality_metadata(components) do
    # Build comprehensive metadata from Ola Maps response
    base_metadata = %{
      source: "ola_maps",
      imported_at: DateTime.utc_now(),
      confidence: "medium"
    }

    base_metadata
    |> add_street_metadata(components)
    |> add_administrative_metadata(components)
    |> add_place_type_metadata(components)
    |> add_viewport_metadata(components)
  end

  defp build_locality_metadata_updates(components, locality) do
    # Build metadata updates for existing locality (only add missing fields)
    existing_metadata = locality.metadata || %{}
    updates = %{}

    updates =
      if is_nil(existing_metadata["street"]) && components[:street] do
        Map.put(updates, "street", components[:street])
      else
        updates
      end

    updates =
      if is_nil(existing_metadata["street_number"]) && components[:street_number] do
        Map.put(updates, "street_number", components[:street_number])
      else
        updates
      end

    updates =
      if is_nil(existing_metadata["ward"]) && components[:ward] do
        Map.put(updates, "ward", components[:ward])
      else
        updates
      end

    updates =
      if is_nil(existing_metadata["zone"]) && components[:zone] do
        Map.put(updates, "zone", components[:zone])
      else
        updates
      end

    updates =
      if is_nil(existing_metadata["district"]) && components[:district] do
        Map.put(updates, "district", components[:district])
      else
        updates
      end

    updates
  end

  defp maybe_put_boundary(attrs, nil), do: attrs

  defp maybe_put_boundary(attrs, %Geo.Polygon{} = boundary) do
    Map.put(attrs, :boundary, boundary)
  end

  defp add_street_metadata(metadata, components) do
    metadata
    |> maybe_add_metadata("street", components[:street])
    |> maybe_add_metadata("street_number", components[:street_number])
    |> maybe_add_metadata("building", components[:building])
  end

  defp add_administrative_metadata(metadata, components) do
    metadata
    |> maybe_add_metadata("ward", components[:ward])
    |> maybe_add_metadata("zone", components[:zone])
    |> maybe_add_metadata("district", components[:district])
    |> maybe_add_metadata("neighborhood", components[:neighborhood])
  end

  defp add_place_type_metadata(metadata, components) do
    metadata =
      if components[:place_types] && length(components[:place_types]) > 0 do
        Map.put(metadata, "place_types", components[:place_types])
      else
        metadata
      end

    if components[:place_type] do
      Map.put(metadata, "place_type", components[:place_type])
    else
      metadata
    end
  end

  defp add_viewport_metadata(metadata, components) do
    if components[:viewport] do
      Map.put(metadata, "viewport", components[:viewport])
    else
      metadata
    end
  end

  defp maybe_add_metadata(metadata, _key, nil), do: metadata

  defp maybe_add_metadata(metadata, key, value) when not is_nil(value),
    do: Map.put(metadata, key, value)

  defp maybe_add_metadata(metadata, _key, _value), do: metadata

  defp create_landmark_if_poi(components, locality, lat, lon) do
    # Check if this is a Point of Interest (not just an address)
    place_name = components[:place_name]
    place_types = components[:place_types] || []

    # Determine if this is a POI (has establishment/point_of_interest types or specific place name)
    is_poi =
      Enum.any?(place_types, fn type ->
        type in [
          "establishment",
          "point_of_interest",
          "restaurant",
          "hospital",
          "school",
          "shopping_mall",
          "metro_station",
          "bank",
          "atm",
          "gas_station"
        ]
      end) || (place_name && place_name != locality.name)

    if is_poi && place_name do
      # Determine category from place types
      category =
        Enum.find(place_types, fn type ->
          type in [
            "shopping_mall",
            "metro_station",
            "hospital",
            "school",
            "restaurant",
            "bank",
            "atm",
            "gas_station"
          ]
        end) || "point_of_interest"

      # Check if landmark already exists
      existing_landmark =
        Landmark
        |> where([lm], lm.locality_id == ^locality.id)
        |> where([lm], fragment("LOWER(?) = ?", lm.name, ^String.downcase(place_name)))
        |> Repo.one()

      if is_nil(existing_landmark) do
        create_landmark(%{
          locality_id: locality.id,
          name: place_name,
          category: category,
          latitude: lat,
          longitude: lon,
          status: "active",
          metadata: %{
            source: "ola_maps",
            place_types: place_types,
            imported_at: DateTime.utc_now()
          }
        })
      end
    end
  end

  # Place name extraction - kept for future use when place_name is not in components
  # defp extract_place_name_from_address(nil), do: nil
  #
  # defp extract_place_name_from_address(address) when is_binary(address) do
  #   # Try to extract place name from formatted address
  #   # This is a simple heuristic - can be enhanced
  #   parts = String.split(address, ",")
  #
  #   if length(parts) > 0 do
  #     first_part = hd(parts) |> String.trim()
  #
  #     # If first part looks like a place name (not a street number), return it
  #     if not Regex.match?(~r/^\d+/, first_part) && String.length(first_part) > 3 do
  #       first_part
  #     else
  #       nil
  #     end
  #   else
  #     nil
  #   end
  # end

  defp extract_locality_name_from_address(address) when is_binary(address) do
    # Simple extraction - try to get first part before comma
    # This can be enhanced with better parsing
    case String.split(address, ",") do
      [first | _] ->
        first
        |> String.trim()
        |> case do
          "" -> nil
          name -> name
        end

      _ ->
        nil
    end
  end

  defp extract_locality_name_from_address(_), do: nil

  defp geocode_by_pincode(address) do
    # Extract pincode from address (6-digit number)
    pincode_match = Regex.run(~r/\b(\d{6})\b/, address)

    if pincode_match do
      pincode = Enum.at(pincode_match, 1)

      case get_pincode_by_code(pincode) do
        nil ->
          {:error, :pincode_not_found}

        pincode_record ->
          pincode_record = Repo.preload(pincode_record, :locality)
          locality = pincode_record.locality

          if locality && locality.location do
            {:ok,
             %{
               latitude: locality.latitude,
               longitude: locality.longitude,
               locality_id: locality.id,
               formatted_address: format_address_from_locality(locality),
               confidence_score: Decimal.new("85"),
               source: "internal"
             }}
          else
            {:error, :no_coordinates}
          end
      end
    else
      {:error, :no_pincode}
    end
  end

  defp geocode_by_locality_name(address) do
    # Try to find locality by name in the address
    # This is a simple implementation - can be enhanced with better parsing
    address_lower = String.downcase(address)

    # Search for localities that match the address
    locality =
      Locality
      |> where([l], l.status == "active")
      |> where([l], not is_nil(l.location))
      |> preload([:city, city: :state])
      |> Repo.all()
      |> Enum.find(fn locality ->
        locality_name_lower = String.downcase(locality.name)
        String.contains?(address_lower, locality_name_lower)
      end)

    if locality do
      {:ok,
       %{
         latitude: locality.latitude,
         longitude: locality.longitude,
         locality_id: locality.id,
         formatted_address: format_address_from_locality(locality),
         confidence_score: Decimal.new("70"),
         source: "internal"
       }}
    else
      {:error, :locality_not_found}
    end
  end

  defp format_address_from_locality(locality) do
    # Preload associations if not already loaded
    locality =
      if Ecto.assoc_loaded?(locality.city) do
        locality
      else
        Repo.preload(locality, city: :state)
      end

    city = locality.city

    city =
      if city && Ecto.assoc_loaded?(city.state) do
        city
      else
        Repo.preload(city, :state)
      end

    state = city.state

    [locality.name, city.name, state.name]
    |> Enum.filter(& &1)
    |> Enum.join(", ")
  end

  defp cache_geocode(address_hash, address, result) do
    expires_at = DateTime.utc_now() |> DateTime.add(90, :day)

    attrs = %{
      address_hash: address_hash,
      address: address,
      latitude: result.latitude,
      longitude: result.longitude,
      formatted_address: result[:formatted_address],
      locality_id: result[:locality_id],
      confidence_score: result[:confidence_score] || Decimal.new("100"),
      source: result[:source] || "internal",
      expires_at: expires_at
    }

    %GeocodingCache{}
    |> GeocodingCache.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, _cache} -> :ok
      # Ignore cache errors
      {:error, _changeset} -> :ok
    end
  end

  @doc """
  Reverse geocodes coordinates (converts coordinates to address).

  Returns {:ok, %{formatted_address: string, locality_id: id, nearest_landmark_id: id}}
  or {:error, reason}

  ## Examples

      iex> reverse_geocode(12.9352, 77.6245)
      {:ok, %{formatted_address: "Koramangala, Bangalore", ...}}

  """
  def reverse_geocode(latitude, longitude) when is_number(latitude) and is_number(longitude) do
    # Round coordinates to 4 decimal places for cache lookup (~11 meters precision)
    lat_rounded = Decimal.from_float(latitude) |> Decimal.round(4)
    lon_rounded = Decimal.from_float(longitude) |> Decimal.round(4)

    # Check cache first
    case get_cached_reverse_geocode(lat_rounded, lon_rounded) do
      nil ->
        # Perform reverse geocoding
        case perform_reverse_geocoding(latitude, longitude) do
          {:ok, result} ->
            # Cache the result
            cache_reverse_geocode(lat_rounded, lon_rounded, result)
            {:ok, result}

          error ->
            error
        end

      cached_result ->
        {:ok, cached_result}
    end
  end

  defp get_cached_reverse_geocode(latitude, longitude) do
    cache =
      ReverseGeocodingCache
      |> where([r], r.latitude == ^latitude and r.longitude == ^longitude)
      |> where([r], is_nil(r.expires_at) or r.expires_at > ^DateTime.utc_now())
      |> Repo.one()

    if cache do
      %{
        formatted_address: cache.formatted_address,
        locality_id: cache.locality_id,
        nearest_landmark_id: cache.nearest_landmark_id,
        source: cache.source
      }
    else
      nil
    end
  end

  defp perform_reverse_geocoding(latitude, longitude) do
    # Find nearest locality using PostGIS
    point = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}

    locality =
      Locality
      |> where([l], l.status == "active")
      |> where([l], not is_nil(l.location))
      |> order_by([l], fragment("ST_Distance(?, ?)", l.location, ^point))
      |> limit(1)
      |> Repo.one()

    if locality do
      # Find nearest landmark
      nearest_landmark =
        Landmark
        |> where([lm], lm.locality_id == ^locality.id and lm.status == "active")
        |> where([lm], not is_nil(lm.location))
        |> order_by([lm], fragment("ST_Distance(?, ?)", lm.location, ^point))
        |> limit(1)
        |> Repo.one()

      hierarchy = get_hierarchy_for_locality(locality.id)

      formatted_address =
        format_address_from_hierarchy(hierarchy, locality)

      {:ok,
       %{
         formatted_address: formatted_address,
         locality_id: locality.id,
         nearest_landmark_id: if(nearest_landmark, do: nearest_landmark.id, else: nil),
         source: "internal"
       }}
    else
      # Fallback to MapProvider if internal reverse geocoding fails
      reverse_geocode_with_ola_maps(latitude, longitude)
    end
  end

  defp reverse_geocode_with_ola_maps(latitude, longitude),
    do: reverse_geocode_with_ola_maps(latitude, longitude, [])

  defp reverse_geocode_with_ola_maps(latitude, longitude, opts) do
    # Use MapProvider abstraction as fallback if enabled
    if Application.get_env(:my_sqrft, :ola_maps_enabled, false) do
      alias MySqrft.Geography.MapProvider

      provider = MapProvider.get_provider()

      case provider.reverse_geocode(latitude, longitude, opts) do
        {:ok, result} ->
          # Persist reverse geocoding result to database
          persist_ola_maps_reverse_geocoding(latitude, longitude, result)

          {:ok,
           %{
             formatted_address: result[:formatted_address],
             source: result[:source] || "map_provider"
           }}

        error ->
          error
      end
    else
      {:error, :reverse_geocoding_not_available}
    end
  end

  defp persist_ola_maps_reverse_geocoding(latitude, longitude, result) do
    # Similar to geocoding persistence, but for reverse geocoding
    try do
      address_components = result[:address_components] || %{}

      # Build or find the geographic hierarchy (country -> state -> city -> locality)
      country = find_or_create_country_from_components(address_components)
      state = find_or_create_state_from_components(address_components, country)
      city = find_or_create_city_from_components(address_components, state, latitude, longitude)

      point = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}
      radius_meters = 1000

      # Find nearest existing locality
      existing_locality =
        if city do
          Locality
          |> where([l], l.city_id == ^city.id and l.status == "active")
          |> where([l], not is_nil(l.location))
          |> where([l], fragment("ST_DWithin(?, ?, ?)", l.location, ^point, ^radius_meters))
          |> order_by([l], fragment("ST_Distance(?, ?)", l.location, ^point))
          |> limit(1)
          |> Repo.one()
        else
          nil
        end

      if existing_locality do
        # Update coordinates if missing or significantly different
        distance_km =
          if existing_locality.location do
            existing_point = existing_locality.location

            query =
              from(
                _ in Locality,
                select:
                  fragment(
                    "ST_Distance(?::geography, ?::geography) / 1000.0",
                    ^point,
                    ^existing_point
                  )
              )

            Repo.one(query) || 0.0
          else
            999.0
          end

        if is_nil(existing_locality.latitude) or is_nil(existing_locality.longitude) or
             distance_km > 0.5 do
          update_locality(
            existing_locality,
            %{
              latitude: Decimal.from_float(latitude),
              longitude: Decimal.from_float(longitude),
              location: point
            }
          )
        end

        # Create or update pincode if available
        if pincode_code = address_components[:pincode] do
          find_or_create_pincode(pincode_code, existing_locality, latitude, longitude)
        end
      else
        # Create new locality from reverse geocoding result
        formatted_address = result[:formatted_address] || ""

        locality_name =
          address_components[:locality] ||
            extract_locality_name_from_address(formatted_address)

        if locality_name && city do
          case create_locality(%{
                 city_id: city.id,
                 name: locality_name,
                 latitude: Decimal.from_float(latitude),
                 longitude: Decimal.from_float(longitude),
                 location: point,
                 status: "active",
                 metadata: %{
                   source: "ola_maps_reverse",
                   imported_at: DateTime.utc_now(),
                   confidence: "medium",
                   formatted_address: formatted_address
                 }
               }) do
            {:ok, new_locality} ->
              # Create pincode if available
              if pincode_code = address_components[:pincode] do
                find_or_create_pincode(pincode_code, new_locality, latitude, longitude)
              end

            error ->
              require Logger

              Logger.warning(
                "Failed to create locality from reverse geocoding: #{inspect(error)}"
              )
          end
        end
      end
    rescue
      error ->
        require Logger
        Logger.warning("Failed to persist Ola Maps reverse geocoding: #{inspect(error)}")
    end
  end

  defp format_address_from_hierarchy(hierarchy, locality) do
    parts = [
      locality.name,
      hierarchy.city.name,
      hierarchy.state.name,
      hierarchy.country.name
    ]

    Enum.join(Enum.filter(parts, & &1), ", ")
  end

  defp cache_reverse_geocode(latitude, longitude, result) do
    expires_at = DateTime.utc_now() |> DateTime.add(90, :day)

    point = %Geo.Point{
      coordinates: {Decimal.to_float(longitude), Decimal.to_float(latitude)},
      srid: 4326
    }

    attrs = %{
      latitude: latitude,
      longitude: longitude,
      location: point,
      formatted_address: result.formatted_address,
      locality_id: result[:locality_id],
      nearest_landmark_id: result[:nearest_landmark_id],
      source: result[:source] || "internal",
      expires_at: expires_at
    }

    %ReverseGeocodingCache{}
    |> ReverseGeocodingCache.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, _cache} -> :ok
      # Ignore cache errors
      {:error, _changeset} -> :ok
    end
  end

  # ============================================================================
  # FR5: Location-Based Search and Filtering
  # ============================================================================

  @doc """
  Finds localities within a radius (in kilometers) of a point.

  ## Examples

      iex> find_localities_within_radius(12.9716, 77.5946, 5.0)
      [%Locality{}, ...]

  """
  def find_localities_within_radius(latitude, longitude, radius_km) do
    point = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}
    radius_meters = radius_km * 1000

    Locality
    |> where([l], l.status == "active")
    |> where([l], not is_nil(l.location))
    |> where([l], fragment("ST_DWithin(?, ?, ?)", l.location, ^point, ^radius_meters))
    |> order_by([l], fragment("ST_Distance(?, ?)", l.location, ^point))
    |> Repo.all()
  end

  @doc """
  Calculates distance between two points in kilometers.

  Uses Haversine formula via PostGIS.

  ## Examples

      iex> calculate_distance(12.9716, 77.5946, 12.9352, 77.6245)
      #Decimal<4.5>

  """
  def calculate_distance(lat1, lon1, lat2, lon2) do
    point1 = %Geo.Point{coordinates: {lon1, lat1}, srid: 4326}
    point2 = %Geo.Point{coordinates: {lon2, lat2}, srid: 4326}

    # Use PostGIS ST_Distance with geography type for accurate distance calculation
    query =
      from(
        _ in Locality,
        select: fragment("ST_Distance(?::geography, ?::geography) / 1000.0", ^point1, ^point2)
      )

    result = Repo.one(query)
    Decimal.from_float(result || 0.0)
  end

  @doc """
  Checks if coordinates fall within a city boundary.

  ## Examples

      iex> coordinates_in_city?(12.9716, 77.5946, city_id)
      true

  """
  def coordinates_in_city?(latitude, longitude, city_id) do
    point = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}

    city =
      City
      |> where([c], c.id == ^city_id)
      |> where([c], not is_nil(c.boundary))
      |> Repo.one()

    if city do
      # Check if point is within city boundary using PostGIS
      query =
        from(
          c in City,
          where: c.id == ^city_id,
          select: fragment("ST_Within(?, ?)", ^point, c.boundary)
        )

      Repo.one(query) || false
    else
      false
    end
  end

  @doc """
  Checks if coordinates fall within a locality boundary.

  ## Examples

      iex> coordinates_in_locality?(12.9352, 77.6245, locality_id)
      true

  """
  def coordinates_in_locality?(latitude, longitude, locality_id) do
    point = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}

    locality =
      Locality
      |> where([l], l.id == ^locality_id)
      |> where([l], not is_nil(l.boundary))
      |> Repo.one()

    if locality do
      # Check if point is within locality boundary using PostGIS
      query =
        from(
          l in Locality,
          where: l.id == ^locality_id,
          select: fragment("ST_Within(?, ?)", ^point, l.boundary)
        )

      Repo.one(query) || false
    else
      false
    end
  end

  # ============================================================================
  # FR6: Address Validation
  # ============================================================================

  @doc """
  Validates an address against the geographic hierarchy.

  Returns {:ok, validated_address} or {:error, errors}

  ## Examples

      iex> validate_address(%{street: "123 Main St", locality: "Koramangala", city: "Bangalore", pincode: "560001"})
      {:ok, %{...}}

  """
  def validate_address(attrs) do
    errors = []

    # Validate pincode if provided
    errors =
      if pincode = Map.get(attrs, :pincode) do
        case get_pincode_by_code(pincode) do
          nil ->
            errors ++ [pincode: "invalid pincode"]

          pincode_record ->
            # Validate locality matches pincode
            locality_id = Map.get(attrs, :locality_id)

            if locality_id && pincode_record.locality_id != locality_id do
              errors ++ [pincode: "pincode does not match locality"]
            else
              errors
            end
        end
      else
        errors
      end

    # Validate locality if provided
    errors =
      if locality_id = Map.get(attrs, :locality_id) do
        try do
          locality = get_locality!(locality_id)

          # Validate city matches locality
          city_id = Map.get(attrs, :city_id)

          if city_id && locality.city_id != city_id do
            errors ++ [locality: "locality does not match city"]
          else
            errors
          end
        rescue
          Ecto.NoResultsError ->
            errors ++ [locality: "locality not found"]
        end
      else
        errors
      end

    if Enum.empty?(errors) do
      {:ok, attrs}
    else
      {:error, errors}
    end
  end

  @doc """
  Standardizes an address format.

  Returns a standardized address map.

  ## Examples

      iex> standardize_address(%{street: "123 Main St", locality: "koramangala", city: "bangalore"})
      %{street: "123 Main St", locality: "Koramangala", city: "Bangalore", ...}

  """
  def standardize_address(attrs) do
    attrs
    |> standardize_locality_name()
    |> standardize_city_name()
  end

  defp standardize_locality_name(attrs) do
    if locality_name = Map.get(attrs, :locality) do
      # Try to find matching locality and use canonical name
      city_id = Map.get(attrs, :city_id)

      if city_id do
        case get_localities_by_name(city_id, locality_name) do
          [locality | _] ->
            Map.put(attrs, :locality, locality.name)
            |> Map.put(:locality_id, locality.id)

          _ ->
            attrs
        end
      else
        attrs
      end
    else
      attrs
    end
  end

  defp standardize_city_name(attrs) do
    if city_name = Map.get(attrs, :city) do
      # Try to find matching city and use canonical name
      state_id = Map.get(attrs, :state_id)

      if state_id do
        cities = list_cities(state_id)

        case Enum.find(cities, fn c -> String.downcase(c.name) == String.downcase(city_name) end) do
          nil ->
            attrs

          city ->
            Map.put(attrs, :city, city.name)
            |> Map.put(:city_id, city.id)
        end
      else
        attrs
      end
    else
      attrs
    end
  end
end
