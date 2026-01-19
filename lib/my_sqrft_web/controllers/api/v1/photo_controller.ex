defmodule MySqrftWeb.API.V1.PhotoController do
  @moduledoc """
  API controller for profile photo management.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement

  action_fallback MySqrftWeb.API.FallbackController

  def index(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      photos = UserManagement.list_profile_photos(profile)

      json(conn, %{data: Enum.map(photos, &photo_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def create(conn, %{"profile_id" => profile_id, "photo" => photo_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          # In a real implementation, this would handle file upload
          # For now, we expect URLs to be provided
          case UserManagement.create_profile_photo(profile, photo_params) do
            {:ok, photo} ->
              conn
              |> put_status(:created)
              |> json(%{data: photo_to_json(photo)})

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{errors: translate_errors(changeset)})
          end
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Forbidden"})
        end
      rescue
        Ecto.NoResultsError ->
          conn
          |> put_status(:not_found)
          |> json(%{error: "Profile not found"})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  def delete(conn, %{"profile_id" => _profile_id, "id" => id}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        photo = UserManagement.get_profile_photo!(id)
        profile = UserManagement.get_profile!(photo.user_profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.delete_profile_photo(photo) do
            {:ok, _photo} ->
              conn
              |> put_status(:no_content)
              |> json(%{})

            {:error, _changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Failed to delete photo"})
          end
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Forbidden"})
        end
      rescue
        Ecto.NoResultsError ->
          conn
          |> put_status(:not_found)
          |> json(%{error: "Photo not found"})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  def set_current(conn, %{"profile_id" => _profile_id, "id" => id}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        photo = UserManagement.get_profile_photo!(id)
        profile = UserManagement.get_profile!(photo.user_profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.set_current_photo(photo) do
            {:ok, photo} ->
              json(conn, %{data: photo_to_json(photo)})

            {:error, _changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Failed to set current photo"})
          end
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Forbidden"})
        end
      rescue
        Ecto.NoResultsError ->
          conn
          |> put_status(:not_found)
          |> json(%{error: "Photo not found"})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  defp photo_to_json(photo) do
    %{
      id: photo.id,
      user_profile_id: photo.user_profile_id,
      original_url: photo.original_url,
      thumbnail_url: photo.thumbnail_url,
      medium_url: photo.medium_url,
      large_url: photo.large_url,
      moderation_status: photo.moderation_status,
      is_current: photo.is_current,
      uploaded_at: photo.uploaded_at
    }
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
