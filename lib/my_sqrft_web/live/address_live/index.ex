defmodule MySqrftWeb.AddressLive.Index do
  @moduledoc """
  LiveView for managing user addresses.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        addresses = UserManagement.list_addresses(profile)

        socket =
          socket
          |> assign(:page_title, "My Addresses")
          |> assign(:profile, profile)
          |> assign(:addresses, addresses)

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
    |> assign(:page_title, "My Addresses")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add Address")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    address = UserManagement.get_address!(id)
    changeset = UserManagement.Address.changeset(address, %{})

    socket
    |> assign(:page_title, "Edit Address")
    |> assign(:address, address)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    address = UserManagement.get_address!(id)
    {:ok, _} = UserManagement.delete_address(address)

    addresses = UserManagement.list_addresses(socket.assigns.profile)

    {:noreply,
     socket
     |> put_flash(:info, "Address deleted successfully")
     |> assign(:addresses, addresses)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
          <div class="mb-6">
            <.link
              navigate={~p"/profile"}
              class="flex items-center text-sm text-gray-600 hover:text-gray-900"
            >
              <.icon name="hero-arrow-left" class="w-4 h-4 mr-1" /> Back to Profile
            </.link>
          </div>
          <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold">My Addresses</h1>
            <.link
              navigate={~p"/addresses/new"}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Add Address
            </.link>
          </div>

          <%= if length(@addresses) == 0 do %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
              <p class="text-gray-600 mb-4">You don't have any addresses yet.</p>
              <.link
                navigate={~p"/addresses/new"}
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 inline-block"
              >
                Add Your First Address
              </.link>
            </div>
          <% else %>
            <div class="space-y-4">
              <%= for address <- @addresses do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <div class="flex justify-between items-start">
                    <div class="flex-1">
                      <%= if address.is_primary do %>
                        <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-medium mb-2 inline-block">
                          Primary
                        </span>
                      <% end %>
                      <p class="font-semibold text-lg mb-2">{address.type |> String.capitalize()}</p>
                      <p class="text-gray-700">{address.line1}</p>
                      <%= if address.line2 do %>
                        <p class="text-gray-700">{address.line2}</p>
                      <% end %>
                      <p class="text-gray-700">
                        {address.locality || ""} {address.city}, {address.state} {address.pin_code}
                      </p>
                      <%= if address.landmark do %>
                        <p class="text-gray-500 text-sm mt-1">Near: {address.landmark}</p>
                      <% end %>
                    </div>
                    <div class="flex gap-2">
                      <.link
                        navigate={~p"/addresses/#{address.id}/edit"}
                        class="px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-50"
                      >
                        Edit
                      </.link>
                      <button
                        phx-click="delete"
                        phx-value-id={address.id}
                        data-confirm="Are you sure you want to delete this address?"
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
