defmodule MySqrftWeb.API.V1.ConsentController do
  @moduledoc """
  API controller for consent management.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement

  action_fallback MySqrftWeb.API.FallbackController

  def index(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      consents = UserManagement.list_consents(profile)

      json(conn, %{data: Enum.map(consents, &consent_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def update(conn, %{"profile_id" => profile_id, "type" => consent_type, "consent" => consent_params}) do
    current_scope = conn.assigns.current_scope

    if current_scope && current_scope.user do
      try do
        profile = UserManagement.get_profile!(profile_id)

        # Verify ownership
        if profile.user_id == current_scope.user.id do
          metadata = %{
            ip_address: conn.remote_ip |> :inet.ntoa() |> to_string(),
            user_agent: get_req_header(conn, "user-agent") |> List.first()
          }

          case Map.get(consent_params, "granted") do
            true ->
              version = Map.get(consent_params, "version", "1.0")

              case UserManagement.grant_consent(profile, consent_type, version, metadata) do
                {:ok, consent} ->
                  json(conn, %{data: consent_to_json(consent)})

                {:error, changeset} ->
                  conn
                  |> put_status(:unprocessable_entity)
                  |> json(%{errors: translate_errors(changeset)})
              end

            false ->
              case UserManagement.revoke_consent(profile, consent_type, metadata) do
                {:ok, consent} ->
                  json(conn, %{data: consent_to_json(consent)})

                {:error, :not_found} ->
                  conn
                  |> put_status(:not_found)
                  |> json(%{error: "Consent not found"})

                {:error, changeset} ->
                  conn
                  |> put_status(:unprocessable_entity)
                  |> json(%{errors: translate_errors(changeset)})
              end

            _ ->
              conn
              |> put_status(:unprocessable_entity)
              |> json(%{error: "Invalid granted value"})
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

  def history(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      consents = UserManagement.list_consents(profile)

      history = Enum.flat_map(consents, fn consent ->
        UserManagement.get_consent_history(consent)
        |> Enum.map(&consent_history_to_json/1)
      end)

      json(conn, %{data: history})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  defp consent_to_json(consent) do
    %{
      id: consent.id,
      user_profile_id: consent.user_profile_id,
      consent_type: consent.consent_type,
      granted: consent.granted,
      version: consent.version,
      granted_at: consent.granted_at,
      revoked_at: consent.revoked_at,
      expires_at: consent.expires_at
    }
  end

  defp consent_history_to_json(history) do
    %{
      id: history.id,
      consent_id: history.consent_id,
      action: history.action,
      version: history.version,
      ip_address: history.ip_address,
      user_agent: history.user_agent,
      timestamp: history.timestamp
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
