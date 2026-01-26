defmodule MySqrft.Repo.Migrations.AddPropertyVerification do
  use Ecto.Migration

  def change do
    # Add verification fields to properties table
    alter table(:properties) do
      add :verification_status, :string, default: "unverified", null: false
      add :verified_at, :utc_datetime
      add :verified_by_id, references(:user_profiles, type: :binary_id)
      add :quality_score, :integer, default: 0
      add :data_completeness_score, :integer, default: 0
    end

    create index(:properties, [:verification_status])
    create index(:properties, [:verified_by_id])

    # Property documents table for ownership proofs
    create table(:property_documents, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :property_id, references(:properties, type: :binary_id, on_delete: :delete_all),
        null: false

      add :document_type, :string, null: false
      add :s3_key, :string, null: false
      add :file_name, :string
      add :file_size, :bigint
      add :mime_type, :string

      # Verification
      add :verification_status, :string, default: "pending", null: false
      add :verified_by_id, references(:user_profiles, type: :binary_id)
      add :verified_at, :utc_datetime
      add :rejection_reason, :text
      add :expiry_date, :date

      timestamps(type: :utc_datetime)
    end

    create index(:property_documents, [:property_id])
    create index(:property_documents, [:verification_status])
    create index(:property_documents, [:document_type])
    create index(:property_documents, [:verified_by_id])
  end
end
