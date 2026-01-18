defmodule MySqrft.Geography.Country do
  @moduledoc """
  Country schema for geographic hierarchy.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias MySqrft.Geography.State

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "countries" do
    field :code, :string  # ISO 3166-1 alpha-2 code
    field :name, :string
    field :name_alt, :string
    field :currency_code, :string
    field :locale, :string
    field :timezone, :string
    field :status, :string, default: "active"
    field :metadata, :map

    has_many :states, State

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:code, :name, :name_alt, :currency_code, :locale, :timezone, :status, :metadata])
    |> validate_required([:code, :name])
    |> validate_length(:code, is: 2)
    |> validate_length(:currency_code, is: 3)
    |> validate_inclusion(:status, ["active", "inactive", "deprecated"])
    |> unique_constraint(:code)
  end
end
