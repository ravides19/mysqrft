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
          // Get the current effective theme (checking data-theme or system preference)
          const getCurrentTheme = () => {
            const dataTheme = document.documentElement.getAttribute("data-theme");
            if (dataTheme === "light" || dataTheme === "dark") {
              return dataTheme;
            }
            // If no data-theme, check system preference
            return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
          };

          // Handle click to toggle theme
          this.el.addEventListener("click", () => {
            const currentTheme = getCurrentTheme();
            const newTheme = currentTheme === "dark" ? "light" : "dark";

            // Set the theme explicitly (not "system")
            localStorage.setItem("phx:theme", newTheme);
            document.documentElement.setAttribute("data-theme", newTheme);

            // Dispatch storage event to sync across tabs
            window.dispatchEvent(new StorageEvent("storage", {
              key: "phx:theme",
              newValue: newTheme
            }));

            // Dispatch custom event for other components
            window.dispatchEvent(new CustomEvent("phx:set-theme", {
              detail: { theme: newTheme }
            }));
          });

          // Listen for storage events (theme changes in other tabs)
          const handleStorage = (e) => {
            if (e.key === "phx:theme") {
              // Theme will be updated by the initialization script
              // The CSS classes will automatically update the button appearance
            }
          };

          window.addEventListener("storage", handleStorage);

          // Listen for custom theme change events
          const handleThemeChange = () => {
            // Theme will be updated by the initialization script
            // The CSS classes will automatically update the button appearance
          };

          window.addEventListener("phx:set-theme", handleThemeChange);

          // Cleanup
          this.handleDestroy = () => {
            window.removeEventListener("storage", handleStorage);
            window.removeEventListener("phx:set-theme", handleThemeChange);
          };
        },
        destroyed() {
          if (this.handleDestroy) {
            this.handleDestroy();
          }
        }
      }
    </script>
    """
  end
end
