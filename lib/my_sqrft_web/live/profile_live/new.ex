defmodule MySqrftWeb.ProfileLive.New do
  @moduledoc """
  LiveView for creating a new user profile.
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement
  alias MySqrft.UserManagement.Profile

  @impl true
  def mount(_params, _session, socket) do
    current_scope = socket.assigns.current_scope

    if current_scope && current_scope.user do
      # Check if profile already exists
      existing_profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

      if existing_profile do
        {:ok, push_navigate(socket, to: ~p"/profile")}
      else
        user = current_scope.user

        attrs = %{
          user_id: user.id,
          display_name: "#{user.firstname} #{user.lastname}",
          first_name: user.firstname,
          last_name: user.lastname,
          email: user.email,
          phone: user.mobile_number,
          status: "active"
        }

        changeset = Profile.changeset(%Profile{}, attrs)

        socket =
          socket
          |> assign(:page_title, "Create Profile")
          |> assign(:form, to_form(changeset))

        {:ok, socket}
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
      %Profile{}
      |> Profile.changeset(profile_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"profile" => profile_params}, socket) do
    current_scope = socket.assigns.current_scope
    # Normalize empty strings for optional fields
    profile_params = normalize_params(profile_params)
    profile_params = Map.put(profile_params, "user_id", current_scope.user.id)

    case UserManagement.create_profile(profile_params) do
      {:ok, _profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile created successfully")
         |> push_navigate(to: ~p"/profile")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp normalize_params(params) do
    params
    |> maybe_normalize("gender")
    |> maybe_normalize("bio")
  end

  defp maybe_normalize(params, key) do
    case Map.get(params, key) do
      "" -> Map.put(params, key, nil)
      _ -> params
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-2xl mx-auto">
          <h1 class="text-3xl font-bold mb-6">Create Your Profile</h1>

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
                      {"male", "Male"},
                      {"female", "Female"},
                      {"other", "Other"},
                      {"prefer_not_to_say", "Prefer not to say"}
                    ]}
                  />
                </div>
              </div>

              <div class="flex gap-4">
                <.button type="submit" variant="primary" phx-disable-with="Creating...">
                  Create Profile
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
