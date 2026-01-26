# Seeds for listings - 50+ listings (one for most properties)
alias MySqrft.Repo
alias MySqrft.Properties.Property
alias MySqrft.Listings.Listing

properties = Repo.all(Property)

# Prices based on property type and city (simple logic for seeding)
# Rent: 0.2% - 0.4% of property value per month
# Sale: Base price per sqft depending on city

transaction_types = ["rent", "sale", "rent", "sale", "pg_coliving"]
statuses = ["active", "active", "active", "draft", "pending_review", "paused", "closed"]
tenant_preferences = ["family", "bachelor", "company", "any"]
diet_preferences = ["veg", "non_veg", "any"]
furnishing_statuses = ["unfurnished", "semi_furnished", "fully_furnished"]
closure_reasons = ["rented", "sold", "withdrawn"]

listings_data = Enum.with_index(properties)
|> Enum.map(fn {property, index} ->
  transaction_type = Enum.at(transaction_types, rem(index, 5))
  status = Enum.at(statuses, rem(index, 7))

  # Determine price based on property type and somewhat random
  configuration = property.configuration
  area = Map.get(configuration, "area_sqft") || Map.get(configuration, "plot_area_sqft") || 1000

  # Base rates (very approximate)
  sale_rate_per_sqft = 5000 + rem(index * 200, 15000)
  sale_price = Decimal.new(area * sale_rate_per_sqft)

  rent_price = Decimal.div(sale_price, Decimal.new(200)) |> Decimal.round(0) # ~0.5% monthly yield

  ask_price = if transaction_type == "sale", do: sale_price, else: rent_price

  security_deposit = if transaction_type == "sale" do
    nil
  else
    Decimal.mult(rent_price, Decimal.new(6)) # 6 months deposit
  end

  # Dates
  today = Date.utc_today()
  available_from = Date.add(today, rem(index * 5, 60)) # Available within next 60 days

  # Closure info
  {closed_at, closure_reason} = if status == "closed" do
    {DateTime.utc_now(:second), Enum.at(closure_reasons, rem(index, 3))}
  else
    {nil, nil}
  end

  # Scores
  market_readiness = 50 + rem(index * 13, 50)
  freshness = 100 - rem(index * 2, 80)

  %{
    property_id: property.id,
    transaction_type: transaction_type,
    status: status,
    ask_price: ask_price,
    security_deposit: security_deposit,
    available_from: available_from,
    tenant_preference: Enum.at(tenant_preferences, rem(index, 4)),
    diet_preference: Enum.at(diet_preferences, rem(index, 3)),
    furnishing_status: Enum.at(furnishing_statuses, rem(index, 3)),
    market_readiness_score: market_readiness,
    freshness_score: freshness,
    view_count: rem(index * 123, 1000),
    last_refreshed_at: DateTime.utc_now(:second),
    expires_at: DateTime.utc_now(:second) |> DateTime.add(60, :day),
    closed_at: closed_at,
    closure_reason: closure_reason
  }
end)

Enum.each(listings_data, fn listing_data ->
  # Check if we can insert (schema constraint: property + transaction_type unique for active?)
  # The schema constraint unique_index property_id, transaction_type seems to be general, not just active.
  # But we iterate distinct properties, so property_id is unique per loop iteration.

  Repo.insert!(%Listing{
    property_id: listing_data.property_id,
    transaction_type: listing_data.transaction_type,
    status: listing_data.status,
    ask_price: listing_data.ask_price,
    security_deposit: listing_data.security_deposit,
    available_from: listing_data.available_from,
    tenant_preference: listing_data.tenant_preference,
    diet_preference: listing_data.diet_preference,
    furnishing_status: listing_data.furnishing_status,
    market_readiness_score: listing_data.market_readiness_score,
    freshness_score: listing_data.freshness_score,
    view_count: listing_data.view_count,
    last_refreshed_at: listing_data.last_refreshed_at,
    expires_at: listing_data.expires_at,
    closed_at: listing_data.closed_at,
    closure_reason: listing_data.closure_reason
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Listing, :count, :id)} listings")
