defmodule MySqrftWeb.API.V1.ProfileController do
  @moduledoc """
  API controller for profile management.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement
  alias MySqrft.UserManagement.Profile

  action_fallback MySqrftWeb.API.FallbackController

  def index(conn, _params) do
    # This would typically list profiles (admin only)
    # For now, return empty list
    json(conn, %{data: []})
  end

  def create(conn, %{"profile" => profile_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      profile_params = Map.put(profile_params, "user_id", current_scope.user.id)

      case UserManagement.create_profile(profile_params) do
        {:ok, profile} ->
          conn
          |> put_status(:created)
          |> json(%{data: profile_to_json(profile)})

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: translate_errors(changeset)})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  def show(conn, %{"id" => "me"}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        json(conn, %{data: profile_to_json(profile)})
      else
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

  def show(conn, %{"id" => id}) do
    try do
      profile = UserManagement.get_profile!(id)
      json(conn, %{data: profile_to_json(profile)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.update_profile(profile, profile_params) do
            {:ok, profile} ->
              json(conn, %{data: profile_to_json(profile)})

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

  def delete(conn, %{"id" => id}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.delete_profile(profile) do
            {:ok, _profile} ->
              conn
              |> put_status(:no_content)
              |> json(%{})

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

  def completeness(conn, %{"id" => id}) do
    try do
      profile = UserManagement.get_profile!(id)
      completeness = UserManagement.get_profile_by_user_id(profile.user_id)

      json(conn, %{
        data: %{
          score: completeness.completeness_score,
          profile_id: profile.id
        }
      })
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  defp profile_to_json(profile) do
    %{
      id: profile.id,
      user_id: profile.user_id,
      display_name: profile.display_name,
      first_name: profile.first_name,
      last_name: profile.last_name,
      email: profile.email,
      phone: profile.phone,
      bio: profile.bio,
      date_of_birth: profile.date_of_birth,
      gender: profile.gender,
      status: profile.status,
      completeness_score: profile.completeness_score,
      inserted_at: profile.inserted_at,
      updated_at: profile.updated_at
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
