defmodule MySqrft.Listings.SearchSync do
  @moduledoc """
  Handles real-time synchronization of listings with the Search domain.

  This module provides hooks that should be called during listing lifecycle
  events to keep the search index up-to-date.

  ## Integration Points

  The sync hooks should be called from the Listings context:
  - After creating a listing → `sync_create/1`
  - After updating a listing → `sync_update/1`
  - After deleting a listing → `sync_delete/1`
  - After status change → `sync_status_change/1`

  ## Future Implementation

  When the Search domain is implemented, replace the stub functions with
  actual calls to the search service (Elasticsearch, Algolia, Typesense, etc.).
  """

  alias MySqrft.Listings.{Listing, SearchDocument}
  require Logger

  @doc """
  Syncs a newly created listing to the search index.

  This should be called after a listing is successfully created.
  """
  def sync_create(%Listing{} = listing) do
    if should_index?(listing) do
      document = SearchDocument.to_search_document(listing)
      document_id = SearchDocument.document_id(listing)

      # TODO: Replace with actual search service call
      # Example: MySqrft.Search.index_document("listings", document_id, document)

      log_sync_event("create", listing.id, document)
      {:ok, :synced}
    else
      {:ok, :skipped}
    end
  end

  @doc """
  Syncs an updated listing to the search index.

  This should be called after a listing is successfully updated.
  """
  def sync_update(%Listing{} = listing) do
    if should_index?(listing) do
      document = SearchDocument.to_search_document(listing)
      document_id = SearchDocument.document_id(listing)

      # TODO: Replace with actual search service call
      # Example: MySqrft.Search.update_document("listings", document_id, document)

      log_sync_event("update", listing.id, document)
      {:ok, :synced}
    else
      # Remove from index if no longer indexable
      sync_delete(listing)
    end
  end

  @doc """
  Removes a listing from the search index.

  This should be called after a listing is deleted or becomes non-indexable.
  """
  def sync_delete(%Listing{} = listing) do
    document_id = SearchDocument.document_id(listing)

    # TODO: Replace with actual search service call
    # Example: MySqrft.Search.delete_document("listings", document_id)

    log_sync_event("delete", listing.id, nil)
    {:ok, :synced}
  end

  @doc """
  Syncs a listing after a status change.

  Special handling for status changes:
  - active → Index the listing
  - paused/expired/closed → Remove from index
  """
  def sync_status_change(%Listing{status: "active"} = listing) do
    sync_update(listing)
  end

  def sync_status_change(%Listing{} = listing) do
    # Remove non-active listings from search
    sync_delete(listing)
  end

  @doc """
  Bulk syncs multiple listings.

  Useful for initial indexing or re-indexing.
  """
  def bulk_sync(listings) when is_list(listings) do
    results =
      Enum.map(listings, fn listing ->
        case sync_update(listing) do
          {:ok, status} -> {listing.id, status}
          {:error, reason} -> {listing.id, {:error, reason}}
        end
      end)

    success_count = Enum.count(results, fn {_, status} -> status == :synced end)
    total_count = length(results)

    Logger.info("[SearchSync] Bulk sync completed: #{success_count}/#{total_count} synced")

    {:ok, %{success: success_count, total: total_count, results: results}}
  end

  @doc """
  Re-indexes all active listings.

  This should be run as a background job for full re-indexing.
  """
  def reindex_all do
    alias MySqrft.Listings

    active_listings =
      Listings.list_listings(status: "active")
      |> MySqrft.Repo.preload([:property, property: [:city, :locality, :owner]])

    bulk_sync(active_listings)
  end

  # Private helpers

  defp should_index?(%Listing{status: "active"}), do: true
  defp should_index?(_), do: false

  defp log_sync_event(action, listing_id, document) do
    Logger.debug(
      "[SearchSync] #{action} listing #{listing_id}" <>
        if(document, do: " (boost: #{document.boost_score})", else: "")
    )
  end

  @doc """
  Returns sync statistics for monitoring.
  """
  def get_sync_stats do
    # TODO: Implement actual sync stats from search service
    # For now, return placeholder stats
    %{
      total_indexed: 0,
      last_sync_at: nil,
      sync_lag_seconds: 0,
      status: :not_implemented
    }
  end
end
