defmodule Storybook.Components.Badge.Badge do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Badge.badge/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic badge with default styling.",
        attributes: %{
          id: "badge-default",
          variant: "base",
          color: "natural",
          size: "extra_small"
        },
        slots: ["Default"]
      },
      %Variation{
        id: :with_icon,
        description: "With icon",
        note: "Badge with an icon on the left side.",
        attributes: %{
          id: "badge-icon",
          icon: "hero-star",
          color: "primary",
          variant: "default",
          size: "small"
        },
        slots: ["Featured"]
      },
      %Variation{
        id: :with_right_icon,
        description: "With right icon",
        note: "Badge with an icon on the right side.",
        attributes: %{
          id: "badge-right-icon",
          icon: "hero-arrow-right",
          color: "info",
          variant: "bordered",
          size: "small",
          right_icon: true
        },
        slots: ["Continue"]
      },
      %Variation{
        id: :dismissible,
        description: "Dismissible",
        note: "Badge with a dismiss button to remove it.",
        attributes: %{
          id: "badge-dismissible",
          color: "warning",
          variant: "bordered",
          size: "small",
          dismiss: true
        },
        slots: ["Removable"]
      },
      %Variation{
        id: :with_indicator,
        description: "With indicator",
        note: "Badge with a status indicator dot.",
        attributes: %{
          id: "badge-indicator",
          color: "success",
          variant: "bordered",
          size: "small",
          indicator: true
        },
        slots: ["Active"]
      },
      %Variation{
        id: :pinging_indicator,
        description: "Pinging indicator",
        note: "Badge with an animated pinging indicator for attention.",
        attributes: %{
          id: "badge-pinging",
          color: "danger",
          variant: "default",
          size: "small",
          indicator: true,
          pinging: true
        },
        slots: ["Live"]
      },
      %Variation{
        id: :circle,
        description: "Circle badge",
        note: "Circular badge, great for notification counts.",
        attributes: %{
          id: "badge-circle",
          color: "danger",
          variant: "default",
          size: "small",
          rounded: "full",
          circle: true
        },
        slots: ["5"]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for badges.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{
              id: "badge-variant-base",
              variant: "base",
              color: "primary",
              size: "small"
            },
            slots: ["Base"]
          },
          %Variation{
            id: :variant_default,
            attributes: %{
              id: "badge-variant-default",
              variant: "default",
              color: "primary",
              size: "small"
            },
            slots: ["Default"]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              id: "badge-variant-outline",
              variant: "outline",
              color: "primary",
              size: "small"
            },
            slots: ["Outline"]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{
              id: "badge-variant-transparent",
              variant: "transparent",
              color: "primary",
              size: "small"
            },
            slots: ["Transparent"]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{
              id: "badge-variant-shadow",
              variant: "shadow",
              color: "primary",
              size: "small"
            },
            slots: ["Shadow"]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{
              id: "badge-variant-bordered",
              variant: "bordered",
              color: "primary",
              size: "small"
            },
            slots: ["Bordered"]
          },
          %Variation{
            id: :variant_gradient,
            attributes: %{
              id: "badge-variant-gradient",
              variant: "gradient",
              color: "primary",
              size: "small"
            },
            slots: ["Gradient"]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for badges.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{
              id: "badge-color-natural",
              variant: "default",
              color: "natural",
              size: "small"
            },
            slots: ["Natural"]
          },
          %Variation{
            id: :color_primary,
            attributes: %{
              id: "badge-color-primary",
              variant: "default",
              color: "primary",
              size: "small"
            },
            slots: ["Primary"]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{
              id: "badge-color-secondary",
              variant: "default",
              color: "secondary",
              size: "small"
            },
            slots: ["Secondary"]
          },
          %Variation{
            id: :color_success,
            attributes: %{
              id: "badge-color-success",
              variant: "default",
              color: "success",
              size: "small"
            },
            slots: ["Success"]
          },
          %Variation{
            id: :color_warning,
            attributes: %{
              id: "badge-color-warning",
              variant: "default",
              color: "warning",
              size: "small"
            },
            slots: ["Warning"]
          },
          %Variation{
            id: :color_danger,
            attributes: %{
              id: "badge-color-danger",
              variant: "default",
              color: "danger",
              size: "small"
            },
            slots: ["Danger"]
          },
          %Variation{
            id: :color_info,
            attributes: %{
              id: "badge-color-info",
              variant: "default",
              color: "info",
              size: "small"
            },
            slots: ["Info"]
          },
          %Variation{
            id: :color_misc,
            attributes: %{
              id: "badge-color-misc",
              variant: "default",
              color: "misc",
              size: "small"
            },
            slots: ["Misc"]
          },
          %Variation{
            id: :color_dawn,
            attributes: %{
              id: "badge-color-dawn",
              variant: "default",
              color: "dawn",
              size: "small"
            },
            slots: ["Dawn"]
          },
          %Variation{
            id: :color_silver,
            attributes: %{
              id: "badge-color-silver",
              variant: "default",
              color: "silver",
              size: "small"
            },
            slots: ["Silver"]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for badges.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              id: "badge-size-xs",
              variant: "bordered",
              color: "primary",
              size: "extra_small"
            },
            slots: ["Extra Small"]
          },
          %Variation{
            id: :size_small,
            attributes: %{
              id: "badge-size-sm",
              variant: "bordered",
              color: "primary",
              size: "small"
            },
            slots: ["Small"]
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              id: "badge-size-md",
              variant: "bordered",
              color: "primary",
              size: "medium"
            },
            slots: ["Medium"]
          },
          %Variation{
            id: :size_large,
            attributes: %{
              id: "badge-size-lg",
              variant: "bordered",
              color: "primary",
              size: "large"
            },
            slots: ["Large"]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{
              id: "badge-size-xl",
              variant: "bordered",
              color: "primary",
              size: "extra_large"
            },
            slots: ["Extra Large"]
          }
        ]
      },
      %VariationGroup{
        id: :rounded,
        description: "Rounded corners",
        note: "Different border radius options.",
        variations: [
          %Variation{
            id: :rounded_none,
            attributes: %{
              id: "badge-rounded-none",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "none"
            },
            slots: ["None"]
          },
          %Variation{
            id: :rounded_extra_small,
            attributes: %{
              id: "badge-rounded-xs",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "extra_small"
            },
            slots: ["Extra Small"]
          },
          %Variation{
            id: :rounded_small,
            attributes: %{
              id: "badge-rounded-sm",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "small"
            },
            slots: ["Small"]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{
              id: "badge-rounded-md",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "medium"
            },
            slots: ["Medium"]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{
              id: "badge-rounded-lg",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "large"
            },
            slots: ["Large"]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{
              id: "badge-rounded-xl",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "extra_large"
            },
            slots: ["Extra Large"]
          },
          %Variation{
            id: :rounded_full,
            attributes: %{
              id: "badge-rounded-full",
              variant: "bordered",
              color: "secondary",
              size: "small",
              rounded: "full"
            },
            slots: ["Full"]
          }
        ]
      },
      %VariationGroup{
        id: :indicator_positions,
        description: "Indicator positions",
        note: "Different positions for the status indicator.",
        variations: [
          %Variation{
            id: :indicator_left,
            attributes: %{
              id: "badge-ind-left",
              variant: "bordered",
              color: "success",
              size: "medium",
              left_indicator: true
            },
            slots: ["Left"]
          },
          %Variation{
            id: :indicator_right,
            attributes: %{
              id: "badge-ind-right",
              variant: "bordered",
              color: "success",
              size: "medium",
              right_indicator: true
            },
            slots: ["Right"]
          },
          %Variation{
            id: :indicator_top_left,
            attributes: %{
              id: "badge-ind-tl",
              variant: "bordered",
              color: "success",
              size: "medium",
              top_left_indicator: true
            },
            slots: ["Top Left"]
          },
          %Variation{
            id: :indicator_top_center,
            attributes: %{
              id: "badge-ind-tc",
              variant: "bordered",
              color: "success",
              size: "medium",
              top_center_indicator: true
            },
            slots: ["Top Center"]
          },
          %Variation{
            id: :indicator_top_right,
            attributes: %{
              id: "badge-ind-tr",
              variant: "bordered",
              color: "success",
              size: "medium",
              top_right_indicator: true
            },
            slots: ["Top Right"]
          },
          %Variation{
            id: :indicator_bottom_left,
            attributes: %{
              id: "badge-ind-bl",
              variant: "bordered",
              color: "success",
              size: "medium",
              bottom_left_indicator: true
            },
            slots: ["Bottom Left"]
          },
          %Variation{
            id: :indicator_bottom_center,
            attributes: %{
              id: "badge-ind-bc",
              variant: "bordered",
              color: "success",
              size: "medium",
              bottom_center_indicator: true
            },
            slots: ["Bottom Center"]
          },
          %Variation{
            id: :indicator_bottom_right,
            attributes: %{
              id: "badge-ind-br",
              variant: "bordered",
              color: "success",
              size: "medium",
              bottom_right_indicator: true
            },
            slots: ["Bottom Right"]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world badge examples.",
        variations: [
          %Variation{
            id: :status_online,
            attributes: %{
              id: "badge-status-online",
              variant: "bordered",
              color: "success",
              size: "small",
              icon: "hero-signal",
              indicator: true
            },
            slots: ["Online"]
          },
          %Variation{
            id: :notification_count,
            attributes: %{
              id: "badge-notification",
              variant: "default",
              color: "danger",
              size: "extra_small",
              rounded: "full",
              circle: true
            },
            slots: ["99+"]
          },
          %Variation{
            id: :new_feature,
            attributes: %{
              id: "badge-new",
              variant: "gradient",
              color: "primary",
              size: "extra_small",
              rounded: "full"
            },
            slots: ["NEW"]
          },
          %Variation{
            id: :beta_tag,
            attributes: %{
              id: "badge-beta",
              variant: "outline",
              color: "warning",
              size: "extra_small"
            },
            slots: ["BETA"]
          },
          %Variation{
            id: :pro_badge,
            attributes: %{
              id: "badge-pro",
              variant: "shadow",
              color: "misc",
              size: "small",
              icon: "hero-sparkles"
            },
            slots: ["PRO"]
          },
          %Variation{
            id: :tag_removable,
            attributes: %{
              id: "badge-tag",
              variant: "bordered",
              color: "info",
              size: "small",
              dismiss: true
            },
            slots: ["JavaScript"]
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
