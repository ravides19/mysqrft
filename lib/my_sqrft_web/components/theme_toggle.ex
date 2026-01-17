defmodule MySqrftWeb.Components.ThemeToggle do
  @moduledoc """
  The `MySqrftWeb.Components.ThemeToggle` module provides a simple theme toggle
  component for switching between dark and light themes.

  ## Features:
  - Toggle between dark and light themes
  - Uses existing project components (icon)
  - Accessible and visually clear

  ## Examples:

      <.theme_toggle />

      <.theme_toggle class="my-custom-class" />
  """
  use Phoenix.Component
  import MySqrftWeb.Components.Icon, only: [icon: 1]

  @doc """
  Renders a theme toggle button that switches between dark and light themes.
  """
  @doc type: :component
  attr :id, :string, default: "theme-toggle", doc: "Unique identifier for the toggle button"
  attr :class, :string, default: nil, doc: "Custom CSS class for additional styling"

  def theme_toggle(assigns) do
    ~H"""
    <button
      type="button"
      id={@id}
      phx-hook=".ThemeToggle"
      class={[
        "relative flex items-center gap-2 px-3 py-2 rounded-lg transition-colors",
        "hover:bg-gray-100 dark:hover:bg-gray-800",
        "text-gray-700 dark:text-gray-300",
        @class
      ]}
      aria-label="Toggle theme"
    >
      <span class="hidden dark:block">
        <.icon name="hero-sun" class="w-5 h-5" />
      </span>
      <span class="block dark:hidden">
        <.icon name="hero-moon" class="w-5 h-5" />
      </span>
      <span class="hidden sm:block text-sm font-medium">
        <span class="hidden dark:inline">Light</span>
        <span class="dark:hidden">Dark</span>
      </span>
    </button>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".ThemeToggle">
      export default {
        mounted() {
          this.el.addEventListener("click", () => {
            const currentTheme = document.documentElement.getAttribute("data-theme") || "light";
            const newTheme = currentTheme === "dark" ? "light" : "dark";

            // Use the same setTheme logic from the head script
            localStorage.setItem("phx:theme", newTheme);
            document.documentElement.setAttribute("data-theme", newTheme);

            // Dispatch storage event to sync across tabs
            window.dispatchEvent(new Event("storage"));
          });
        }
      }
    </script>
    """
  end
end
