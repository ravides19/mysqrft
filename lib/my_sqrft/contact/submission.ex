defmodule MySqrft.Contact.Submission do
  @moduledoc """
  Schema for contact form submissions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "contact_submissions" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :subject, :string
    field :message, :string
    field :status, :string, default: "new"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:name, :email, :phone, :subject, :message, :status])
    |> validate_required([:name, :email, :subject, :message])
    |> validate_length(:name, min: 1, max: 200)
    |> validate_length(:subject, min: 1, max: 200)
    |> validate_length(:message, min: 10, max: 5000)
    |> validate_email()
    |> validate_phone()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+\.[^@,;\s]+$/,
      message: "must be a valid email address"
    )
    |> validate_length(:email, max: 160)
  end

  defp validate_phone(changeset) do
    phone = get_field(changeset, :phone)

    if phone && phone != "" do
      validate_format(changeset, :phone, ~r/^\+?[1-9]\d{1,14}$/,
        message: "must be a valid phone number"
      )
    else
      changeset
    end
  end
end
