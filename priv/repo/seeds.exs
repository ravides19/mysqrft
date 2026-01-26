# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MySqrft.Repo.insert!(%MySqrft.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

IO.puts("\n🌱 Starting database seeding...\n")

# Import seed files in dependency order
seed_files = [
  # Geography - Foundation
  "01_geography_countries.exs",
  "02_geography_states.exs",
  "03_geography_cities.exs",
  "04_geography_localities.exs",
  "05_geography_pincodes.exs",
  "06_geography_landmarks.exs",

  # User Management - Foundation
  "07_user_management_roles.exs",
  "08_auth_users.exs",
  "09_user_management_profiles.exs",
  "10_user_management_user_roles.exs",

  # Properties & Listings
  "11_properties.exs",
  "12_listings.exs",

  # Additional User Data
  "13_user_management_addresses.exs",
  "14_user_management_consents.exs",

  # Contact
  "15_contact_submissions.exs"
]

seeds_dir = Path.join([__DIR__, "seeds"])

Enum.each(seed_files, fn file ->
  file_path = Path.join(seeds_dir, file)

  if File.exists?(file_path) do
    IO.puts("📄 Running #{file}...")
    Code.eval_file(file_path)
  else
    IO.puts("⚠️  Skipping #{file} (file not found)")
  end
end)

IO.puts("\n✅ Database seeding completed!\n")
