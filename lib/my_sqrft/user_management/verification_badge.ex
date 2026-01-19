defmodule MySqrft.UserManagement.VerificationBadge do
  @moduledoc """
  VerificationBadge schema - display of verification badges on user profiles.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "verification_badges" do
    field :badge_type, :string
    field :verification_id, :binary_id
    field :display_name, :string
    field :granted_at, :utc_datetime
    field :expires_at, :utc_datetime
    field :is_active, :boolean, default: true

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(verification_badge, attrs) do
    verification_badge
    |> cast(attrs, [
      :user_profile_id,
      :badge_type,
      :verification_id,
      :display_name,
      :granted_at,
      :expires_at,
      :is_active
    ])
    |> validate_required([:user_profile_id, :badge_type, :display_name, :granted_at])
    |> validate_inclusion(:badge_type, ["identity", "phone", "email", "address", "background"])
  end
end
