defmodule MySqrft.Repo.Migrations.CreatePropertiesTables do
  use Ecto.Migration

  def change do
    # Properties Table
    create table(:properties, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :owner_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all),
        null: false

      # Geography Linkage
      add :city_id, references(:cities, type: :binary_id), null: false
      add :locality_id, references(:localities, type: :binary_id), null: false
      # PostGIS Point
      add :location, :geometry
      add :address_text, :string

      # Asset Details
      add :project_name, :string
      # apartment, villa, etc.
      add :type, :string, null: false
      # Generic map for 2BHK, Area, etc.
      add :configuration, :map, default: "{}"
      # draft, active, archived
      add :status, :string, default: "draft"

      timestamps(type: :utc_datetime)
    end

    create index(:properties, [:owner_id])
    create index(:properties, [:city_id])
    create index(:properties, [:locality_id])
    create index(:properties, [:location], using: :gist)

    # Property Images Table
    create table(:property_images, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :property_id, references(:properties, type: :binary_id, on_delete: :delete_all),
        null: false

      # Tigris/S3 Data
      add :s3_key, :string, null: false

      # Metadata
      # exterior, interior, floor_plan
      add :type, :string, default: "interior"
      add :is_primary, :boolean, default: false
      add :sort_order, :integer, default: 0
      add :caption, :string

      timestamps(type: :utc_datetime)
    end

    create index(:property_images, [:property_id])
    create index(:property_images, [:property_id, :is_primary])
  end
end
