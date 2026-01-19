defmodule MySqrft.UserManagement.EmergencyContact do
  @moduledoc """
  EmergencyContact schema - stores emergency contact information.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "emergency_contacts" do
    field :name, :string
    field :relationship, :string
    field :phone, :string
    field :email, :string
    field :priority, :integer, default: 1

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(emergency_contact, attrs) do
    emergency_contact
    |> cast(attrs, [:user_profile_id, :name, :relationship, :phone, :email, :priority])
    |> validate_required([:user_profile_id, :name, :relationship, :phone])
    |> validate_length(:name, min: 1, max: 100)
    |> validate_format(:phone, ~r/^\+[1-9]\d{1,14}$/, message: "must be in international format")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email", allow_nil: true)
    |> validate_number(:priority, greater_than: 0, less_than_or_equal_to: 3)
  end
end
