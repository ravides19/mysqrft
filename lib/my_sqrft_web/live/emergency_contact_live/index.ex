defmodule MySqrftWeb.EmergencyContactLive.Index do
  @moduledoc """
  LiveView for managing emergency contacts.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        contacts = UserManagement.list_emergency_contacts(profile)

        socket =
          socket
          |> assign(:page_title, "Emergency Contacts")
          |> assign(:profile, profile)
          |> assign(:contacts, contacts)

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
    |> assign(:page_title, "Emergency Contacts")
  end

  defp apply_action(socket, :new, _params) do
    changeset = UserManagement.EmergencyContact.changeset(%UserManagement.EmergencyContact{}, %{})

    socket
    |> assign(:page_title, "Add Emergency Contact")
    |> assign(:contact, nil)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    contact = UserManagement.get_emergency_contact!(id)
    changeset = UserManagement.EmergencyContact.changeset(contact, %{})

    socket
    |> assign(:page_title, "Edit Emergency Contact")
    |> assign(:contact, contact)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = UserManagement.get_emergency_contact!(id)
    {:ok, _} = UserManagement.delete_emergency_contact(contact)
    contacts = UserManagement.list_emergency_contacts(socket.assigns.profile)

    {:noreply,
     socket
     |> put_flash(:info, "Emergency contact deleted successfully")
     |> assign(:contacts, contacts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
          <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold">Emergency Contacts</h1>
            <.link
              navigate={~p"/emergency-contacts/new"}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Add Contact
            </.link>
          </div>

          <%= if length(@contacts) == 0 do %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
              <p class="text-gray-600 mb-4">You don't have any emergency contacts yet.</p>
              <.link
                navigate={~p"/emergency-contacts/new"}
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 inline-block"
              >
                Add Your First Contact
              </.link>
            </div>
          <% else %>
            <div class="space-y-4">
              <%= for contact <- @contacts do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <div class="flex justify-between items-start">
                    <div class="flex-1">
                      <h3 class="text-xl font-semibold mb-2"><%= contact.name %></h3>
                      <p class="text-gray-600 mb-1">Relationship: <%= String.capitalize(contact.relationship) %></p>
                      <p class="text-gray-600 mb-1">Phone: <%= contact.phone %></p>
                      <%= if contact.email do %>
                        <p class="text-gray-600 mb-1">Email: <%= contact.email %></p>
                      <% end %>
                      <p class="text-sm text-gray-500 mt-2">Priority: <%= contact.priority %></p>
                    </div>
                    <div class="flex gap-2">
                      <.link
                        navigate={~p"/emergency-contacts/#{contact.id}/edit"}
                        class="px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-50"
                      >
                        Edit
                      </.link>
                      <button
                        phx-click="delete"
                        phx-value-id={contact.id}
                        data-confirm="Are you sure you want to delete this emergency contact?"
                        class="px-3 py-1 text-sm border border-red-300 text-red-600 rounded hover:bg-red-50"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
