defmodule MySqrftWeb.EmergencyContactLive.Form do
  @moduledoc """
  LiveView component for emergency contact form (used for both new and edit).
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement
  alias MySqrft.UserManagement.EmergencyContact

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    current_scope = socket.assigns.current_scope
    profile = UserManagement.get_profile_by_user_id(current_scope.user.id)

    changeset = EmergencyContact.changeset(%EmergencyContact{}, %{user_profile_id: profile.id})

    socket
    |> assign(:page_title, "Add Emergency Contact")
    |> assign(:profile, profile)
    |> assign(:contact, nil)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    contact = UserManagement.get_emergency_contact!(id)
    changeset = EmergencyContact.changeset(contact, %{})

    socket
    |> assign(:page_title, "Edit Emergency Contact")
    |> assign(:contact, contact)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"emergency_contact" => contact_params}, socket) do
    changeset =
      (socket.assigns.contact || %EmergencyContact{})
      |> EmergencyContact.changeset(contact_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"emergency_contact" => contact_params}, socket) do
    save_contact(socket, socket.assigns.live_action, contact_params)
  end

  defp save_contact(socket, :edit, contact_params) do
    case UserManagement.update_emergency_contact(socket.assigns.contact, contact_params) do
      {:ok, _contact} ->
        {:noreply,
         socket
         |> put_flash(:info, "Emergency contact updated successfully")
         |> push_navigate(to: ~p"/emergency-contacts")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_contact(socket, :new, contact_params) do
    case UserManagement.create_emergency_contact(socket.assigns.profile, contact_params) do
      {:ok, _contact} ->
        {:noreply,
         socket
         |> put_flash(:info, "Emergency contact created successfully")
         |> push_navigate(to: ~p"/emergency-contacts")}

      {:error, :emergency_contact_limit_reached} ->
        {:noreply,
         socket
         |> put_flash(:error, "You can only have up to 3 emergency contacts")
         |> push_navigate(to: ~p"/emergency-contacts")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto px-4 py-8">
        <div class="max-w-2xl mx-auto">
          <h1 class="text-3xl font-bold mb-6"><%= @page_title %></h1>

          <.form for={@form} phx-submit="save" phx-change="validate" id="emergency-contact-form">
            <div class="bg-white rounded-lg shadow p-6 space-y-6">
              <div>
                <.input
                  field={@form[:name]}
                  type="text"
                  label="Name"
                  required
                />
              </div>

              <div>
                <.input
                  field={@form[:relationship]}
                  type="text"
                  label="Relationship"
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
                  field={@form[:email]}
                  type="email"
                  label="Email (Optional)"
                />
              </div>

              <div>
                <.input
                  field={@form[:priority]}
                  type="number"
                  label="Priority (1-3)"
                  min="1"
                  max="3"
                  value={@form[:priority].value || 1}
                />
              </div>

              <div class="flex gap-4">
                <.button type="submit" variant="primary" phx-disable-with="Saving...">
                  Save Contact
                </.button>
                <.link
                  navigate={~p"/emergency-contacts"}
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
