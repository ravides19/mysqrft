defmodule MySqrftWeb.Live.Components.ButtonLive do
  @moduledoc """
  LiveView showcasing Button component variations.
  """
  use MySqrftWeb, :live_view
  alias MySqrftWeb.Live.Components.ComponentHelpers

  defp humanize_token(token) when is_binary(token) do
    token
    |> String.replace("_", " ")
    |> String.replace("-", " ")
    |> String.split(" ", trim: true)
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  @impl true
  def mount(_params, _session, socket) do
    config = ComponentHelpers.load_config()

    {:ok,
     assign(socket,
       colors: config.colors,
       variants: config.variants,
       sizes: config.sizes,
       rounded: config.rounded,
       borders:
         Map.get(config, :border, [
           "none",
           "extra_small",
           "small",
           "medium",
           "large",
           "extra_large"
         ])
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Button Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all button variations, colors, sizes, and styles
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Colors</h2>
            <div class="flex flex-wrap gap-3">
              <div :for={color <- @colors}>
                <.button variant="default" color={color}>{humanize_token(color)}</.button>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Variants</h2>
            <div class="flex flex-wrap gap-3">
              <div :for={variant <- @variants}>
                <.button variant={variant} color="primary">
                  {humanize_token(variant)}
                </.button>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="flex flex-wrap items-center gap-3">
              <div :for={size <- @sizes}>
                <.button size={size} color="primary">
                  {humanize_token(size)}
                </.button>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Rounded</h2>
            <div class="flex flex-wrap gap-3">
              <div :for={round <- @rounded}>
                <.button rounded={round} color="primary">
                  {humanize_token(round)}
                </.button>
              </div>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Border</h2>
            <div class="flex flex-wrap gap-3">
              <div :for={border <- @borders}>
                <.button variant="bordered" border={border} color="primary">
                  {humanize_token(border)}
                </.button>
              </div>
            </div>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
              Note: Border sizing only applies to non-gradient/non-shadow variants. This demo uses the
              <span class="font-medium">bordered</span>
              variant so the border differences are visible.
            </p>
          </div>

          <div>
            <h2 class="text-2xl font-semibold mb-4">Button Group</h2>
            <div class="space-y-4">
              <.button_group color="primary" rounded="medium">
                <.button variant="default" color="primary">Button 1</.button>
                <.button variant="default" color="primary">Button 2</.button>
                <.button variant="default" color="primary">Button 3</.button>
              </.button_group>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
