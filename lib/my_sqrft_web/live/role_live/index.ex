defmodule MySqrftWeb.RoleLive.Index do
  @moduledoc """
  LiveView for managing user roles.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        user_roles = UserManagement.get_user_roles(profile)
        active_roles = UserManagement.list_active_roles()

        socket =
          socket
          |> assign(:page_title, "My Roles")
          |> assign(:profile, profile)
          |> assign(:user_roles, user_roles)
          |> assign(:available_roles, active_roles)

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
    |> assign(:page_title, "My Roles")
  end

  defp apply_action(socket, :add, _params) do
    socket
    |> assign(:page_title, "Add Role")
  end

  @impl true
  def handle_event("deactivate", %{"id" => id}, socket) do
    user_role = Enum.find(socket.assigns.user_roles, &(&1.id == id))
    {:ok, _} = UserManagement.deactivate_user_role(user_role)
    user_roles = UserManagement.get_user_roles(socket.assigns.profile)

    {:noreply,
     socket
     |> put_flash(:info, "Role deactivated successfully")
     |> assign(:user_roles, user_roles)}
  end

  def handle_event("activate", %{"id" => id}, socket) do
    user_role = Enum.find(socket.assigns.user_roles, &(&1.id == id))
    {:ok, _} = UserManagement.activate_user_role(user_role)
    user_roles = UserManagement.get_user_roles(socket.assigns.profile)

    {:noreply,
     socket
     |> put_flash(:info, "Role activated successfully")
     |> assign(:user_roles, user_roles)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
          <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold">My Roles</h1>
            <.link
              navigate={~p"/roles/add"}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Add Role
            </.link>
          </div>

          <%= if length(@user_roles) == 0 do %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
              <p class="text-gray-600 mb-4">You don't have any roles yet.</p>
              <.link
                navigate={~p"/roles/add"}
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 inline-block"
              >
                Add Your First Role
              </.link>
            </div>
          <% else %>
            <div class="space-y-4">
              <%= for user_role <- @user_roles do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <div class="flex justify-between items-start">
                    <div class="flex-1">
                      <h3 class="text-xl font-semibold mb-2"><%= user_role.role.name %></h3>
                      <%= if user_role.role.description do %>
                        <p class="text-gray-600 mb-2"><%= user_role.role.description %></p>
                      <% end %>
                      <span class={"px-2 py-1 rounded text-xs font-medium #{status_color(user_role.status)}"}>
                        <%= String.capitalize(user_role.status) %>
                      </span>
                      <%= if user_role.activated_at do %>
                        <p class="text-sm text-gray-500 mt-2">
                          Activated: <%= Calendar.strftime(user_role.activated_at, "%B %d, %Y") %>
                        </p>
                      <% end %>
                    </div>
                    <div class="flex gap-2">
                      <%= if user_role.status == "active" do %>
                        <button
                          phx-click="deactivate"
                          phx-value-id={user_role.id}
                          data-confirm="Are you sure you want to deactivate this role?"
                          class="px-3 py-1 text-sm border border-yellow-300 text-yellow-600 rounded hover:bg-yellow-50"
                        >
                          Deactivate
                        </button>
                      <% else %>
                        <button
                          phx-click="activate"
                          phx-value-id={user_role.id}
                          class="px-3 py-1 text-sm border border-green-300 text-green-600 rounded hover:bg-green-50"
                        >
                          Activate
                        </button>
                      <% end %>
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

  defp status_color("active"), do: "bg-green-100 text-green-800"
  defp status_color("inactive"), do: "bg-gray-100 text-gray-800"
  defp status_color("pending"), do: "bg-yellow-100 text-yellow-800"
  defp status_color(_), do: "bg-gray-100 text-gray-800"
end
