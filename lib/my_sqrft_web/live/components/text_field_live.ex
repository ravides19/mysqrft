defmodule MySqrftWeb.Live.Components.TextFieldLive do
  @moduledoc """
  LiveView showcasing TextField component variations.
  """
  use MySqrftWeb, :live_view
  alias MySqrftWeb.Live.Components.ComponentHelpers

  @impl true
  def mount(_params, _session, socket) do
    config = ComponentHelpers.load_config()

    {:ok,
     assign(socket,
       colors: config.colors,
       sizes: config.sizes
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Text Field Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all text field variations, colors, and sizes
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="space-y-3 max-w-md">
              <div :for={color <- @colors}>
                <.text_field
                  name={"field_#{color}"}
                  value=""
                  label={String.capitalize(color) <> " Input"}
                  color={color}
                  placeholder="Enter text..."
                />
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="space-y-3 max-w-md">
              <div :for={size <- @sizes}>
                <.text_field
                  name={"field_#{size}"}
                  value=""
                  label={String.replace(size, "_", " ") |> String.capitalize() |> Kernel.<>(" Input")}
                  size={size}
                  placeholder="Enter text..."
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
