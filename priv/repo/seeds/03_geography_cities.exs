# Seeds for cities - 50+ major Indian cities
alias MySqrft.Repo
alias MySqrft.Geography.{State, City}

# Get states
states = %{
  "KA" => Repo.get_by!(State, code: "KA"),
  "MH" => Repo.get_by!(State, code: "MH"),
  "TN" => Repo.get_by!(State, code: "TN"),
  "DL" => Repo.get_by!(State, code: "DL"),
  "TG" => Repo.get_by!(State, code: "TG"),
  "AP" => Repo.get_by!(State, code: "AP"),
  "GJ" => Repo.get_by!(State, code: "GJ"),
  "RJ" => Repo.get_by!(State, code: "RJ"),
  "UP" => Repo.get_by!(State, code: "UP"),
  "WB" => Repo.get_by!(State, code: "WB"),
  "KL" => Repo.get_by!(State, code: "KL"),
  "PB" => Repo.get_by!(State, code: "PB"),
  "HR" => Repo.get_by!(State, code: "HR"),
  "MP" => Repo.get_by!(State, code: "MP"),
  "BR" => Repo.get_by!(State, code: "BR"),
  "OR" => Repo.get_by!(State, code: "OR"),
  "CT" => Repo.get_by!(State, code: "CT"),
  "JH" => Repo.get_by!(State, code: "JH"),
  "AS" => Repo.get_by!(State, code: "AS"),
  "HP" => Repo.get_by!(State, code: "HP"),
  "UT" => Repo.get_by!(State, code: "UT"),
  "GA" => Repo.get_by!(State, code: "GA"),
  "CH" => Repo.get_by!(State, code: "CH"),
  "PY" => Repo.get_by!(State, code: "PY")
}

cities_data = [
  # Karnataka
  %{name: "Bangalore", name_alt: "ಬೆಂಗಳೂರು", state: "KA", lat: "12.9716", lon: "77.5946"},
  %{name: "Mysore", name_alt: "ಮೈಸೂರು", state: "KA", lat: "12.2958", lon: "76.6394"},
  %{name: "Mangalore", name_alt: "ಮಂಗಳೂರು", state: "KA", lat: "12.9141", lon: "74.8560"},
  %{name: "Hubli", name_alt: "ಹುಬ್ಬಳ್ಳಿ", state: "KA", lat: "15.3647", lon: "75.1240"},
  %{name: "Belgaum", name_alt: "ಬೆಳಗಾವಿ", state: "KA", lat: "15.8497", lon: "74.4977"},

  # Maharashtra
  %{name: "Mumbai", name_alt: "मुंबई", state: "MH", lat: "19.0760", lon: "72.8777"},
  %{name: "Pune", name_alt: "पुणे", state: "MH", lat: "18.5204", lon: "73.8567"},
  %{name: "Nagpur", name_alt: "नागपूर", state: "MH", lat: "21.1458", lon: "79.0882"},
  %{name: "Nashik", name_alt: "नाशिक", state: "MH", lat: "19.9975", lon: "73.7898"},
  %{name: "Aurangabad", name_alt: "औरंगाबाद", state: "MH", lat: "19.8762", lon: "75.3433"},
  %{name: "Thane", name_alt: "ठाणे", state: "MH", lat: "19.2183", lon: "72.9781"},

  # Tamil Nadu
  %{name: "Chennai", name_alt: "சென்னை", state: "TN", lat: "13.0827", lon: "80.2707"},
  %{name: "Coimbatore", name_alt: "கோயம்புத்தூர்", state: "TN", lat: "11.0168", lon: "76.9558"},
  %{name: "Madurai", name_alt: "மதுரை", state: "TN", lat: "9.9252", lon: "78.1198"},
  %{name: "Tiruchirappalli", name_alt: "திருச்சிராப்பள்ளி", state: "TN", lat: "10.7905", lon: "78.7047"},
  %{name: "Salem", name_alt: "சேலம்", state: "TN", lat: "11.6643", lon: "78.1460"},

  # Delhi
  %{name: "New Delhi", name_alt: "नई दिल्ली", state: "DL", lat: "28.6139", lon: "77.2090"},

  # Telangana
  %{name: "Hyderabad", name_alt: "హైదరాబాద్", state: "TG", lat: "17.3850", lon: "78.4867"},
  %{name: "Warangal", name_alt: "వరంగల్", state: "TG", lat: "17.9689", lon: "79.5941"},

  # Andhra Pradesh
  %{name: "Visakhapatnam", name_alt: "విశాఖపట్నం", state: "AP", lat: "17.6868", lon: "83.2185"},
  %{name: "Vijayawada", name_alt: "విజయవాడ", state: "AP", lat: "16.5062", lon: "80.6480"},
  %{name: "Guntur", name_alt: "గుంటూరు", state: "AP", lat: "16.3067", lon: "80.4365"},
  %{name: "Tirupati", name_alt: "తిరుపతి", state: "AP", lat: "13.6288", lon: "79.4192"},

  # Gujarat
  %{name: "Ahmedabad", name_alt: "અમદાવાદ", state: "GJ", lat: "23.0225", lon: "72.5714"},
  %{name: "Surat", name_alt: "સુરત", state: "GJ", lat: "21.1702", lon: "72.8311"},
  %{name: "Vadodara", name_alt: "વડોદરા", state: "GJ", lat: "22.3072", lon: "73.1812"},
  %{name: "Rajkot", name_alt: "રાજકોટ", state: "GJ", lat: "22.3039", lon: "70.8022"},

  # Rajasthan
  %{name: "Jaipur", name_alt: "जयपुर", state: "RJ", lat: "26.9124", lon: "75.7873"},
  %{name: "Jodhpur", name_alt: "जोधपुर", state: "RJ", lat: "26.2389", lon: "73.0243"},
  %{name: "Udaipur", name_alt: "उदयपुर", state: "RJ", lat: "24.5854", lon: "73.7125"},
  %{name: "Kota", name_alt: "कोटा", state: "RJ", lat: "25.2138", lon: "75.8648"},

  # Uttar Pradesh
  %{name: "Lucknow", name_alt: "लखनऊ", state: "UP", lat: "26.8467", lon: "80.9462"},
  %{name: "Kanpur", name_alt: "कानपुर", state: "UP", lat: "26.4499", lon: "80.3319"},
  %{name: "Agra", name_alt: "आगरा", state: "UP", lat: "27.1767", lon: "78.0081"},
  %{name: "Varanasi", name_alt: "वाराणसी", state: "UP", lat: "25.3176", lon: "82.9739"},
  %{name: "Noida", name_alt: "नोएडा", state: "UP", lat: "28.5355", lon: "77.3910"},
  %{name: "Ghaziabad", name_alt: "गाजियाबाद", state: "UP", lat: "28.6692", lon: "77.4538"},

  # West Bengal
  %{name: "Kolkata", name_alt: "কলকাতা", state: "WB", lat: "22.5726", lon: "88.3639"},
  %{name: "Howrah", name_alt: "হাওড়া", state: "WB", lat: "22.5958", lon: "88.2636"},
  %{name: "Durgapur", name_alt: "দুর্গাপুর", state: "WB", lat: "23.5204", lon: "87.3119"},

  # Kerala
  %{name: "Kochi", name_alt: "കൊച്ചി", state: "KL", lat: "9.9312", lon: "76.2673"},
  %{name: "Thiruvananthapuram", name_alt: "തിരുവനന്തപുരം", state: "KL", lat: "8.5241", lon: "76.9366"},
  %{name: "Kozhikode", name_alt: "കോഴിക്കോട്", state: "KL", lat: "11.2588", lon: "75.7804"},
  %{name: "Thrissur", name_alt: "തൃശ്ശൂർ", state: "KL", lat: "10.5276", lon: "76.2144"},

  # Punjab
  %{name: "Ludhiana", name_alt: "ਲੁਧਿਆਣਾ", state: "PB", lat: "30.9010", lon: "75.8573"},
  %{name: "Amritsar", name_alt: "ਅੰਮ੍ਰਿਤਸਰ", state: "PB", lat: "31.6340", lon: "74.8723"},
  %{name: "Jalandhar", name_alt: "ਜਲੰਧਰ", state: "PB", lat: "31.3260", lon: "75.5762"},

  # Haryana
  %{name: "Faridabad", name_alt: "फरीदाबाद", state: "HR", lat: "28.4089", lon: "77.3178"},
  %{name: "Gurgaon", name_alt: "गुड़गांव", state: "HR", lat: "28.4595", lon: "77.0266"},

  # Madhya Pradesh
  %{name: "Indore", name_alt: "इंदौर", state: "MP", lat: "22.7196", lon: "75.8577"},
  %{name: "Bhopal", name_alt: "भोपाल", state: "MP", lat: "23.2599", lon: "77.4126"},
  %{name: "Jabalpur", name_alt: "जबलपुर", state: "MP", lat: "23.1815", lon: "79.9864"},

  # Bihar
  %{name: "Patna", name_alt: "पटना", state: "BR", lat: "25.5941", lon: "85.1376"},

  # Odisha
  %{name: "Bhubaneswar", name_alt: "ଭୁବନେଶ୍ୱର", state: "OR", lat: "20.2961", lon: "85.8245"},
  %{name: "Cuttack", name_alt: "କଟକ", state: "OR", lat: "20.4625", lon: "85.8830"},

  # Chhattisgarh
  %{name: "Raipur", name_alt: "रायपुर", state: "CT", lat: "21.2514", lon: "81.6296"},

  # Jharkhand
  %{name: "Ranchi", name_alt: "रांची", state: "JH", lat: "23.3441", lon: "85.3096"},

  # Assam
  %{name: "Guwahati", name_alt: "গুৱাহাটী", state: "AS", lat: "26.1445", lon: "91.7362"},

  # Himachal Pradesh
  %{name: "Shimla", name_alt: "शिमला", state: "HP", lat: "31.1048", lon: "77.1734"},

  # Uttarakhand
  %{name: "Dehradun", name_alt: "देहरादून", state: "UT", lat: "30.3165", lon: "78.0322"},

  # Goa
  %{name: "Panaji", name_alt: "पणजी", state: "GA", lat: "15.4909", lon: "73.8278"},

  # Chandigarh
  %{name: "Chandigarh", name_alt: "ਚੰਡੀਗੜ੍ਹ", state: "CH", lat: "30.7333", lon: "76.7794"},

  # Puducherry
  %{name: "Puducherry", name_alt: "புதுச்சேரி", state: "PY", lat: "11.9416", lon: "79.8083"}
]

Enum.each(cities_data, fn city_data ->
  Repo.insert!(%City{
    name: city_data.name,
    name_alt: city_data.name_alt,
    state_id: states[city_data.state].id,
    latitude: Decimal.new(city_data.lat),
    longitude: Decimal.new(city_data.lon),
    timezone: "Asia/Kolkata",
    status: "active",
    metadata: %{}
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(City, :count, :id)} cities")
