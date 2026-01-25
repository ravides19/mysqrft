defmodule MySqrft.UserManagement do
  @moduledoc """
  The UserManagement context.

  This context handles all user profile management, roles, preferences,
  consents, trust scores, and related functionality.
  """

  import Ecto.Query, warn: false
  alias MySqrft.Repo

  alias MySqrft.UserManagement.{
    Profile,
    Role,
    UserRole,
    Address,
    ProfilePhoto,
    Preference,
    Consent,
    ConsentHistory,
    TrustScore,
    VerificationBadge,
    ProfileCompleteness,
    OnboardingFlow,
    EmergencyContact,
    Events
  }

  ## Profile Management

  @doc """
  Gets a profile by user ID.
  """
  def get_profile_by_user_id(user_id) do
    Repo.get_by(Profile, user_id: user_id)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.
  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Gets a profile with preloaded associations.
  """
  def get_profile_with_associations!(id) do
    Repo.get!(Profile, id)
    |> Repo.preload([
      :user,
      :user_roles,
      :addresses,
      :profile_photos,
      :preferences,
      :consents,
      :trust_scores,
      :verification_badges,
      :profile_completeness_records,
      :onboarding_flows,
      :emergency_contacts
    ])
  end

  @doc """
  Creates a profile for a user.

  ## Examples

      iex> create_profile(%{user_id: user.id, display_name: "John Doe", ...})
      {:ok, %Profile{}}

      iex> create_profile(%{user_id: user.id})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, profile} ->
        # Calculate initial completeness
        calculate_and_update_completeness(profile)
        # Publish event
        Events.publish_profile_created(profile)
        {:ok, profile}

      error ->
        error
    end
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{display_name: "Jane Doe"})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{display_name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    old_status = profile.status
    changed_fields = get_changed_fields(profile, attrs)

    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_profile} ->
        # Recalculate completeness after update
        calculate_and_update_completeness(updated_profile)
        # Publish events
        Events.publish_profile_updated(updated_profile, changed_fields)

        if old_status != updated_profile.status do
          Events.publish_status_changed(updated_profile, old_status, updated_profile.status)
        end

        {:ok, updated_profile}

      error ->
        error
    end
  end

  defp get_changed_fields(profile, attrs) do
    Enum.filter(attrs, fn {key, value} ->
      field = String.to_existing_atom(key)
      Map.get(profile, field) != value
    end)
    |> Enum.map(fn {key, _} -> key end)
  end

  @doc """
  Deletes a profile (soft delete by setting status to "deleted").

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

  """
  def delete_profile(%Profile{} = profile) do
    case update_profile(profile, %{status: "deleted"}) do
      {:ok, updated_profile} ->
        Events.publish_user_deleted(updated_profile)
        {:ok, updated_profile}

      error ->
        error
    end
  end

  @doc """
  Suspends a profile.

  ## Examples

      iex> suspend_profile(profile, "Violation of terms")
      {:ok, %Profile{}}

  """
  def suspend_profile(%Profile{} = profile, _reason) do
    update_profile(profile, %{status: "suspended"})
  end

  @doc """
  Reactivates a suspended profile.

  ## Examples

      iex> reactivate_profile(profile)
      {:ok, %Profile{}}

  """
  def reactivate_profile(%Profile{} = profile) do
    update_profile(profile, %{status: "active"})
  end

  ## Role Management

  @doc """
  Gets a role by name.
  """
  def get_role_by_name(name), do: Repo.get_by(Role, name: name)

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.
  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Lists all active roles.
  """
  def list_active_roles do
    Repo.all(from r in Role, where: r.is_active == true)
  end

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{name: "Tenant", description: "..."})
      {:ok, %Role{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Adds a role to a user profile.

  ## Examples

      iex> add_role_to_profile(profile, role, %{})
      {:ok, %UserRole{}}

  """
  def add_role_to_profile(%Profile{} = profile, %Role{} = role, role_data \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(%{
      user_profile_id: profile.id,
      role_id: role.id,
      role_specific_data: role_data,
      status: "active",
      activated_at: DateTime.utc_now()
    })
    |> Repo.insert()
    |> case do
      {:ok, user_role} ->
        user_role = Repo.preload(user_role, [:user_profile, :role])
        Events.publish_role_added(user_role)
        {:ok, user_role}

      error ->
        error
    end
  end

  @doc """
  Gets all roles for a user profile.
  """
  def get_user_roles(%Profile{} = profile) do
    Repo.all(
      from ur in UserRole,
        where: ur.user_profile_id == ^profile.id,
        preload: :role
    )
  end

  @doc """
  Gets active roles for a user profile.
  """
  def get_active_user_roles(%Profile{} = profile) do
    Repo.all(
      from ur in UserRole,
        where: ur.user_profile_id == ^profile.id and ur.status == "active",
        preload: :role
    )
  end

  @doc """
  Deactivates a user role.

  ## Examples

      iex> deactivate_user_role(user_role)
      {:ok, %UserRole{}}

  """
  def deactivate_user_role(%UserRole{} = user_role) do
    user_role
    |> UserRole.deactivate_changeset()
    |> Repo.update()
    |> case do
      {:ok, updated_role} ->
        updated_role = Repo.preload(updated_role, [:user_profile, :role])
        Events.publish_role_removed(updated_role)
        {:ok, updated_role}

      error ->
        error
    end
  end

  @doc """
  Activates a user role.

  ## Examples

      iex> activate_user_role(user_role)
      {:ok, %UserRole{}}

  """
  def activate_user_role(%UserRole{} = user_role) do
    user_role
    |> UserRole.activate_changeset()
    |> Repo.update()
  end

  ## Address Management

  @doc """
  Gets an address.

  Raises `Ecto.NoResultsError` if the Address does not exist.
  """
  def get_address!(id), do: Repo.get!(Address, id)

  @doc """
  Lists all addresses for a profile.
  """
  def list_addresses(%Profile{} = profile) do
    Repo.all(
      from a in Address, where: a.user_profile_id == ^profile.id, order_by: [desc: a.is_primary]
    )
  end

  @doc """
  Creates an address.

  ## Examples

      iex> create_address(profile, %{line1: "123 Main St", city: "Bangalore", ...})
      {:ok, %Address{}}

  """
  def create_address(%Profile{} = profile, attrs \\ %{}) do
    # Check address limit (max 5 per user)
    existing_count =
      Repo.aggregate(
        from(a in Address, where: a.user_profile_id == ^profile.id),
        :count
      )

    if existing_count >= 5 do
      {:error, :address_limit_reached}
    else
      # Normalize attrs to have string keys (Phoenix forms provide string keys)
      attrs =
        attrs
        |> ensure_string_keys()
        |> Map.put("user_profile_id", profile.id)

      # If this is the first address or explicitly set as primary, make it primary
      attrs =
        if existing_count == 0 or Map.get(attrs, "is_primary", false) do
          # Unset other primary addresses
          Repo.update_all(
            from(a in Address, where: a.user_profile_id == ^profile.id),
            set: [is_primary: false]
          )

          Map.put(attrs, "is_primary", true)
        else
          attrs
        end

      %Address{}
      |> Address.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:ok, address} ->
          calculate_and_update_completeness(profile)
          {:ok, address}

        error ->
          error
      end
    end
  end

  @doc """
  Updates an address.

  ## Examples

      iex> update_address(address, %{line1: "456 Oak Ave"})
      {:ok, %Address{}}

  """
  def update_address(%Address{} = address, attrs) do
    # Normalize attrs to have string keys
    attrs = ensure_string_keys(attrs)

    # If setting as primary, unset other primary addresses
    if Map.get(attrs, "is_primary", false) do
      Repo.update_all(
        from(a in Address,
          where: a.user_profile_id == ^address.user_profile_id and a.id != ^address.id
        ),
        set: [is_primary: false]
      )
    end

    address
    |> Address.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_address} ->
        profile = Repo.get!(Profile, updated_address.user_profile_id)
        calculate_and_update_completeness(profile)
        {:ok, updated_address}

      error ->
        error
    end
  end

  @doc """
  Deletes an address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

  """
  def delete_address(%Address{} = address) do
    profile = Repo.get!(Profile, address.user_profile_id)

    Repo.delete(address)
    |> case do
      {:ok, _} ->
        calculate_and_update_completeness(profile)
        {:ok, address}

      error ->
        error
    end
  end

  ## Profile Photo Management

  @doc """
  Gets a profile photo.

  Raises `Ecto.NoResultsError` if the ProfilePhoto does not exist.
  """
  def get_profile_photo!(id), do: Repo.get!(ProfilePhoto, id)

  @doc """
  Lists all photos for a profile.
  """
  def list_profile_photos(%Profile{} = profile) do
    Repo.all(
      from pp in ProfilePhoto,
        where: pp.user_profile_id == ^profile.id,
        order_by: [desc: pp.is_current, desc: pp.uploaded_at]
    )
  end

  @doc """
  Creates a profile photo.

  ## Examples

      iex> create_profile_photo(profile, %{original_url: "...", ...})
      {:ok, %ProfilePhoto{}}

  """
  def create_profile_photo(%Profile{} = profile, attrs \\ %{}) do
    # Unset current photo if this one is being set as current
    if Map.get(attrs, :is_current, false) do
      Repo.update_all(
        from(pp in ProfilePhoto, where: pp.user_profile_id == ^profile.id),
        set: [is_current: false]
      )
    end

    attrs =
      Map.merge(attrs, %{
        user_profile_id: profile.id,
        uploaded_at: DateTime.utc_now()
      })

    %ProfilePhoto{}
    |> ProfilePhoto.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, photo} ->
        calculate_and_update_completeness(profile)
        {:ok, photo}

      error ->
        error
    end
  end

  @doc """
  Sets a photo as the current profile photo.

  ## Examples

      iex> set_current_photo(photo)
      {:ok, %ProfilePhoto{}}

  """
  def set_current_photo(%ProfilePhoto{} = photo) do
    # Unset all other current photos for this profile
    Repo.update_all(
      from(pp in ProfilePhoto, where: pp.user_profile_id == ^photo.user_profile_id),
      set: [is_current: false]
    )

    photo
    |> ProfilePhoto.changeset(%{is_current: true})
    |> Repo.update()
  end

  @doc """
  Deletes a profile photo.

  ## Examples

      iex> delete_profile_photo(photo)
      {:ok, %ProfilePhoto{}}

  """
  def delete_profile_photo(%ProfilePhoto{} = photo) do
    profile = Repo.get!(Profile, photo.user_profile_id)

    Repo.delete(photo)
    |> case do
      {:ok, _} ->
        calculate_and_update_completeness(profile)
        {:ok, photo}

      error ->
        error
    end
  end

  ## Preference Management

  @doc """
  Gets a preference.

  Raises `Ecto.NoResultsError` if the Preference does not exist.
  """
  def get_preference!(id), do: Repo.get!(Preference, id)

  @doc """
  Gets preferences for a profile, optionally filtered by category and role.
  """
  def get_preferences(%Profile{} = profile, category \\ nil, role_id \\ nil) do
    query = from p in Preference, where: p.user_profile_id == ^profile.id

    query =
      if category do
        from p in query, where: p.category == ^category
      else
        query
      end

    query =
      if role_id do
        from p in query, where: p.role_id == ^role_id
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Creates or updates a preference.

  ## Examples

      iex> upsert_preference(profile, "search", "budget_range", %{min: 10000, max: 50000})
      {:ok, %Preference{}}

  """
  def upsert_preference(%Profile{} = profile, category, key, value, role_id \\ nil) do
    attrs = %{
      user_profile_id: profile.id,
      category: category,
      key: key,
      value: value,
      role_id: role_id
    }

    query =
      from p in Preference,
        where: p.user_profile_id == ^profile.id,
        where: p.category == ^category,
        where: p.key == ^key

    query =
      if role_id do
        from p in query, where: p.role_id == ^role_id
      else
        from p in query, where: is_nil(p.role_id)
      end

    case Repo.one(query) do
      nil ->
        %Preference{}
        |> Preference.changeset(attrs)
        |> Repo.insert()
        |> case do
          {:ok, preference} ->
            Events.publish_preferences_updated(profile, category, %{key => value})
            {:ok, preference}

          error ->
            error
        end

      existing ->
        existing
        |> Preference.changeset(%{value: value})
        |> Repo.update()
        |> case do
          {:ok, preference} ->
            Events.publish_preferences_updated(profile, category, %{key => value})
            {:ok, preference}

          error ->
            error
        end
    end
  end

  @doc """
  Deletes a preference.

  ## Examples

      iex> delete_preference(preference)
      {:ok, %Preference{}}

  """
  def delete_preference(%Preference{} = preference) do
    Repo.delete(preference)
  end

  ## Consent Management

  @doc """
  Gets a consent.

  Raises `Ecto.NoResultsError` if the Consent does not exist.
  """
  def get_consent!(id), do: Repo.get!(Consent, id)

  @doc """
  Gets consent for a profile and type.
  """
  def get_consent_by_type(%Profile{} = profile, consent_type) do
    Repo.get_by(Consent, user_profile_id: profile.id, consent_type: consent_type)
  end

  @doc """
  Lists all consents for a profile.
  """
  def list_consents(%Profile{} = profile) do
    Repo.all(from c in Consent, where: c.user_profile_id == ^profile.id)
  end

  @doc """
  Grants consent for a profile.

  ## Examples

      iex> grant_consent(profile, "data_sharing", "1.0", %{ip_address: "...", user_agent: "..."})
      {:ok, %Consent{}}

  """
  def grant_consent(%Profile{} = profile, consent_type, version, metadata \\ %{}) do
    Repo.transaction(fn ->
      # Get or create consent
      consent =
        case get_consent_by_type(profile, consent_type) do
          nil ->
            %Consent{}
            |> Consent.changeset(%{
              user_profile_id: profile.id,
              consent_type: consent_type,
              granted: true,
              version: version
            })
            |> Repo.insert!()

          existing ->
            existing
            |> Consent.grant_changeset(version)
            |> Repo.update!()
        end

      # Create consent history entry
      %ConsentHistory{}
      |> ConsentHistory.changeset(%{
        consent_id: consent.id,
        action: "granted",
        version: version,
        ip_address: Map.get(metadata, :ip_address),
        user_agent: Map.get(metadata, :user_agent),
        timestamp: DateTime.utc_now()
      })
      |> Repo.insert!()

      # Publish event
      consent = Repo.preload(consent, :user_profile)
      Events.publish_consent_changed(consent)

      consent
    end)
  end

  @doc """
  Revokes consent for a profile.

  ## Examples

      iex> revoke_consent(profile, "data_sharing", %{ip_address: "...", user_agent: "..."})
      {:ok, %Consent{}}

  """
  def revoke_consent(%Profile{} = profile, consent_type, metadata \\ %{}) do
    case get_consent_by_type(profile, consent_type) do
      nil ->
        {:error, :not_found}

      consent ->
        Repo.transaction(fn ->
          # Update consent
          updated_consent =
            consent
            |> Consent.revoke_changeset()
            |> Repo.update!()

          # Create consent history entry
          %ConsentHistory{}
          |> ConsentHistory.changeset(%{
            consent_id: updated_consent.id,
            action: "revoked",
            version: updated_consent.version,
            ip_address: Map.get(metadata, :ip_address),
            user_agent: Map.get(metadata, :user_agent),
            timestamp: DateTime.utc_now()
          })
          |> Repo.insert!()

          # Publish event
          updated_consent = Repo.preload(updated_consent, :user_profile)
          Events.publish_consent_changed(updated_consent)

          updated_consent
        end)
    end
  end

  @doc """
  Gets consent history for a consent.
  """
  def get_consent_history(%Consent{} = consent) do
    Repo.all(
      from ch in ConsentHistory,
        where: ch.consent_id == ^consent.id,
        order_by: [desc: ch.timestamp]
    )
  end

  ## Trust Score Management

  @doc """
  Gets the current trust score for a profile.
  """
  def get_current_trust_score(%Profile{} = profile) do
    Repo.get_by(TrustScore, user_profile_id: profile.id)
  end

  @doc """
  Calculates and updates trust score for a profile.

  This is a simplified implementation. In production, this would integrate
  with the Verification domain to get verification status.
  """
  def calculate_and_update_trust_score(%Profile{} = profile) do
    # Simplified trust score calculation
    # In production, this would integrate with Verification domain
    factors = %{
      email_verified: false,
      phone_verified: false,
      identity_verified: false,
      address_verified: false,
      profile_complete: profile.completeness_score >= 80,
      account_age_days: calculate_account_age_days(profile)
    }

    score = calculate_trust_score_from_factors(factors)

    attrs = %{
      user_profile_id: profile.id,
      score: score,
      factors: factors,
      calculated_at: DateTime.utc_now(),
      valid_until: DateTime.utc_now() |> DateTime.add(24, :hour)
    }

    case get_current_trust_score(profile) do
      nil ->
        %TrustScore{}
        |> TrustScore.changeset(attrs)
        |> Repo.insert()

      existing ->
        existing
        |> TrustScore.changeset(attrs)
        |> Repo.update()
    end
  end

  defp calculate_account_age_days(%Profile{} = profile) do
    DateTime.diff(DateTime.utc_now(), profile.inserted_at, :day)
  end

  defp calculate_trust_score_from_factors(factors) do
    base_score = 0

    score = if factors.email_verified, do: base_score + 10, else: base_score
    score = if factors.phone_verified, do: score + 15, else: score
    score = if factors.identity_verified, do: score + 25, else: score
    score = if factors.address_verified, do: score + 15, else: score
    score = if factors.profile_complete, do: score + 10, else: score

    # Account age contribution (max 10 points)
    age_score = min(div(factors.account_age_days, 30) * 2, 10)
    score + age_score
  end

  ## Profile Completeness

  @doc """
  Gets the latest profile completeness record for a profile.
  """
  def get_profile_completeness(%Profile{} = profile) do
    Repo.get_by(ProfileCompleteness, user_profile_id: profile.id)
  end

  @doc """
  Calculates and updates profile completeness for a profile.
  """
  def calculate_and_update_completeness(%Profile{} = profile) do
    profile = Repo.preload(profile, [:addresses, :profile_photos, :emergency_contacts])

    # Calculate completeness based on filled fields
    total_fields = 15
    filled_fields = count_filled_fields(profile)

    score = round(filled_fields / total_fields * 100)
    breakdown = calculate_completeness_breakdown(profile)
    missing_fields = get_missing_fields(profile)

    attrs = %{
      user_profile_id: profile.id,
      total_score: score,
      breakdown: breakdown,
      missing_fields: missing_fields,
      calculated_at: DateTime.utc_now()
    }

    # Update profile completeness score
    Repo.update_all(
      from(p in Profile, where: p.id == ^profile.id),
      set: [completeness_score: score]
    )

    # Upsert completeness record
    case Repo.get_by(ProfileCompleteness, user_profile_id: profile.id) do
      nil ->
        %ProfileCompleteness{}
        |> ProfileCompleteness.changeset(attrs)
        |> Repo.insert()

      existing ->
        existing
        |> ProfileCompleteness.changeset(attrs)
        |> Repo.update()
    end
  end

  defp count_filled_fields(profile) do
    count = 0
    count = if profile.display_name, do: count + 1, else: count
    count = if profile.first_name, do: count + 1, else: count
    count = if profile.last_name, do: count + 1, else: count
    count = if profile.email, do: count + 1, else: count
    count = if profile.phone, do: count + 1, else: count
    count = if profile.bio, do: count + 1, else: count
    count = if profile.date_of_birth, do: count + 1, else: count
    count = if profile.gender, do: count + 1, else: count
    count = if length(profile.addresses) > 0, do: count + 1, else: count
    count = if length(profile.profile_photos) > 0, do: count + 1, else: count
    count = if length(profile.emergency_contacts) > 0, do: count + 1, else: count
    count
  end

  defp calculate_completeness_breakdown(profile) do
    %{
      basic_info:
        calculate_section_score(
          ["display_name", "first_name", "last_name", "email", "phone"],
          profile
        ),
      personal_info: calculate_section_score(["bio", "date_of_birth", "gender"], profile),
      address: if(length(profile.addresses) > 0, do: 100, else: 0),
      photo: if(length(profile.profile_photos) > 0, do: 100, else: 0),
      emergency_contacts: if(length(profile.emergency_contacts) > 0, do: 100, else: 0)
    }
  end

  defp calculate_section_score(fields, profile) do
    filled =
      Enum.count(fields, fn field ->
        value = Map.get(profile, String.to_existing_atom(field))
        value != nil && value != ""
      end)

    round(filled / length(fields) * 100)
  end

  defp get_missing_fields(profile) do
    missing = []
    missing = if !profile.display_name, do: ["display_name" | missing], else: missing
    missing = if !profile.first_name, do: ["first_name" | missing], else: missing
    missing = if !profile.last_name, do: ["last_name" | missing], else: missing
    missing = if !profile.email, do: ["email" | missing], else: missing
    missing = if !profile.phone, do: ["phone" | missing], else: missing
    missing = if !profile.bio, do: ["bio" | missing], else: missing
    missing = if !profile.date_of_birth, do: ["date_of_birth" | missing], else: missing
    missing = if !profile.gender, do: ["gender" | missing], else: missing
    missing = if length(profile.addresses) == 0, do: ["address" | missing], else: missing

    missing =
      if length(profile.profile_photos) == 0, do: ["profile_photo" | missing], else: missing

    missing =
      if length(profile.emergency_contacts) == 0,
        do: ["emergency_contact" | missing],
        else: missing

    missing
  end

  ## Verification Badge Management

  @doc """
  Gets verification badges for a profile.
  """
  def get_verification_badges(%Profile{} = profile) do
    Repo.all(
      from vb in VerificationBadge,
        where: vb.user_profile_id == ^profile.id and vb.is_active == true
    )
  end

  @doc """
  Creates a verification badge.

  This would typically be called by the Verification domain when a verification is completed.
  """
  def create_verification_badge(%Profile{} = profile, attrs) do
    attrs =
      Map.merge(attrs, %{
        user_profile_id: profile.id,
        granted_at: DateTime.utc_now()
      })

    %VerificationBadge{}
    |> VerificationBadge.changeset(attrs)
    |> Repo.insert()
  end

  ## Onboarding Flow Management

  @doc """
  Gets an onboarding flow for a profile and role.
  """
  def get_onboarding_flow(%Profile{} = profile, %Role{} = role, flow_type) do
    Repo.get_by(OnboardingFlow,
      user_profile_id: profile.id,
      role_id: role.id,
      flow_type: flow_type
    )
  end

  @doc """
  Creates or gets an onboarding flow.

  ## Examples

      iex> start_onboarding_flow(profile, role, "tenant_onboarding", 5)
      {:ok, %OnboardingFlow{}}

  """
  def start_onboarding_flow(%Profile{} = profile, %Role{} = role, flow_type, total_steps) do
    case get_onboarding_flow(profile, role, flow_type) do
      nil ->
        %OnboardingFlow{}
        |> OnboardingFlow.changeset(%{
          user_profile_id: profile.id,
          role_id: role.id,
          flow_type: flow_type,
          total_steps: total_steps,
          started_at: DateTime.utc_now()
        })
        |> Repo.insert()

      existing ->
        {:ok, existing}
    end
  end

  @doc """
  Updates onboarding progress.

  ## Examples

      iex> update_onboarding_step(flow, "step_2")
      {:ok, %OnboardingFlow{}}

  """
  def update_onboarding_step(%OnboardingFlow{} = flow, step_id) do
    completed_steps = [step_id | flow.completed_steps || []]
    current_step = min(flow.current_step + 1, flow.total_steps)

    attrs = %{
      current_step: current_step,
      completed_steps: completed_steps
    }

    attrs =
      if current_step >= flow.total_steps do
        Map.merge(attrs, %{status: "completed", completed_at: DateTime.utc_now()})
      else
        attrs
      end

    flow
    |> OnboardingFlow.changeset(attrs)
    |> Repo.update()
  end

  ## Emergency Contact Management

  @doc """
  Gets an emergency contact.

  Raises `Ecto.NoResultsError` if the EmergencyContact does not exist.
  """
  def get_emergency_contact!(id), do: Repo.get!(EmergencyContact, id)

  @doc """
  Lists all emergency contacts for a profile.
  """
  def list_emergency_contacts(%Profile{} = profile) do
    Repo.all(
      from ec in EmergencyContact,
        where: ec.user_profile_id == ^profile.id,
        order_by: [asc: ec.priority]
    )
  end

  @doc """
  Creates an emergency contact.

  ## Examples

      iex> create_emergency_contact(profile, %{name: "John Doe", ...})
      {:ok, %EmergencyContact{}}

  """
  def create_emergency_contact(%Profile{} = profile, attrs \\ %{}) do
    # Check limit (max 3 per user)
    existing_count =
      Repo.aggregate(
        from(ec in EmergencyContact, where: ec.user_profile_id == ^profile.id),
        :count
      )

    if existing_count >= 3 do
      {:error, :emergency_contact_limit_reached}
    else
      # Normalize attrs to have string keys (Phoenix forms provide string keys)
      attrs =
        attrs
        |> ensure_string_keys()
        |> Map.put("user_profile_id", profile.id)

      %EmergencyContact{}
      |> EmergencyContact.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:ok, contact} ->
          calculate_and_update_completeness(profile)
          {:ok, contact}

        error ->
          error
      end
    end
  end

  @doc """
  Updates an emergency contact.

  ## Examples

      iex> update_emergency_contact(contact, %{phone: "+1234567890"})
      {:ok, %EmergencyContact{}}

  """
  def update_emergency_contact(%EmergencyContact{} = contact, attrs) do
    contact
    |> EmergencyContact.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_contact} ->
        profile = Repo.get!(Profile, updated_contact.user_profile_id)
        calculate_and_update_completeness(profile)
        {:ok, updated_contact}

      error ->
        error
    end
  end

  @doc """
  Deletes an emergency contact.

  ## Examples

      iex> delete_emergency_contact(contact)
      {:ok, %EmergencyContact{}}

  """
  def delete_emergency_contact(%EmergencyContact{} = contact) do
    profile = Repo.get!(Profile, contact.user_profile_id)

    Repo.delete(contact)
    |> case do
      {:ok, _} ->
        calculate_and_update_completeness(profile)
        {:ok, contact}

      error ->
        error
    end
  end

  ## Helper Functions

  # Normalizes map keys to strings, converting atom keys to string keys.
  # This ensures consistency when merging form params (string keys) with programmatically added params.
  defp ensure_string_keys(attrs) when is_map(attrs) do
    Enum.reduce(attrs, %{}, fn {key, value}, acc ->
      normalized_key = if is_atom(key), do: Atom.to_string(key), else: key
      Map.put(acc, normalized_key, value)
    end)
  end

  defp ensure_string_keys(attrs), do: attrs
end
