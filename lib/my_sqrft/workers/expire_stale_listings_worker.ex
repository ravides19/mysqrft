defmodule MySqrft.Workers.ExpireStaleListingsWorker do
  @moduledoc """
  Oban worker that automatically expires stale listings.

  This worker runs daily at midnight (configured in config.exs) and expires
  all active listings that have passed their expiry date (60 days from last refresh).

  ## Configuration

  Configured in `config/config.exs`:
  ```elixir
  {Oban.Plugins.Cron,
   crontab: [
     {"0 0 * * *", MySqrft.Workers.ExpireStaleListingsWorker}
   ]}
  ```

  ## Manual Execution

  You can manually trigger this worker in IEx:
  ```elixir
  %{}
  |> MySqrft.Workers.ExpireStaleListingsWorker.new()
  |> Oban.insert()
  ```
  """

  use Oban.Worker, queue: :listings, max_attempts: 3

  alias MySqrft.Listings

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    Logger.info("[ExpireStaleListingsWorker] Starting auto-expiry job")

    case Listings.expire_stale_listings() do
      {:ok, count} when count > 0 ->
        Logger.info("[ExpireStaleListingsWorker] Expired #{count} stale listing(s)")
        {:ok, %{expired_count: count}}

      {:ok, 0} ->
        Logger.debug("[ExpireStaleListingsWorker] No stale listings to expire")
        {:ok, %{expired_count: 0}}
    end
  end
end
