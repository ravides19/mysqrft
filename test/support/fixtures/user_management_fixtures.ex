defmodule MySqrft.UserManagementFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MySqrft.UserManagement` context.
  """

  alias MySqrft.UserManagement

  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        display_name: "Test User",
        first_name: "Test",
        last_name: "User",
        email: "test#{System.unique_integer()}@example.com",
        phone: "+1234567890",
        bio: "Test bio",
        date_of_birth: ~D[1990-01-01],
        gender: "other",
        status: "active"
      })
      |> UserManagement.create_profile()

    profile
  end

  def profile_photo_fixture(profile, attrs \\ %{}) do
    {:ok, photo} =
      attrs
      |> Enum.into(%{
        original_url: "test/photos/#{System.unique_integer()}.jpg",
        thumbnail_url: "test/photos/#{System.unique_integer()}_thumb.jpg",
        medium_url: "test/photos/#{System.unique_integer()}_medium.jpg",
        large_url: "test/photos/#{System.unique_integer()}_large.jpg",
        moderation_status: "approved",
        is_current: false,
        uploaded_at: DateTime.utc_now()
      })
      |> then(&UserManagement.create_profile_photo(profile, &1))

    photo
  end
end
