defmodule MySqrft.UserManagement.ConsentHistory do
  @moduledoc """
  ConsentHistory schema - immutable audit log of consent changes.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "consent_history" do
    field :action, :string
    field :version, :string
    field :ip_address, :string
    field :user_agent, :string
    field :timestamp, :utc_datetime

    belongs_to :consent, MySqrft.UserManagement.Consent

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(consent_history, attrs) do
    consent_history
    |> cast(attrs, [:consent_id, :action, :version, :ip_address, :user_agent, :timestamp])
    |> validate_required([:consent_id, :action, :version, :timestamp])
    |> validate_inclusion(:action, ["granted", "revoked", "expired"])
  end
end
