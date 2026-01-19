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
    case UserManagement.get_profile_by_user_id(profile.user_id) do
      nil -> nil
      p -> %{score: p.completeness_score}
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
                  <div class="flex items-center gap-4">
                    <div class="flex-1">
                      <div class="w-full bg-gray-200 rounded-full h-4">
                        <div
                          class="bg-blue-600 h-4 rounded-full transition-all"
                          style={"width: #{@completeness.score}%"}
                        >
                        </div>
                      </div>
                    </div>
                    <span class="text-lg font-semibold"><%= @completeness.score %>%</span>
                  </div>
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
                        <%= String.capitalize(@profile.status) %>
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
end
