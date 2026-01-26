defmodule MySqrft.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset
  alias MySqrft.Properties.PropertyImage

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "properties" do
    # Asset Details
    field :project_name, :string
    # apartment, villa, independent_house, plot
    field :type, :string
    # bhk, bathrooms, etc.
    field :configuration, :map, default: %{}
    field :status, :string, default: "draft"
    field :address_text, :string

    # Verification
    field :verification_status, :string, default: "unverified"
    field :verified_at, :utc_datetime
    belongs_to :verified_by, MySqrft.UserManagement.Profile

    # Quality Scoring
    field :quality_score, :integer, default: 0
    field :data_completeness_score, :integer, default: 0

    # Location (PostGIS)
    field :location, Geo.PostGIS.Geometry

    # Relationships
    belongs_to :owner, MySqrft.UserManagement.Profile, foreign_key: :owner_id
    belongs_to :city, MySqrft.Geography.City
    belongs_to :locality, MySqrft.Geography.Locality

    has_many :images, PropertyImage, on_delete: :delete_all
    has_many :documents, MySqrft.Properties.PropertyDocument
    has_many :listings, MySqrft.Listings.Listing
    has_many :price_history, MySqrft.Properties.PropertyPriceHistory

    timestamps(type: :utc_datetime)
  end

  @types ~w(apartment villa independent_house plot commercial managed)
  @statuses ~w(draft active archived)
  @verification_statuses ~w(unverified pending verified rejected)

  def changeset(property, attrs) do
    property
    |> cast(attrs, [
      :project_name,
      :type,
      :configuration,
      :status,
      :address_text,
      :location,
      :owner_id,
      :city_id,
      :locality_id
    ])
    |> validate_required([:type, :owner_id, :city_id, :locality_id])
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:status, @statuses)
    |> validate_configuration()
    |> foreign_key_constraint(:owner_id)
    |> foreign_key_constraint(:city_id)
    |> foreign_key_constraint(:locality_id)
  end

  defp validate_configuration(changeset) do
    type = get_field(changeset, :type)
    configuration = get_field(changeset, :configuration) || %{}

    if type do
      case MySqrft.Properties.PropertyTypeValidator.validate_configuration(type, configuration) do
        :ok ->
          changeset

        {:error, errors} ->
          Enum.reduce(errors, changeset, fn {field, message}, acc ->
            add_error(acc, :configuration, "#{field}: #{message}")
          end)
      end
    else
      changeset
    end
  end
end
