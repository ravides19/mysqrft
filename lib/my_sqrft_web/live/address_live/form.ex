defmodule MySqrftWeb.AddressLive.Form do
  @moduledoc """
  LiveView component for address form (used for both new and edit).
  """
  use MySqrftWeb, :live_view

  alias MySqrft.UserManagement
  alias MySqrft.UserManagement.Address

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

    changeset = Address.changeset(%Address{}, %{user_profile_id: profile.id})

    socket
    |> assign(:page_title, "Add Address")
    |> assign(:profile, profile)
    |> assign(:address, nil)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    address = UserManagement.get_address!(id)
    changeset = Address.changeset(address, %{})

    socket
    |> assign(:page_title, "Edit Address")
    |> assign(:address, address)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"address" => address_params}, socket) do
    changeset =
      (socket.assigns.address || %Address{})
      |> Address.changeset(address_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"address" => address_params}, socket) do
    save_address(socket, socket.assigns.live_action, address_params)
  end

  defp save_address(socket, :edit, address_params) do
    case UserManagement.update_address(socket.assigns.address, address_params) do
      {:ok, _address} ->
        {:noreply,
         socket
         |> put_flash(:info, "Address updated successfully")
         |> push_navigate(to: ~p"/addresses")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_address(socket, :new, address_params) do
    case UserManagement.create_address(socket.assigns.profile, address_params) do
      {:ok, _address} ->
        {:noreply,
         socket
         |> put_flash(:info, "Address created successfully")
         |> push_navigate(to: ~p"/addresses")}

      {:error, :address_limit_reached} ->
        {:noreply,
         socket
         |> put_flash(:error, "You can only have up to 5 addresses")
         |> push_navigate(to: ~p"/addresses")}

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
          <h1 class="text-3xl font-bold mb-6">{@page_title}</h1>

          <.form for={@form} phx-submit="save" phx-change="validate" id="address-form">
            <div class="bg-white rounded-lg shadow p-6 space-y-6">
              <div>
                <.input
                  field={@form[:label]}
                  type="text"
                  label="Address Label (Optional)"
                  placeholder="e.g. Main Office, Mom's House"
                />
              </div>

              <div>
                <.input
                  field={@form[:type]}
                  type="select"
                  label="Address Type"
                  options={[
                    {"Home", "home"},
                    {"Work", "work"},
                    {"Other", "other"}
                  ]}
                  required
                />
              </div>

              <div>
                <.input
                  field={@form[:line1]}
                  type="text"
                  label="Address Line 1"
                  required
                />
              </div>

              <div>
                <.input
                  field={@form[:line2]}
                  type="text"
                  label="Address Line 2"
                />
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <.input
                    field={@form[:locality]}
                    type="text"
                    label="Locality"
                  />
                </div>
                <div>
                  <.input
                    field={@form[:city]}
                    type="text"
                    label="City"
                    required
                  />
                </div>
              </div>

              <div>
                <.input
                  field={@form[:landmark]}
                  type="text"
                  label="Landmark"
                />
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <.input
                    field={@form[:state]}
                    type="text"
                    label="State"
                    required
                  />
                </div>
                <div>
                  <.input
                    field={@form[:pin_code]}
                    type="text"
                    label="PIN Code"
                    required
                  />
                </div>
              </div>

              <div>
                <.input
                  field={@form[:country]}
                  type="text"
                  label="Country"
                  value={@form[:country].value || "IN"}
                  required
                />
              </div>

              <div>
                <.input
                  field={@form[:is_primary]}
                  type="checkbox"
                  label="Set as primary address"
                />
              </div>

              <div class="flex gap-4">
                <.button type="submit" variant="primary" phx-disable-with="Saving...">
                  Save Address
                </.button>
                <.link
                  navigate={~p"/addresses"}
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
