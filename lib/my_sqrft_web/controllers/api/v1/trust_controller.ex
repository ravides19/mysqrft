defmodule MySqrftWeb.API.V1.TrustController do
  @moduledoc """
  API controller for trust score and verification badges.
  """
  use MySqrftWeb, :controller

  alias MySqrft.UserManagement

  action_fallback MySqrftWeb.API.FallbackController

  def trust_score(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      trust_score = UserManagement.get_current_trust_score(profile)

      if trust_score do
        json(conn, %{data: trust_score_to_json(trust_score)})
      else
        conn
        |> put_status(:not_found)
        |> json(%{error: "Trust score not found"})
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  def badges(conn, %{"profile_id" => profile_id}) do
    try do
      profile = UserManagement.get_profile!(profile_id)
      badges = UserManagement.get_verification_badges(profile)

      json(conn, %{data: Enum.map(badges, &badge_to_json/1)})
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Profile not found"})
    end
  end

  defp trust_score_to_json(trust_score) do
    %{
      id: trust_score.id,
      user_profile_id: trust_score.user_profile_id,
      score: trust_score.score,
      factors: trust_score.factors,
      calculated_at: trust_score.calculated_at,
      valid_until: trust_score.valid_until
    }
  end

  defp badge_to_json(badge) do
    %{
      id: badge.id,
      user_profile_id: badge.user_profile_id,
      badge_type: badge.badge_type,
      verification_id: badge.verification_id,
      display_name: badge.display_name,
      granted_at: badge.granted_at,
      expires_at: badge.expires_at,
      is_active: badge.is_active
    }
  end
end
