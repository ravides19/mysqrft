defmodule MySqrftWeb.API.V1.PreferenceController do
  @moduledoc """
  API controller for preference management.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement

  action_fallback MySqrftWeb.API.FallbackController

  def index(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      preferences = UserManagement.get_preferences(profile)

      json(conn, %{data: Enum.map(preferences, &preference_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def show(conn, %{"profile_id" => profile_id, "category" => category}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      preferences = UserManagement.get_preferences(profile, category)

      json(conn, %{data: Enum.map(preferences, &preference_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def update(conn, %{"profile_id" => profile_id, "category" => category, "preferences" => prefs}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          results = Enum.map(prefs, fn {key, value} ->
            UserManagement.upsert_preference(profile, category, key, value)
          end)

          if Enum.all?(results, fn {status, _} -> status == :ok end) do
            preferences = UserManagement.get_preferences(profile, category)
            json(conn, %{data: Enum.map(preferences, &preference_to_json/1)})
          else
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Some preferences failed to save"})
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

  defp preference_to_json(preference) do
    %{
      id: preference.id,
      user_profile_id: preference.user_profile_id,
      role_id: preference.role_id,
      category: preference.category,
      key: preference.key,
      value: preference.value
    }
  end
end
