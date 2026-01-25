defmodule MySqrftWeb.ProfileLive.Index do
  @moduledoc """
  LiveView for viewing and managing user profile.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        # Preload associations needed for completeness calculation and view
        profile =
          MySqrft.Repo.preload(profile, [
            :addresses,
            :profile_photos,
            :emergency_contacts,
            user_roles: :role
          ])

        # Ensure completeness is calculated
        completeness_record = UserManagement.get_profile_completeness(profile)

        # Calculate if it doesn't exist or is outdated (older than 1 hour)
        if completeness_record == nil or
             DateTime.diff(DateTime.utc_now(), completeness_record.calculated_at, :second) > 3600 do
          UserManagement.calculate_and_update_completeness(profile)
        end

        socket =
          socket
          |> assign(:page_title, "My Profile")
          |> assign(:profile, profile)
          |> assign(:completeness, get_completeness(profile))
          |> assign(:trust_score, get_trust_score(profile))
          |> assign(:badges, get_badges(profile))

        {:ok, socket}
      else
        {:ok, push_navigate(socket, to: ~p"/profile/new")}
      end
    else
      {:ok, push_navigate(socket, to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Profile")
  end

  defp get_completeness(nil), do: nil

  defp get_completeness(profile) do
    completeness_record = UserManagement.get_profile_completeness(profile)

    if completeness_record do
      %{
        score: completeness_record.total_score,
        breakdown: completeness_record.breakdown || %{},
        missing_fields: completeness_record.missing_fields || []
      }
    else
      # Fallback to score from profile if completeness record doesn't exist
      %{
        score: profile.completeness_score || 0,
        breakdown: %{},
        missing_fields: []
      }
    end
  end

  defp get_trust_score(nil), do: nil

  defp get_trust_score(profile) do
    UserManagement.get_current_trust_score(profile)
  end

  defp get_badges(nil), do: []

  defp get_badges(profile) do
    UserManagement.get_verification_badges(profile)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <!-- Profile Header -->
      <div class="bg-gradient-to-r from-primary-dark to-primary-light text-white pb-24 pt-12 px-4 sm:px-6 lg:px-8 -mt-8 mb-8">
        <div class="max-w-7xl mx-auto">
          <div class="flex flex-col md:flex-row items-center md:items-start gap-6">
            <div class="relative group">
              <%= if @profile.profile_photos && length(@profile.profile_photos) > 0 do %>
                <.avatar
                  src={List.first(@profile.profile_photos).url}
                  alt={@profile.display_name}
                  size="extra_large"
                  rounded="full"
                  class="!size-32 border-4 border-white shadow-lg"
                />
              <% else %>
                <.avatar
                  size="extra_large"
                  color="white"
                  rounded="full"
                  class="!size-32 text-primary-dark border-4 border-white shadow-lg"
                >
                  {String.first(@profile.display_name || "U") |> String.upcase()}
                </.avatar>
              <% end %>
              <.link
                navigate={~p"/photos"}
                class="absolute bottom-0 right-0 bg-white text-gray-900 p-2 rounded-full shadow-md hover:bg-gray-100 transition-colors"
                title="Change Photo"
              >
                <.icon name="hero-camera" class="w-5 h-5" />
              </.link>
            </div>

            <div class="text-center md:text-left flex-1">
              <div class="flex flex-col md:flex-row items-center gap-3 mb-2">
                <h1 class="text-3xl font-bold">{@profile.display_name}</h1>
                <%= if length(@badges) > 0 do %>
                  <div class="flex gap-1">
                    <%= for badge <- @badges do %>
                      <.badge
                        variant="outline"
                        color="white"
                        rounded="full"
                        class="border-white/30 bg-white/20 backdrop-blur-sm"
                      >
                        {badge.display_name}
                      </.badge>
                    <% end %>
                  </div>
                <% end %>
              </div>
              <p class="text-primary-100 text-lg mb-4">{@profile.email}</p>

              <div class="flex flex-wrap justify-center md:justify-start gap-4">
                <.badge
                  variant="outline"
                  color="white"
                  size="medium"
                  rounded="medium"
                  icon="hero-shield-check"
                  class="bg-white/10 backdrop-blur-sm border-0"
                >
                  Trust Score: {if @trust_score, do: @trust_score.score, else: "N/A"}
                </.badge>
                <.badge
                  variant="outline"
                  color="white"
                  size="medium"
                  rounded="medium"
                  icon="hero-check-circle"
                  class="bg-white/10 backdrop-blur-sm border-0"
                >
                  Status: {String.capitalize(@profile.status || "active", :ascii)}
                </.badge>
              </div>
            </div>

            <div class="flex gap-3 mt-4 md:mt-0">
              <.button
                type="button"
                class="bg-white/20 hover:bg-white/30 backdrop-blur-sm border-white/50 !text-white cursor-not-allowed opacity-70"
              >
                <.icon name="hero-eye" class="w-5 h-5 mr-2" /> Public View (Soon)
              </.button>
              <.button_link
                navigate={~p"/profile/edit"}
                variant="shadow"
                color="white"
                class="text-primary-dark font-bold shadow-md"
              >
                <.icon name="hero-pencil-square" class="w-5 h-5 mr-2" /> Edit Profile
              </.button_link>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-20">
        <!-- Completeness Banner -->
        <%= if @completeness && @completeness.score < 100 do %>
          <.card
            variant="shadow"
            padding="large"
            rounded="extra_large"
            class="mb-8 relative overflow-hidden border-gray-100"
          >
            <div class="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-blue-50 to-indigo-50 rounded-bl-full -mr-8 -mt-8 z-0">
            </div>
            <div class="relative z-10">
              <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
                <div class="flex-1 w-full">
                  <h3 class="text-lg font-bold text-gray-900 mb-2">Complete your profile</h3>
                  <p class="text-gray-600 mb-4 max-w-2xl">
                    A complete profile increases your trust score and helps you get faster responses.
                    You are <span class="font-bold text-primary-600">{@completeness.score}%</span>
                    there!
                  </p>
                  <.progress value={@completeness.score} color="primary" size="medium" rounded="full" />
                </div>
                <%= if length(@completeness.missing_fields) > 0 do %>
                  <div class="flex-shrink-0">
                    <.button_link
                      navigate={get_field_link(List.first(@completeness.missing_fields))}
                      color="primary"
                      variant="shadow"
                    >
                      Complete {format_field_name(List.first(@completeness.missing_fields))}
                      <.icon name="hero-arrow-right" class="w-4 h-4 ml-2" />
                    </.button_link>
                  </div>
                <% end %>
              </div>
            </div>
          </.card>
        <% end %>
        
    <!-- Dashboard Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
          
    <!-- Personal Information Card -->
          <.dashboard_card
            title="Personal Info"
            icon="hero-user"
            link={~p"/profile/edit"}
            color="blue"
          >
            <div class="space-y-3">
              <div class="flex items-center gap-3 text-sm text-gray-600">
                <.icon name="hero-envelope" class="w-5 h-5 text-gray-400" />
                <span class="truncate">{@profile.email}</span>
              </div>
              <div class="flex items-center gap-3 text-sm text-gray-600">
                <.icon name="hero-phone" class="w-5 h-5 text-gray-400" />
                <span>{@profile.phone || "Add phone number"}</span>
              </div>
              <div class="flex items-center gap-3 text-sm text-gray-600">
                <.icon name="hero-calendar" class="w-5 h-5 text-gray-400" />
                <span>
                  {if @profile.date_of_birth,
                    do: Calendar.strftime(@profile.date_of_birth, "%B %d, %Y"),
                    else: "Add date of birth"}
                </span>
              </div>
            </div>
          </.dashboard_card>
          
    <!-- Addresses Card -->
          <.dashboard_card
            title="My Addresses"
            icon="hero-map-pin"
            link={~p"/addresses"}
            color="green"
            action_text="Manage"
          >
            <%= if @profile.addresses && length(@profile.addresses) > 0 do %>
              <div class="space-y-3">
                <%= for address <- Enum.take(@profile.addresses, 2) do %>
                  <div class="flex items-start gap-3">
                    <div class="mt-0.5"><.icon name="hero-home" class="w-5 h-5 text-gray-400" /></div>
                    <div>
                      <p class="text-sm font-medium text-gray-900">
                        {String.capitalize(address.type || "home")}
                      </p>
                      <p class="text-xs text-gray-500 line-clamp-1">{address.line1}</p>
                    </div>
                  </div>
                <% end %>
                <%= if length(@profile.addresses) > 2 do %>
                  <p class="text-xs text-center text-gray-500 pt-1">
                    + {length(@profile.addresses) - 2} more addresses
                  </p>
                <% end %>
              </div>
            <% else %>
              <div class="text-center py-4">
                <div class="bg-gray-50 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-2">
                  <.icon name="hero-map" class="w-6 h-6 text-gray-400" />
                </div>
                <p class="text-sm text-gray-500 mb-2">No addresses added yet</p>
                <.link
                  navigate={~p"/addresses/new"}
                  class="text-sm font-medium text-primary-600 hover:text-primary-700"
                >
                  + Add Address
                </.link>
              </div>
            <% end %>
          </.dashboard_card>
          
    <!-- Photos Card -->
          <.dashboard_card
            title="Photos & Media"
            icon="hero-photo"
            link={~p"/photos"}
            color="purple"
            action_text="Gallery"
          >
            <%= if @profile.profile_photos && length(@profile.profile_photos) > 0 do %>
              <div class="grid grid-cols-3 gap-2">
                <%= for photo <- Enum.take(@profile.profile_photos, 3) do %>
                  <div class="aspect-square rounded-lg overflow-hidden bg-gray-100 relative">
                    <.card_media src={photo.url} class="h-full w-full object-cover" />
                    <%= if photo.is_current do %>
                      <div class="absolute top-1 right-1 w-2.5 h-2.5 bg-green-500 rounded-full border border-white">
                      </div>
                    <% end %>
                  </div>
                <% end %>
                <%= if length(@profile.profile_photos) > 3 do %>
                  <div class="aspect-square rounded-lg bg-gray-50 flex items-center justify-center border border-dashed border-gray-300">
                    <span class="text-xs font-medium text-gray-500">
                      +{length(@profile.profile_photos) - 3}
                    </span>
                  </div>
                <% end %>
              </div>
            <% else %>
              <div class="text-center py-4">
                <div class="bg-gray-50 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-2">
                  <.icon name="hero-camera" class="w-6 h-6 text-gray-400" />
                </div>
                <p class="text-sm text-gray-500 mb-2">No photos yet</p>
                <.link
                  navigate={~p"/photos"}
                  class="text-sm font-medium text-primary-600 hover:text-primary-700"
                >
                  + Upload Photos
                </.link>
              </div>
            <% end %>
          </.dashboard_card>
          
    <!-- Emergency Contacts -->
          <.dashboard_card
            title="Emergency Contacts"
            icon="hero-heart"
            link={~p"/emergency-contacts"}
            color="red"
            action_text="Manage"
          >
            <%= if @profile.emergency_contacts && length(@profile.emergency_contacts) > 0 do %>
              <div class="space-y-3">
                <%= for contact <- Enum.take(@profile.emergency_contacts, 2) do %>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-full bg-red-50 flex items-center justify-center text-red-600 font-bold text-xs">
                      {String.first(contact.name)}
                    </div>
                    <div>
                      <p class="text-sm font-medium text-gray-900">{contact.name}</p>
                      <p class="text-xs text-gray-500">{contact.relationship} • {contact.phone}</p>
                    </div>
                  </div>
                <% end %>
              </div>
            <% else %>
              <div class="text-center py-4">
                <p class="text-sm text-gray-500 mb-2">
                  Keep your loved ones close in case of emergency.
                </p>
                <.link
                  navigate={~p"/emergency-contacts/new"}
                  class="text-sm font-medium text-primary-600 hover:text-primary-700"
                >
                  + Add Contact
                </.link>
              </div>
            <% end %>
          </.dashboard_card>
          
    <!-- Preferences -->
          <.dashboard_card
            title="Preferences"
            icon="hero-adjustments-horizontal"
            link={~p"/preferences"}
            color="amber"
          >
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Communications</span>
                <.badge color="success" size="extra_small" rounded="full">Enabled</.badge>
              </div>
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Privacy</span>
                <.badge color="natural" size="extra_small" rounded="full">Standard</.badge>
              </div>
              <div class="flex items-center justify-between">
                <span class="text-sm text-gray-600">Language</span>
                <span class="text-xs text-gray-600">English</span>
              </div>
            </div>
          </.dashboard_card>
          
    <!-- Roles & Permissions -->
          <.dashboard_card
            title="Roles"
            icon="hero-briefcase"
            link={~p"/roles"}
            color="slate"
          >
            <div class="flex flex-wrap gap-2">
              <%= if @profile.user_roles && length(@profile.user_roles) > 0 do %>
                <%= for user_role <- @profile.user_roles do %>
                  <.badge color="natural" variant="outline" size="small">
                    {String.upcase(user_role.role.name)}
                  </.badge>
                <% end %>
              <% else %>
                <.badge color="natural" variant="outline" size="small">USER</.badge>
              <% end %>
            </div>
            <p class="text-xs text-gray-500 mt-3">
              Manage your active roles and verify your professional status.
            </p>
          </.dashboard_card>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp dashboard_card(assigns) do
    ~H"""
    <.card
      variant="shadow"
      rounded="extra_large"
      class="hover:shadow-md transition-shadow duration-300 border-gray-100 h-full flex flex-col"
      padding="none"
    >
      <.card_title
        padding="medium"
        class="border-b border-gray-50 bg-gray-50/50 justify-between items-center"
      >
        <div class="flex items-center gap-3">
          <div class={"p-2 rounded-lg bg-#{@color}-100 text-#{@color}-600"}>
            <.icon name={@icon} class="w-5 h-5" />
          </div>
          <h3 class="font-semibold text-gray-900 text-base">{@title}</h3>
        </div>
        <%= if assigns[:action_text] do %>
          <.link
            navigate={@link}
            class={"text-xs font-medium text-#{@color}-600 hover:text-#{@color}-700"}
          >
            {@action_text}
          </.link>
        <% end %>
      </.card_title>

      <.card_content padding="medium" class="flex-1">
        {render_slot(@inner_block)}
      </.card_content>

      <%= if !assigns[:action_text] do %>
        <.card_footer padding="medium" class="bg-gray-50 border-t border-gray-100">
          <.link
            navigate={@link}
            class="text-sm font-medium text-gray-600 hover:text-primary-600 flex items-center justify-between group w-full"
          >
            Manage {@title}
            <.icon
              name="hero-arrow-right"
              class="w-4 h-4 text-gray-400 group-hover:text-primary-600 transition-colors"
            />
          </.link>
        </.card_footer>
      <% end %>
    </.card>
    """
  end

  defp format_field_name("display_name"), do: "Display Name"
  defp format_field_name("first_name"), do: "First Name"
  defp format_field_name("last_name"), do: "Last Name"
  defp format_field_name("email"), do: "Email"
  defp format_field_name("phone"), do: "Phone Number"
  defp format_field_name("bio"), do: "Bio"
  defp format_field_name("date_of_birth"), do: "Date of Birth"
  defp format_field_name("gender"), do: "Gender"
  defp format_field_name("address"), do: "Address"
  defp format_field_name("profile_photo"), do: "Profile Photo"
  defp format_field_name("emergency_contact"), do: "Emergency Contact"

  defp format_field_name(field) do
    field
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp get_field_link("display_name"), do: ~p"/profile/edit"
  defp get_field_link("first_name"), do: ~p"/profile/edit"
  defp get_field_link("last_name"), do: ~p"/profile/edit"
  defp get_field_link("email"), do: ~p"/profile/edit"
  defp get_field_link("phone"), do: ~p"/profile/edit"
  defp get_field_link("bio"), do: ~p"/profile/edit"
  defp get_field_link("date_of_birth"), do: ~p"/profile/edit"
  defp get_field_link("gender"), do: ~p"/profile/edit"
  defp get_field_link("address"), do: ~p"/addresses/new"
  defp get_field_link("profile_photo"), do: ~p"/photos"
  defp get_field_link("emergency_contact"), do: ~p"/emergency-contacts/new"
  defp get_field_link(_), do: ~p"/profile/edit"
end
