defmodule MySqrft.Repo do
  use Ecto.Repo,
    otp_app: :my_sqrft,
    adapter: Ecto.Adapters.Postgres

  # Configure Postgrex to use PostGIS types
  def init(_type, config) do
    # Define custom Postgres types with PostGIS extension
    Postgrex.Types.define(
      MySqrft.PostgresTypes,
      [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
      json: Jason
    )

    config =
      config
      |> Keyword.put(:types, MySqrft.PostgresTypes)

    {:ok, config}
  end
end
