defmodule MySqrft.UserManagement.ProfilePhoto do
  @moduledoc """
  ProfilePhoto schema - manages user profile photos and their versions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "profile_photos" do
    field :original_url, :string
    field :thumbnail_url, :string
    field :medium_url, :string
    field :large_url, :string
    field :moderation_status, :string, default: "pending"
    field :is_current, :boolean, default: false
    field :uploaded_at, :utc_datetime

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile_photo, attrs) do
    profile_photo
    |> cast(attrs, [
      :user_profile_id,
      :original_url,
      :thumbnail_url,
      :medium_url,
      :large_url,
      :moderation_status,
      :is_current,
      :uploaded_at
    ])
    |> validate_required([
      :user_profile_id,
      :original_url,
      :thumbnail_url,
      :medium_url,
      :large_url,
      :moderation_status,
      :uploaded_at
    ])
    |> validate_inclusion(:moderation_status, ["pending", "approved", "rejected"])
    |> validate_format(:original_url, ~r/^https?:\/\//, message: "must be a valid URL")
    |> validate_format(:thumbnail_url, ~r/^https?:\/\//, message: "must be a valid URL")
    |> validate_format(:medium_url, ~r/^https?:\/\//, message: "must be a valid URL")
    |> validate_format(:large_url, ~r/^https?:\/\//, message: "must be a valid URL")
  end
end
