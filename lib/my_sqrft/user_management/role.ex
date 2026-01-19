defmodule MySqrft.UserManagement.Role do
  @moduledoc """
  Role schema - defines available roles on the platform.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "roles" do
    field :name, :string
    field :description, :string
    field :required_fields, :map, default: %{}
    field :permissions, :map, default: %{}
    field :is_active, :boolean, default: true

    has_many :user_roles, MySqrft.UserManagement.UserRole
    has_many :preferences, MySqrft.UserManagement.Preference

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description, :required_fields, :permissions, :is_active])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 50)
    |> unique_constraint(:name)
  end
end
