# Seeds for states
alias MySqrft.Repo
alias MySqrft.Geography.{Country, State}

india = Repo.get_by!(Country, code: "IN")

states_data = [
  # States
  %{code: "AP", name: "Andhra Pradesh", name_alt: "ఆంధ్ర ప్రదేశ్"},
  %{code: "AR", name: "Arunachal Pradesh", name_alt: "अरुणाचल प्रदेश"},
  %{code: "AS", name: "Assam", name_alt: "অসম"},
  %{code: "BR", name: "Bihar", name_alt: "बिहार"},
  %{code: "CT", name: "Chhattisgarh", name_alt: "छत्तीसगढ़"},
  %{code: "GA", name: "Goa", name_alt: "गोंय"},
  %{code: "GJ", name: "Gujarat", name_alt: "ગુજરાત"},
  %{code: "HR", name: "Haryana", name_alt: "हरियाणा"},
  %{code: "HP", name: "Himachal Pradesh", name_alt: "हिमाचल प्रदेश"},
  %{code: "JH", name: "Jharkhand", name_alt: "झारखंड"},
  %{code: "KA", name: "Karnataka", name_alt: "ಕರ್ನಾಟಕ"},
  %{code: "KL", name: "Kerala", name_alt: "കേരളം"},
  %{code: "MP", name: "Madhya Pradesh", name_alt: "मध्य प्रदेश"},
  %{code: "MH", name: "Maharashtra", name_alt: "महाराष्ट्र"},
  %{code: "MN", name: "Manipur", name_alt: "মণিপুর"},
  %{code: "ML", name: "Meghalaya", name_alt: "Meghalaya"},
  %{code: "MZ", name: "Mizoram", name_alt: "Mizoram"},
  %{code: "NL", name: "Nagaland", name_alt: "Nagaland"},
  %{code: "OR", name: "Odisha", name_alt: "ଓଡ଼ିଶା"},
  %{code: "PB", name: "Punjab", name_alt: "ਪੰਜਾਬ"},
  %{code: "RJ", name: "Rajasthan", name_alt: "राजस्थान"},
  %{code: "SK", name: "Sikkim", name_alt: "सिक्किम"},
  %{code: "TN", name: "Tamil Nadu", name_alt: "தமிழ்நாடு"},
  %{code: "TG", name: "Telangana", name_alt: "తెలంగాణ"},
  %{code: "TR", name: "Tripura", name_alt: "ত্রিপুরা"},
  %{code: "UP", name: "Uttar Pradesh", name_alt: "उत्तर प्रदेश"},
  %{code: "UT", name: "Uttarakhand", name_alt: "उत्तराखण्ड"},
  %{code: "WB", name: "West Bengal", name_alt: "পশ্চিমবঙ্গ"},

  # Union Territories
  %{code: "AN", name: "Andaman and Nicobar Islands", name_alt: "Andaman and Nicobar Islands"},
  %{code: "CH", name: "Chandigarh", name_alt: "ਚੰਡੀਗੜ੍ਹ"},
  %{code: "DN", name: "Dadra and Nagar Haveli and Daman and Diu", name_alt: "દાદરા અને નગર હવેલી અને દમણ અને દીવ"},
  %{code: "DL", name: "Delhi", name_alt: "दिल्ली"},
  %{code: "JK", name: "Jammu and Kashmir", name_alt: "जम्मू और कश्मीर"},
  %{code: "LA", name: "Ladakh", name_alt: "ལ་དྭགས"},
  %{code: "LD", name: "Lakshadweep", name_alt: "ലക്ഷദ്വീപ്"},
  %{code: "PY", name: "Puducherry", name_alt: "புதுச்சேரி"}
]

Enum.each(states_data, fn state_data ->
  Repo.insert!(%State{
    code: state_data.code,
    name: state_data.name,
    name_alt: state_data.name_alt,
    country_id: india.id,
    status: "active",
    metadata: %{}
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(State, :count, :id)} states")
