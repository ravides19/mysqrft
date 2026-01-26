# Seeds for countries
alias MySqrft.Repo
alias MySqrft.Geography.Country

# India
india = Repo.insert!(%Country{
  code: "IN",
  name: "India",
  name_alt: "भारत",
  currency_code: "INR",
  locale: "en_IN",
  timezone: "Asia/Kolkata",
  status: "active",
  metadata: %{
    "calling_code" => "+91",
    "capital" => "New Delhi",
    "region" => "South Asia"
  }
})

IO.puts("✓ Seeded #{Repo.aggregate(Country, :count, :id)} countries")
