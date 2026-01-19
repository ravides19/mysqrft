defmodule MySqrft.UserManagement.ProfileCompleteness do
  @moduledoc """
  ProfileCompleteness schema - tracks profile completeness calculation details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "profile_completeness" do
    field :total_score, :integer
    field :breakdown, :map, default: %{}
    field :missing_fields, {:array, :string}, default: []
    field :calculated_at, :utc_datetime

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile_completeness, attrs) do
    profile_completeness
    |> cast(attrs, [:user_profile_id, :total_score, :breakdown, :missing_fields, :calculated_at])
    |> validate_required([:user_profile_id, :total_score, :calculated_at])
    |> validate_number(:total_score, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> unique_constraint(:user_profile_id)
  end
end
