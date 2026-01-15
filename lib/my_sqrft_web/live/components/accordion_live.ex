defmodule MySqrftWeb.Live.Components.AccordionLive do
  @moduledoc """
  LiveView showcasing Accordion component variations.
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
          <h1 class="text-4xl font-bold mb-2">Accordion Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore accordion component variations
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Example</h2>
            <div class="max-w-2xl">
              <.accordion id="accordion-example">
                <:item title="Item 1">
                  <p>Content for item 1</p>
                </:item>
                <:item title="Item 2">
                  <p>Content for item 2</p>
                </:item>
                <:item title="Item 3">
                  <p>Content for item 3</p>
                </:item>
              </.accordion>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
