defmodule MySqrftWeb.Live.Components.ModalLive do
  @moduledoc """
  LiveView showcasing Modal component variations.
  """
  use MySqrftWeb, :live_view
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Modal Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore modal component variations
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Example</h2>
            <div class="max-w-md">
              <.button phx-click={JS.dispatch("phx:show-modal", to: "#example-modal")}>
                Open Modal
              </.button>
              <.modal id="example-modal" title="Modal Title">
                <p>This is modal content.</p>
              </.modal>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
