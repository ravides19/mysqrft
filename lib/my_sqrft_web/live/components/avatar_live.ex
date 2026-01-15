defmodule MySqrftWeb.Live.Components.AvatarLive do
  @moduledoc """
  LiveView showcasing Avatar component variations.
  """
  use MySqrftWeb, :live_view
  alias MySqrftWeb.Live.Components.ComponentHelpers

  @impl true
  def mount(_params, _session, socket) do
    config = ComponentHelpers.load_config()

    {:ok, assign(socket, sizes: config.sizes)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Avatar Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all avatar variations and sizes
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Sizes</h2>
            <div class="flex flex-wrap items-center gap-6">
              <div :for={size <- @sizes} class="flex flex-col items-center gap-2">
                <.avatar size={size} color="primary" />
                <span class="text-sm">{String.replace(size, "_", " ") |> String.capitalize()}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
