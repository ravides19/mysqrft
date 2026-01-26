defmodule MySqrft.Listings.SearchDocument do
  @moduledoc """
  Defines the search document structure for listings.

  This module provides functions to convert a listing into a search-optimized
  document structure that can be indexed by the Search domain (Elasticsearch,
  Algolia, Typesense, etc.).

  ## Document Structure

  The search document includes:
  - Listing metadata (id, status, transaction_type, prices)
  - Property details (type, configuration, location)
  - Geography hierarchy (city, locality)
  - Owner information (trust score, verification status)
  - Computed fields (freshness_score, market_readiness_score)
  - Timestamps for sorting and filtering
  """

  alias MySqrft.Listings.Listing
  alias MySqrft.Properties

  @doc """
  Converts a listing to a search document.

  Returns a map suitable for indexing in a search engine.
  """
  def to_search_document(%Listing{} = listing) do
    listing = MySqrft.Repo.preload(listing, [:property, property: [:city, :locality, :owner]])
    property = listing.property

    %{
      # Listing Core Fields
      id: listing.id,
      status: listing.status,
      transaction_type: listing.transaction_type,
      ask_price: to_float(listing.ask_price),
      security_deposit: to_float(listing.security_deposit),
      available_from: listing.available_from,

      # Property Details
      property_id: property.id,
      property_type: property.type,
      property_configuration: property.configuration,
      address_text: property.address_text,

      # Geography
      city_id: property.city_id,
      city_name: property.city.name,
      locality_id: property.locality_id,
      locality_name: property.locality.name,
      location: format_location(property.location),

      # Preferences & Filters
      tenant_preference: listing.tenant_preference,
      diet_preference: listing.diet_preference,
      furnishing_status: listing.furnishing_status,

      # Scoring & Quality
      market_readiness_score: listing.market_readiness_score || 0,
      freshness_score: listing.freshness_score || 0,
      quality_score: property.quality_score || 0,
      data_completeness_score: property.data_completeness_score || 0,

      # Owner Trust
      owner_trust_score: calculate_owner_trust_score(property),
      is_verified_property: property.verification_status == "verified",

      # Metadata
      view_count: listing.view_count || 0,
      image_count: count_images(property),
      last_refreshed_at: listing.last_refreshed_at,
      expires_at: listing.expires_at,

      # Timestamps
      created_at: listing.inserted_at,
      updated_at: listing.updated_at,

      # Computed Fields for Search
      price_per_sqft: calculate_price_per_sqft(listing, property),
      is_premium: is_premium_listing?(listing, property),
      boost_score: calculate_boost_score(listing, property)
    }
  end

  @doc """
  Generates a unique document ID for search indexing.
  """
  def document_id(%Listing{id: id}), do: "listing_#{id}"

  # Helper functions

  defp to_float(nil), do: nil
  defp to_float(%Decimal{} = decimal), do: Decimal.to_float(decimal)
  defp to_float(value) when is_number(value), do: value * 1.0

  defp format_location(nil), do: nil

  defp format_location(%Geo.Point{coordinates: {lon, lat}}) do
    %{lat: lat, lon: lon}
  end

  defp calculate_owner_trust_score(property) do
    Properties.calculate_owner_trust_score(property)
  end

  defp count_images(property) do
    property = MySqrft.Repo.preload(property, :images)
    length(property.images || [])
  end

  defp calculate_price_per_sqft(listing, property) do
    built_up_area =
      property.configuration["built_up_area"] || property.configuration[:built_up_area]

    if built_up_area && listing.ask_price do
      to_float(listing.ask_price) / built_up_area
    else
      nil
    end
  end

  defp is_premium_listing?(listing, property) do
    # Premium if: verified property + high quality + fresh listing
    property.verification_status == "verified" &&
      property.quality_score >= 80 &&
      (listing.freshness_score || 0) >= 80
  end

  defp calculate_boost_score(listing, property) do
    # Boost score for search ranking (0-100)
    base_score = 50

    # Add bonuses
    verification_bonus = if property.verification_status == "verified", do: 20, else: 0
    quality_bonus = trunc((property.quality_score || 0) * 0.15)
    freshness_bonus = trunc((listing.freshness_score || 0) * 0.15)

    min(100, base_score + verification_bonus + quality_bonus + freshness_bonus)
  end
end
