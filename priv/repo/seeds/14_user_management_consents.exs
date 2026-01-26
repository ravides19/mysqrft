# Seeds for user consents - 150+ consents (approx 3 per user)
alias MySqrft.Repo
alias MySqrft.UserManagement.{Profile, Consent}

profiles = Repo.all(Profile)

consent_types = ["marketing", "data_processing", "terms_of_service"]
statuses = ["granted", "granted", "granted", "denied"] # Mostly granted

Enum.each(profiles, fn profile ->
  Enum.each(consent_types, fn type ->
    # Randomly skip some consents for variety, but ensure terms is granted
    should_seed = type == "terms_of_service" || rem(profile.id |> :erlang.phash2(), 10) > 2

    if should_seed do
      # Determine granted status
      granted = if type == "terms_of_service", do: true, else: Enum.random([true, true, true, false])

      Repo.insert!(%Consent{
        user_profile_id: profile.id,
        consent_type: type,
        granted: granted,
        granted_at: if(granted, do: DateTime.utc_now(:second), else: nil),
        revoked_at: if(!granted, do: DateTime.utc_now(:second), else: nil),
        version: "1.0"
        # Removed: purpose, status, ip_address, user_agent (not in schema)
      })
    end
  end)
end)

IO.puts("✓ Seeded #{Repo.aggregate(Consent, :count, :id)} consents")
