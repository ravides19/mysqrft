defmodule MySqrft.UserManagement.Profile do
  @moduledoc """
  User profile schema - extends Auth.User with profile information.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_profiles" do
    field :display_name, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :bio, :string
    field :date_of_birth, :date
    field :gender, :string
    field :status, :string, default: "active"
    field :completeness_score, :integer, default: 0

    belongs_to :user, MySqrft.Auth.User, foreign_key: :user_id
    has_many :user_roles, MySqrft.UserManagement.UserRole, foreign_key: :user_profile_id
    has_many :addresses, MySqrft.UserManagement.Address, foreign_key: :user_profile_id
    has_many :profile_photos, MySqrft.UserManagement.ProfilePhoto, foreign_key: :user_profile_id
    has_many :preferences, MySqrft.UserManagement.Preference, foreign_key: :user_profile_id
    has_many :consents, MySqrft.UserManagement.Consent, foreign_key: :user_profile_id
    has_many :trust_scores, MySqrft.UserManagement.TrustScore, foreign_key: :user_profile_id
    has_many :verification_badges, MySqrft.UserManagement.VerificationBadge, foreign_key: :user_profile_id
    has_many :profile_completeness_records, MySqrft.UserManagement.ProfileCompleteness, foreign_key: :user_profile_id
    has_many :onboarding_flows, MySqrft.UserManagement.OnboardingFlow, foreign_key: :user_profile_id
    has_many :emergency_contacts, MySqrft.UserManagement.EmergencyContact, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :user_id,
      :display_name,
      :first_name,
      :last_name,
      :email,
      :phone,
      :bio,
      :date_of_birth,
      :gender,
      :status,
      :completeness_score
    ])
    |> normalize_empty_strings([:bio, :gender])
    |> validate_required([:user_id, :display_name, :first_name, :last_name, :email, :phone, :status])
    |> validate_length(:display_name, min: 1, max: 100)
    |> validate_length(:first_name, min: 1, max: 100)
    |> validate_length(:last_name, min: 1, max: 100)
    |> validate_length(:bio, max: 500)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_format(:phone, ~r/^\+[1-9]\d{1,14}$/, message: "must be in international format")
    |> validate_inclusion(:status, ["active", "suspended", "blocked", "deleted"])
    |> validate_number(:completeness_score, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer_not_to_say"], allow_nil: true)
    |> unique_constraint(:user_id)
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
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
