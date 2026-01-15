defmodule MySqrftWeb.Live.Components.CheckboxFieldLive do
  @moduledoc """
  LiveView showcasing CheckboxField component variations.
  """
  use MySqrftWeb, :live_view
  alias MySqrftWeb.Live.Components.ComponentHelpers

  @impl true
  def mount(_params, _session, socket) do
    config = ComponentHelpers.load_config()
    {:ok, assign(socket, colors: config.colors)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Checkbox Field Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all checkbox field variations and colors
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="space-y-3 max-w-md">
              <div :for={color <- @colors}>
                <.checkbox_field
                  name={"checkbox_#{color}"}
                  label={String.capitalize(color) <> " Checkbox"}
                  color={color}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
