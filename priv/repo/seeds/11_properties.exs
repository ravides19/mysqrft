# Seeds for properties - 50 properties
alias MySqrft.Repo
alias MySqrft.Properties.Property
alias MySqrft.UserManagement.{Profile, Role, UserRole}
alias MySqrft.Geography.{City, Locality}
import Ecto.Query

# Get owners and agents (users with owner or agent role)
owner_role = Repo.get_by!(Role, name: "owner")
agent_role = Repo.get_by!(Role, name: "agent")

owner_profiles =
  Repo.all(
    from ur in UserRole,
    where: ur.role_id == ^owner_role.id or ur.role_id == ^agent_role.id,
    select: ur.user_profile_id,
    distinct: true
  )
  |> Enum.map(&Repo.get!(Profile, &1))

# Get cities and localities
bangalore = Repo.get_by!(City, name: "Bangalore")
mumbai = Repo.get_by!(City, name: "Mumbai")
delhi = Repo.get_by!(City, name: "New Delhi")
hyderabad = Repo.get_by!(City, name: "Hyderabad")
chennai = Repo.get_by!(City, name: "Chennai")
pune = Repo.get_by!(City, name: "Pune")

# Get localities for each city
blr_localities = Repo.all(from l in Locality, where: l.city_id == ^bangalore.id, limit: 10)
mum_localities = Repo.all(from l in Locality, where: l.city_id == ^mumbai.id, limit: 8)
del_localities = Repo.all(from l in Locality, where: l.city_id == ^delhi.id, limit: 6)
hyd_localities = Repo.all(from l in Locality, where: l.city_id == ^hyderabad.id, limit: 6)
che_localities = Repo.all(from l in Locality, where: l.city_id == ^chennai.id, limit: 5)
pun_localities = Repo.all(from l in Locality, where: l.city_id == ^pune.id, limit: 5)

project_names = [
  "Prestige Lakeside Habitat", "Sobha Dream Acres", "Brigade Metropolis", "Godrej Properties",
  "Lodha Luxury Apartments", "DLF Garden City", "Mahindra Lifespaces", "Oberoi Realty",
  "Hiranandani Gardens", "Puravankara Projects", "Shapoorji Pallonji", "Tata Housing",
  "Birla Estates", "Embassy Group", "Mantri Developers", "Shriram Properties",
  "Salarpuria Sattva", "Phoenix Mills", "Runwal Group", "Kalpataru Limited",
  "Rustomjee", "Piramal Realty", "Raheja Developers", "Unitech Group", "Ansal API",
  "Omaxe Limited", "Supertech Limited", "Gaurs Group", "Mahagun Group", "ATS Group",
  "Eldeco Group", "Ajnara India", "Amrapali Group", "Jaypee Greens", "Parsvnath Developers",
  "Ashiana Housing", "Vatika Group", "Emaar India", "Ireo", "M3M India",
  "Godrej Summit", "Prestige Falcon City", "Sobha City", "Brigade Gateway", "Purva Venezia",
  "Independent Villa", "Luxury Penthouse", "Green Meadows", "Skyline Towers", "Palm Grove"
]

property_types = ["apartment", "villa", "independent_house", "plot"]
statuses = ["draft", "active", "active", "active"]  # 75% active
verification_statuses = ["unverified", "pending", "verified", "verified"]  # 50% verified

# Generate 50 properties
properties_data = Enum.map(0..49, fn i ->
  # Distribute across cities
  {city, localities} = case rem(i, 6) do
    0 -> {bangalore, blr_localities}
    1 -> {mumbai, mum_localities}
    2 -> {delhi, del_localities}
    3 -> {hyderabad, hyd_localities}
    4 -> {chennai, che_localities}
    _ -> {pune, pun_localities}
  end

  locality = Enum.at(localities, rem(i, length(localities)))
  owner = Enum.at(owner_profiles, rem(i, length(owner_profiles)))

  property_type = Enum.at(property_types, rem(i, 4))

  # Generate configuration based on type
  configuration = case property_type do
    "apartment" ->
      bhk = Enum.at([1, 2, 2, 3, 3, 3, 4], rem(i, 7))
      %{
        "bhk" => bhk,
        "bathrooms" => min(bhk, 2 + div(bhk, 2)),
        "balconies" => min(bhk - 1, 3),
        "area_sqft" => 600 + (bhk * 400) + rem(i * 50, 500),
        "floor" => 1 + rem(i, 15),
        "total_floors" => 5 + rem(i, 15)
      }

    "villa" ->
      bhk = Enum.at([3, 4, 4, 5], rem(i, 4))
      %{
        "bhk" => bhk,
        "bathrooms" => bhk,
        "balconies" => 2 + rem(i, 3),
        "area_sqft" => 2000 + (bhk * 500) + rem(i * 100, 1000),
        "floors" => 2 + rem(i, 2),
        "plot_area_sqft" => 1500 + rem(i * 200, 3000)
      }

    "independent_house" ->
      bhk = Enum.at([2, 3, 3, 4], rem(i, 4))
      %{
        "bhk" => bhk,
        "bathrooms" => bhk,
        "balconies" => 1 + rem(i, 2),
        "area_sqft" => 1200 + (bhk * 300) + rem(i * 80, 800),
        "floors" => 1 + rem(i, 3),
        "plot_area_sqft" => 1000 + rem(i * 150, 2000)
      }

    "plot" ->
      %{
        "plot_area_sqft" => 1000 + rem(i * 500, 5000),
        "plot_type" => Enum.at(["residential", "commercial"], rem(i, 2))
      }
  end

  verification_status = Enum.at(verification_statuses, rem(i, 4))

  %{
    project_name: Enum.at(project_names, i),
    type: property_type,
    configuration: configuration,
    status: Enum.at(statuses, rem(i, 4)),
    address_text: "#{locality.name}, #{city.name}",
    owner_id: owner.id,
    city_id: city.id,
    locality_id: locality.id,
    verification_status: verification_status,
    verified_at: if(verification_status == "verified", do: DateTime.utc_now(:second), else: nil),
    quality_score: 60 + rem(i * 7, 40),
    data_completeness_score: 65 + rem(i * 5, 35)
  }
end)

Enum.each(properties_data, fn property_data ->
  Repo.insert!(%Property{
    project_name: property_data.project_name,
    type: property_data.type,
    configuration: property_data.configuration,
    status: property_data.status,
    address_text: property_data.address_text,
    owner_id: property_data.owner_id,
    city_id: property_data.city_id,
    locality_id: property_data.locality_id,
    verification_status: property_data.verification_status,
    verified_at: property_data[:verified_at],
    quality_score: property_data.quality_score,
    data_completeness_score: property_data.data_completeness_score
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Property, :count, :id)} properties")
