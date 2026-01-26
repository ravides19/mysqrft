# Seeds for user addresses - 50+ addresses
alias MySqrft.Repo
alias MySqrft.UserManagement.{Profile, Address}
alias MySqrft.Geography.{City, Locality, Pincode}

profiles = Repo.all(Profile)
cities = Repo.all(City)
localities = Repo.all(Locality)
pincodes = Repo.all(Pincode)

# Create lookup maps
city_names = Enum.into(cities, %{}, fn c -> {c.id, c.name} end)
locality_pincodes = Enum.into(pincodes, %{}, fn p -> {p.locality_id, p.code} end)

address_types = ["home", "work", "office", "other"]

# Assign 1-2 addresses to each profile
addresses_data = Enum.flat_map(Enum.with_index(profiles), fn {profile, index} ->
  count = 1 + rem(index, 2) # 1 or 2 addresses

  Enum.map(1..count, fn i ->
    locality = Enum.random(localities)
    city_name = Map.get(city_names, locality.city_id, "Bangalore")
    pincode = Map.get(locality_pincodes, locality.id, "560001")

    street = "No. #{1 + rem(index * 10 + i, 500)}, #{rem(index, 20)}th Cross, #{rem(index, 10)}th Main"

    %{
      user_profile_id: profile.id,
      type: Enum.at(address_types, rem(i, 4)),
      line1: street,
      city: city_name,
      locality: locality.name,
      pin_code: pincode,
      state: "Karnataka", # Simplified
      country: "IN",
      is_primary: (i == 1)
    }
  end)
end)

Enum.each(addresses_data, fn address_data ->
  Repo.insert!(%Address{
    user_profile_id: address_data.user_profile_id,
    type: address_data.type,
    line1: address_data.line1,
    city: address_data.city,
    locality: address_data.locality,
    pin_code: address_data.pin_code,
    state: address_data.state,
    country: address_data.country,
    is_primary: address_data.is_primary
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Address, :count, :id)} addresses")
