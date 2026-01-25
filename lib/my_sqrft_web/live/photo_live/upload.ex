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
    case consume_uploaded_entries(socket, :photo, fn %{path: _path}, entry ->
           # In a real implementation, this would upload to S3/CDN
           # For now, we'll create a placeholder URL
           filename = "#{entry.uuid}-#{entry.client_name}"
           # TODO: Upload to S3/CDN and get URLs
           # For now, using placeholder URLs
           original_url = "/uploads/#{filename}"
           thumbnail_url = "/uploads/thumbnails/#{filename}"
           medium_url = "/uploads/medium/#{filename}"
           large_url = "/uploads/large/#{filename}"

           {:ok,
            %{
              original_url: original_url,
              thumbnail_url: thumbnail_url,
              medium_url: medium_url,
              large_url: large_url
            }}
         end) do
      {[], []} ->
        {:noreply,
         socket
         |> put_flash(:error, "Please select a photo to upload")
         |> assign(:photos, UserManagement.list_profile_photos(socket.assigns.profile))}

      {urls, []} ->
        [url_data | _] = urls

        attrs =
          Map.merge(url_data, %{
            is_current: true,
            moderation_status: "pending"
          })

        case UserManagement.create_profile_photo(socket.assigns.profile, attrs) do
          {:ok, _photo} ->
            photos = UserManagement.list_profile_photos(socket.assigns.profile)

            {:noreply,
             socket
             |> put_flash(:info, "Photo uploaded successfully")
             |> assign(:photos, photos)}

          {:error, _changeset} ->
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
        <div class="max-w-4xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">Profile Photos</h1>

          <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-xl font-semibold mb-4">Upload New Photo</h2>
            <form phx-submit="save" phx-change="validate" id="photo-upload-form">
              <.live_file_input upload={@uploads.photo} class="mb-4" />
              <%= for entry <- @uploads.photo.entries do %>
                <div class="mb-4">
                  <div class="flex items-center gap-4">
                    <div class="flex-1">
                      <p class="text-sm text-gray-600">{entry.client_name}</p>
                      <progress value={entry.progress} max="100" class="w-full mt-2">
                        {entry.progress}%
                      </progress>
                    </div>
                    <button
                      type="button"
                      phx-click="cancel-entry"
                      phx-value-ref={entry.ref}
                      class="px-3 py-1 text-sm border border-red-300 text-red-600 rounded hover:bg-red-50"
                    >
                      Cancel
                    </button>
                  </div>
                  <%= for err <- upload_errors(@uploads.photo, entry) do %>
                    <p class="text-sm text-red-600 mt-1">{error_to_string(err)}</p>
                  <% end %>
                </div>
              <% end %>
              <button
                type="submit"
                class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                phx-disable-with="Uploading..."
              >
                Upload Photo
              </button>
            </form>
          </div>

          <%= if length(@photos) > 0 do %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <%= for photo <- @photos do %>
                <div class="bg-white rounded-lg shadow p-4">
                  <div class="aspect-square bg-gray-200 rounded mb-4 flex items-center justify-center">
                    <%= if photo.thumbnail_url do %>
                      <img
                        src={photo.thumbnail_url}
                        alt="Profile photo"
                        class="w-full h-full object-cover rounded"
                      />
                    <% else %>
                      <span class="text-gray-400">No image</span>
                    <% end %>
                  </div>
                  <div class="flex gap-2">
                    <%= if photo.is_current do %>
                      <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-medium">
                        Current
                      </span>
                    <% else %>
                      <button
                        phx-click="set-current"
                        phx-value-id={photo.id}
                        class="px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-50"
                      >
                        Set as Current
                      </button>
                    <% end %>
                    <button
                      phx-click="delete"
                      phx-value-id={photo.id}
                      data-confirm="Are you sure you want to delete this photo?"
                      class="px-3 py-1 text-sm border border-red-300 text-red-600 rounded hover:bg-red-50"
                    >
                      Delete
                    </button>
                  </div>
                  <p class="text-xs text-gray-500 mt-2">
                    Status: {String.capitalize(photo.moderation_status)}
                  </p>
                </div>
              <% end %>
            </div>
          <% else %>
            <div class="bg-white rounded-lg shadow p-6 text-center">
              <p class="text-gray-600">You don't have any photos yet. Upload one above!</p>
            </div>
          <% end %>
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
