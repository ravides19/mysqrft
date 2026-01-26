# Seeds for user roles (junction table) - 50 assignments
alias MySqrft.Repo
alias MySqrft.Auth.User
alias MySqrft.UserManagement.{Role, UserRole, Profile}

owner_role = Repo.get_by!(Role, name: "owner")
tenant_role = Repo.get_by!(Role, name: "tenant")
buyer_role = Repo.get_by!(Role, name: "buyer")
agent_role = Repo.get_by!(Role, name: "agent")

profiles = Repo.all(Profile)

# Assign roles to profiles with varied distribution
# 40% owners, 30% tenants, 20% buyers, 10% agents

Enum.with_index(profiles, fn profile, index ->
  # Primary role based on index
  primary_role = cond do
    rem(index, 10) < 4 -> owner_role
    rem(index, 10) < 7 -> tenant_role
    rem(index, 10) < 9 -> buyer_role
    true -> agent_role
  end

  # Insert primary role
  Repo.insert!(%UserRole{
    user_profile_id: profile.id,
    role_id: primary_role.id,
    status: "active",
    activated_at: DateTime.utc_now(:second)
  })

  # 30% chance of having a secondary role
  if rem(index, 10) < 3 do
    secondary_role = if primary_role == owner_role, do: buyer_role, else: owner_role

    Repo.insert!(%UserRole{
      user_profile_id: profile.id,
      role_id: secondary_role.id,
      status: "active",
      activated_at: DateTime.utc_now(:second)
    })
  end
end)

IO.puts("✓ Seeded #{Repo.aggregate(UserRole, :count, :id)} user role assignments")
