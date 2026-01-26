defmodule MySqrft.Properties.PropertyImage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "property_images" do
    field :s3_key, :string
    field :type, :string, default: "interior"
    field :is_primary, :boolean, default: false
    field :sort_order, :integer, default: 0
    field :caption, :string

    # Virtual fields for signed URLs
    field :original_url, :string, virtual: true
    field :thumbnail_url, :string, virtual: true
    field :medium_url, :string, virtual: true
    field :large_url, :string, virtual: true

    belongs_to :property, MySqrft.Properties.Property

    timestamps(type: :utc_datetime)
  end

  @types ~w(exterior interior floor_plan site_plan)

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:s3_key, :type, :is_primary, :sort_order, :caption, :property_id])
    |> validate_required([:s3_key, :property_id])
    |> validate_inclusion(:type, @types)
  end
end
