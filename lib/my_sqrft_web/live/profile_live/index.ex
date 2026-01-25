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

      # Ensure completeness is calculated
      if profile do
        # Preload associations needed for completeness calculation
        profile = MySqrft.Repo.preload(profile, [:addresses, :profile_photos, :emergency_contacts])

        completeness_record = UserManagement.get_profile_completeness(profile)

        # Calculate if it doesn't exist or is outdated (older than 1 hour)
        if completeness_record == nil or
           DateTime.diff(DateTime.utc_now(), completeness_record.calculated_at, :second) > 3600 do
          UserManagement.calculate_and_update_completeness(profile)
        end
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
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">My Profile</h1>

          <%= if @profile do %>
            <div class="space-y-6">
              <!-- Profile Completeness -->
              <%= if @completeness do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <h2 class="text-xl font-semibold mb-4">Profile Completeness</h2>

                  <!-- Overall Score -->
                  <div class="flex items-center gap-4 mb-6">
                    <div class="flex-1">
                      <div class="w-full bg-gray-200 rounded-full h-6">
                        <div
                          class={[
                            "h-6 rounded-full transition-all",
                            if(@completeness.score >= 80, do: "bg-green-600", else: if(@completeness.score >= 50, do: "bg-yellow-500", else: "bg-blue-600"))
                          ]}
                          style={"width: #{@completeness.score}%"}
                        >
                        </div>
                      </div>
                    </div>
                    <span class="text-2xl font-bold"><%= @completeness.score %>%</span>
                  </div>

                  <!-- Breakdown by Section -->
                  <%= if map_size(@completeness.breakdown) > 0 do %>
                    <div class="mb-6">
                      <h3 class="text-lg font-medium mb-3">Progress by Section</h3>
                      <div class="space-y-3">
                        <%= for {section, score} <- @completeness.breakdown do %>
                          <div>
                            <div class="flex justify-between items-center mb-1">
                              <span class="text-sm font-medium text-gray-700">
                                <%= format_section_name(section) %>
                              </span>
                              <span class="text-sm font-semibold text-gray-900"><%= score %>%</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-2">
                              <div
                                class={[
                                  "h-2 rounded-full transition-all",
                                  if(score == 100, do: "bg-green-600", else: if(score >= 50, do: "bg-yellow-500", else: "bg-blue-600"))
                                ]}
                                style={"width: #{score}%"}
                              >
                              </div>
                            </div>
                          </div>
                        <% end %>
                      </div>
                    </div>
                  <% end %>

                  <!-- Missing Fields / Next Steps -->
                  <%= if length(@completeness.missing_fields) > 0 do %>
                    <div class="border-t pt-4 mt-4">
                      <h3 class="text-lg font-medium mb-3">Complete Your Profile</h3>
                      <p class="text-sm text-gray-600 mb-4">
                        Add the following information to improve your profile completeness:
                      </p>
                      <ul class="space-y-2">
                        <%= for field <- @completeness.missing_fields do %>
                          <li class="flex items-center justify-between py-2 px-3 bg-gray-50 rounded-lg">
                            <span class="text-sm text-gray-700">
                              <%= format_field_name(field) %>
                            </span>
                            <.link
                              navigate={get_field_link(field)}
                              class="text-sm text-blue-600 hover:text-blue-800 font-medium"
                            >
                              <%= get_field_action(field) %>
                            </.link>
                          </li>
                        <% end %>
                      </ul>
                    </div>
                  <% else %>
                    <div class="border-t pt-4 mt-4">
                      <div class="flex items-center gap-2 text-green-600">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                        </svg>
                        <span class="text-sm font-medium">Your profile is complete!</span>
                      </div>
                    </div>
                  <% end %>
                </div>
              <% end %>

              <!-- Trust Score -->
              <%= if @trust_score do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <h2 class="text-xl font-semibold mb-4">Trust Score</h2>
                  <div class="text-4xl font-bold text-blue-600"><%= @trust_score.score %></div>
                  <p class="text-gray-600 mt-2">Out of 100</p>
                </div>
              <% end %>

              <!-- Verification Badges -->
              <%= if length(@badges) > 0 do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <h2 class="text-xl font-semibold mb-4">Verification Badges</h2>
                  <div class="flex flex-wrap gap-2">
                    <%= for badge <- @badges do %>
                      <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm">
                        <%= badge.display_name %>
                      </span>
                    <% end %>
                  </div>
                </div>
              <% end %>

              <!-- Profile Information -->
              <div class="bg-white rounded-lg shadow p-6">
                <h2 class="text-xl font-semibold mb-4">Profile Information</h2>
                <dl class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Display Name</dt>
                    <dd class="mt-1 text-sm text-gray-900"><%= @profile.display_name %></dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Email</dt>
                    <dd class="mt-1 text-sm text-gray-900"><%= @profile.email %></dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Phone</dt>
                    <dd class="mt-1 text-sm text-gray-900"><%= @profile.phone %></dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Status</dt>
                    <dd class="mt-1 text-sm text-gray-900">
                      <span class={"px-2 py-1 rounded text-xs font-medium #{status_color(@profile.status)}"}>
                        <%= String.capitalize(@profile.status, :ascii) %>
                      </span>
                    </dd>
                  </div>
                </dl>
              </div>

              <!-- Actions -->
              <div class="flex gap-4">
                <.link
                  navigate={~p"/profile/edit"}
                  class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                >
                  Edit Profile
                </.link>
              </div>
            </div>
          <% else %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
              <p class="text-gray-600 mb-4">You don't have a profile yet.</p>
              <.link
                navigate={~p"/profile/new"}
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 inline-block"
              >
                Create Profile
              </.link>
            </div>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp status_color("active"), do: "bg-green-100 text-green-800"
  defp status_color("suspended"), do: "bg-yellow-100 text-yellow-800"
  defp status_color("blocked"), do: "bg-red-100 text-red-800"
  defp status_color("deleted"), do: "bg-gray-100 text-gray-800"
  defp status_color(_), do: "bg-gray-100 text-gray-800"

  defp format_section_name(:basic_info), do: "Basic Information"
  defp format_section_name(:personal_info), do: "Personal Information"
  defp format_section_name(:address), do: "Address"
  defp format_section_name(:photo), do: "Profile Photo"
  defp format_section_name(:emergency_contacts), do: "Emergency Contacts"
  # Handle string keys from JSONB
  defp format_section_name("basic_info"), do: "Basic Information"
  defp format_section_name("personal_info"), do: "Personal Information"
  defp format_section_name("address"), do: "Address"
  defp format_section_name("photo"), do: "Profile Photo"
  defp format_section_name("emergency_contacts"), do: "Emergency Contacts"
  # Fallback for other atom keys
  defp format_section_name(section) when is_atom(section) do
    section
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
  # Fallback for string keys
  defp format_section_name(section) when is_binary(section) do
    section
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
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

  defp get_field_action("address"), do: "Add Address"
  defp get_field_action("profile_photo"), do: "Add Photo"
  defp get_field_action("emergency_contact"), do: "Add Contact"
  defp get_field_action(_), do: "Edit"
end
