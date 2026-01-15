defmodule MySqrftWeb.Live.Components.SpinnerLive do
  @moduledoc """
  LiveView showcasing Spinner component variations.
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
          <h1 class="text-4xl font-bold mb-2">Spinner Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all spinner variations, colors, and sizes
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="flex flex-wrap gap-6">
              <div :for={color <- @colors} class="flex flex-col items-center gap-2">
                <.spinner color={color} />
                <span class="text-sm">{String.capitalize(color)}</span>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="flex flex-wrap items-center gap-6">
              <div :for={size <- @sizes} class="flex flex-col items-center gap-2">
                <.spinner size={size} color="primary" />
                <span class="text-sm">
                  {String.replace(size, "_", " ") |> String.capitalize()}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
