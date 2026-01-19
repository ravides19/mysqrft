defmodule MySqrft.Repo do
  use Ecto.Repo,
    otp_app: :my_sqrft,
    adapter: Ecto.Adapters.Postgres

  # Configure Postgrex to use PostGIS types
  def init(_type, config) do
    config =
      config
      |> Keyword.put(:types, MySqrft.PostgresTypes)

    {:ok, config}
  end
end
