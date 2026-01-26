# Seeds for roles
alias MySqrft.Repo
alias MySqrft.UserManagement.Role

roles_data = [
  %{
    name: "owner",
    description: "Property owner who can list properties for rent or sale",
    required_fields: %{
      "profile" => ["full_name", "phone", "email"],
      "verification" => ["phone_verified"]
    },
    permissions: %{
      "properties" => ["create", "read", "update", "delete"],
      "listings" => ["create", "read", "update", "delete"]
    },
    is_active: true
  },
  %{
    name: "tenant",
    description: "Tenant looking for properties to rent",
    required_fields: %{
      "profile" => ["full_name", "phone", "email"]
    },
    permissions: %{
      "listings" => ["read", "search"],
      "inquiries" => ["create", "read"]
    },
    is_active: true
  },
  %{
    name: "buyer",
    description: "Buyer looking for properties to purchase",
    required_fields: %{
      "profile" => ["full_name", "phone", "email"]
    },
    permissions: %{
      "listings" => ["read", "search"],
      "inquiries" => ["create", "read"]
    },
    is_active: true
  },
  %{
    name: "agent",
    description: "Real estate agent who can manage multiple properties",
    required_fields: %{
      "profile" => ["full_name", "phone", "email", "company_name"],
      "verification" => ["phone_verified", "email_verified", "rera_verified"]
    },
    permissions: %{
      "properties" => ["create", "read", "update", "delete"],
      "listings" => ["create", "read", "update", "delete"],
      "clients" => ["manage"]
    },
    is_active: true
  },
  %{
    name: "admin",
    description: "Platform administrator with full access",
    required_fields: %{
      "profile" => ["full_name", "email"]
    },
    permissions: %{
      "all" => ["*"]
    },
    is_active: true
  }
]

Enum.each(roles_data, fn role_data ->
  Repo.insert!(%Role{
    name: role_data.name,
    description: role_data.description,
    required_fields: role_data.required_fields,
    permissions: role_data.permissions,
    is_active: role_data.is_active
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Role, :count, :id)} roles")
