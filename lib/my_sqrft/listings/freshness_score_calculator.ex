defmodule MySqrft.Listings.FreshnessScoreCalculator do
  @moduledoc """
  Calculates freshness score for listings (0-100).

  Freshness indicates how recently the listing was created or updated,
  which affects search ranking and user trust.

  ## Scoring Factors

  1. **Time Since Creation** (40 points)
     - < 7 days: 40 points
     - 7-14 days: 30 points
     - 14-30 days: 20 points
     - 30-60 days: 10 points
     - > 60 days: 0 points

  2. **Time Since Last Refresh** (30 points)
     - < 7 days: 30 points
     - 7-14 days: 20 points
     - 14-30 days: 10 points
     - > 30 days: 0 points

  3. **Time Until Expiry** (20 points)
     - > 45 days: 20 points
     - 30-45 days: 15 points
     - 15-30 days: 10 points
     - < 15 days: 5 points

  4. **Recent Activity** (10 points)
     - Price changed in last 7 days: 10 points
     - Price changed in last 30 days: 5 points
     - No recent changes: 0 points
  """

  alias MySqrft.Listings.Listing

  @doc """
  Calculates freshness score for a listing.

  Returns an integer from 0 to 100.
  """
  def calculate(%Listing{} = listing) do
    now = DateTime.utc_now()

    creation_score = calculate_creation_score(listing.inserted_at, now)
    refresh_score = calculate_refresh_score(listing.last_refreshed_at, now)
    expiry_score = calculate_expiry_score(listing.expires_at, now)
    activity_score = calculate_activity_score(listing, now)

    trunc(creation_score + refresh_score + expiry_score + activity_score)
  end

  # Time since creation (40 points max)
  defp calculate_creation_score(inserted_at, now) do
    days_old = DateTime.diff(now, inserted_at, :day)

    cond do
      days_old < 7 -> 40
      days_old < 14 -> 30
      days_old < 30 -> 20
      days_old < 60 -> 10
      true -> 0
    end
  end

  # Time since last refresh (30 points max)
  defp calculate_refresh_score(nil, _now), do: 0

  defp calculate_refresh_score(last_refreshed_at, now) do
    days_since_refresh = DateTime.diff(now, last_refreshed_at, :day)

    cond do
      days_since_refresh < 7 -> 30
      days_since_refresh < 14 -> 20
      days_since_refresh < 30 -> 10
      true -> 0
    end
  end

  # Time until expiry (20 points max)
  defp calculate_expiry_score(nil, _now), do: 0

  defp calculate_expiry_score(expires_at, now) do
    days_until_expiry = DateTime.diff(expires_at, now, :day)

    cond do
      days_until_expiry > 45 -> 20
      days_until_expiry > 30 -> 15
      days_until_expiry > 15 -> 10
      days_until_expiry > 0 -> 5
      true -> 0
    end
  end

  # Recent activity (10 points max)
  defp calculate_activity_score(listing, now) do
    # Check if price was changed recently by looking at updated_at
    # In a full implementation, we'd check listing_price_history
    days_since_update = DateTime.diff(now, listing.updated_at, :day)

    cond do
      days_since_update < 7 -> 10
      days_since_update < 30 -> 5
      true -> 0
    end
  end

  @doc """
  Determines if a listing should be considered "fresh" for marketing purposes.

  Returns true if freshness score >= 70.
  """
  def is_fresh?(%Listing{} = listing) do
    calculate(listing) >= 70
  end

  @doc """
  Gets a human-readable freshness status.

  Returns: :very_fresh, :fresh, :aging, or :stale
  """
  def freshness_status(%Listing{} = listing) do
    score = calculate(listing)

    cond do
      score >= 80 -> :very_fresh
      score >= 60 -> :fresh
      score >= 30 -> :aging
      true -> :stale
    end
  end
end
