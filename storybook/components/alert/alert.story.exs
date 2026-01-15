defmodule Storybook.Components.Alert.Alert do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Alert.alert/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic alert with title and content.",
        attributes: %{
          id: "alert-default",
          title: "Notice",
          kind: :natural,
          variant: "default",
          size: "medium",
          rounded: "small",
          width: "full"
        },
        slots: ["This is a default alert message with important information."]
      },
      %Variation{
        id: :with_icon,
        description: "With custom icon",
        note: "Alert with a custom icon matching its purpose.",
        attributes: %{
          id: "alert-with-icon",
          title: "Information",
          kind: :info,
          variant: "bordered",
          icon: "hero-information-circle",
          size: "medium"
        },
        slots: ["Here's some useful information you should know about."]
      },
      %Variation{
        id: :no_icon,
        description: "Without icon",
        note: "Alert without any icon for minimal styling.",
        attributes: %{
          id: "alert-no-icon",
          title: "Simple Alert",
          kind: :natural,
          variant: "outline",
          icon: nil,
          size: "medium"
        },
        slots: ["A minimalist alert without an icon."]
      },
      %VariationGroup{
        id: :kinds,
        description: "Kinds",
        note: "Different alert kinds for various semantic meanings.",
        variations: [
          %Variation{
            id: :kind_info,
            attributes: %{
              id: "alert-kind-info",
              title: "Info",
              kind: :info,
              variant: "default",
              icon: "hero-information-circle"
            },
            slots: ["Informational message for the user."]
          },
          %Variation{
            id: :kind_success,
            attributes: %{
              id: "alert-kind-success",
              title: "Success",
              kind: :success,
              variant: "default",
              icon: "hero-check-circle"
            },
            slots: ["Operation completed successfully!"]
          },
          %Variation{
            id: :kind_warning,
            attributes: %{
              id: "alert-kind-warning",
              title: "Warning",
              kind: :warning,
              variant: "default",
              icon: "hero-exclamation-triangle"
            },
            slots: ["Please review this before continuing."]
          },
          %Variation{
            id: :kind_danger,
            attributes: %{
              id: "alert-kind-danger",
              title: "Error",
              kind: :danger,
              variant: "default",
              icon: "hero-x-circle"
            },
            slots: ["Something went wrong. Please try again."]
          },
          %Variation{
            id: :kind_primary,
            attributes: %{
              id: "alert-kind-primary",
              title: "Primary",
              kind: :primary,
              variant: "default",
              icon: "hero-star"
            },
            slots: ["A primary alert for important callouts."]
          },
          %Variation{
            id: :kind_secondary,
            attributes: %{
              id: "alert-kind-secondary",
              title: "Secondary",
              kind: :secondary,
              variant: "default",
              icon: "hero-bookmark"
            },
            slots: ["A secondary alert for supporting information."]
          }
        ]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for the alert component.",
        variations: [
          %Variation{
            id: :variant_default,
            attributes: %{
              id: "alert-variant-default",
              title: "Default Variant",
              kind: :primary,
              variant: "default"
            },
            slots: ["Solid background with no border."]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              id: "alert-variant-outline",
              title: "Outline Variant",
              kind: :primary,
              variant: "outline"
            },
            slots: ["Transparent background with colored border."]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{
              id: "alert-variant-shadow",
              title: "Shadow Variant",
              kind: :primary,
              variant: "shadow"
            },
            slots: ["Elevated with a drop shadow effect."]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{
              id: "alert-variant-bordered",
              title: "Bordered Variant",
              kind: :primary,
              variant: "bordered"
            },
            slots: ["Soft background with matching border."]
          },
          %Variation{
            id: :variant_gradient,
            attributes: %{
              id: "alert-variant-gradient",
              title: "Gradient Variant",
              kind: :primary,
              variant: "gradient"
            },
            slots: ["Gradient background for eye-catching alerts."]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Typography and icon scale with size.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              id: "alert-size-xs",
              title: "Extra Small",
              kind: :info,
              variant: "bordered",
              size: "extra_small"
            },
            slots: ["Compact alert for dense layouts."]
          },
          %Variation{
            id: :size_small,
            attributes: %{
              id: "alert-size-sm",
              title: "Small",
              kind: :info,
              variant: "bordered",
              size: "small"
            },
            slots: ["Small alert with reduced typography."]
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              id: "alert-size-md",
              title: "Medium",
              kind: :info,
              variant: "bordered",
              size: "medium"
            },
            slots: ["Default medium size alert."]
          },
          %Variation{
            id: :size_large,
            attributes: %{
              id: "alert-size-lg",
              title: "Large",
              kind: :info,
              variant: "bordered",
              size: "large"
            },
            slots: ["Large alert with increased typography."]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{
              id: "alert-size-xl",
              title: "Extra Large",
              kind: :info,
              variant: "bordered",
              size: "extra_large"
            },
            slots: ["Extra large alert for emphasis."]
          }
        ]
      },
      %VariationGroup{
        id: :widths,
        description: "Widths",
        note: "Control the width of the alert component.",
        variations: [
          %Variation{
            id: :width_small,
            attributes: %{
              id: "alert-width-sm",
              title: "Small Width",
              kind: :success,
              variant: "bordered",
              width: "small"
            },
            slots: ["Narrow alert."]
          },
          %Variation{
            id: :width_medium,
            attributes: %{
              id: "alert-width-md",
              title: "Medium Width",
              kind: :success,
              variant: "bordered",
              width: "medium"
            },
            slots: ["Medium width alert."]
          },
          %Variation{
            id: :width_large,
            attributes: %{
              id: "alert-width-lg",
              title: "Large Width",
              kind: :success,
              variant: "bordered",
              width: "large"
            },
            slots: ["Large width alert."]
          },
          %Variation{
            id: :width_full,
            attributes: %{
              id: "alert-width-full",
              title: "Full Width",
              kind: :success,
              variant: "bordered",
              width: "full"
            },
            slots: ["Full width alert stretches to container."]
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
              id: "alert-rounded-none",
              title: "No Rounding",
              kind: :warning,
              variant: "bordered",
              rounded: "none"
            },
            slots: ["Sharp corners."]
          },
          %Variation{
            id: :rounded_small,
            attributes: %{
              id: "alert-rounded-sm",
              title: "Small Rounding",
              kind: :warning,
              variant: "bordered",
              rounded: "small"
            },
            slots: ["Subtle rounded corners."]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{
              id: "alert-rounded-md",
              title: "Medium Rounding",
              kind: :warning,
              variant: "bordered",
              rounded: "medium"
            },
            slots: ["Standard rounded corners."]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{
              id: "alert-rounded-lg",
              title: "Large Rounding",
              kind: :warning,
              variant: "bordered",
              rounded: "large"
            },
            slots: ["Prominent rounded corners."]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{
              id: "alert-rounded-xl",
              title: "Extra Large Rounding",
              kind: :warning,
              variant: "bordered",
              rounded: "extra_large"
            },
            slots: ["Very rounded corners."]
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
