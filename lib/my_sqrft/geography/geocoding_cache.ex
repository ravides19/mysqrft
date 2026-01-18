defmodule MySqrft.Geography.GeocodingCache do
  @moduledoc """
  Geocoding cache schema for performance optimization.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias MySqrft.Geography.Locality

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "geocoding_cache" do
    field :address_hash, :string
    field :address, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :location, Geo.PostGIS.Geometry  # PostGIS point geometry
    field :formatted_address, :string
    field :confidence_score, :decimal
    field :source, :string  # "internal", "google", "mapbox", etc.
    field :expires_at, :utc_datetime

    belongs_to :locality, Locality

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(geocoding_cache, attrs) do
    geocoding_cache
    |> cast(attrs, [:address_hash, :address, :latitude, :longitude, :location, :formatted_address, :confidence_score, :source, :expires_at, :locality_id])
    |> validate_required([:address_hash, :address, :latitude, :longitude, :location])
    |> validate_coordinates()
    |> set_location_from_coordinates()
    |> unique_constraint(:address_hash)
  end

  defp validate_coordinates(changeset) do
    lat = get_field(changeset, :latitude)
    lon = get_field(changeset, :longitude)

    cond do
      is_nil(lat) or is_nil(lon) ->
        add_error(changeset, :coordinates, "both latitude and longitude must be provided")

      Decimal.lt?(lat, Decimal.new("-90")) or Decimal.gt?(lat, Decimal.new("90")) ->
        add_error(changeset, :latitude, "must be between -90 and 90")

      Decimal.lt?(lon, Decimal.new("-180")) or Decimal.gt?(lon, Decimal.new("180")) ->
        add_error(changeset, :longitude, "must be between -180 and 180")

      true ->
        changeset
    end
  end

  defp set_location_from_coordinates(changeset) do
    lat = get_field(changeset, :latitude)
    lon = get_field(changeset, :longitude)
    location = get_field(changeset, :location)

    cond do
      not is_nil(lat) and not is_nil(lon) and is_nil(location) ->
        point = %Geo.Point{coordinates: {Decimal.to_float(lon), Decimal.to_float(lat)}, srid: 4326}
        put_change(changeset, :location, point)

      true ->
        changeset
    end
  end
end
