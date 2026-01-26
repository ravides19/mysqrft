defmodule MySqrft.Listings.MarketReadinessScoreCalculator do
  @moduledoc """
  Calculates market readiness score for listings (0-100).

  Market readiness indicates how well-prepared a listing is for the market,
  based on property quality, documentation, pricing, and market conditions.

  ## Scoring Factors

  1. **Property Quality** (30 points)
     - Property quality score (scaled)
     - Property verification status
     - Document completeness

  2. **Listing Completeness** (25 points)
     - All required fields filled
     - Images uploaded (min 5)
     - Property description quality

  3. **Pricing Competitiveness** (25 points)
     - Price within market range (requires market data)
     - Price history (stable vs volatile)
     - Price per sqft comparison

  4. **Owner Trust** (20 points)
     - Owner verification status
     - Owner trust score
     - Previous listing history

  ## Future Enhancements with RERA/Market Data

  When RERA or market data APIs are integrated:
  - Compare prices with RERA-registered projects in locality
  - Factor in project completion status
  - Include builder reputation score
  - Add market demand indicators
  """

  alias MySqrft.Listings.Listing
  alias MySqrft.Properties

  @doc """
  Calculates market readiness score for a listing.

  Returns an integer from 0 to 100.
  """
  def calculate(%Listing{} = listing) do
    listing = MySqrft.Repo.preload(listing, [:property, property: [:documents, :images, :owner]])

    property_quality_score = calculate_property_quality_score(listing.property)
    listing_completeness_score = calculate_listing_completeness_score(listing)
    pricing_score = calculate_pricing_score(listing)
    owner_trust_score = calculate_owner_trust_score(listing.property)

    trunc(property_quality_score + listing_completeness_score + pricing_score + owner_trust_score)
  end

  # Property Quality (30 points max)
  defp calculate_property_quality_score(property) do
    # 20 points from quality score
    base_score = (property.quality_score || 0) * 0.20

    verification_bonus =
      case property.verification_status do
        "verified" -> 10
        "pending" -> 5
        _ -> 0
      end

    min(30, trunc(base_score + verification_bonus))
  end

  # Listing Completeness (25 points max)
  defp calculate_listing_completeness_score(listing) do
    property = listing.property

    # Required fields check
    required_fields_score =
      if all_required_fields_present?(listing) do
        10
      else
        0
      end

    # Image count
    image_count = length(property.images || [])

    image_score =
      cond do
        image_count >= 10 -> 10
        image_count >= 5 -> 7
        image_count >= 3 -> 4
        image_count >= 1 -> 2
        true -> 0
      end

    # Preferences filled
    preferences_score =
      if listing.tenant_preference && listing.diet_preference && listing.furnishing_status do
        5
      else
        2
      end

    required_fields_score + image_score + preferences_score
  end

  defp all_required_fields_present?(listing) do
    required = [
      listing.ask_price,
      listing.available_from,
      listing.property.address_text,
      listing.property.type
    ]

    Enum.all?(required, fn field -> !is_nil(field) end)
  end

  # Pricing Competitiveness (25 points max)
  defp calculate_pricing_score(listing) do
    # Base score for having a price
    base_score = if listing.ask_price, do: 10, else: 0

    # Price per sqft reasonableness (simplified without market data)
    price_per_sqft_score = calculate_price_per_sqft_score(listing)

    # Price stability (check if price has been changed frequently)
    # Default, would check price history in full implementation
    stability_score = 5

    # TODO: When market data is available, compare with:
    # - Average price in locality for similar properties
    # - RERA project prices in the area
    # - Recent transaction prices from Zapkey/Propstack APIs
    # Placeholder for future market data integration
    market_comparison_score = 0

    base_score + price_per_sqft_score + stability_score + market_comparison_score
  end

  defp calculate_price_per_sqft_score(listing) do
    property = listing.property

    built_up_area =
      property.configuration["built_up_area"] || property.configuration[:built_up_area]

    if built_up_area && listing.ask_price do
      price_per_sqft = Decimal.to_float(listing.ask_price) / built_up_area

      # Reasonable range check (very simplified)
      # TODO: Replace with actual market data comparison
      cond do
        # Reasonable range
        price_per_sqft > 1000 && price_per_sqft < 50000 -> 10
        # Acceptable range
        price_per_sqft > 500 && price_per_sqft < 100_000 -> 5
        # Outlier
        true -> 0
      end
    else
      0
    end
  end

  # Owner Trust (20 points max)
  defp calculate_owner_trust_score(property) do
    trust_score = Properties.calculate_owner_trust_score(property)

    # Scale 0-100 trust score to 0-20 points
    trunc(trust_score * 0.20)
  end

  @doc """
  Determines if a listing is market-ready.

  Returns true if market readiness score >= 70.
  """
  def is_market_ready?(%Listing{} = listing) do
    calculate(listing) >= 70
  end

  @doc """
  Gets a human-readable market readiness status.

  Returns: :excellent, :good, :fair, or :poor
  """
  def readiness_status(%Listing{} = listing) do
    score = calculate(listing)

    cond do
      score >= 80 -> :excellent
      score >= 60 -> :good
      score >= 40 -> :fair
      true -> :poor
    end
  end

  @doc """
  Gets improvement suggestions for a listing.

  Returns a list of actionable suggestions to improve market readiness.
  """
  def get_improvement_suggestions(%Listing{} = listing) do
    listing = MySqrft.Repo.preload(listing, [:property, property: [:documents, :images, :owner]])
    suggestions = []

    # Property verification
    suggestions =
      if listing.property.verification_status != "verified" do
        ["Upload ownership documents and get property verified" | suggestions]
      else
        suggestions
      end

    # Images
    image_count = length(listing.property.images || [])

    suggestions =
      if image_count < 5 do
        ["Add more property images (minimum 5 recommended)" | suggestions]
      else
        suggestions
      end

    # Preferences
    suggestions =
      if is_nil(listing.tenant_preference) || is_nil(listing.diet_preference) do
        ["Complete tenant and diet preferences" | suggestions]
      else
        suggestions
      end

    # Price per sqft
    built_up_area =
      listing.property.configuration["built_up_area"] ||
        listing.property.configuration[:built_up_area]

    suggestions =
      if is_nil(built_up_area) do
        ["Add built-up area to property configuration" | suggestions]
      else
        suggestions
      end

    Enum.reverse(suggestions)
  end

  # ============================================================================
  # Future: RERA/Market Data Integration
  # ============================================================================

  @doc """
  Placeholder for future RERA data integration.

  When implemented, this will fetch:
  - RERA project details
  - Builder reputation
  - Project completion status
  - Approved floor plans
  """
  def fetch_rera_data(_property) do
    # TODO: Integrate with RERA verification API (e.g., Surepass)
    # Example: Surepass.verify_rera_project(rera_id)
    {:error, :not_implemented}
  end

  @doc """
  Placeholder for future market data integration.

  When implemented, this will fetch:
  - Average prices in locality
  - Recent transaction prices (Zapkey API)
  - Market trends (Propstack API)
  - Demand indicators
  """
  def fetch_market_data(_locality_id, _property_type) do
    # TODO: Integrate with market data APIs
    # Example: Propstack.get_market_data(locality_id, property_type)
    # Example: Zapkey.get_transaction_prices(locality_id)
    {:error, :not_implemented}
  end
end
