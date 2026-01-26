defmodule MySqrft.Listings.Listing do
  @moduledoc """
  The Listing schema represents a market posting for a Property.

  A Listing is the temporal market intent - it links to a persistent Property asset
  and contains market-specific data like price, availability, and preferences.

  ## State Machine

  ```
  draft → pending_review → active → paused → active
                             ↓         ↓
                          expired  closed
  ```

  ## Business Rules

  - A Property cannot have 2 active listings of the same transaction_type
  - Active listings auto-expire after 60 days if not refreshed
  - Price must be > 0
  - Available from date must be >= today (for new listings)
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "listings" do
    # Relationships
    belongs_to :property, MySqrft.Properties.Property

    # Transaction Details
    field :transaction_type, :string
    field :status, :string, default: "draft"

    # Pricing
    field :ask_price, :decimal
    field :security_deposit, :decimal

    # Availability
    field :available_from, :date

    # Preferences
    field :tenant_preference, :string
    field :diet_preference, :string
    field :furnishing_status, :string

    # Scoring
    field :market_readiness_score, :integer, default: 0
    field :freshness_score, :integer, default: 0
    field :view_count, :integer, default: 0

    # Lifecycle
    field :last_refreshed_at, :utc_datetime
    field :expires_at, :utc_datetime
    field :closed_at, :utc_datetime
    field :closure_reason, :string

    # Associations
    has_many :price_history, MySqrft.Listings.ListingPriceHistory

    timestamps(type: :utc_datetime)
  end

  @transaction_types ~w(rent sale pg_coliving)
  @statuses ~w(draft pending_review active paused expired closed)
  @tenant_preferences ~w(family bachelor company any)
  @diet_preferences ~w(veg non_veg any)
  @furnishing_statuses ~w(unfurnished semi_furnished fully_furnished)
  @closure_reasons ~w(rented sold withdrawn)

  @doc """
  Returns the list of valid transaction types.
  """
  def transaction_types, do: @transaction_types

  @doc """
  Returns the list of valid statuses.
  """
  def statuses, do: @statuses

  @doc """
  Returns the list of valid tenant preferences.
  """
  def tenant_preferences, do: @tenant_preferences

  @doc """
  Returns the list of valid diet preferences.
  """
  def diet_preferences, do: @diet_preferences

  @doc """
  Returns the list of valid furnishing statuses.
  """
  def furnishing_statuses, do: @furnishing_statuses

  @doc """
  Returns the list of valid closure reasons.
  """
  def closure_reasons, do: @closure_reasons

  @doc """
  Changeset for creating/updating a listing.
  """
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [
      :property_id,
      :transaction_type,
      :status,
      :ask_price,
      :security_deposit,
      :available_from,
      :tenant_preference,
      :diet_preference,
      :furnishing_status,
      :market_readiness_score,
      :freshness_score,
      :view_count,
      :last_refreshed_at,
      :expires_at,
      :closed_at,
      :closure_reason
    ])
    |> validate_required([:property_id, :transaction_type, :ask_price])
    |> validate_inclusion(:transaction_type, @transaction_types)
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:tenant_preference, @tenant_preferences ++ [nil])
    |> validate_inclusion(:diet_preference, @diet_preferences ++ [nil])
    |> validate_inclusion(:furnishing_status, @furnishing_statuses ++ [nil])
    |> validate_inclusion(:closure_reason, @closure_reasons ++ [nil])
    |> validate_number(:ask_price, greater_than: 0)
    |> validate_number(:security_deposit, greater_than_or_equal_to: 0)
    |> validate_number(:market_readiness_score,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100
    )
    |> validate_number(:freshness_score, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_available_from()
    |> foreign_key_constraint(:property_id)
    |> unique_constraint([:property_id, :transaction_type],
      name: :listings_active_unique_idx,
      message: "property already has an active listing of this type"
    )
  end

  defp validate_available_from(changeset) do
    case get_change(changeset, :available_from) do
      nil ->
        changeset

      date ->
        today = Date.utc_today()

        if Date.compare(date, today) == :lt do
          add_error(changeset, :available_from, "must be today or in the future")
        else
          changeset
        end
    end
  end

  @doc """
  Checks if a status transition is valid.
  """
  def can_transition?(from_status, to_status) do
    valid_transitions = %{
      "draft" => ["pending_review", "active"],
      "pending_review" => ["active", "draft"],
      "active" => ["paused", "expired", "closed"],
      "paused" => ["active", "closed"],
      "expired" => [],
      "closed" => []
    }

    to_status in Map.get(valid_transitions, from_status, [])
  end
end
