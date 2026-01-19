defmodule MySqrftWeb.ConsentLive.Index do
  @moduledoc """
  LiveView for managing user consents.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        consents = UserManagement.list_consents(profile)

        socket =
          socket
          |> assign(:page_title, "Consent Management")
          |> assign(:profile, profile)
          |> assign(:consents, consents)

        {:ok, socket}
      else
        {:ok, push_navigate(socket, to: ~p"/profile/new")}
      end
    else
      {:ok, push_navigate(socket, to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("grant", %{"type" => consent_type}, socket) do
    user_agent = get_connect_info(socket, :user_agent) || "unknown"
    ip_address = get_connect_info(socket, :peer_data) |> Map.get(:address, "unknown")
    ip_string = if is_tuple(ip_address), do: :inet.ntoa(ip_address) |> to_string(), else: "unknown"

    metadata = %{
      ip_address: ip_string,
      user_agent: user_agent
    }

    case UserManagement.grant_consent(socket.assigns.profile, consent_type, "1.0", metadata) do
      {:ok, _consent} ->
        consents = UserManagement.list_consents(socket.assigns.profile)

        {:noreply,
         socket
         |> put_flash(:info, "Consent granted successfully")
         |> assign(:consents, consents)}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to grant consent")}
    end
  end

  def handle_event("revoke", %{"type" => consent_type}, socket) do
    user_agent = get_connect_info(socket, :user_agent) || "unknown"
    ip_address = get_connect_info(socket, :peer_data) |> Map.get(:address, "unknown")
    ip_string = if is_tuple(ip_address), do: :inet.ntoa(ip_address) |> to_string(), else: "unknown"

    metadata = %{
      ip_address: ip_string,
      user_agent: user_agent
    }

    case UserManagement.revoke_consent(socket.assigns.profile, consent_type, metadata) do
      {:ok, _consent} ->
        consents = UserManagement.list_consents(socket.assigns.profile)

        {:noreply,
         socket
         |> put_flash(:info, "Consent revoked successfully")
         |> assign(:consents, consents)}

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Consent not found")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to revoke consent")}
    end
  end

  def handle_event("view-history", %{"id" => id}, socket) do
    consent = UserManagement.get_consent!(id)
    history = UserManagement.get_consent_history(consent)

    {:noreply,
     socket
     |> assign(:selected_consent, consent)
     |> assign(:consent_history, history)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">Consent Management</h1>

          <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-xl font-semibold mb-4">Data Sharing Consents</h2>
            <div class="space-y-4">
              <%= for consent_type <- ["data_sharing", "marketing", "analytics", "third_party"] do %>
                <% consent = Enum.find(@consents, &(&1.consent_type == consent_type)) %>
                <div class="flex justify-between items-center p-4 border rounded">
                  <div>
                    <h3 class="font-medium"><%= String.replace(consent_type, "_", " ") |> String.capitalize() %></h3>
                    <%= if consent do %>
                      <p class="text-sm text-gray-600">
                        Status: <%= if consent.granted, do: "Granted", else: "Revoked" %>
                        <%= if consent.granted_at do %>
                          on <%= Calendar.strftime(consent.granted_at, "%B %d, %Y") %>
                        <% end %>
                      </p>
                      <p class="text-xs text-gray-500">Version: <%= consent.version %></p>
                    <% else %>
                      <p class="text-sm text-gray-600">Not set</p>
                    <% end %>
                  </div>
                  <div class="flex gap-2">
                    <%= if consent && consent.granted do %>
                      <button
                        phx-click="revoke"
                        phx-value-type={consent_type}
                        class="px-3 py-1 text-sm border border-red-300 text-red-600 rounded hover:bg-red-50"
                      >
                        Revoke
                      </button>
                    <% else %>
                      <button
                        phx-click="grant"
                        phx-value-type={consent_type}
                        class="px-3 py-1 text-sm bg-green-600 text-white rounded hover:bg-green-700"
                      >
                        Grant
                      </button>
                    <% end %>
                    <%= if consent do %>
                      <button
                        phx-click="view-history"
                        phx-value-id={consent.id}
                        class="px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-50"
                      >
                        History
                      </button>
                    <% end %>
                  </div>
                </div>
              <% end %>
            </div>
          </div>

          <%= if assigns[:selected_consent] && assigns[:consent_history] do %>
            <div class="bg-white rounded-lg shadow p-6">
              <h2 class="text-xl font-semibold mb-4">
                Consent History: <%= @selected_consent.consent_type |> String.replace("_", " ") |> String.capitalize() %>
              </h2>
              <div class="space-y-2">
                <%= for entry <- @consent_history do %>
                  <div class="p-3 border rounded">
                    <div class="flex justify-between">
                      <span class="font-medium"><%= String.capitalize(entry.action) %></span>
                      <span class="text-sm text-gray-600">
                        <%= Calendar.strftime(entry.timestamp, "%B %d, %Y at %I:%M %p") %>
                      </span>
                    </div>
                    <p class="text-sm text-gray-600">Version: <%= entry.version %></p>
                    <%= if entry.ip_address do %>
                      <p class="text-xs text-gray-500">IP: <%= entry.ip_address %></p>
                    <% end %>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
