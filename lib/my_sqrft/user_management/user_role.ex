defmodule MySqrft.UserManagement.UserRole do
  @moduledoc """
  UserRole schema - junction table linking users to their roles.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_roles" do
    field :role_specific_data, :map, default: %{}
    field :status, :string, default: "active"
    field :activated_at, :utc_datetime
    field :deactivated_at, :utc_datetime

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id
    belongs_to :role, MySqrft.UserManagement.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_profile_id, :role_id, :role_specific_data, :status, :activated_at, :deactivated_at])
    |> validate_required([:user_profile_id, :role_id, :status])
    |> validate_inclusion(:status, ["active", "inactive", "pending"])
    |> unique_constraint([:user_profile_id, :role_id])
  end

  def activate_changeset(user_role) do
    now = DateTime.utc_now()
    change(user_role, status: "active", activated_at: now, deactivated_at: nil)
  end

  def deactivate_changeset(user_role) do
    now = DateTime.utc_now()
    change(user_role, status: "inactive", deactivated_at: now)
  end
end
