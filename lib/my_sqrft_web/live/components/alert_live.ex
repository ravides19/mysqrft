defmodule MySqrftWeb.Live.Components.AlertLive do
  @moduledoc """
  LiveView showcasing Alert component variations.
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
          <h1 class="text-4xl font-bold mb-2">Alert Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all alert variations, colors, sizes, and styles
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors (as kind)</h2>
            <div class="space-y-3">
              <div :for={color <- @colors}>
                <.alert kind={String.to_atom(color)} variant="default">
                  This is a {color} alert
                </.alert>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Variants</h2>
            <div class="space-y-3">
              <div :for={variant <- @variants}>
                <.alert kind={:info} variant={variant}>
                  This is a {variant} alert
                </.alert>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="space-y-3">
              <div :for={size <- @sizes}>
                <.alert kind={:info} size={size}>
                  This is a {String.replace(size, "_", " ")} alert
                </.alert>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
