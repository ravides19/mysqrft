# Component LiveViews

This directory contains individual LiveView files for each component showcase.

## Structure

Each component LiveView follows this pattern:

```elixir
defmodule MySqrftWeb.Live.Components.ComponentNameLive do
  @moduledoc """
  LiveView showcasing ComponentName component variations.
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
       sizes: config.sizes,
       rounded: config.rounded
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Component Name</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Explore all component variations
          </p>
        </div>

        <div class="space-y-8">
          <!-- Add component examples here -->
        </div>
      </div>
    </Layouts.app>
    """
  end
end
```

## Adding Routes

Add routes to `lib/my_sqrft_web/router.ex`:

```elixir
scope "/components", MySqrftWeb.Live.Components do
  pipe_through :browser
  
  live "/component-name", ComponentNameLive
end
```

## Available Components

- Button
- Badge
- Alert
- Card
- Spinner
- Progress
- TextField
- EmailField
- PasswordField
- NumberField
- CheckboxField
- TextareaField
- Accordion
- Avatar
- Tabs
- Modal

## Remaining Components to Create

See `lib/my_sqrft_web/components/mishka_components.ex` for the full list of available components.
