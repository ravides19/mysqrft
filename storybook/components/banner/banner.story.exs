defmodule Storybook.Components.Banner.Banner do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Banner.banner/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic banner with default styling, positioned at top full-width.",
        attributes: %{
          id: "banner-default",
          variant: "base",
          color: "natural",
          position: "full",
          vertical_position: "top"
        },
        slots: ["<span>Welcome to our platform! Check out the new features.</span>"]
      },
      %Variation{
        id: :without_dismiss,
        description: "Without dismiss button",
        note: "Banner without the dismiss/close button.",
        attributes: %{
          id: "banner-no-dismiss",
          variant: "bordered",
          color: "info",
          position: "full",
          hide_dismiss: true
        },
        slots: ["<span>This banner cannot be dismissed.</span>"]
      },
      %Variation{
        id: :bottom_positioned,
        description: "Bottom positioned",
        note: "Banner positioned at the bottom of the viewport.",
        attributes: %{
          id: "banner-bottom",
          variant: "default",
          color: "primary",
          position: "full",
          vertical_position: "bottom"
        },
        slots: ["<span>This banner appears at the bottom of the page.</span>"]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for banners.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{
              id: "banner-variant-base",
              variant: "base",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Base variant banner</span>"]
          },
          %Variation{
            id: :variant_default,
            attributes: %{
              id: "banner-variant-default",
              variant: "default",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Default variant banner</span>"]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              id: "banner-variant-outline",
              variant: "outline",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Outline variant banner</span>"]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{
              id: "banner-variant-shadow",
              variant: "shadow",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Shadow variant banner</span>"]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{
              id: "banner-variant-transparent",
              variant: "transparent",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Transparent variant banner</span>"]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{
              id: "banner-variant-bordered",
              variant: "bordered",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Bordered variant banner</span>"]
          },
          %Variation{
            id: :variant_gradient,
            attributes: %{
              id: "banner-variant-gradient",
              variant: "gradient",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Gradient variant banner</span>"]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for banners.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{
              id: "banner-color-natural",
              variant: "default",
              color: "natural",
              position: "full"
            },
            slots: ["<span>Natural color banner</span>"]
          },
          %Variation{
            id: :color_primary,
            attributes: %{
              id: "banner-color-primary",
              variant: "default",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Primary color banner</span>"]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{
              id: "banner-color-secondary",
              variant: "default",
              color: "secondary",
              position: "full"
            },
            slots: ["<span>Secondary color banner</span>"]
          },
          %Variation{
            id: :color_success,
            attributes: %{
              id: "banner-color-success",
              variant: "default",
              color: "success",
              position: "full"
            },
            slots: ["<span>Success color banner</span>"]
          },
          %Variation{
            id: :color_warning,
            attributes: %{
              id: "banner-color-warning",
              variant: "default",
              color: "warning",
              position: "full"
            },
            slots: ["<span>Warning color banner</span>"]
          },
          %Variation{
            id: :color_danger,
            attributes: %{
              id: "banner-color-danger",
              variant: "default",
              color: "danger",
              position: "full"
            },
            slots: ["<span>Danger color banner</span>"]
          },
          %Variation{
            id: :color_info,
            attributes: %{
              id: "banner-color-info",
              variant: "default",
              color: "info",
              position: "full"
            },
            slots: ["<span>Info color banner</span>"]
          }
        ]
      },
      %VariationGroup{
        id: :positions,
        description: "Positions",
        note: "Different positioning options for banners.",
        variations: [
          %Variation{
            id: :position_full,
            attributes: %{
              id: "banner-pos-full",
              variant: "bordered",
              color: "primary",
              position: "full"
            },
            slots: ["<span>Full width banner</span>"]
          },
          %Variation{
            id: :position_center,
            attributes: %{
              id: "banner-pos-center",
              variant: "bordered",
              color: "primary",
              position: "center",
              rounded: "medium",
              rounded_position: "all"
            },
            slots: ["<span>Center positioned banner</span>"]
          },
          %Variation{
            id: :position_top_left,
            attributes: %{
              id: "banner-pos-tl",
              variant: "bordered",
              color: "secondary",
              position: "top_left",
              position_size: "small",
              rounded: "medium",
              rounded_position: "all"
            },
            slots: ["<span>Top left banner</span>"]
          },
          %Variation{
            id: :position_top_right,
            attributes: %{
              id: "banner-pos-tr",
              variant: "bordered",
              color: "success",
              position: "top_right",
              position_size: "small",
              rounded: "medium",
              rounded_position: "all"
            },
            slots: ["<span>Top right banner</span>"]
          },
          %Variation{
            id: :position_bottom_left,
            attributes: %{
              id: "banner-pos-bl",
              variant: "bordered",
              color: "warning",
              position: "bottom_left",
              position_size: "small",
              vertical_position: "bottom",
              rounded: "medium",
              rounded_position: "all"
            },
            slots: ["<span>Bottom left banner</span>"]
          },
          %Variation{
            id: :position_bottom_right,
            attributes: %{
              id: "banner-pos-br",
              variant: "bordered",
              color: "danger",
              position: "bottom_right",
              position_size: "small",
              vertical_position: "bottom",
              rounded: "medium",
              rounded_position: "all"
            },
            slots: ["<span>Bottom right banner</span>"]
          }
        ]
      },
      %VariationGroup{
        id: :border_positions,
        description: "Border positions",
        note: "Different border position options.",
        variations: [
          %Variation{
            id: :border_top,
            attributes: %{
              id: "banner-border-top",
              variant: "bordered",
              color: "info",
              position: "full",
              border_position: "top",
              border: "medium"
            },
            slots: ["<span>Border on top</span>"]
          },
          %Variation{
            id: :border_bottom,
            attributes: %{
              id: "banner-border-bottom",
              variant: "bordered",
              color: "info",
              position: "full",
              border_position: "bottom",
              border: "medium"
            },
            slots: ["<span>Border on bottom</span>"]
          },
          %Variation{
            id: :border_full,
            attributes: %{
              id: "banner-border-full",
              variant: "bordered",
              color: "info",
              position: "full",
              border_position: "full",
              border: "small"
            },
            slots: ["<span>Border on all sides</span>"]
          },
          %Variation{
            id: :border_none,
            attributes: %{
              id: "banner-border-none",
              variant: "bordered",
              color: "info",
              position: "full",
              border_position: "none"
            },
            slots: ["<span>No border</span>"]
          }
        ]
      },
      %VariationGroup{
        id: :rounded,
        description: "Rounded corners",
        note: "Different border radius options.",
        variations: [
          %Variation{
            id: :rounded_top,
            attributes: %{
              id: "banner-rounded-top",
              variant: "default",
              color: "secondary",
              position: "full",
              vertical_position: "top",
              rounded: "large",
              rounded_position: "top"
            },
            slots: ["<span>Rounded bottom corners (top position)</span>"]
          },
          %Variation{
            id: :rounded_bottom,
            attributes: %{
              id: "banner-rounded-bottom",
              variant: "default",
              color: "secondary",
              position: "full",
              vertical_position: "bottom",
              rounded: "large",
              rounded_position: "bottom"
            },
            slots: ["<span>Rounded top corners (bottom position)</span>"]
          },
          %Variation{
            id: :rounded_all,
            attributes: %{
              id: "banner-rounded-all",
              variant: "default",
              color: "secondary",
              position: "center",
              rounded: "large",
              rounded_position: "all"
            },
            slots: ["<span>All corners rounded</span>"]
          }
        ]
      },
      %VariationGroup{
        id: :padding_sizes,
        description: "Padding sizes",
        note: "Different padding options for banners.",
        variations: [
          %Variation{
            id: :padding_extra_small,
            attributes: %{
              id: "banner-padding-xs",
              variant: "bordered",
              color: "natural",
              position: "full",
              padding: "extra_small"
            },
            slots: ["<span>Extra small padding</span>"]
          },
          %Variation{
            id: :padding_small,
            attributes: %{
              id: "banner-padding-sm",
              variant: "bordered",
              color: "natural",
              position: "full",
              padding: "small"
            },
            slots: ["<span>Small padding</span>"]
          },
          %Variation{
            id: :padding_medium,
            attributes: %{
              id: "banner-padding-md",
              variant: "bordered",
              color: "natural",
              position: "full",
              padding: "medium"
            },
            slots: ["<span>Medium padding</span>"]
          },
          %Variation{
            id: :padding_large,
            attributes: %{
              id: "banner-padding-lg",
              variant: "bordered",
              color: "natural",
              position: "full",
              padding: "large"
            },
            slots: ["<span>Large padding</span>"]
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{
              id: "banner-padding-xl",
              variant: "bordered",
              color: "natural",
              position: "full",
              padding: "extra_large"
            },
            slots: ["<span>Extra large padding</span>"]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world banner examples.",
        variations: [
          %Variation{
            id: :announcement,
            attributes: %{
              id: "banner-announcement",
              variant: "gradient",
              color: "primary",
              position: "full",
              padding: "small"
            },
            slots: [
              "<span class=\"flex items-center gap-2\"><span class=\"font-semibold\">🎉 New Feature!</span> Check out our latest updates and improvements.</span>"
            ]
          },
          %Variation{
            id: :cookie_consent,
            attributes: %{
              id: "banner-cookie",
              variant: "bordered",
              color: "natural",
              position: "full",
              vertical_position: "bottom",
              padding: "small"
            },
            slots: [
              "<span>We use cookies to enhance your experience. By continuing to visit this site you agree to our use of cookies.</span>"
            ]
          },
          %Variation{
            id: :maintenance,
            attributes: %{
              id: "banner-maintenance",
              variant: "default",
              color: "warning",
              position: "full",
              padding: "small",
              hide_dismiss: true
            },
            slots: [
              "<span class=\"flex items-center gap-2\"><span class=\"font-semibold\">⚠️ Scheduled Maintenance:</span> The system will be unavailable on Sunday from 2-4 AM UTC.</span>"
            ]
          },
          %Variation{
            id: :promo,
            attributes: %{
              id: "banner-promo",
              variant: "gradient",
              color: "success",
              position: "full",
              padding: "small"
            },
            slots: [
              "<span class=\"font-medium\">🔥 Limited Time Offer: Get 50% off your first month! Use code: SAVE50</span>"
            ]
          },
          %Variation{
            id: :error_notice,
            attributes: %{
              id: "banner-error",
              variant: "default",
              color: "danger",
              position: "full",
              padding: "small"
            },
            slots: [
              "<span>⚠️ We're experiencing some technical difficulties. Our team is working on it.</span>"
            ]
          }
        ]
      },
      MySqrftWeb.Storybook.ComponentDefaults.all_params_variation(function(),
        id: :all_params,
        description: "All params"
      )
    ]
  end
end
