# Seeds for demo users - 50 users
alias MySqrft.Repo
alias MySqrft.Auth.User

# Indian first and last names for realistic data
first_names = ["Ravi", "Priya", "Amit", "Sneha", "Rajesh", "Anita", "Suresh", "Kavita", "Vijay", "Deepa",
               "Arun", "Meera", "Kiran", "Pooja", "Manoj", "Lakshmi", "Sanjay", "Divya", "Ramesh", "Swati",
               "Prakash", "Nisha", "Ashok", "Rekha", "Dinesh", "Sunita", "Mohan", "Geeta", "Vinod", "Asha",
               "Sunil", "Radha", "Ajay", "Usha", "Naveen", "Shanti", "Rakesh", "Lata", "Mahesh", "Parvati",
               "Ganesh", "Saraswati", "Krishna", "Durga", "Shiva", "Kali", "Vishnu", "Sita", "Rama", "Ganga"]

last_names = ["Kumar", "Sharma", "Patel", "Reddy", "Singh", "Gupta", "Nair", "Iyer", "Rao", "Desai",
              "Joshi", "Menon", "Pillai", "Agarwal", "Verma", "Mehta", "Shah", "Bhat", "Kulkarni", "Naik",
              "Shetty", "Hegde", "Kamath", "Pai", "Amin", "Trivedi", "Pandey", "Mishra", "Tiwari", "Dubey",
              "Chopra", "Kapoor", "Malhotra", "Khanna", "Sethi", "Arora", "Bhatia", "Tandon", "Saxena", "Jain",
              "Agrawal", "Bansal", "Goyal", "Singhal", "Mittal", "Garg", "Jindal", "Khandelwal", "Maheshwari", "Bhargava"]

# Generate 50 users
users_data = Enum.map(0..49, fn i ->
  first_name = Enum.at(first_names, i)
  last_name = Enum.at(last_names, i)
  email = "#{String.downcase(first_name)}.#{String.downcase(last_name)}#{if i > 0, do: i, else: ""}@example.com"
  mobile = "+9198765#{String.pad_leading(Integer.to_string(43210 + i), 5, "0")}"

  %{
    firstname: first_name,
    lastname: last_name,
    email: email,
    mobile_number: mobile,
    confirmed_at: DateTime.utc_now(:second)
  }
end)

Enum.each(users_data, fn user_data ->
  # Create user with password
  {:ok, user} =
    %User{}
    |> User.registration_changeset(Map.put(user_data, :password, "Password123!"))
    |> Repo.insert()

  # Confirm the user
  user
  |> User.confirm_changeset()
  |> Repo.update!()
end)

IO.puts("✓ Seeded #{Repo.aggregate(User, :count, :id)} demo users (password: Password123!)")
