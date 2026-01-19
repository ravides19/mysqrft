defmodule MySqrftWeb.PreferenceLive.Edit do
  @moduledoc """
  LiveView for editing preferences by category.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        socket =
          socket
          |> assign(:page_title, "Edit Preferences")
          |> assign(:profile, profile)

        {:ok, socket}
      else
        {:ok, push_navigate(socket, to: ~p"/profile/new")}
      end
    else
      {:ok, push_navigate(socket, to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_params(%{"category" => category}, _url, socket) do
    preferences = UserManagement.get_preferences(socket.assigns.profile, category)

    socket =
      socket
      |> assign(:category, category)
      |> assign(:preferences, preferences)
      |> assign(:page_title, "Edit #{String.capitalize(category)} Preferences")

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"preferences" => prefs}, socket) do
    # Save each preference
    results = Enum.map(prefs, fn {key, value} ->
      UserManagement.upsert_preference(socket.assigns.profile, socket.assigns.category, key, value)
    end)

    if Enum.all?(results, fn {status, _} -> status == :ok end) do
      {:noreply,
       socket
       |> put_flash(:info, "Preferences saved successfully")
       |> push_navigate(to: ~p"/preferences")}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Some preferences failed to save")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-2xl mx-auto">
          <h1 class="text-3xl font-bold mb-6"><%= @page_title %></h1>

          <.form for={%{}} phx-submit="save" id="preferences-form">
            <div class="bg-white rounded-lg shadow p-6 space-y-6">
              <%= render_category_form(assigns) %>

              <div class="flex gap-4">
                <.button type="submit" variant="primary" phx-disable-with="Saving...">
                  Save Preferences
                </.button>
                <.link
                  navigate={~p"/preferences"}
                  class="px-4 py-2 border border-gray-300 rounded hover:bg-gray-50"
                >
                  Cancel
                </.link>
              </div>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp render_category_form(assigns) do
    case assigns.category do
      "search" ->
        ~H"""
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Budget Range (Min)</label>
          <input
            type="number"
            name="preferences[budget_min]"
            value={get_pref_value(assigns.preferences, "budget_min")}
            class="w-full px-3 py-2 border border-gray-300 rounded"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Budget Range (Max)</label>
          <input
            type="number"
            name="preferences[budget_max]"
            value={get_pref_value(assigns.preferences, "budget_max")}
            class="w-full px-3 py-2 border border-gray-300 rounded"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Preferred Localities (comma-separated)</label>
          <input
            type="text"
            name="preferences[preferred_localities]"
            value={get_pref_value(assigns.preferences, "preferred_localities")}
            class="w-full px-3 py-2 border border-gray-300 rounded"
          />
        </div>
        """

      "communication" ->
        ~H"""
        <div>
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              name="preferences[email_enabled]"
              checked={get_pref_value(assigns.preferences, "email_enabled") == true}
              class="rounded"
            />
            <span class="text-sm font-medium text-gray-700">Enable Email Notifications</span>
          </label>
        </div>
        <div>
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              name="preferences[sms_enabled]"
              checked={get_pref_value(assigns.preferences, "sms_enabled") == true}
              class="rounded"
            />
            <span class="text-sm font-medium text-gray-700">Enable SMS Notifications</span>
          </label>
        </div>
        <div>
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              name="preferences[push_enabled]"
              checked={get_pref_value(assigns.preferences, "push_enabled") == true}
              class="rounded"
            />
            <span class="text-sm font-medium text-gray-700">Enable Push Notifications</span>
          </label>
        </div>
        """

      _ ->
        ~H"""
        <p class="text-gray-600">Preference form for <%= assigns.category %> category.</p>
        """
    end
  end

  defp get_pref_value(preferences, key) do
    case Enum.find(preferences, &(&1.key == key)) do
      nil -> ""
      pref -> if is_map(pref.value) or is_list(pref.value), do: Jason.encode!(pref.value), else: pref.value
    end
  end
end
