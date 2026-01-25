defmodule MySqrft.UserManagement.Address do
  @moduledoc """
  Address schema - stores user addresses with location details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "addresses" do
    field :label, :string
    field :type, :string
    field :line1, :string
    field :line2, :string
    field :city, :string
    field :locality, :string
    field :landmark, :string
    field :pin_code, :string
    field :state, :string
    field :country, :string, default: "IN"
    field :latitude, :decimal
    field :longitude, :decimal
    field :is_primary, :boolean, default: false

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :user_profile_id,
      :label,
      :type,
      :line1,
      :line2,
      :city,
      :locality,
      :landmark,
      :pin_code,
      :state,
      :country,
      :latitude,
      :longitude,
      :is_primary
    ])
    |> normalize_empty_strings([:label, :type, :line2, :locality, :landmark])
    |> validate_required([:user_profile_id, :type, :line1, :city, :pin_code, :state, :country])
    |> validate_inclusion(:type, ["home", "work", "other"])
    |> validate_length(:label, max: 50)
    |> validate_length(:line1, min: 1, max: 200)
    |> validate_length(:pin_code, min: 5, max: 10)
    |> validate_format(:pin_code, ~r/^\d+$/, message: "must contain only digits")
  end

  # Convert empty strings to nil for optional fields
  defp normalize_empty_strings(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, acc ->
      update_change(acc, field, fn
        "" -> nil
        value -> value
      end)
    end)
  end
end
