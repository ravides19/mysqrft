defmodule MySqrft.Listings.ListingPriceHistory do
  @moduledoc """
  Tracks price changes for a specific listing over time.

  This allows analytics on how listing prices change during their active period.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "listing_price_history" do
    belongs_to :listing, MySqrft.Listings.Listing
    belongs_to :changed_by, MySqrft.UserManagement.Profile

    field :price, :decimal
    field :security_deposit, :decimal
    field :change_reason, :string

    timestamps(type: :utc_datetime, updated_at: false)
  end

  def changeset(price_history, attrs) do
    price_history
    |> cast(attrs, [:listing_id, :price, :security_deposit, :changed_by_id, :change_reason])
    |> validate_required([:listing_id, :price])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:security_deposit, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:listing_id)
    |> foreign_key_constraint(:changed_by_id)
  end
end
