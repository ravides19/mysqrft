defmodule MySqrftWeb.Live.Components.ProgressLive do
  @moduledoc """
  LiveView showcasing Progress component variations.
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
          <h1 class="text-4xl font-bold mb-2">Progress Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all progress bar variations, colors, and sizes
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="space-y-4">
              <div :for={color <- @colors}>
                <.progress color={color} value={50} />
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="space-y-4">
              <div :for={size <- @sizes}>
                <.progress size={size} color="primary" value={50} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
