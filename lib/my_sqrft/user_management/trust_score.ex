defmodule MySqrft.UserManagement.TrustScore do
  @moduledoc """
  TrustScore schema - calculated trust score for users.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "trust_scores" do
    field :score, :integer
    field :factors, :map, default: %{}
    field :calculated_at, :utc_datetime
    field :valid_until, :utc_datetime

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(trust_score, attrs) do
    trust_score
    |> cast(attrs, [:user_profile_id, :score, :factors, :calculated_at, :valid_until])
    |> validate_required([:user_profile_id, :score, :calculated_at, :valid_until])
    |> validate_number(:score, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> unique_constraint(:user_profile_id)
  end
end
