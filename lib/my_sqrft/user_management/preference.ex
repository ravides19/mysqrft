defmodule MySqrft.UserManagement.Preference do
  @moduledoc """
  Preference schema - stores user preferences of various types.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "preferences" do
    field :category, :string
    field :key, :string
    field :value, MySqrft.Type.AnyJSON

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id
    belongs_to :role, MySqrft.UserManagement.Role

    timestamps(type: :utc_datetime, updated_at: true)
  end

  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, [:user_profile_id, :role_id, :category, :key, :value])
    |> validate_required([:user_profile_id, :category, :key, :value])
    |> validate_inclusion(:category, ["search", "lifestyle", "communication", "notification"])
    |> unique_constraint([:user_profile_id, :role_id, :category, :key],
      name: :preferences_user_profile_id_role_id_category_key_index
    )
    |> unique_constraint([:user_profile_id, :category, :key],
      name: :preferences_user_profile_id_category_key_index
    )
  end
end
