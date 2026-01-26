# Seeds for localities - 50+ popular localities
alias MySqrft.Repo
alias MySqrft.Geography.{City, Locality, Pincode}

cities = %{
  "Bangalore" => Repo.get_by!(City, name: "Bangalore"),
  "Mumbai" => Repo.get_by!(City, name: "Mumbai"),
  "Delhi" => Repo.get_by!(City, name: "New Delhi"),
  "Hyderabad" => Repo.get_by!(City, name: "Hyderabad"),
  "Chennai" => Repo.get_by!(City, name: "Chennai"),
  "Pune" => Repo.get_by!(City, name: "Pune"),
  "Kolkata" => Repo.get_by!(City, name: "Kolkata"),
  "Ahmedabad" => Repo.get_by!(City, name: "Ahmedabad"),
  "Jaipur" => Repo.get_by!(City, name: "Jaipur"),
  "Kochi" => Repo.get_by!(City, name: "Kochi")
}

localities_data = [
  # Bangalore - 15 localities
  %{name: "Koramangala", city: "Bangalore", lat: "12.9352", lon: "77.6245", pincode: "560034"},
  %{name: "Indiranagar", city: "Bangalore", lat: "12.9716", lon: "77.6412", pincode: "560038"},
  %{name: "Whitefield", city: "Bangalore", lat: "12.9698", lon: "77.7500", pincode: "560066"},
  %{name: "HSR Layout", city: "Bangalore", lat: "12.9121", lon: "77.6446", pincode: "560102"},
  %{name: "Marathahalli", city: "Bangalore", lat: "12.9591", lon: "77.6974", pincode: "560037"},
  %{name: "Electronic City", city: "Bangalore", lat: "12.8456", lon: "77.6603", pincode: "560100"},
  %{name: "Jayanagar", city: "Bangalore", lat: "12.9250", lon: "77.5838", pincode: "560041"},
  %{name: "BTM Layout", city: "Bangalore", lat: "12.9165", lon: "77.6101", pincode: "560076"},
  %{name: "Malleshwaram", city: "Bangalore", lat: "13.0059", lon: "77.5713", pincode: "560003"},
  %{name: "Rajajinagar", city: "Bangalore", lat: "12.9916", lon: "77.5544", pincode: "560010"},
  %{name: "Yelahanka", city: "Bangalore", lat: "13.1007", lon: "77.5963", pincode: "560064"},
  %{name: "Banashankari", city: "Bangalore", lat: "12.9250", lon: "77.5500", pincode: "560070"},
  %{name: "Sarjapur Road", city: "Bangalore", lat: "12.9100", lon: "77.6900", pincode: "560035"},
  %{name: "Bellandur", city: "Bangalore", lat: "12.9259", lon: "77.6766", pincode: "560103"},
  %{name: "Hebbal", city: "Bangalore", lat: "13.0358", lon: "77.5970", pincode: "560024"},

  # Mumbai - 10 localities
  %{name: "Andheri", city: "Mumbai", lat: "19.1136", lon: "72.8697", pincode: "400053"},
  %{name: "Bandra", city: "Mumbai", lat: "19.0596", lon: "72.8295", pincode: "400050"},
  %{name: "Powai", city: "Mumbai", lat: "19.1176", lon: "72.9060", pincode: "400076"},
  %{name: "Goregaon", city: "Mumbai", lat: "19.1653", lon: "72.8489", pincode: "400062"},
  %{name: "Malad", city: "Mumbai", lat: "19.1864", lon: "72.8481", pincode: "400064"},
  %{name: "Borivali", city: "Mumbai", lat: "19.2403", lon: "72.8565", pincode: "400066"},
  %{name: "Kandivali", city: "Mumbai", lat: "19.2074", lon: "72.8479", pincode: "400067"},
  %{name: "Juhu", city: "Mumbai", lat: "19.1075", lon: "72.8263", pincode: "400049"},
  %{name: "Worli", city: "Mumbai", lat: "19.0176", lon: "72.8170", pincode: "400018"},
  %{name: "Lower Parel", city: "Mumbai", lat: "18.9988", lon: "72.8303", pincode: "400013"},

  # Delhi - 8 localities
  %{name: "Connaught Place", city: "Delhi", lat: "28.6304", lon: "77.2177", pincode: "110001"},
  %{name: "Dwarka", city: "Delhi", lat: "28.5921", lon: "77.0460", pincode: "110075"},
  %{name: "Rohini", city: "Delhi", lat: "28.7495", lon: "77.0736", pincode: "110085"},
  %{name: "Saket", city: "Delhi", lat: "28.5244", lon: "77.2066", pincode: "110017"},
  %{name: "Vasant Kunj", city: "Delhi", lat: "28.5200", lon: "77.1598", pincode: "110070"},
  %{name: "Greater Kailash", city: "Delhi", lat: "28.5494", lon: "77.2426", pincode: "110048"},
  %{name: "Lajpat Nagar", city: "Delhi", lat: "28.5677", lon: "77.2431", pincode: "110024"},
  %{name: "Karol Bagh", city: "Delhi", lat: "28.6519", lon: "77.1900", pincode: "110005"},

  # Hyderabad - 8 localities
  %{name: "Gachibowli", city: "Hyderabad", lat: "17.4399", lon: "78.3487", pincode: "500032"},
  %{name: "Hitech City", city: "Hyderabad", lat: "17.4485", lon: "78.3908", pincode: "500081"},
  %{name: "Madhapur", city: "Hyderabad", lat: "17.4483", lon: "78.3915", pincode: "500081"},
  %{name: "Banjara Hills", city: "Hyderabad", lat: "17.4239", lon: "78.4738", pincode: "500034"},
  %{name: "Jubilee Hills", city: "Hyderabad", lat: "17.4326", lon: "78.4071", pincode: "500033"},
  %{name: "Kondapur", city: "Hyderabad", lat: "17.4616", lon: "78.3643", pincode: "500084"},
  %{name: "Kukatpally", city: "Hyderabad", lat: "17.4849", lon: "78.3914", pincode: "500072"},
  %{name: "Miyapur", city: "Hyderabad", lat: "17.4967", lon: "78.3583", pincode: "500049"},

  # Chennai - 6 localities
  %{name: "Anna Nagar", city: "Chennai", lat: "13.0850", lon: "80.2101", pincode: "600040"},
  %{name: "T Nagar", city: "Chennai", lat: "13.0418", lon: "80.2341", pincode: "600017"},
  %{name: "Velachery", city: "Chennai", lat: "12.9750", lon: "80.2210", pincode: "600042"},
  %{name: "Adyar", city: "Chennai", lat: "13.0067", lon: "80.2572", pincode: "600020"},
  %{name: "OMR", city: "Chennai", lat: "12.8996", lon: "80.2209", pincode: "600097"},
  %{name: "Porur", city: "Chennai", lat: "13.0358", lon: "80.1572", pincode: "600116"},

  # Pune - 5 localities
  %{name: "Hinjewadi", city: "Pune", lat: "18.5912", lon: "73.7389", pincode: "411057"},
  %{name: "Kothrud", city: "Pune", lat: "18.5074", lon: "73.8077", pincode: "411038"},
  %{name: "Wakad", city: "Pune", lat: "18.5974", lon: "73.7898", pincode: "411057"},
  %{name: "Viman Nagar", city: "Pune", lat: "18.5679", lon: "73.9143", pincode: "411014"},
  %{name: "Baner", city: "Pune", lat: "18.5590", lon: "73.7804", pincode: "411045"},

  # Kolkata - 4 localities
  %{name: "Salt Lake", city: "Kolkata", lat: "22.5804", lon: "88.4161", pincode: "700091"},
  %{name: "New Town", city: "Kolkata", lat: "22.5958", lon: "88.4636", pincode: "700156"},
  %{name: "Park Street", city: "Kolkata", lat: "22.5535", lon: "88.3516", pincode: "700016"},
  %{name: "Rajarhat", city: "Kolkata", lat: "22.6211", lon: "88.4542", pincode: "700135"},

  # Ahmedabad - 3 localities
  %{name: "Satellite", city: "Ahmedabad", lat: "23.0300", lon: "72.5200", pincode: "380015"},
  %{name: "Vastrapur", city: "Ahmedabad", lat: "23.0395", lon: "72.5268", pincode: "380015"},
  %{name: "Bodakdev", city: "Ahmedabad", lat: "23.0395", lon: "72.5068", pincode: "380054"},

  # Jaipur - 3 localities
  %{name: "Malviya Nagar", city: "Jaipur", lat: "26.8523", lon: "75.8154", pincode: "302017"},
  %{name: "Vaishali Nagar", city: "Jaipur", lat: "26.9157", lon: "75.7273", pincode: "302021"},
  %{name: "C Scheme", city: "Jaipur", lat: "26.9124", lon: "75.7873", pincode: "302001"},

  # Kochi - 2 localities
  %{name: "Kakkanad", city: "Kochi", lat: "10.0104", lon: "76.3525", pincode: "682030"},
  %{name: "Edappally", city: "Kochi", lat: "10.0241", lon: "76.3080", pincode: "682024"}
]

Enum.each(localities_data, fn locality_data ->
  locality = Repo.insert!(%Locality{
    name: locality_data.name,
    city_id: cities[locality_data.city].id,
    latitude: Decimal.new(locality_data.lat),
    longitude: Decimal.new(locality_data.lon),
    status: "active",
    metadata: %{}
  })

  # Seed Pincode for this locality if present
  if locality_data.pincode do
    # Use on_conflict: :nothing in case of rerun/dupes
    Repo.insert!(%Pincode{
      code: locality_data.pincode,
      locality_id: locality.id,
      latitude: Decimal.new(locality_data.lat),
      longitude: Decimal.new(locality_data.lon),
      status: "active"
    }, on_conflict: :nothing)
  end
end)

IO.puts("✓ Seeded #{Repo.aggregate(Locality, :count, :id)} localities")
