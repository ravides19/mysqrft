defmodule MySqrftWeb.ProfileLive.Edit do
  @moduledoc """
  LiveView for editing user profile.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement
  alias MySqrft.UserManagement.Profile

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if profile do
        changeset = Profile.changeset(profile, %{})

        socket =
          socket
          |> assign(:page_title, "Edit Profile")
          |> assign(:profile, profile)
          |> assign(:form, to_form(changeset))

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
  def handle_event("validate", %{"profile" => profile_params}, socket) do
    # Normalize empty strings for optional fields before validation
    profile_params = normalize_params(profile_params)

    changeset =
      socket.assigns.profile
      |> Profile.changeset(profile_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"profile" => profile_params}, socket) do
    case UserManagement.update_profile(socket.assigns.profile, profile_params) do
      {:ok, _profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully")
         |> push_navigate(to: ~p"/profile")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp normalize_params(params) do
    Enum.reduce(params, params, fn {key, value}, acc ->
      if key in ["gender", "bio"] and value == "" do
        Map.put(acc, key, nil)
      else
        acc
      end
    end)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-2xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">Edit Profile</h1>

          <.form for={@form} phx-submit="save" phx-change="validate" id="profile-form">
            <div class="bg-white rounded-lg shadow p-6 space-y-6">
              <div>
                <.input
                  field={@form[:display_name]}
                  type="text"
                  label="Display Name"
                  required
                />
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <.input
                    field={@form[:first_name]}
                    type="text"
                    label="First Name"
                    required
                  />
                </div>
                <div>
                  <.input
                    field={@form[:last_name]}
                    type="text"
                    label="Last Name"
                    required
                  />
                </div>
              </div>

              <div>
                <.input
                  field={@form[:email]}
                  type="email"
                  label="Email"
                  required
                />
              </div>

              <div>
                <.input
                  field={@form[:phone]}
                  type="tel"
                  label="Phone"
                  placeholder="+1234567890"
                  required
                />
              </div>

              <div>
                <.input
                  field={@form[:bio]}
                  type="textarea"
                  label="Bio"
                  rows={4}
                />
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <.input
                    field={@form[:date_of_birth]}
                    type="date"
                    label="Date of Birth"
                  />
                </div>
                <div>
                  <.input
                    field={@form[:gender]}
                    type="select"
                    label="Gender"
                    prompt="Select..."
                    options={[
                      {"Male", "male"},
                      {"Female", "female"},
                      {"Other", "other"},
                      {"Prefer not to say", "prefer_not_to_say"}
                    ]}
                  />
                </div>
              </div>

              <div class="flex gap-4">
                <.button type="submit" variant="primary" phx-disable-with="Saving...">
                  Save Changes
                </.button>
                <.link
                  navigate={~p"/profile"}
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
end
