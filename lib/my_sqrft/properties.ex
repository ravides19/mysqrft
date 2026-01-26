defmodule MySqrft.Properties do
  @moduledoc """
  The Properties context for managing Property Assets (Inventory).
  """

  import Ecto.Query, warn: false
  alias MySqrft.Repo
  alias MySqrft.Properties.Property
  alias MySqrft.Properties.PropertyImage
  alias MySqrft.UserManagement.Profile

  @doc """
  Returns the list of properties owned by a user.
  """
  def list_user_properties(user_id) do
    Property
    |> join(:inner, [p], owner in Profile, on: p.owner_id == owner.id)
    |> where([p, owner], owner.user_id == ^user_id)
    |> preload([:city, :locality, :images])
    |> Repo.all()
  end

  @doc """
  Gets a single property.

  Raises `Ecto.NoResultsError` if the Property does not exist.
  """
  def get_property!(id) do
    Property
    |> preload([:city, :locality, :images])
    |> Repo.get!(id)
  end

  @doc """
  Creates a property.
  """
  def create_property(%Profile{} = owner, attrs \\ %{}) do
    %Property{}
    |> Property.changeset(Map.put(attrs, "owner_id", owner.id))
    |> Repo.insert()
  end

  @doc """
  Updates a property.
  """
  def update_property(%Property{} = property, attrs) do
    property
    |> Property.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a property.
  """
  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  @doc """
  Returns an `Ecto.Changeset` for tracking property changes.
  """
  def change_property(%Property{} = property, attrs \\ %{}) do
    Property.changeset(property, attrs)
  end

  # ============================================================================
  # Property Images
  # ============================================================================

  @doc """
  Creates a property image.
  """
  def create_property_image(%Property{} = property, attrs \\ %{}) do
    %PropertyImage{}
    |> PropertyImage.changeset(Map.put(attrs, "property_id", property.id))
    |> Repo.insert()
  end

  @doc """
  Deletes a property image.
  """
  def delete_property_image(%PropertyImage{} = image) do
    Repo.delete(image)
  end

  @doc """
  Gets a property image.
  """
  def get_property_image!(id), do: Repo.get!(PropertyImage, id)

  # ============================================================================
  # Property Documents & Verification
  # ============================================================================

  alias MySqrft.Properties.PropertyDocument

  @doc """
  Creates a property document.
  """
  def create_property_document(%Property{} = property, attrs \\ %{}) do
    %PropertyDocument{}
    |> PropertyDocument.changeset(Map.put(attrs, "property_id", property.id))
    |> Repo.insert()
  end

  @doc """
  Lists all documents for a property.
  """
  def list_property_documents(property_id) do
    PropertyDocument
    |> where([d], d.property_id == ^property_id)
    |> order_by([d], desc: d.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single property document.
  """
  def get_property_document!(id), do: Repo.get!(PropertyDocument, id)

  @doc """
  Deletes a property document.
  """
  def delete_property_document(%PropertyDocument{} = document) do
    Repo.delete(document)
  end

  @doc """
  Verifies a property document.
  """
  def verify_document(%PropertyDocument{} = document, verifier_id) do
    document
    |> PropertyDocument.verify_changeset(verifier_id)
    |> Repo.update()
    |> case do
      {:ok, verified_doc} ->
        # Check if all required documents are verified
        maybe_verify_property(verified_doc.property_id, verifier_id)
        {:ok, verified_doc}

      error ->
        error
    end
  end

  @doc """
  Rejects a property document.
  """
  def reject_document(%PropertyDocument{} = document, reason) do
    document
    |> PropertyDocument.reject_changeset(reason)
    |> Repo.update()
  end

  defp maybe_verify_property(property_id, verifier_id) do
    property = get_property!(property_id) |> Repo.preload(:documents)

    # Check if at least one ownership document is verified
    has_verified_ownership =
      Enum.any?(property.documents, fn doc ->
        doc.verification_status == "verified" and
          doc.document_type in ["sale_deed", "property_tax", "electricity_bill"]
      end)

    if has_verified_ownership and property.verification_status != "verified" do
      property
      |> Ecto.Changeset.change(%{
        verification_status: "verified",
        verified_at: DateTime.utc_now(),
        verified_by_id: verifier_id
      })
      |> Repo.update()
    end
  end

  # ============================================================================
  # Quality Scoring
  # ============================================================================

  @doc """
  Calculates and updates quality scores for a property.

  Quality Score (0-100):
  - Field completeness: 30 points
  - Media count: 20 points
  - Location precision: 20 points
  - Document verification: 30 points

  Data Completeness Score (0-100):
  - Percentage of required fields filled
  """
  def update_quality_scores(%Property{} = property) do
    property = Repo.preload(property, [:images, :documents])

    quality_score = calculate_quality_score(property)
    completeness_score = calculate_data_completeness_score(property)

    property
    |> Ecto.Changeset.change(%{
      quality_score: quality_score,
      data_completeness_score: completeness_score
    })
    |> Repo.update()
  end

  defp calculate_quality_score(property) do
    field_score = calculate_field_completeness_score(property)
    media_score = calculate_media_score(property)
    location_score = calculate_location_score(property)
    document_score = calculate_document_score(property)

    field_score + media_score + location_score + document_score
  end

  defp calculate_field_completeness_score(property) do
    required_fields = [:type, :address_text, :city_id, :locality_id]
    config_fields = Map.keys(property.configuration || %{})

    filled_count =
      Enum.count(required_fields, fn field ->
        value = Map.get(property, field)
        value != nil and value != ""
      end)

    base_score = trunc(filled_count / length(required_fields) * 20)
    config_bonus = min(length(config_fields) * 2, 10)

    base_score + config_bonus
  end

  defp calculate_media_score(property) do
    image_count = length(property.images || [])

    cond do
      image_count >= 10 -> 20
      image_count >= 5 -> 15
      image_count >= 3 -> 10
      image_count >= 1 -> 5
      true -> 0
    end
  end

  defp calculate_location_score(property) do
    cond do
      property.location != nil and property.locality_id != nil -> 20
      property.locality_id != nil -> 15
      property.city_id != nil -> 10
      true -> 0
    end
  end

  defp calculate_document_score(property) do
    verified_docs =
      Enum.count(property.documents || [], fn doc ->
        doc.verification_status == "verified"
      end)

    cond do
      verified_docs >= 3 -> 30
      verified_docs >= 2 -> 25
      verified_docs >= 1 -> 20
      true -> 0
    end
  end

  defp calculate_data_completeness_score(property) do
    all_fields = [
      :type,
      :address_text,
      :city_id,
      :locality_id,
      :location,
      :project_name
    ]

    config_fields = Map.keys(property.configuration || %{})
    total_fields = length(all_fields) + length(config_fields)

    filled_fields =
      Enum.count(all_fields, fn field ->
        value = Map.get(property, field)
        value != nil and value != ""
      end) + length(config_fields)

    trunc(filled_fields / total_fields * 100)
  end

  # ============================================================================
  # Geography Integration
  # ============================================================================

  alias MySqrft.Geography

  @doc """
  Validates that a property's address binding is correct.

  Checks:
  - City exists
  - Locality belongs to the specified city
  - Location (if provided) is within locality bounds (future enhancement)

  Returns :ok or {:error, message}
  """
  def validate_address_binding(attrs) do
    with {:ok, _city} <- validate_city(attrs["city_id"]),
         {:ok, _locality} <- validate_locality(attrs["locality_id"], attrs["city_id"]) do
      :ok
    end
  end

  defp validate_city(nil), do: {:error, "City is required"}

  defp validate_city(city_id) do
    try do
      city = Geography.get_city!(city_id)
      {:ok, city}
    rescue
      Ecto.NoResultsError -> {:error, "City not found"}
    end
  end

  defp validate_locality(nil, _city_id), do: {:error, "Locality is required"}

  defp validate_locality(locality_id, city_id) do
    try do
      locality = Geography.get_locality!(locality_id)

      if locality.city_id == city_id do
        {:ok, locality}
      else
        {:error, "Locality does not belong to the specified city"}
      end
    rescue
      Ecto.NoResultsError -> {:error, "Locality not found"}
    end
  end

  @doc """
  Syncs property when locality changes (e.g., locality merged or renamed).

  This would be called by a Geography domain event handler.
  """
  def sync_locality_change(old_locality_id, new_locality_id) do
    Property
    |> where([p], p.locality_id == ^old_locality_id)
    |> Repo.update_all(set: [locality_id: new_locality_id, updated_at: DateTime.utc_now()])
  end

  # ============================================================================
  # User Management Integration
  # ============================================================================

  @doc """
  Calculates owner trust score based on verification status.

  This can be used by the Listings domain to boost listing quality.

  Returns a score from 0-100:
  - Unverified owner: 0
  - Pending verification: 25
  - Verified owner: 100
  """
  def calculate_owner_trust_score(%Property{} = property) do
    property = Repo.preload(property, :owner)

    case property.verification_status do
      "verified" -> 100
      "pending" -> 25
      _ -> 0
    end
  end

  @doc """
  Gets enhanced property data for listing creation.

  Includes owner trust score and quality metrics.
  """
  def get_property_for_listing(property_id) do
    property = get_property!(property_id)
    property = Repo.preload(property, [:owner, :documents, :images])

    %{
      property: property,
      owner_trust_score: calculate_owner_trust_score(property),
      quality_score: property.quality_score,
      data_completeness: property.data_completeness_score,
      is_verified: property.verification_status == "verified",
      document_count: length(property.documents || []),
      image_count: length(property.images || [])
    }
  end

  # ============================================================================
  # Duplicate Detection
  # ============================================================================

  @doc """
  Finds potential duplicate properties using fuzzy matching.

  Checks for duplicates based on:
  - Same locality
  - Similar address (Levenshtein distance)
  - Location proximity (within 50 meters if GPS available)
  - Same property type

  Returns list of potential duplicates with similarity scores.
  """
  def find_potential_duplicates(attrs) do
    locality_id = attrs["locality_id"] || attrs[:locality_id]
    address_text = attrs["address_text"] || attrs[:address_text]
    property_type = attrs["type"] || attrs[:type]
    location = attrs["location"] || attrs[:location]

    if is_nil(locality_id) do
      []
    else
      query =
        Property
        |> where([p], p.locality_id == ^locality_id)
        |> where([p], p.status != "archived")

      # Filter by property type if provided
      query =
        if property_type do
          where(query, [p], p.type == ^property_type)
        else
          query
        end

      # Get candidates
      candidates = Repo.all(query)

      # Score each candidate
      candidates
      |> Enum.map(fn candidate ->
        similarity_score = calculate_similarity_score(candidate, address_text, location)
        %{property: candidate, similarity_score: similarity_score}
      end)
      |> Enum.filter(fn %{similarity_score: score} -> score > 50 end)
      |> Enum.sort_by(fn %{similarity_score: score} -> score end, :desc)
    end
  end

  defp calculate_similarity_score(property, address_text, location) do
    address_score = calculate_address_similarity(property.address_text, address_text)
    location_score = calculate_location_similarity(property.location, location)

    # Weighted average: address 60%, location 40%
    trunc(address_score * 0.6 + location_score * 0.4)
  end

  defp calculate_address_similarity(nil, _), do: 0
  defp calculate_address_similarity(_, nil), do: 0

  defp calculate_address_similarity(addr1, addr2) do
    # Simple Levenshtein-based similarity
    addr1_lower = String.downcase(addr1)
    addr2_lower = String.downcase(addr2)

    distance = String.jaro_distance(addr1_lower, addr2_lower)
    trunc(distance * 100)
  end

  defp calculate_location_similarity(nil, _), do: 0
  defp calculate_location_similarity(_, nil), do: 0

  defp calculate_location_similarity(loc1, loc2) do
    # Calculate distance between two PostGIS points
    # If within 50m, score 100; if within 200m, score 50; else 0
    query =
      from(
        _ in Property,
        select:
          fragment(
            "ST_Distance(?::geography, ?::geography)",
            ^loc1,
            ^loc2
          )
      )

    case Repo.one(query) do
      nil ->
        0

      distance when distance < 50 ->
        100

      distance when distance < 200 ->
        50

      _ ->
        0
    end
  end

  # ============================================================================
  # Media Vault Enhancements
  # ============================================================================

  @doc """
  Validates media upload limits for a property.

  Returns :ok or {:error, message}
  """
  def validate_media_upload_limit(%Property{} = property) do
    property = Repo.preload(property, :images)
    image_count = length(property.images || [])

    if image_count >= 20 do
      {:error, "Maximum 20 media items allowed per property"}
    else
      :ok
    end
  end

  @doc """
  Creates a property image with validation.
  """
  def create_property_image_with_validation(%Property{} = property, attrs \\ %{}) do
    with :ok <- validate_media_upload_limit(property),
         {:ok, image} <- create_property_image(property, attrs) do
      {:ok, image}
    end
  end

  @doc """
  Gets media statistics for a property.
  """
  def get_property_media_stats(property_id) do
    property = get_property!(property_id) |> Repo.preload(:images)

    images_by_type =
      Enum.group_by(property.images || [], fn img -> img.type end)
      |> Enum.map(fn {type, images} -> {type, length(images)} end)
      |> Map.new()

    %{
      total_images: length(property.images || []),
      images_by_type: images_by_type,
      has_primary: Enum.any?(property.images || [], fn img -> img.is_primary end),
      remaining_slots: max(0, 20 - length(property.images || []))
    }
  end
end
