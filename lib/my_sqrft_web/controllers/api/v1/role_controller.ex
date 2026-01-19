defmodule MySqrftWeb.API.V1.RoleController do
  @moduledoc """
  API controller for user role management.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement

  action_fallback MySqrftWeb.API.FallbackController

  def index(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      user_roles = UserManagement.get_user_roles(profile)

      json(conn, %{data: Enum.map(user_roles, &user_role_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def create(conn, %{"profile_id" => profile_id, "role" => role_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(profile_id)
        role = UserManagement.get_role!(role_params["role_id"])

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          role_data = Map.get(role_params, "role_specific_data", %{})

          case UserManagement.add_role_to_profile(profile, role, role_data) do
            {:ok, user_role} ->
              conn
              |> put_status(:created)
              |> json(%{data: user_role_to_json(user_role)})

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
          |> json(%{error: "Profile or role not found"})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  def update(conn, %{"profile_id" => _profile_id, "id" => id, "role" => role_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile_by_user_id(current_scope.user.id)
        user_roles = UserManagement.get_user_roles(profile)
        user_role = Enum.find(user_roles, &(&1.id == id))

        if user_role do
          case Map.get(role_params, "status") do
            "active" ->
              case UserManagement.activate_user_role(user_role) do
                {:ok, user_role} ->
                  json(conn, %{data: user_role_to_json(user_role)})

                {:error, _changeset} ->
                  conn
                  |> put_status(:unprocessable_entity)
                  |> json(%{error: "Failed to activate role"})
              end

            "inactive" ->
              case UserManagement.deactivate_user_role(user_role) do
                {:ok, user_role} ->
                  json(conn, %{data: user_role_to_json(user_role)})

                {:error, _changeset} ->
                  conn
                  |> put_status(:unprocessable_entity)
                  |> json(%{error: "Failed to deactivate role"})
              end

            _ ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Invalid status"})
          end
        else
          conn
          |> put_status(:not_found)
          |> json(%{error: "User role not found"})
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
        profile = UserManagement.get_profile_by_user_id(current_scope.user.id)
        user_roles = UserManagement.get_user_roles(profile)
        user_role = Enum.find(user_roles, &(&1.id == id))

        if user_role do
          case UserManagement.deactivate_user_role(user_role) do
            {:ok, _user_role} ->
              conn
              |> put_status(:no_content)
              |> json(%{})

            {:error, _changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Failed to deactivate role"})
          end
        else
          conn
          |> put_status(:not_found)
          |> json(%{error: "User role not found"})
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

  defp user_role_to_json(user_role) do
    %{
      id: user_role.id,
      user_profile_id: user_role.user_profile_id,
      role_id: user_role.role_id,
      role_name: user_role.role.name,
      role_specific_data: user_role.role_specific_data,
      status: user_role.status,
      activated_at: user_role.activated_at,
      deactivated_at: user_role.deactivated_at
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
