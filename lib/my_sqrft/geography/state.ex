defmodule MySqrft.Geography.State do
  @moduledoc """
  State schema for geographic hierarchy.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias MySqrft.Geography.{Country, City}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "states" do
    field :code, :string
    field :name, :string
    field :name_alt, :string
    field :status, :string, default: "active"
    field :metadata, :map

    belongs_to :country, Country
    has_many :cities, City

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:code, :name, :name_alt, :status, :metadata, :country_id])
    |> validate_required([:code, :name, :country_id])
    |> validate_inclusion(:status, ["active", "inactive", "deprecated"])
    |> unique_constraint([:country_id, :code])
  end
end
