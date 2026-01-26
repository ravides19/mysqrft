# Seeds for landmarks - 50+ landmarks
alias MySqrft.Repo
alias MySqrft.Geography.{City, Locality, Landmark}

cities = Repo.all(City)
localities = Repo.all(Locality)

categories = ["shopping", "sports", "commercial", "park", "hospital", "school", "transport", "government"]

# Simple generator
landmarks_data = Enum.map(1..50, fn i ->
  # Pick a random locality directly to ensure we always have a valid association
  locality = Enum.random(localities)

  lat_offset = (rem(i, 100) - 50) / 1000.0
  lon_offset = (rem(i * 2, 100) - 50) / 1000.0

  base_lat = locality.latitude
  base_lon = locality.longitude

  %{
    name: "Landmark #{i} - #{Enum.random(["Mall", "Park", "Station", "Hospital", "School"])}",
    category: Enum.random(categories),
    locality_id: locality.id,
    latitude: Decimal.add(base_lat, Decimal.from_float(lat_offset)),
    longitude: Decimal.add(base_lon, Decimal.from_float(lon_offset)),
    status: "active"
  }
end)

Enum.each(landmarks_data, fn landmark_data ->
  Repo.insert!(%Landmark{
    name: landmark_data.name,
    category: landmark_data.category,
    # city_id removed as it does not exist in Landmark schema
    locality_id: landmark_data.locality_id,
    latitude: landmark_data.latitude,
    longitude: landmark_data.longitude,
    status: landmark_data.status,
    metadata: %{}
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Landmark, :count, :id)} landmarks")
