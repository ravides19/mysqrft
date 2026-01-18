defmodule MySqrft.Geography.LocalityAlias do
  @moduledoc """
  Locality alias schema for name variations.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias MySqrft.Geography.Locality

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "locality_aliases" do
    field :alias, :string
    field :is_primary, :boolean, default: false

    belongs_to :locality, Locality

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(locality_alias, attrs) do
    locality_alias
    |> cast(attrs, [:alias, :is_primary, :locality_id])
    |> validate_required([:alias, :locality_id])
    |> unique_constraint([:locality_id, :alias])
  end
end
