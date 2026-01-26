# Seeds for user profiles - 50 profiles
alias MySqrft.Repo
alias MySqrft.Auth.User
alias MySqrft.UserManagement.Profile

users = Repo.all(User)

occupations = ["Software Engineer", "Business Owner", "Doctor", "Teacher", "Architect", "Lawyer",
               "Accountant", "Marketing Manager", "Sales Executive", "HR Manager", "Product Manager",
               "Data Scientist", "Consultant", "Entrepreneur", "Civil Engineer", "Mechanical Engineer",
               "Designer", "Analyst", "Project Manager", "Operations Manager", "Finance Manager",
               "Real Estate Agent", "Investor", "Banker", "Insurance Agent", "Pharmacist",
               "Nurse", "Professor", "Researcher", "Writer", "Journalist", "Artist", "Photographer",
               "Chef", "Pilot", "CA", "CS", "Manager", "Director", "VP", "CEO", "CTO", "CFO",
               "Freelancer", "Student", "Retired", "Homemaker", "Government Employee", "PSU Employee", "IT Professional"]

companies = ["Tech Corp", "InfoSys", "TCS", "Wipro", "Accenture", "Cognizant", "HCL", "Google",
             "Microsoft", "Amazon", "Flipkart", "Swiggy", "Zomato", "Ola", "Uber", "Paytm",
             "PhonePe", "HDFC Bank", "ICICI Bank", "SBI", "Axis Bank", "Kotak Bank", "Yes Bank",
             "Reliance", "Tata", "Aditya Birla", "Mahindra", "L&T", "Godrej", "Bajaj",
             "Self Employed", "Own Business", "Freelance", "Startup", "Consulting Firm",
             "Law Firm", "Hospital", "School", "College", "University", "Government",
             "PSU", "MNC", "SME", "Enterprise", "Agency", "Studio", "Practice", "Clinic"]

genders = ["male", "female", "other"]

bios = [
  "Property owner with multiple properties",
  "Looking for a comfortable apartment",
  "Real estate investor",
  "First-time home buyer",
  "Experienced property dealer",
  "Seeking rental property",
  "Property consultant",
  "Looking to upgrade home",
  "Downsizing to smaller apartment",
  "Relocating for work",
  "Investment in real estate",
  "Building property portfolio",
  "Seeking commercial space",
  "Looking for PG accommodation",
  "Family looking for spacious home",
  "Young professional seeking apartment",
  "Retired couple looking for villa",
  "Student seeking shared accommodation",
  "Entrepreneur seeking office space",
  "Looking for property near workplace"
]

Enum.each(users, fn user ->
  index = rem(user.id |> :erlang.phash2(), 50)

  occupation = Enum.at(occupations, index)
  company = Enum.at(companies, index)
  bio_text = Enum.at(bios, rem(index, length(bios)))

  # Combine occupation/company into bio since fields don't exist
  rich_bio = "#{occupation} at #{company}. #{bio_text}"

  Repo.insert!(%Profile{
    user_id: user.id,
    display_name: "#{user.firstname} #{user.lastname}",
    first_name: user.firstname,
    last_name: user.lastname,
    email: user.email, # Duplicate from user as per schema
    phone: user.mobile_number, # Duplicate from user as per schema
    bio: rich_bio,
    date_of_birth: Date.add(~D[1990-01-01], -365 * rem(index, 30)),
    gender: Enum.at(genders, rem(index, 3)),
    status: "active",
    completeness_score: 50 + rem(index, 50)
    # Removed: occupation, company_name, is_public (not in schema)
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Profile, :count, :id)} user profiles")
