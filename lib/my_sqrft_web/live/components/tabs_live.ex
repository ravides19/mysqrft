defmodule MySqrftWeb.Live.Components.TabsLive do
  @moduledoc """
  LiveView showcasing Tabs component variations.
  """
  use MySqrftWeb, :live_view

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
          <h1 class="text-4xl font-bold mb-2">Tabs Component</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore tabs component variations
          </p>
        </div>

        <div class="space-y-8">
          <div>
            <h2 class="text-2xl font-semibold mb-4">Example</h2>
            <div class="max-w-2xl">
              <.tabs id="tabs-example">
                <:tab>Tab 1</:tab>
                <:tab>Tab 2</:tab>
                <:tab>Tab 3</:tab>
                <:panel>
                  <p>Content for Tab 1</p>
                </:panel>
                <:panel>
                  <p>Content for Tab 2</p>
                </:panel>
                <:panel>
                  <p>Content for Tab 3</p>
                </:panel>
              </.tabs>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
