defmodule MySqrftWeb.Live.Components.ComponentHelpers do
  @moduledoc """
  Shared helpers for component LiveViews to load configuration.
  """

  def load_config do
    %{
      colors: [
        # Must match the generated Mishka Chelekom button color tokens
        # (see `MySqrftWeb.Components.Button.color_variant/3`).
        "white",
        "dark",
        "natural",
        "primary",
        "secondary",
        "success",
        "warning",
        "danger",
        "info",
        "misc",
        "dawn",
        "silver"
      ],
      variants: [
        "default",
        "outline",
        "transparent",
        "bordered",
        "shadow",
        "subtle",
        "default_gradient",
        "outline_gradient",
        "inverted_gradient"
      ],
      sizes: [
        "extra_small",
        "small",
        "medium",
        "large",
        "extra_large"
      ],
      rounded: [
        "none",
        "extra_small",
        "small",
        "medium",
        "large",
        "extra_large",
        "full"
      ],
      border: [
        "none",
        "extra_small",
        "small",
        "medium",
        "large",
        "extra_large"
      ],
      padding: [
        "extra_small",
        "small",
        "medium",
        "large",
        "extra_large",
        "none"
      ],
      space: [
        "extra_small",
        "small",
        "medium",
        "large",
        "extra_large",
        "none"
      ]
    }
  end
end
