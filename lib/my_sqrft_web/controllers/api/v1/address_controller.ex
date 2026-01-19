defmodule MySqrftWeb.API.V1.AddressController do
  @moduledoc """
  API controller for address management.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement

  action_fallback MySqrftWeb.API.FallbackController

  def index(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      addresses = UserManagement.list_addresses(profile)

      json(conn, %{data: Enum.map(addresses, &address_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def create(conn, %{"profile_id" => profile_id, "address" => address_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.create_address(profile, address_params) do
            {:ok, address} ->
              conn
              |> put_status(:created)
              |> json(%{data: address_to_json(address)})

            {:error, :address_limit_reached} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Address limit reached (max 5 addresses)"})

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

  def update(conn, %{"profile_id" => _profile_id, "id" => id, "address" => address_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        address = UserManagement.get_address!(id)
        profile = UserManagement.get_profile!(address.user_profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.update_address(address, address_params) do
            {:ok, address} ->
              json(conn, %{data: address_to_json(address)})

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
          |> json(%{error: "Address not found"})
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
        address = UserManagement.get_address!(id)
        profile = UserManagement.get_profile!(address.user_profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          case UserManagement.delete_address(address) do
            {:ok, _address} ->
              conn
              |> put_status(:no_content)
              |> json(%{})

            {:error, _changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Failed to delete address"})
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
          |> json(%{error: "Address not found"})
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  defp address_to_json(address) do
    %{
      id: address.id,
      user_profile_id: address.user_profile_id,
      type: address.type,
      line1: address.line1,
      line2: address.line2,
      city: address.city,
      locality: address.locality,
      landmark: address.landmark,
      pin_code: address.pin_code,
      state: address.state,
      country: address.country,
      latitude: address.latitude,
      longitude: address.longitude,
      is_primary: address.is_primary
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
