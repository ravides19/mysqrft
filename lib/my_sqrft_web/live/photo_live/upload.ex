defmodule MySqrftWeb.PhotoLive.Upload do
  @moduledoc """
  LiveView for uploading profile photos.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        photos = UserManagement.list_profile_photos(profile)

        socket =
          socket
          |> assign(:page_title, "Profile Photos")
          |> assign(:profile, profile)
          |> assign(:photos, photos)
          |> allow_upload(:photo,
            accept: ~w(.jpg .jpeg .png .webp),
            max_entries: 1,
            max_file_size: 5_000_000
          )

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
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  def handle_event("save", _params, socket) do
    case consume_uploaded_entries(socket, :photo, fn %{path: path}, entry ->
           dest_dir = Path.join(:code.priv_dir(:my_sqrft), "static/uploads")
           # Ensure directory exists
           File.mkdir_p!(dest_dir)
           filename = "#{entry.uuid}-#{entry.client_name}"
           dest_path = Path.join(dest_dir, filename)

           IO.inspect(path, label: "Temp File Path")
           IO.inspect(dest_path, label: "Destination Path")
           File.cp!(path, dest_path)

           url = "/uploads/#{filename}"

           {:ok,
            %{
              original_url: url,
              thumbnail_url: url,
              medium_url: url,
              large_url: url
            }}
         end) do
      {[], []} ->
        {:noreply,
         socket
         |> put_flash(:error, "Please select a photo to upload")
         |> assign(:photos, UserManagement.list_profile_photos(socket.assigns.profile))}

      {urls, []} ->
        [url_data | _] = urls
        IO.inspect(url_data, label: "URL Data")

        attrs =
          Map.merge(url_data, %{
            is_current: true,
            moderation_status: "pending"
          })

        case UserManagement.create_profile_photo(socket.assigns.profile, attrs) do
          {:ok, photo} ->
            IO.inspect(photo, label: "Created Photo")
            photos = UserManagement.list_profile_photos(socket.assigns.profile)
            IO.inspect(length(photos), label: "Photo Count")

            {:noreply,
             socket
             |> put_flash(:info, "Photo uploaded successfully")
             |> assign(:photos, photos)}

          {:error, changeset} ->
            IO.inspect(changeset, label: "Create Error")

            {:noreply,
             socket
             |> put_flash(:error, "Failed to save photo")
             |> assign(:photos, UserManagement.list_profile_photos(socket.assigns.profile))}
        end

      {_urls, errors} ->
        error_msg = Enum.map_join(errors, ", ", fn {entry, _error} -> entry.client_name end)

        {:noreply,
         socket
         |> put_flash(:error, "Failed to upload: #{error_msg}")
         |> assign(:photos, UserManagement.list_profile_photos(socket.assigns.profile))}
    end
  end

  def handle_event("set-current", %{"id" => id}, socket) do
    photo = UserManagement.get_profile_photo!(id)
    {:ok, _} = UserManagement.set_current_photo(photo)
    photos = UserManagement.list_profile_photos(socket.assigns.profile)

    {:noreply,
     socket
     |> put_flash(:info, "Photo set as current")
     |> assign(:photos, photos)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    photo = UserManagement.get_profile_photo!(id)
    {:ok, _} = UserManagement.delete_profile_photo(photo)
    photos = UserManagement.list_profile_photos(socket.assigns.profile)

    {:noreply,
     socket
     |> put_flash(:info, "Photo deleted successfully")
     |> assign(:photos, photos)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto space-y-8">
          <div>
            <.link
              navigate={~p"/profile"}
              class="flex items-center text-sm text-gray-600 hover:text-gray-900"
            >
              <.icon name="hero-arrow-left" class="w-4 h-4 mr-1" /> Back to Profile
            </.link>
          </div>
          <.card title="Upload New Photo" padding="medium">
            <form phx-submit="save" phx-change="validate" id="photo-upload-form">
              <div class="flex items-center justify-center w-full mb-6">
                <label
                  for={@uploads.photo.ref}
                  class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 relative overflow-hidden"
                >
                  <%= if length(@uploads.photo.entries) > 0 do %>
                    <%= for entry <- @uploads.photo.entries do %>
                      <.live_img_preview entry={entry} class="w-full h-full object-contain" />
                    <% end %>
                  <% else %>
                    <div class="flex flex-col items-center justify-center pt-5 pb-6">
                      <.icon name="hero-cloud-arrow-up" class="w-10 h-10 mb-3 text-gray-400" />
                      <p class="mb-2 text-sm text-gray-500">
                        <span class="font-semibold">Click to upload</span> or drag and drop
                      </p>
                      <p class="text-xs text-gray-500">SVG, PNG, JPG or GIF (MAX. 5MB)</p>
                    </div>
                  <% end %>
                  <.live_file_input upload={@uploads.photo} class="hidden" />
                </label>
              </div>

              <%= for entry <- @uploads.photo.entries do %>
                <div class="mb-6">
                  <div class="flex items-center gap-4 mb-2">
                    <span class="text-sm font-medium text-gray-700 truncate flex-1">
                      {entry.client_name}
                    </span>
                    <.button
                      type="button"
                      phx-click="cancel-entry"
                      phx-value-ref={entry.ref}
                      variant="ghost"
                      color="danger"
                      size="small"
                    >
                      Cancel
                    </.button>
                  </div>
                  <.progress value={entry.progress} color="primary" size="medium" />
                  <%= for err <- upload_errors(@uploads.photo, entry) do %>
                    <p class="text-sm text-red-600 mt-1">{error_to_string(err)}</p>
                  <% end %>
                </div>
              <% end %>

              <div class="flex justify-end">
                <.button
                  type="submit"
                  variant="primary"
                  phx-disable-with="Uploading..."
                  disabled={length(@uploads.photo.entries) == 0}
                >
                  Upload Photo
                </.button>
              </div>
            </form>
          </.card>

          <.card title="Your Photos" padding="medium">
            <%= if length(@photos) > 0 do %>
              <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
                <%= for photo <- @photos do %>
                  <div class="relative group">
                    <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden border border-gray-200">
                      <.avatar
                        src={photo.thumbnail_url || photo.original_url}
                        size="full"
                        rounded="none"
                        class="w-full h-full object-cover"
                      />
                    </div>

                    <div class="absolute top-2 right-2">
                      <%= if photo.is_current do %>
                        <.badge color="primary" variant="default" size="small">Current</.badge>
                      <% end %>
                    </div>

                    <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-2">
                      <%= unless photo.is_current do %>
                        <.button
                          phx-click="set-current"
                          phx-value-id={photo.id}
                          variant="secondary"
                          size="small"
                        >
                          Set Current
                        </.button>
                      <% end %>
                      <.button
                        phx-click="delete"
                        phx-value-id={photo.id}
                        data-confirm="Are you sure you want to delete this photo?"
                        variant="danger"
                        size="small"
                        icon="hero-trash"
                      />
                    </div>
                  </div>
                <% end %>
              </div>
            <% else %>
              <div class="text-center py-12">
                <.icon name="hero-photo" class="mx-auto h-12 w-12 text-gray-300" />
                <h3 class="mt-2 text-sm font-semibold text-gray-900">No photos</h3>
                <p class="mt-1 text-sm text-gray-500">Get started by uploading a new photo.</p>
              </div>
            <% end %>
          </.card>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp error_to_string(:too_large), do: "File is too large (max 5MB)"
  defp error_to_string(:too_many_files), do: "Too many files"

  defp error_to_string(:not_accepted),
    do: "Invalid file type. Only JPG, PNG, and WebP are allowed"

  defp error_to_string(error), do: "Upload error: #{inspect(error)}"
end
