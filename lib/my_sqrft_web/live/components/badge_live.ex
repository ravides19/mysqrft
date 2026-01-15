defmodule MySqrftWeb.Live.Components.BadgeLive do
  @moduledoc """
  LiveView showcasing Badge component variations.
  """
  use MySqrftWeb, :live_view
  alias MySqrftWeb.Live.Components.ComponentHelpers

  @impl true
  def mount(_params, _session, socket) do
    config = ComponentHelpers.load_config()

    {:ok,
     assign(socket,
       colors: config.colors,
       variants: config.variants,
       sizes: config.sizes
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Badge Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all badge variations, colors, sizes, and styles
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="flex flex-wrap gap-3">
              <div :for={color <- @colors}>
                <.badge color={color}>{String.capitalize(color)}</.badge>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Variants</h2>
            <div class="flex flex-wrap gap-3">
              <div :for={variant <- @variants}>
                <.badge variant={variant} color="primary">
                  {String.capitalize(variant)}
                </.badge>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="flex flex-wrap items-center gap-3">
              <div :for={size <- @sizes}>
                <.badge size={size} color="primary">
                  {String.replace(size, "_", " ") |> String.capitalize()}
                </.badge>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
