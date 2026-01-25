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
    results =
      Enum.map(prefs, fn {key, value} ->
        UserManagement.upsert_preference(
          socket.assigns.profile,
          socket.assigns.category,
          key,
          value
        )
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
          <h1 class="text-3xl font-bold mb-6">{@page_title}</h1>

          <.form for={%{}} phx-submit="save" id="preferences-form">
            <div class="bg-white rounded-lg shadow p-6 space-y-6">
              {render_category_form(assigns)}

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
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Preferred Localities (comma-separated)
          </label>
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

      "lifestyle" ->
        ~H"""
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Smoking</label>
          <select
            name="preferences[smoking]"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-white"
          >
            {Phoenix.HTML.Form.options_for_select(
              ["No", "Yes", "Outside only"],
              get_pref_value(assigns.preferences, "smoking")
            )}
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Pets</label>
          <select
            name="preferences[pets]"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-white"
          >
            {Phoenix.HTML.Form.options_for_select(
              ["No", "Yes", "Dog", "Cat", "Other"],
              get_pref_value(assigns.preferences, "pets")
            )}
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Dietary</label>
          <select
            name="preferences[dietary]"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-white"
          >
            {Phoenix.HTML.Form.options_for_select(
              ["None", "Vegetarian", "Vegan", "Halal", "Kosher"],
              get_pref_value(assigns.preferences, "dietary")
            )}
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Drinking</label>
          <select
            name="preferences[drinking]"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-white"
          >
            {Phoenix.HTML.Form.options_for_select(
              ["No", "Yes", "Socially"],
              get_pref_value(assigns.preferences, "drinking")
            )}
          </select>
        </div>
        """

      "notification" ->
        ~H"""
        <div class="space-y-4">
          <p class="text-sm text-gray-500 mb-4">Select the types of notifications you want to receive.</p>

          <div>
            <label class="flex items-center gap-2">
              <input
                type="checkbox"
                name="preferences[new_match_alerts]"
                checked={get_pref_value(assigns.preferences, "new_match_alerts") == "true"}
                value="true"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
              <input type="hidden" name="preferences[new_match_alerts]" value="false" />
              <span class="text-sm font-medium text-gray-700">New Match Alerts</span>
            </label>
            <p class="text-xs text-gray-500 ml-6">Get notified when you have a new match.</p>
          </div>

          <div>
            <label class="flex items-center gap-2">
              <input
                type="checkbox"
                name="preferences[unread_message_reminders]"
                checked={get_pref_value(assigns.preferences, "unread_message_reminders") == "true"}
                value="true"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
              <input type="hidden" name="preferences[unread_message_reminders]" value="false" />
              <span class="text-sm font-medium text-gray-700">Unread Message Reminders</span>
            </label>
            <p class="text-xs text-gray-500 ml-6">Receive reminders about unread messages.</p>
          </div>

          <div>
            <label class="flex items-center gap-2">
              <input
                type="checkbox"
                name="preferences[marketing_promotions]"
                checked={get_pref_value(assigns.preferences, "marketing_promotions") == "true"}
                value="true"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
              <input type="hidden" name="preferences[marketing_promotions]" value="false" />
              <span class="text-sm font-medium text-gray-700">Marketing & Promotions</span>
            </label>
            <p class="text-xs text-gray-500 ml-6">Receive updates about new features and promotions.</p>
          </div>

          <div>
            <label class="flex items-center gap-2">
              <input
                type="checkbox"
                name="preferences[system_updates]"
                checked={get_pref_value(assigns.preferences, "system_updates") == "true"}
                value="true"
                class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
              />
              <input type="hidden" name="preferences[system_updates]" value="false" />
              <span class="text-sm font-medium text-gray-700">System Updates</span>
            </label>
            <p class="text-xs text-gray-500 ml-6">Important updates about the platform.</p>
          </div>
        </div>
        """

      _ ->
        ~H"""
        <p class="text-gray-600">Preference form for {assigns.category} category.</p>
        """
    end
  end

  defp get_pref_value(preferences, key) do
    case Enum.find(preferences, &(&1.key == key)) do
      nil ->
        ""

      pref ->
        if is_map(pref.value) or is_list(pref.value),
          do: Jason.encode!(pref.value),
          else: pref.value
    end
  end
end
