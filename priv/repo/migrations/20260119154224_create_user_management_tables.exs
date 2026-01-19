defmodule MySqrft.Repo.Migrations.CreateUserManagementTables do
  use Ecto.Migration

  def change do
    # Roles table - defines available roles on the platform
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :required_fields, :jsonb, default: "{}"
      add :permissions, :jsonb, default: "{}"
      add :is_active, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:name])
    create index(:roles, [:is_active])

    # User Profiles table - extends Auth.User with profile information
    create table(:user_profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :display_name, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :citext, null: false
      add :phone, :string, null: false
      add :bio, :text
      add :date_of_birth, :date
      add :gender, :string
      add :status, :string, default: "active", null: false
      add :completeness_score, :integer, default: 0, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_profiles, [:user_id])
    create unique_index(:user_profiles, [:email])
    create unique_index(:user_profiles, [:phone])
    create index(:user_profiles, [:status])
    create index(:user_profiles, [:completeness_score])

    # User Roles junction table - links users to their roles
    create table(:user_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :role_id, references(:roles, type: :binary_id, on_delete: :restrict), null: false
      add :role_specific_data, :jsonb, default: "{}"
      add :status, :string, default: "active", null: false
      add :activated_at, :utc_datetime
      add :deactivated_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_profile_id, :role_id])
    create index(:user_roles, [:user_profile_id])
    create index(:user_roles, [:role_id])
    create index(:user_roles, [:status])

    # Addresses table - user addresses with location details
    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :type, :string, null: false
      add :line1, :string, null: false
      add :line2, :string
      add :city, :string, null: false
      add :locality, :string
      add :landmark, :string
      add :pin_code, :string, null: false
      add :state, :string, null: false
      add :country, :string, default: "IN", null: false
      add :latitude, :decimal, precision: 10, scale: 7
      add :longitude, :decimal, precision: 10, scale: 7
      add :is_primary, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:addresses, [:user_profile_id])
    create index(:addresses, [:is_primary])
    create index(:addresses, [:pin_code])
    create index(:addresses, [:city])

    # Profile Photos table - manages user profile photos
    create table(:profile_photos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :original_url, :string, null: false
      add :thumbnail_url, :string, null: false
      add :medium_url, :string, null: false
      add :large_url, :string, null: false
      add :moderation_status, :string, default: "pending", null: false
      add :is_current, :boolean, default: false, null: false
      add :uploaded_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:profile_photos, [:user_profile_id])
    create index(:profile_photos, [:is_current])
    create index(:profile_photos, [:moderation_status])

    # Preferences table - stores user preferences
    create table(:preferences, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :role_id, references(:roles, type: :binary_id, on_delete: :delete_all)
      add :category, :string, null: false
      add :key, :string, null: false
      add :value, :jsonb, null: false

      timestamps(type: :utc_datetime, updated_at: true)
    end

    create index(:preferences, [:user_profile_id])
    create index(:preferences, [:role_id])
    create index(:preferences, [:category])
    # Unique constraint for role-specific preferences
    create unique_index(:preferences, [:user_profile_id, :role_id, :category, :key],
      name: :preferences_user_profile_id_role_id_category_key_index,
      where: "role_id IS NOT NULL"
    )
    # Unique constraint for global preferences
    create unique_index(:preferences, [:user_profile_id, :category, :key],
      name: :preferences_user_profile_id_category_key_index,
      where: "role_id IS NULL"
    )

    # Consents table - tracks user consent for data processing
    create table(:consents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :consent_type, :string, null: false
      add :granted, :boolean, null: false
      add :version, :string, null: false
      add :granted_at, :utc_datetime
      add :revoked_at, :utc_datetime
      add :expires_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:consents, [:user_profile_id])
    create index(:consents, [:consent_type])
    create unique_index(:consents, [:user_profile_id, :consent_type])

    # Consent History table - immutable audit log of consent changes
    create table(:consent_history, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :consent_id, references(:consents, type: :binary_id, on_delete: :delete_all), null: false
      add :action, :string, null: false
      add :version, :string, null: false
      add :ip_address, :string
      add :user_agent, :string
      add :timestamp, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:consent_history, [:consent_id])
    create index(:consent_history, [:timestamp])

    # Trust Scores table - calculated trust scores for users
    create table(:trust_scores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :score, :integer, null: false
      add :factors, :jsonb, default: "{}"
      add :calculated_at, :utc_datetime, null: false
      add :valid_until, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:trust_scores, [:user_profile_id])
    create index(:trust_scores, [:score])
    create index(:trust_scores, [:calculated_at])

    # Verification Badges table - display of verification badges
    create table(:verification_badges, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :badge_type, :string, null: false
      add :verification_id, :binary_id
      add :display_name, :string, null: false
      add :granted_at, :utc_datetime, null: false
      add :expires_at, :utc_datetime
      add :is_active, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:verification_badges, [:user_profile_id])
    create index(:verification_badges, [:badge_type])
    create index(:verification_badges, [:is_active])

    # Profile Completeness table - tracks completeness calculation details
    create table(:profile_completeness, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :total_score, :integer, null: false
      add :breakdown, :jsonb, default: "{}"
      add :missing_fields, :jsonb, default: "[]"
      add :calculated_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:profile_completeness, [:user_profile_id])
    create index(:profile_completeness, [:total_score])

    # Onboarding Flows table - tracks user progress through onboarding
    create table(:onboarding_flows, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :role_id, references(:roles, type: :binary_id, on_delete: :restrict), null: false
      add :flow_type, :string, null: false
      add :current_step, :integer, default: 1, null: false
      add :total_steps, :integer, null: false
      add :completed_steps, :jsonb, default: "[]"
      add :status, :string, default: "in_progress", null: false
      add :started_at, :utc_datetime, null: false
      add :completed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:onboarding_flows, [:user_profile_id])
    create index(:onboarding_flows, [:role_id])
    create index(:onboarding_flows, [:status])
    create unique_index(:onboarding_flows, [:user_profile_id, :role_id, :flow_type])

    # Emergency Contacts table - stores emergency contact information
    create table(:emergency_contacts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :binary_id, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :relationship, :string, null: false
      add :phone, :string, null: false
      add :email, :string
      add :priority, :integer, default: 1, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:emergency_contacts, [:user_profile_id])
    create index(:emergency_contacts, [:priority])
  end
end
