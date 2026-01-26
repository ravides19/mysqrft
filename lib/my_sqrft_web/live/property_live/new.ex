defmodule MySqrftWeb.PropertyLive.New do
  use MySqrftWeb, :live_view

  alias MySqrft.Geography
  alias MySqrft.Properties
  alias MySqrft.Properties.Property
  alias MySqrft.UserManagement
  alias MySqrft.Media.ImageProcessor

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      changeset = MySqrft.Properties.change_property(%Property{})

      {:ok,
       socket
       |> assign(:profile, profile)
       # 1: Location, 2: Details, 3: Photos
       |> assign(:step, 1)
       |> assign(:changeset, changeset)
       |> assign(:property_params, %{})
       |> assign(:selected_locality, nil)
       |> assign(:search_query, "")
       |> assign(:search_results, [])
       |> allow_upload(:photos, accept: ~w(.jpg .jpeg .png .webp), max_entries: 5)}
    else
      {:ok, push_navigate(socket, to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("search_location", %{"query" => query}, socket) do
    # Search for localities in the default city (assume Bangalore for limited scope or user's city)
    # Ideally should allow selecting city first. For MVP, we search across localities.
    # We need a city_id. Let's fetch Bangalore's city_id for now or improve this.
    # For now, let's just return empty if query is short.

    if String.length(query) > 2 do
      # TODO: fetch city_id dynamically. Assuming first city for now.
      city = MySqrft.Repo.one(MySqrft.Geography.City)

      results =
        if city do
          Geography.get_localities_by_name(city.id, query)
        else
          []
        end

      {:noreply, assign(socket, search_query: query, search_results: results)}
    else
      {:noreply, assign(socket, search_query: query, search_results: [])}
    end
  end

  def handle_event("select_locality", %{"id" => id}, socket) do
    locality = Geography.get_locality_with_hierarchy!(id)

    {:noreply,
     socket
     |> assign(:selected_locality, locality)
     |> assign(
       :property_params,
       Map.merge(socket.assigns.property_params, %{
         "locality_id" => locality.id,
         "city_id" => locality.city_id,
         "address_text" => "#{locality.name}, #{locality.city.name}, #{locality.city.state.name}"
       })
     )
     |> assign(:step, 2)}
  end

  def handle_event("validate_details", %{"property" => params}, socket) do
    # Validate step 2 details
    params = Map.merge(socket.assigns.property_params, params)

    changeset =
      %Property{}
      |> MySqrft.Properties.change_property(params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:property_params, params)}
  end

  def handle_event("next_step", %{"property" => params}, socket) do
    params = Map.merge(socket.assigns.property_params, params)
    {:noreply, assign(socket, property_params: params, step: 3)}
  end

  def handle_event("save_property", _params, socket) do
    # 1. Create Property
    case Properties.create_property(socket.assigns.profile, socket.assigns.property_params) do
      {:ok, property} ->
        # 2. Consume Uploads and Create Images
        consume_uploaded_entries(socket, :photos, fn %{path: path}, entry ->
          # Upload logic (reuse from PhotoLive)
          base_key = "properties/#{property.id}/#{entry.uuid}"
          ext = Path.extname(entry.client_name)

          case ImageProcessor.process_photo(path, base_key) do
            {:ok, keys} ->
              # Upload original
              {:ok, file_content} = File.read(path)

              MySqrft.ObjectStorage.put_object(base_key <> ext, file_content,
                content_type: entry.client_type
              )

              # Create PropertyImage record
              Properties.create_property_image(property, %{
                # Actually storing original key base, will rely on schema virtuals later or just store main key
                s3_key: keys.original,
                type: "interior",
                is_primary: false
              })

              {:ok, keys}

            _ ->
              {:error, "Failed"}
          end
        end)

        {:noreply,
         socket
         |> put_flash(:info, "Property created successfully")
         |> push_navigate(to: ~p"/properties")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  def handle_event("set_step", %{"step" => step}, socket) do
    {:noreply, assign(socket, step: String.to_integer(step))}
  end

  def handle_event("validate_photos", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-3xl mx-auto px-4 py-12">
        <!-- Progress Steps -->
        <div class="mb-8">
          <div class="flex items-center justify-between relative">
            <div class="absolute left-0 top-1/2 -z-10 w-full h-0.5 bg-gray-200 dark:bg-gray-700">
            </div>

            <div class={"flex flex-col items-center gap-2 bg-white dark:bg-gray-900 px-2 " <> if(@step >= 1, do: "text-primary-600", else: "text-gray-400")}>
              <div class={"w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold border-2 " <> if(@step >= 1, do: "border-primary-600 bg-primary-50", else: "border-gray-300 bg-white")}>
                1
              </div>
              <span class="text-sm font-medium">Location</span>
            </div>

            <div class={"flex flex-col items-center gap-2 bg-white dark:bg-gray-900 px-2 " <> if(@step >= 2, do: "text-primary-600", else: "text-gray-400")}>
              <div class={"w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold border-2 " <> if(@step >= 2, do: "border-primary-600 bg-primary-50", else: "border-gray-300 bg-white")}>
                2
              </div>
              <span class="text-sm font-medium">Details</span>
            </div>

            <div class={"flex flex-col items-center gap-2 bg-white dark:bg-gray-900 px-2 " <> if(@step >= 3, do: "text-primary-600", else: "text-gray-400")}>
              <div class={"w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold border-2 " <> if(@step >= 3, do: "border-primary-600 bg-primary-50", else: "border-gray-300 bg-white")}>
                3
              </div>
              <span class="text-sm font-medium">Photos</span>
            </div>
          </div>
        </div>

        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 p-8">
          
    <!-- STEP 1: LOCATION -->
          <%= if @step == 1 do %>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">
              Where is your property?
            </h2>

            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Search Locality
                </label>
                <form
                  phx-change="search_location"
                  phx-submit="prevent_default"
                  onsubmit="return false;"
                >
                  <input
                    type="text"
                    name="query"
                    value={@search_query}
                    placeholder="Enter locality (e.g. Koramangala)"
                    class="w-full rounded-lg border-gray-300 dark:border-gray-600 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-900 dark:text-white"
                    autocomplete="off"
                  />
                </form>
              </div>

              <%= if length(@search_results) > 0 do %>
                <div class="border rounded-lg divide-y divide-gray-100 dark:divide-gray-700 border-gray-200 dark:border-gray-700">
                  <%= for locality <- @search_results do %>
                    <button
                      phx-click="select_locality"
                      phx-value-id={locality.id}
                      class="w-full text-left px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors flex items-center justify-between group"
                    >
                      <span>{locality.name}</span>
                      <.icon
                        name="hero-chevron-right"
                        class="w-4 h-4 text-gray-400 group-hover:text-primary-500"
                      />
                    </button>
                  <% end %>
                </div>
              <% end %>
            </div>
          <% end %>
          
    <!-- STEP 2: DETAILS -->
          <%= if @step == 2 do %>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">Property Details</h2>
            <div class="mb-6 p-4 bg-primary-50 dark:bg-primary-900/10 rounded-lg flex items-center justify-between">
              <div>
                <span class="text-xs font-bold text-primary-600 dark:text-primary-400 uppercase tracking-wider">
                  Selected Location
                </span>
                <p class="font-medium text-gray-900 dark:text-white">{@selected_locality.name}</p>
              </div>
              <button
                phx-click="set_step"
                phx-value-step="1"
                class="text-sm text-primary-600 hover:text-primary-700 font-medium"
              >
                Change
              </button>
            </div>

            <.form
              :let={f}
              for={@changeset}
              phx-change="validate_details"
              phx-submit="next_step"
              class="space-y-6"
            >
              <div>
                <.input
                  field={f[:project_name]}
                  type="text"
                  label="Project / Building Name"
                  placeholder="e.g. Sobha City"
                />
              </div>

              <div class="grid grid-cols-2 gap-4">
                <.input
                  field={f[:type]}
                  type="select"
                  label="Property Type"
                  options={[
                    {"Apartment", "apartment"},
                    {"Villa", "villa"},
                    {"Independent House", "independent_house"},
                    {"Plot", "plot"}
                  ]}
                />

                <.input
                  field={f[:status]}
                  type="select"
                  label="Status"
                  options={[
                    {"Active", "active"},
                    {"Draft", "draft"}
                  ]}
                />
              </div>
              
    <!-- Configuration Map Fields (Simplified for MVP) -->
              <h3 class="font-medium text-gray-900 dark:text-white pt-4">Configuration</h3>
              <div class="grid grid-cols-2 gap-4">
                <div class="space-y-2">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    BHK
                  </label>
                  <input
                    type="number"
                    name="property[configuration][bhk]"
                    value={@property_params["configuration"]["bhk"]}
                    class="block w-full rounded-lg border-gray-300 dark:border-gray-600 shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm dark:bg-zinc-900 dark:text-zinc-200"
                  />
                </div>
                <div class="space-y-2">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    Bathrooms
                  </label>
                  <input
                    type="number"
                    name="property[configuration][bathrooms]"
                    value={@property_params["configuration"]["bathrooms"]}
                    class="block w-full rounded-lg border-gray-300 dark:border-gray-600 shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm dark:bg-zinc-900 dark:text-zinc-200"
                  />
                </div>
              </div>

              <div class="flex justify-end pt-6">
                <.button type="submit" phx-disable-with="Validation...">Next: Photos</.button>
              </div>
            </.form>
          <% end %>
          
    <!-- STEP 3: PHOTOS -->
          <%= if @step == 3 do %>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6">Add Photos</h2>

            <form phx-submit="save_property" phx-change="validate_photos">
              <div class="flex items-center justify-center w-full mb-6">
                <label
                  for={@uploads.photos.ref}
                  class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
                >
                  <div class="flex flex-col items-center justify-center pt-5 pb-6">
                    <.icon name="hero-cloud-arrow-up" class="w-10 h-10 mb-3 text-gray-400" />
                    <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
                      <span class="font-semibold">Click to upload</span> or drag and drop
                    </p>
                    <p class="text-xs text-gray-500 dark:text-gray-400">
                      PNG, JPG or WEBP (MAX. 5 files)
                    </p>
                  </div>
                  <.live_file_input upload={@uploads.photos} class="hidden" />
                </label>
              </div>
              
    <!-- Previews -->
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <%= for entry <- @uploads.photos.entries do %>
                  <div class="relative group">
                    <.live_img_preview entry={entry} class="h-24 w-full object-cover rounded-lg" />
                    <button
                      type="button"
                      phx-click="cancel-upload"
                      phx-value-ref={entry.ref}
                      class="absolute top-1 right-1 p-1 bg-red-500 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
                    >
                      <.icon name="hero-x-mark" class="w-3 h-3" />
                    </button>
                    <!-- Progress Bar -->
                    <div class="absolute bottom-0 left-0 w-full h-1 bg-gray-200 rounded-b-lg overflow-hidden">
                      <div
                        class="h-full bg-primary-600 transition-all duration-300"
                        style={"width: #{entry.progress}%"}
                      >
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>

              <div class="flex justify-between pt-6">
                <button
                  type="button"
                  phx-click="set_step"
                  phx-value-step="2"
                  class="text-gray-600 hover:text-gray-900 font-medium"
                >
                  Back
                </button>
                <.button type="submit" phx-disable-with="Creating...">Create Property</.button>
              </div>
            </form>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
