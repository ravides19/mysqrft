# Seeds for pincodes
# Note: Pincodes are now seeded in 04_geography_localities.exs to ensure correct association
alias MySqrft.Repo
alias MySqrft.Geography.Pincode

count = Repo.aggregate(Pincode, :count, :id)
IO.puts("✓ Pincodes already seeded with Localities. Total count: #{count}")
