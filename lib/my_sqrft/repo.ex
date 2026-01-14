defmodule MySqrft.Repo do
  use Ecto.Repo,
    otp_app: :my_sqrft,
    adapter: Ecto.Adapters.Postgres
end
