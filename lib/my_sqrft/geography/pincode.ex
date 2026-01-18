defmodule MySqrft.Geography.Pincode do
  @moduledoc """
  Pincode schema for postal code management.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias MySqrft.Geography.Locality

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "pincodes" do
    field :code, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :location, Geo.PostGIS.Geometry  # PostGIS point geometry
    field :status, :string, default: "active"

    belongs_to :locality, Locality

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pincode, attrs) do
    pincode
    |> cast(attrs, [:code, :latitude, :longitude, :location, :status, :locality_id])
    |> validate_required([:code, :locality_id])
    |> validate_length(:code, max: 10)
    |> validate_inclusion(:status, ["active", "inactive", "deprecated"])
    |> validate_coordinates()
    |> set_location_from_coordinates()
    |> unique_constraint(:code)
  end

  defp validate_coordinates(changeset) do
    lat = get_field(changeset, :latitude)
    lon = get_field(changeset, :longitude)

    cond do
      is_nil(lat) and is_nil(lon) ->
        changeset

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
