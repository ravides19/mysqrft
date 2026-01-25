# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :my_sqrft, :scopes,
  user: [
    default: true,
    module: MySqrft.Auth.Scope,
    assign_key: :current_scope,
    access_path: [:user, :id],
    schema_key: :user_id,
    schema_type: :binary_id,
    schema_table: :users,
    test_data_fixture: MySqrft.AuthFixtures,
    test_setup_helper: :register_and_log_in_user
  ]

config :my_sqrft,
  ecto_repos: [MySqrft.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configure the endpoint
config :my_sqrft, MySqrftWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: MySqrftWeb.ErrorHTML, json: MySqrftWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MySqrft.PubSub,
  live_view: [signing_salt: "YphVryyk"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :my_sqrft, MySqrft.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  my_sqrft: [
    args:
      ~w(js/app.js js/storybook.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  my_sqrft: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ],
  storybook: [
    args: ~w(
      --input=css/storybook.css
      --output=../priv/static/assets/storybook.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure bcrypt cost factor (log_rounds)
# Cost factor 12 means 2^12 = 4096 iterations
config :bcrypt_elixir, :log_rounds, 12

# Configure Ola Maps Geocoding API
# Get your API key from: https://maps.olakrutrim.com
# Set OLA_MAPS_API_KEY environment variable or configure here
config :my_sqrft,
       :ola_maps_api_key,
       System.get_env("OLA_MAPS_API_KEY")

# Enable/disable Ola Maps geocoding (set to false to use only internal geocoding)
config :my_sqrft, :ola_maps_enabled, true

config :ex_aws, :s3,
  scheme: "https://",
  host: "fly.storage.tigris.dev",
  region: "auto"

config :my_sqrft, :tigris_bucket, System.get_env("BUCKET_NAME") || "mysqrft-local-dev"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
