defmodule MySqrftWeb.PropertyLive.Index do
  use MySqrftWeb, :live_view

  alias MySqrft.Properties
  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    # Ensure user is authenticated
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        properties = Properties.list_user_properties(current_scope.user.id)

        {:ok,
         socket
         |> assign(:page_title, "My Properties")
         |> assign(:properties, properties)}
      else
        {:ok, push_navigate(socket, to: ~p"/profile/new")}
      end
    else
      {:ok, push_navigate(socket, to: ~p"/users/log-in")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-3xl font-bold text-gray-900 dark:text-white">My Properties</h1>
            <p class="text-gray-500 mt-2">Manage your property portfolio</p>
          </div>
          <.link
            navigate={~p"/properties/new"}
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg flex items-center gap-2 transition-colors"
          >
            <.icon name="hero-plus" class="w-5 h-5" /> Add Property
          </.link>
        </div>

        <%= if Enum.empty?(@properties) do %>
          <div class="text-center py-16 bg-white dark:bg-gray-800 rounded-2xl border-2 border-dashed border-gray-200 dark:border-gray-700">
            <div class="mx-auto w-16 h-16 bg-primary-50 dark:bg-primary-900/20 rounded-full flex items-center justify-center mb-4">
              <.icon name="hero-home" class="w-8 h-8 text-primary-600 dark:text-primary-400" />
            </div>
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
              No properties yet
            </h3>
            <p class="text-gray-500 mb-6 max-w-sm mx-auto">
              Add your first property to start managing rentals, maintenance, and more.
            </p>
            <.link
              navigate={~p"/properties/new"}
              class="inline-flex items-center px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg gap-2 transition-colors"
            >
              <.icon name="hero-plus" class="w-5 h-5" /> Add First Property
            </.link>
          </div>
        <% else %>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for property <- @properties do %>
              <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow border border-gray-100 dark:border-gray-700">
                <!-- Property Image -->
                <div class="h-48 bg-gray-100 dark:bg-gray-900 relative">
                  <%= if List.first(property.images) do %>
                    <img
                      src={
                        List.first(property.images).medium_url || List.first(property.images).s3_key
                      }
                      class="w-full h-full object-cover"
                    />
                  <% else %>
                    <div class="w-full h-full flex items-center justify-center text-gray-400">
                      <.icon name="hero-photo" class="w-12 h-12" />
                    </div>
                  <% end %>

                  <div class="absolute top-2 right-2 px-2 py-1 bg-black/50 backdrop-blur-sm rounded-lg text-white text-xs font-medium">
                    {String.capitalize(property.status)}
                  </div>
                </div>
                
    <!-- Content -->
                <div class="p-4">
                  <div class="flex justify-between items-start mb-2">
                    <h3 class="text-lg font-semibold text-gray-900 dark:text-white truncate">
                      {property.project_name || "Unnamed Property"}
                    </h3>
                  </div>

                  <div class="flex items-center gap-2 text-gray-500 text-sm mb-4">
                    <.icon name="hero-map-pin" class="w-4 h-4" />
                    <span class="truncate">
                      {property.locality.name}, {property.city.name}
                    </span>
                  </div>

                  <div class="flex items-center gap-4 text-sm text-gray-600 dark:text-gray-400 border-t border-gray-100 dark:border-gray-700 pt-4">
                    <div class="flex items-center gap-1">
                      <.icon name="hero-home" class="w-4 h-4" />
                      <span>{String.capitalize(property.type)}</span>
                    </div>
                    <%= if property.configuration["bhk"] do %>
                      <div class="flex items-center gap-1">
                        <.icon name="hero-square-2-stack" class="w-4 h-4" />
                        <span>{property.configuration["bhk"]} BHK</span>
                      </div>
                    <% end %>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end
end
