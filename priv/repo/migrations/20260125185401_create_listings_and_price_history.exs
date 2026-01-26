defmodule MySqrft.Repo.Migrations.CreateListingsAndPriceHistory do
  use Ecto.Migration

  def change do
    # Listings Table
    create table(:listings, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :property_id, references(:properties, type: :binary_id, on_delete: :restrict),
        null: false

      # Transaction Details
      add :transaction_type, :string, null: false
      # draft, pending_review, active, paused, expired, closed
      add :status, :string, default: "draft", null: false

      # Pricing
      add :ask_price, :decimal, precision: 12, scale: 2, null: false
      add :security_deposit, :decimal, precision: 12, scale: 2

      # Availability
      add :available_from, :date

      # Preferences (for rent/PG)
      add :tenant_preference, :string
      add :diet_preference, :string
      add :furnishing_status, :string

      # Scoring
      add :market_readiness_score, :integer, default: 0
      add :freshness_score, :integer, default: 0
      add :view_count, :integer, default: 0

      # Lifecycle
      add :last_refreshed_at, :utc_datetime
      add :expires_at, :utc_datetime
      add :closed_at, :utc_datetime
      add :closure_reason, :string

      timestamps(type: :utc_datetime)
    end

    create index(:listings, [:property_id])
    create index(:listings, [:status])
    create index(:listings, [:transaction_type])
    create index(:listings, [:expires_at])
    create index(:listings, [:status, :transaction_type])

    # Unique constraint: property cannot have 2 active listings of same transaction type
    create unique_index(:listings, [:property_id, :transaction_type],
             where: "status = 'active'",
             name: :listings_active_unique_idx
           )

    # Listing Price History Table
    create table(:listing_price_history, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :listing_id, references(:listings, type: :binary_id, on_delete: :delete_all),
        null: false

      add :price, :decimal, precision: 12, scale: 2, null: false
      add :security_deposit, :decimal, precision: 12, scale: 2
      add :changed_by_id, references(:user_profiles, type: :binary_id)
      add :change_reason, :string

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:listing_price_history, [:listing_id])
    create index(:listing_price_history, [:listing_id, :inserted_at])

    # Property Price History Table (for analytics)
    create table(:property_price_history, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :property_id, references(:properties, type: :binary_id, on_delete: :delete_all),
        null: false

      add :listing_id, references(:listings, type: :binary_id, on_delete: :nilify_all)
      add :transaction_type, :string, null: false
      add :price, :decimal, precision: 12, scale: 2, null: false
      add :security_deposit, :decimal, precision: 12, scale: 2
      add :status, :string
      # Track when this price was active
      add :active_from, :utc_datetime
      add :active_until, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:property_price_history, [:property_id])
    create index(:property_price_history, [:property_id, :transaction_type])
    create index(:property_price_history, [:property_id, :inserted_at])
  end
end
