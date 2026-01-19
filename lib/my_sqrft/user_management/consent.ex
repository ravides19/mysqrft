defmodule MySqrft.UserManagement.Consent do
  @moduledoc """
  Consent schema - tracks user consent for data processing activities.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "consents" do
    field :consent_type, :string
    field :granted, :boolean
    field :version, :string
    field :granted_at, :utc_datetime
    field :revoked_at, :utc_datetime
    field :expires_at, :utc_datetime

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id
    has_many :consent_history, MySqrft.UserManagement.ConsentHistory

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(consent, attrs) do
    consent
    |> cast(attrs, [
      :user_profile_id,
      :consent_type,
      :granted,
      :version,
      :granted_at,
      :revoked_at,
      :expires_at
    ])
    |> validate_required([:user_profile_id, :consent_type, :granted, :version])
    |> unique_constraint([:user_profile_id, :consent_type])
  end

  def grant_changeset(consent, version) do
    now = DateTime.utc_now()
    change(consent, granted: true, version: version, granted_at: now, revoked_at: nil)
  end

  def revoke_changeset(consent) do
    now = DateTime.utc_now()
    change(consent, granted: false, revoked_at: now)
  end
end
