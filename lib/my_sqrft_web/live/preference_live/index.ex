defmodule MySqrftWeb.PreferenceLive.Index do
  @moduledoc """
  LiveView for managing user preferences.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        preferences = UserManagement.get_preferences(profile)

        socket =
          socket
          |> assign(:page_title, "Preferences")
          |> assign(:profile, profile)
          |> assign(:preferences, preferences)
          |> assign(:categories, ["search", "lifestyle", "communication", "notification"])

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
    |> assign(:page_title, "Preferences")
  end

  defp apply_action(socket, :edit, %{"category" => category}) do
    preferences = UserManagement.get_preferences(socket.assigns.profile, category)

    socket
    |> assign(:page_title, "Edit #{String.capitalize(category)} Preferences")
    |> assign(:category, category)
    |> assign(:category_preferences, preferences)
  end

  @impl true
  def handle_event("save-preference", %{"category" => category, "key" => key, "value" => value}, socket) do
    # Parse JSON value if it's a string
    parsed_value = case Jason.decode(value) do
      {:ok, decoded} -> decoded
      {:error, _} -> value
    end

    case UserManagement.upsert_preference(socket.assigns.profile, category, key, parsed_value) do
      {:ok, _preference} ->
        preferences = UserManagement.get_preferences(socket.assigns.profile, category)

        {:noreply,
         socket
         |> put_flash(:info, "Preference saved successfully")
         |> assign(:category_preferences, preferences)}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to save preference")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">Preferences</h1>

          <div class="space-y-4">
            <%= for category <- @categories do %>
              <div class="bg-white rounded-lg shadow p-6">
                <div class="flex justify-between items-center mb-4">
                  <h2 class="text-xl font-semibold"><%= String.capitalize(category) %></h2>
                  <.link
                    navigate={~p"/preferences/#{category}/edit"}
                    class="px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-50"
                  >
                    Edit
                  </.link>
                </div>
                <%= render_category_preferences(assigns, category) %>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp render_category_preferences(assigns, category) do
    category_prefs = Enum.filter(assigns.preferences, &(&1.category == category))

    if length(category_prefs) == 0 do
      ~H"""
      <p class="text-gray-500">No preferences set for this category.</p>
      """
    else
      ~H"""
      <dl class="space-y-2">
        <%= for pref <- category_prefs do %>
          <div>
            <dt class="font-medium text-gray-700"><%= String.replace(pref.key, "_", " ") |> String.capitalize() %></dt>
            <dd class="text-gray-600">
              <%= if is_map(pref.value) or is_list(pref.value) do %>
                <%= Jason.encode!(pref.value) %>
              <% else %>
                <%= pref.value %>
              <% end %>
            </dd>
          </div>
        <% end %>
      </dl>
      """
    end
  end
end
