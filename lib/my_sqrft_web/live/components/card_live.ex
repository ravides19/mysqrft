defmodule MySqrftWeb.Live.Components.CardLive do
  @moduledoc """
  LiveView showcasing Card component variations.
  """
  use MySqrftWeb, :live_view
  alias MySqrftWeb.Live.Components.ComponentHelpers

  @impl true
  def mount(_params, _session, socket) do
    config = ComponentHelpers.load_config()

    {:ok,
     assign(socket,
       colors: config.colors,
       variants: config.variants
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Card Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all card variations, colors, and styles
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div :for={color <- @colors}>
                <.card color={color} class="h-full">
                  <.card_title>Card Title</.card_title>
                  <.card_content>
                    <p>This is a {color} card</p>
                  </.card_content>
                </.card>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Variants</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div :for={variant <- @variants}>
                <.card variant={variant} color="primary" class="h-full">
                  <.card_title>{String.capitalize(variant)} Card</.card_title>
                  <.card_content>
                    <p>This is a {variant} variant card</p>
                  </.card_content>
                </.card>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
