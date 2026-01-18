defmodule MySqrft.Repo.Migrations.CreateGeographyTables do
  use Ecto.Migration

  def change do
    # Enable PostGIS extension for geospatial data
    execute "CREATE EXTENSION IF NOT EXISTS postgis", ""
    execute "CREATE EXTENSION IF NOT EXISTS postgis_topology", ""

    # Countries table
    create table(:countries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :code, :string, null: false, size: 2  # ISO 3166-1 alpha-2 code (e.g., "IN", "US")
      add :name, :string, null: false
      add :name_alt, :string  # Alternate name
      add :currency_code, :string, size: 3  # ISO 4217 currency code
      add :locale, :string, size: 10  # Default locale (e.g., "en-IN", "en-US")
      add :timezone, :string  # Default timezone (e.g., "Asia/Kolkata")
      add :status, :string, default: "active", null: false  # active, inactive, deprecated
      add :metadata, :jsonb  # Additional country-specific metadata

      timestamps(type: :utc_datetime)
    end

    create unique_index(:countries, [:code])
    create index(:countries, [:status])
    create index(:countries, [:name])

    # States table
    create table(:states, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :country_id, references(:countries, type: :binary_id, on_delete: :restrict), null: false
      add :code, :string, null: false  # State code (e.g., "KA" for Karnataka)
      add :name, :string, null: false
      add :name_alt, :string  # Alternate name
      add :status, :string, default: "active", null: false
      add :metadata, :jsonb

      timestamps(type: :utc_datetime)
    end

    create unique_index(:states, [:country_id, :code])
    create index(:states, [:country_id])
    create index(:states, [:status])
    create index(:states, [:name])

    # Cities table
    create table(:cities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state_id, references(:states, type: :binary_id, on_delete: :restrict), null: false
      add :name, :string, null: false
      add :name_alt, :string  # Alternate name
      add :latitude, :decimal, precision: 10, scale: 7  # City center coordinates
      add :longitude, :decimal, precision: 10, scale: 7
      add :location, :geometry  # PostGIS point geometry for city center
      add :boundary, :geometry  # PostGIS polygon geometry for city boundary
      add :timezone, :string  # City-specific timezone
      add :status, :string, default: "active", null: false
      add :metadata, :jsonb  # City-specific metadata (population, area, etc.)

      timestamps(type: :utc_datetime)
    end

    create index(:cities, [:state_id])
    create index(:cities, [:status])
    create index(:cities, [:name])
    create index(:cities, [:location], using: "GIST")  # Spatial index for location
    create index(:cities, [:boundary], using: "GIST")  # Spatial index for boundary

    # Localities table
    create table(:localities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :city_id, references(:cities, type: :binary_id, on_delete: :restrict), null: false
      add :name, :string, null: false
      add :name_alt, :string  # Alternate name
      add :latitude, :decimal, precision: 10, scale: 7  # Locality center coordinates
      add :longitude, :decimal, precision: 10, scale: 7
      add :location, :geometry  # PostGIS point geometry for locality center
      add :boundary, :geometry  # PostGIS polygon geometry for locality boundary
      add :status, :string, default: "active", null: false
      add :metadata, :jsonb  # Locality-specific metadata

      timestamps(type: :utc_datetime)
    end

    create index(:localities, [:city_id])
    create index(:localities, [:status])
    create index(:localities, [:name])
    create index(:localities, [:location], using: "GIST")  # Spatial index
    create index(:localities, [:boundary], using: "GIST")  # Spatial index

    # Locality aliases table for name variations
    create table(:locality_aliases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :locality_id, references(:localities, type: :binary_id, on_delete: :delete_all), null: false
      add :alias, :string, null: false
      add :is_primary, :boolean, default: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:locality_aliases, [:locality_id, :alias])
    create index(:locality_aliases, [:locality_id])
    create index(:locality_aliases, [:alias])

    # Pincodes table
    create table(:pincodes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :locality_id, references(:localities, type: :binary_id, on_delete: :restrict), null: false
      add :code, :string, null: false, size: 10  # Pincode (e.g., "560001")
      add :latitude, :decimal, precision: 10, scale: 7
      add :longitude, :decimal, precision: 10, scale: 7
      add :location, :geometry  # PostGIS point geometry
      add :status, :string, default: "active", null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:pincodes, [:code])
    create index(:pincodes, [:locality_id])
    create index(:pincodes, [:status])
    create index(:pincodes, [:location], using: "GIST")  # Spatial index

    # Landmarks table
    create table(:landmarks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :locality_id, references(:localities, type: :binary_id, on_delete: :restrict), null: false
      add :name, :string, null: false
      add :name_alt, :string
      add :category, :string  # e.g., "shopping_mall", "metro_station", "hospital", "school"
      add :latitude, :decimal, precision: 10, scale: 7
      add :longitude, :decimal, precision: 10, scale: 7
      add :location, :geometry  # PostGIS point geometry
      add :status, :string, default: "active", null: false
      add :metadata, :jsonb  # Additional landmark metadata

      timestamps(type: :utc_datetime)
    end

    create index(:landmarks, [:locality_id])
    create index(:landmarks, [:status])
    create index(:landmarks, [:name])
    create index(:landmarks, [:category])
    create index(:landmarks, [:location], using: "GIST")  # Spatial index

    # Geocoding cache table for performance
    create table(:geocoding_cache, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :address_hash, :string, null: false  # Hash of normalized address
      add :address, :text, null: false  # Original address
      add :latitude, :decimal, precision: 10, scale: 7, null: false
      add :longitude, :decimal, precision: 10, scale: 7, null: false
      add :location, :geometry, null: false  # PostGIS point
      add :formatted_address, :text
      add :locality_id, references(:localities, type: :binary_id, on_delete: :nilify_all)
      add :confidence_score, :decimal, precision: 5, scale: 2  # 0-100
      add :source, :string  # "internal", "google", "mapbox", etc.
      add :expires_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:geocoding_cache, [:address_hash])
    create index(:geocoding_cache, [:locality_id])
    create index(:geocoding_cache, [:expires_at])
    create index(:geocoding_cache, [:location], using: "GIST")  # Spatial index

    # Reverse geocoding cache table
    create table(:reverse_geocoding_cache, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :latitude, :decimal, precision: 10, scale: 7, null: false
      add :longitude, :decimal, precision: 10, scale: 7, null: false
      add :location, :geometry, null: false  # PostGIS point
      add :formatted_address, :text, null: false
      add :locality_id, references(:localities, type: :binary_id, on_delete: :nilify_all)
      add :nearest_landmark_id, references(:landmarks, type: :binary_id, on_delete: :nilify_all)
      add :source, :string
      add :expires_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:reverse_geocoding_cache, [:latitude, :longitude])
    create index(:reverse_geocoding_cache, [:locality_id])
    create index(:reverse_geocoding_cache, [:expires_at])
    create index(:reverse_geocoding_cache, [:location], using: "GIST")  # Spatial index
  end
end
