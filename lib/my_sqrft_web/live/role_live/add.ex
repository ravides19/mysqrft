defmodule MySqrftWeb.RoleLive.Add do
  @moduledoc """
  LiveView for adding a new role to user profile.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        active_roles = UserManagement.list_active_roles()
        existing_role_ids = UserManagement.get_user_roles(profile) |> Enum.map(& &1.role_id)
        available_roles = Enum.reject(active_roles, &(&1.id in existing_role_ids))

        socket =
          socket
          |> assign(:page_title, "Add Role")
          |> assign(:profile, profile)
          |> assign(:available_roles, available_roles)

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
  def handle_event("add-role", %{"role_id" => role_id}, socket) do
    role = UserManagement.get_role!(role_id)

    case UserManagement.add_role_to_profile(socket.assigns.profile, role, %{}) do
      {:ok, _user_role} ->
        {:noreply,
         socket
         |> put_flash(:info, "Role added successfully")
         |> push_navigate(to: ~p"/roles")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to add role")
         |> push_navigate(to: ~p"/roles")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-2xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">Add Role</h1>

          <%= if length(@available_roles) == 0 do %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
              <p class="text-gray-600 mb-4">You already have all available roles.</p>
              <.link
                navigate={~p"/roles"}
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 inline-block"
              >
                Back to Roles
              </.link>
            </div>
          <% else %>
            <div class="space-y-4">
              <%= for role <- @available_roles do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <h3 class="text-xl font-semibold mb-2"><%= role.name %></h3>
                  <%= if role.description do %>
                    <p class="text-gray-600 mb-4"><%= role.description %></p>
                  <% end %>
                  <button
                    phx-click="add-role"
                    phx-value-role_id={role.id}
                    class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                  >
                    Add Role
                  </button>
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
