defmodule MySqrft.Properties.PropertyDocument do
  @moduledoc """
  Schema for property ownership documents and verification.

  Documents are uploaded by property owners to prove ownership and are
  verified by admin users before a property can be marked as verified.

  ## Document Types

  - `electricity_bill` - Recent electricity bill (< 3 months old)
  - `property_tax` - Property tax receipt
  - `sale_deed` - Sale deed/agreement
  - `lease_deed` - Lease agreement (for rental properties)
  - `other` - Other supporting documents

  ## Verification Workflow

  1. Owner uploads document → status: `pending`
  2. Admin reviews → status: `verified` or `rejected`
  3. If all required documents verified → property status: `verified`
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "property_documents" do
    belongs_to :property, MySqrft.Properties.Property
    belongs_to :verified_by, MySqrft.UserManagement.Profile

    field :document_type, :string
    field :s3_key, :string
    field :file_name, :string
    field :file_size, :integer
    field :mime_type, :string

    # Verification
    field :verification_status, :string, default: "pending"
    field :verified_at, :utc_datetime
    field :rejection_reason, :string
    field :expiry_date, :date

    timestamps(type: :utc_datetime)
  end

  @document_types ~w(electricity_bill property_tax sale_deed lease_deed other)
  @verification_statuses ~w(pending verified rejected)

  @doc """
  Returns the list of valid document types.
  """
  def document_types, do: @document_types

  @doc """
  Returns the list of valid verification statuses.
  """
  def verification_statuses, do: @verification_statuses

  @doc """
  Changeset for creating/updating a property document.
  """
  def changeset(document, attrs) do
    document
    |> cast(attrs, [
      :property_id,
      :document_type,
      :s3_key,
      :file_name,
      :file_size,
      :mime_type,
      :verification_status,
      :verified_by_id,
      :verified_at,
      :rejection_reason,
      :expiry_date
    ])
    |> validate_required([:property_id, :document_type, :s3_key])
    |> validate_inclusion(:document_type, @document_types)
    |> validate_inclusion(:verification_status, @verification_statuses)
    |> validate_number(:file_size, greater_than: 0)
    |> foreign_key_constraint(:property_id)
    |> foreign_key_constraint(:verified_by_id)
  end

  @doc """
  Changeset for verifying a document.
  """
  def verify_changeset(document, verifier_id) do
    document
    |> change(%{
      verification_status: "verified",
      verified_by_id: verifier_id,
      verified_at: DateTime.utc_now()
    })
  end

  @doc """
  Changeset for rejecting a document.
  """
  def reject_changeset(document, reason) do
    document
    |> change(%{
      verification_status: "rejected",
      rejection_reason: reason
    })
  end
end
