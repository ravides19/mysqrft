defmodule MySqrft.Properties.PropertyPriceHistory do
  @moduledoc """
  Tracks all pricing history for a property across all its listings over time.

  This provides property-level analytics:
  - How has this property been priced historically?
  - What was the rent/sale price in different time periods?
  - Price trends for the property over years
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "property_price_history" do
    belongs_to :property, MySqrft.Properties.Property
    belongs_to :listing, MySqrft.Listings.Listing

    field :transaction_type, :string
    field :price, :decimal
    field :security_deposit, :decimal
    field :status, :string
    field :active_from, :utc_datetime
    field :active_until, :utc_datetime

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def changeset(price_history, attrs) do
    price_history
    |> cast(attrs, [
      :property_id,
      :listing_id,
      :transaction_type,
      :price,
      :security_deposit,
      :status,
      :active_from,
      :active_until
    ])
    |> validate_required([:property_id, :transaction_type, :price])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:security_deposit, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:property_id)
    |> foreign_key_constraint(:listing_id)
  end
end
