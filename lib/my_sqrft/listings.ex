defmodule MySqrft.Listings do
  @moduledoc """
  The Listings context for managing marketplace postings.
  """

  import Ecto.Query, warn: false
  alias MySqrft.Repo
  alias MySqrft.Listings.Listing
  alias MySqrft.Listings.ListingPriceHistory
  alias MySqrft.Properties.Property
  alias MySqrft.Properties.PropertyPriceHistory

  @expiry_days 60

  # Basic CRUD Operations

  def list_listings(opts \\ []) do
    Listing
    |> apply_filters(opts)
    |> maybe_preload(opts[:preload])
    |> Repo.all()
  end

  def list_property_listings(property_id, opts \\ []) do
    Listing
    |> where([l], l.property_id == ^property_id)
    |> maybe_preload(opts[:preload])
    |> order_by([l], desc: l.inserted_at)
    |> Repo.all()
  end

  def list_user_listings(user_id, opts \\ []) do
    Listing
    |> join(:inner, [l], p in Property, on: l.property_id == p.id)
    |> join(:inner, [l, p], owner in assoc(p, :owner))
    |> where([l, p, owner], owner.user_id == ^user_id)
    |> apply_filters(opts)
    |> maybe_preload(opts[:preload])
    |> order_by([l], desc: l.inserted_at)
    |> Repo.all()
  end

  def get_listing!(id, opts \\ []) do
    Listing
    |> maybe_preload(opts[:preload])
    |> Repo.get!(id)
  end

  def create_listing(%Property{} = property, attrs \\ %{}) do
    attrs = Map.put(attrs, "property_id", property.id)

    result =
      %Listing{}
      |> Listing.changeset(attrs)
      |> maybe_set_expiry()
      |> Repo.insert()

    case result do
      {:ok, listing} ->
        create_listing_price_history(listing, %{
          price: listing.ask_price,
          security_deposit: listing.security_deposit,
          change_reason: "Initial listing creation"
        })

        if listing.status == "active" do
          create_property_price_history(listing)
        end

        {:ok, Repo.preload(listing, :property)}

      error ->
        error
    end
  end

  def update_listing(%Listing{} = listing, attrs) do
    old_price = listing.ask_price
    old_status = listing.status

    changeset = Listing.changeset(listing, attrs)
    new_price = get_change(changeset, :ask_price)
    new_status = get_change(changeset, :status)

    result = Repo.update(changeset)

    case result do
      {:ok, updated_listing} ->
        if new_price && Decimal.compare(new_price, old_price) != :eq do
          create_listing_price_history(updated_listing, %{
            price: new_price,
            security_deposit: updated_listing.security_deposit,
            change_reason: "Price updated"
          })
        end

        if new_status && new_status != old_status do
          handle_status_change_price_history(updated_listing, old_status, new_status)
        end

        {:ok, updated_listing}

      error ->
        error
    end
  end

  def delete_listing(%Listing{} = listing) do
    Repo.delete(listing)
  end

  def change_listing(%Listing{} = listing, attrs \\ %{}) do
    Listing.changeset(listing, attrs)
  end

  # State Transitions

  def publish_listing(%Listing{status: "draft"} = listing) do
    now = DateTime.utc_now()

    result =
      listing
      |> Listing.changeset(%{
        status: "active",
        last_refreshed_at: now,
        expires_at: calculate_expires_at(now)
      })
      |> Repo.update()

    case result do
      {:ok, updated_listing} ->
        create_property_price_history(updated_listing)
        {:ok, updated_listing}

      error ->
        error
    end
  end

  def publish_listing(%Listing{} = listing) do
    {:error, "Can only publish draft listings. Current status: #{listing.status}"}
  end

  def pause_listing(%Listing{status: "active"} = listing) do
    result =
      listing
      |> Listing.changeset(%{status: "paused"})
      |> Repo.update()

    case result do
      {:ok, _} -> close_property_price_history(listing)
      _ -> :ok
    end

    result
  end

  def pause_listing(%Listing{} = listing) do
    {:error, "Can only pause active listings. Current status: #{listing.status}"}
  end

  def resume_listing(%Listing{status: "paused"} = listing) do
    now = DateTime.utc_now()

    result =
      listing
      |> Listing.changeset(%{
        status: "active",
        last_refreshed_at: now,
        expires_at: calculate_expires_at(now)
      })
      |> Repo.update()

    case result do
      {:ok, updated_listing} ->
        create_property_price_history(updated_listing)
        {:ok, updated_listing}

      error ->
        error
    end
  end

  def resume_listing(%Listing{} = listing) do
    {:error, "Can only resume paused listings. Current status: #{listing.status}"}
  end

  def close_listing(%Listing{} = listing, opts \\ [])
      when listing.status in ["active", "paused"] do
    reason = opts[:reason] || "withdrawn"

    result =
      listing
      |> Listing.changeset(%{
        status: "closed",
        closed_at: DateTime.utc_now(),
        closure_reason: reason
      })
      |> Repo.update()

    case result do
      {:ok, _} -> close_property_price_history(listing)
      _ -> :ok
    end

    result
  end

  def close_listing(%Listing{} = listing, _opts) do
    {:error, "Can only close active or paused listings. Current status: #{listing.status}"}
  end

  def expire_listing(%Listing{status: "active"} = listing) do
    result =
      listing
      |> Listing.changeset(%{status: "expired"})
      |> Repo.update()

    case result do
      {:ok, _} -> close_property_price_history(listing)
      _ -> :ok
    end

    result
  end

  def expire_listing(%Listing{} = listing) do
    {:error, "Can only expire active listings. Current status: #{listing.status}"}
  end

  # Lifecycle Management

  def refresh_listing(%Listing{status: "active"} = listing) do
    now = DateTime.utc_now()

    listing
    |> Listing.changeset(%{
      last_refreshed_at: now,
      expires_at: calculate_expires_at(now)
    })
    |> Repo.update()
  end

  def refresh_listing(%Listing{} = listing) do
    {:error, "Can only refresh active listings. Current status: #{listing.status}"}
  end

  def repost_listing(%Listing{status: "closed"} = closed_listing) do
    attrs = %{
      "transaction_type" => closed_listing.transaction_type,
      "ask_price" => closed_listing.ask_price,
      "security_deposit" => closed_listing.security_deposit,
      "available_from" => Date.utc_today(),
      "tenant_preference" => closed_listing.tenant_preference,
      "diet_preference" => closed_listing.diet_preference,
      "furnishing_status" => closed_listing.furnishing_status
    }

    closed_listing
    |> Repo.preload(:property)
    |> Map.get(:property)
    |> create_listing(attrs)
  end

  def repost_listing(%Listing{} = listing) do
    {:error, "Can only repost closed listings. Current status: #{listing.status}"}
  end

  def expire_stale_listings do
    now = DateTime.utc_now()

    {count, _} =
      Listing
      |> where([l], l.status == "active")
      |> where([l], l.expires_at < ^now)
      |> Repo.update_all(set: [status: "expired", updated_at: now])

    {:ok, count}
  end

  def calculate_expires_at(from_datetime \\ DateTime.utc_now()) do
    from_datetime
    |> DateTime.add(@expiry_days * 24 * 60 * 60, :second)
  end

  # Price History

  def create_listing_price_history(%Listing{} = listing, attrs) do
    attrs =
      Map.merge(attrs, %{
        "listing_id" => listing.id,
        "price" => attrs[:price] || listing.ask_price,
        "security_deposit" => attrs[:security_deposit] || listing.security_deposit
      })

    %ListingPriceHistory{}
    |> ListingPriceHistory.changeset(attrs)
    |> Repo.insert()
  end

  def create_property_price_history(%Listing{status: "active"} = listing) do
    listing = Repo.preload(listing, :property)

    %PropertyPriceHistory{}
    |> PropertyPriceHistory.changeset(%{
      "property_id" => listing.property_id,
      "listing_id" => listing.id,
      "transaction_type" => listing.transaction_type,
      "price" => listing.ask_price,
      "security_deposit" => listing.security_deposit,
      "status" => "active",
      "active_from" => listing.last_refreshed_at || DateTime.utc_now()
    })
    |> Repo.insert()
  end

  def create_property_price_history(_listing), do: {:ok, nil}

  def close_property_price_history(%Listing{} = listing) do
    PropertyPriceHistory
    |> where([pph], pph.listing_id == ^listing.id)
    |> where([pph], is_nil(pph.active_until))
    |> Repo.update_all(set: [active_until: DateTime.utc_now(), status: "closed"])

    :ok
  end

  def list_listing_price_history(listing_id) do
    ListingPriceHistory
    |> where([lph], lph.listing_id == ^listing_id)
    |> order_by([lph], desc: lph.inserted_at)
    |> Repo.all()
  end

  def list_property_price_history(property_id, opts \\ []) do
    query =
      PropertyPriceHistory
      |> where([pph], pph.property_id == ^property_id)

    query =
      if opts[:transaction_type] do
        where(query, [pph], pph.transaction_type == ^opts[:transaction_type])
      else
        query
      end

    query
    |> order_by([pph], desc: pph.inserted_at)
    |> Repo.all()
  end

  # Statistics

  def count_active_listings do
    Listing
    |> where([l], l.status == "active")
    |> Repo.aggregate(:count)
  end

  def count_user_active_listings(user_id) do
    Listing
    |> join(:inner, [l], p in Property, on: l.property_id == p.id)
    |> join(:inner, [l, p], owner in assoc(p, :owner))
    |> where([l, p, owner], owner.user_id == ^user_id)
    |> where([l], l.status == "active")
    |> Repo.aggregate(:count)
  end

  def count_expired_listings do
    Listing
    |> where([l], l.status == "expired")
    |> Repo.aggregate(:count)
  end

  # Private Helpers

  defp apply_filters(query, opts) do
    Enum.reduce(opts, query, fn
      {:status, status}, query ->
        where(query, [l], l.status == ^status)

      {:transaction_type, type}, query ->
        where(query, [l], l.transaction_type == ^type)

      {:property_id, property_id}, query ->
        where(query, [l], l.property_id == ^property_id)

      _other, query ->
        query
    end)
  end

  defp maybe_preload(query, nil), do: query
  defp maybe_preload(query, []), do: query
  defp maybe_preload(query, preloads), do: preload(query, ^preloads)

  defp maybe_set_expiry(changeset) do
    status = Ecto.Changeset.get_field(changeset, :status)

    if status == "active" do
      now = DateTime.utc_now()

      changeset
      |> Ecto.Changeset.put_change(:last_refreshed_at, now)
      |> Ecto.Changeset.put_change(:expires_at, calculate_expires_at(now))
    else
      changeset
    end
  end

  defp get_change(changeset, field) do
    case Ecto.Changeset.fetch_change(changeset, field) do
      {:ok, value} -> value
      :error -> nil
    end
  end

  defp handle_status_change_price_history(listing, old_status, new_status) do
    cond do
      new_status == "active" and old_status != "active" ->
        create_property_price_history(listing)

      old_status == "active" and new_status != "active" ->
        close_property_price_history(listing)

      true ->
        :ok
    end
  end

  # ============================================================================
  # Search Domain Integration
  # ============================================================================

  alias MySqrft.Listings.SearchSync

  @doc """
  Syncs a listing to the search index.

  This is called automatically after create/update operations.
  Can also be called manually to force a sync.
  """
  def sync_to_search(%Listing{} = listing) do
    SearchSync.sync_update(listing)
  end

  @doc """
  Re-indexes all active listings in the search domain.

  This should be run as a background job for full re-indexing.
  """
  def reindex_all_listings do
    SearchSync.reindex_all()
  end

  @doc """
  Gets search sync statistics.
  """
  def get_search_sync_stats do
    SearchSync.get_sync_stats()
  end

  # ============================================================================
  # Scoring & Analytics
  # ============================================================================

  alias MySqrft.Listings.{FreshnessScoreCalculator, MarketReadinessScoreCalculator}

  @doc """
  Calculates and updates freshness score for a listing.
  """
  def update_freshness_score(%Listing{} = listing) do
    freshness_score = FreshnessScoreCalculator.calculate(listing)

    listing
    |> Ecto.Changeset.change(%{freshness_score: freshness_score})
    |> Repo.update()
  end

  @doc """
  Calculates and updates market readiness score for a listing.
  """
  def update_market_readiness_score(%Listing{} = listing) do
    market_readiness_score = MarketReadinessScoreCalculator.calculate(listing)

    listing
    |> Ecto.Changeset.change(%{market_readiness_score: market_readiness_score})
    |> Repo.update()
  end

  @doc """
  Updates both freshness and market readiness scores for a listing.
  """
  def update_all_scores(%Listing{} = listing) do
    freshness_score = FreshnessScoreCalculator.calculate(listing)
    market_readiness_score = MarketReadinessScoreCalculator.calculate(listing)

    listing
    |> Ecto.Changeset.change(%{
      freshness_score: freshness_score,
      market_readiness_score: market_readiness_score
    })
    |> Repo.update()
  end

  @doc """
  Gets improvement suggestions for a listing.
  """
  def get_improvement_suggestions(%Listing{} = listing) do
    MarketReadinessScoreCalculator.get_improvement_suggestions(listing)
  end

  @doc """
  Checks if a listing is market-ready.
  """
  def is_market_ready?(%Listing{} = listing) do
    MarketReadinessScoreCalculator.is_market_ready?(listing)
  end

  @doc """
  Checks if a listing is fresh.
  """
  def is_fresh?(%Listing{} = listing) do
    FreshnessScoreCalculator.is_fresh?(listing)
  end

  @doc """
  Bulk updates scores for all active listings.

  This should be run as a background job (e.g., daily via Oban).
  """
  def bulk_update_scores do
    active_listings = list_listings(status: "active")

    results =
      Enum.map(active_listings, fn listing ->
        case update_all_scores(listing) do
          {:ok, updated_listing} ->
            {listing.id, :success, updated_listing.freshness_score,
             updated_listing.market_readiness_score}

          {:error, _} ->
            {listing.id, :error, nil, nil}
        end
      end)

    success_count = Enum.count(results, fn {_, status, _, _} -> status == :success end)

    {:ok, %{total: length(results), success: success_count, results: results}}
  end
end
