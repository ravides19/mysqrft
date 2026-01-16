defmodule Storybook.Components.Button.Button do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Button.button/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic button with default styling.",
        attributes: %{
          id: "button-default"
        },
        slots: ["Click me"]
      },
      %Variation{
        id: :with_icon,
        description: "With icon",
        note: "Button with an icon on the left side.",
        attributes: %{
          id: "button-icon",
          icon: "hero-arrow-down-tray",
          color: "primary",
          variant: "default"
        },
        slots: ["Download"]
      },
      %Variation{
        id: :with_right_icon,
        description: "With right icon",
        note: "Button with an icon on the right side.",
        attributes: %{
          id: "button-right-icon",
          icon: "hero-arrow-right",
          color: "info",
          variant: "default",
          right_icon: true
        },
        slots: ["Continue"]
      },
      %Variation{
        id: :icon_only,
        description: "Icon only",
        note: "Button with only an icon, no text.",
        attributes: %{
          id: "button-icon-only",
          icon: "hero-plus",
          color: "success",
          variant: "default",
          circle: true
        },
        slots: []
      },
      %Variation{
        id: :disabled,
        description: "Disabled",
        note: "Button in disabled state.",
        attributes: %{
          id: "button-disabled",
          color: "primary",
          variant: "default",
          disabled: true
        },
        slots: ["Disabled"]
      },
      %Variation{
        id: :full_width,
        description: "Full width",
        note: "Button that spans the full width of its container.",
        attributes: %{
          id: "button-full-width",
          color: "primary",
          variant: "default",
          full_width: true
        },
        slots: ["Full Width Button"]
      },
      %Variation{
        id: :submit_button,
        description: "Submit button",
        note: "Button with type submit for forms.",
        attributes: %{
          id: "button-submit",
          type: "submit",
          color: "success",
          variant: "default",
          icon: "hero-check"
        },
        slots: ["Submit"]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for buttons.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{id: "button-variant-base", variant: "base", color: "primary"},
            slots: ["Base"]
          },
          %Variation{
            id: :variant_default,
            attributes: %{id: "button-variant-default", variant: "default", color: "primary"},
            slots: ["Default"]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{id: "button-variant-outline", variant: "outline", color: "primary"},
            slots: ["Outline"]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{id: "button-variant-transparent", variant: "transparent", color: "primary"},
            slots: ["Transparent"]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{id: "button-variant-bordered", variant: "bordered", color: "primary"},
            slots: ["Bordered"]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{id: "button-variant-shadow", variant: "shadow", color: "primary"},
            slots: ["Shadow"]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for buttons.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{id: "button-color-natural", variant: "default", color: "natural"},
            slots: ["Natural"]
          },
          %Variation{
            id: :color_primary,
            attributes: %{id: "button-color-primary", variant: "default", color: "primary"},
            slots: ["Primary"]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{id: "button-color-secondary", variant: "default", color: "secondary"},
            slots: ["Secondary"]
          },
          %Variation{
            id: :color_success,
            attributes: %{id: "button-color-success", variant: "default", color: "success"},
            slots: ["Success"]
          },
          %Variation{
            id: :color_warning,
            attributes: %{id: "button-color-warning", variant: "default", color: "warning"},
            slots: ["Warning"]
          },
          %Variation{
            id: :color_danger,
            attributes: %{id: "button-color-danger", variant: "default", color: "danger"},
            slots: ["Danger"]
          },
          %Variation{
            id: :color_info,
            attributes: %{id: "button-color-info", variant: "default", color: "info"},
            slots: ["Info"]
          },
          %Variation{
            id: :color_misc,
            attributes: %{id: "button-color-misc", variant: "default", color: "misc"},
            slots: ["Misc"]
          },
          %Variation{
            id: :color_dawn,
            attributes: %{id: "button-color-dawn", variant: "default", color: "dawn"},
            slots: ["Dawn"]
          },
          %Variation{
            id: :color_silver,
            attributes: %{id: "button-color-silver", variant: "default", color: "silver"},
            slots: ["Silver"]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for buttons.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{id: "button-size-xs", variant: "default", color: "primary", size: "extra_small"},
            slots: ["Extra Small"]
          },
          %Variation{
            id: :size_small,
            attributes: %{id: "button-size-sm", variant: "default", color: "primary", size: "small"},
            slots: ["Small"]
          },
          %Variation{
            id: :size_medium,
            attributes: %{id: "button-size-md", variant: "default", color: "primary", size: "medium"},
            slots: ["Medium"]
          },
          %Variation{
            id: :size_large,
            attributes: %{id: "button-size-lg", variant: "default", color: "primary", size: "large"},
            slots: ["Large"]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{id: "button-size-xl", variant: "default", color: "primary", size: "extra_large"},
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
            attributes: %{id: "button-rounded-none", variant: "default", color: "secondary", rounded: "none"},
            slots: ["None"]
          },
          %Variation{
            id: :rounded_extra_small,
            attributes: %{id: "button-rounded-xs", variant: "default", color: "secondary", rounded: "extra_small"},
            slots: ["Extra Small"]
          },
          %Variation{
            id: :rounded_small,
            attributes: %{id: "button-rounded-sm", variant: "default", color: "secondary", rounded: "small"},
            slots: ["Small"]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{id: "button-rounded-md", variant: "default", color: "secondary", rounded: "medium"},
            slots: ["Medium"]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{id: "button-rounded-lg", variant: "default", color: "secondary", rounded: "large"},
            slots: ["Large"]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{id: "button-rounded-xl", variant: "default", color: "secondary", rounded: "extra_large"},
            slots: ["Extra Large"]
          },
          %Variation{
            id: :rounded_full,
            attributes: %{id: "button-rounded-full", variant: "default", color: "secondary", rounded: "full"},
            slots: ["Full"]
          }
        ]
      },
      %VariationGroup{
        id: :border_sizes,
        description: "Border sizes",
        note: "Different border width options for outline/bordered variants.",
        variations: [
          %Variation{
            id: :border_none,
            attributes: %{id: "button-border-none", variant: "bordered", color: "primary", border: "none"},
            slots: ["None"]
          },
          %Variation{
            id: :border_extra_small,
            attributes: %{id: "button-border-xs", variant: "bordered", color: "primary", border: "extra_small"},
            slots: ["Extra Small"]
          },
          %Variation{
            id: :border_small,
            attributes: %{id: "button-border-sm", variant: "bordered", color: "primary", border: "small"},
            slots: ["Small"]
          },
          %Variation{
            id: :border_medium,
            attributes: %{id: "button-border-md", variant: "bordered", color: "primary", border: "medium"},
            slots: ["Medium"]
          },
          %Variation{
            id: :border_large,
            attributes: %{id: "button-border-lg", variant: "bordered", color: "primary", border: "large"},
            slots: ["Large"]
          },
          %Variation{
            id: :border_extra_large,
            attributes: %{id: "button-border-xl", variant: "bordered", color: "primary", border: "extra_large"},
            slots: ["Extra Large"]
          }
        ]
      },
      %VariationGroup{
        id: :indicators,
        description: "Indicators",
        note: "Buttons with status indicators in different positions.",
        variations: [
          %Variation{
            id: :indicator_left,
            attributes: %{id: "button-ind-left", variant: "default", color: "success", left_indicator: true},
            slots: ["Left Indicator"]
          },
          %Variation{
            id: :indicator_right,
            attributes: %{id: "button-ind-right", variant: "default", color: "success", right_indicator: true},
            slots: ["Right Indicator"]
          },
          %Variation{
            id: :indicator_top_left,
            attributes: %{id: "button-ind-tl", variant: "default", color: "danger", top_left_indicator: true},
            slots: ["Top Left"]
          },
          %Variation{
            id: :indicator_top_center,
            attributes: %{id: "button-ind-tc", variant: "default", color: "danger", top_center_indicator: true},
            slots: ["Top Center"]
          },
          %Variation{
            id: :indicator_top_right,
            attributes: %{id: "button-ind-tr", variant: "default", color: "danger", top_right_indicator: true},
            slots: ["Top Right"]
          },
          %Variation{
            id: :indicator_middle_left,
            attributes: %{id: "button-ind-ml", variant: "default", color: "warning", middle_left_indicator: true},
            slots: ["Middle Left"]
          },
          %Variation{
            id: :indicator_middle_right,
            attributes: %{id: "button-ind-mr", variant: "default", color: "warning", middle_right_indicator: true},
            slots: ["Middle Right"]
          },
          %Variation{
            id: :indicator_bottom_left,
            attributes: %{id: "button-ind-bl", variant: "default", color: "info", bottom_left_indicator: true},
            slots: ["Bottom Left"]
          },
          %Variation{
            id: :indicator_bottom_center,
            attributes: %{id: "button-ind-bc", variant: "default", color: "info", bottom_center_indicator: true},
            slots: ["Bottom Center"]
          },
          %Variation{
            id: :indicator_bottom_right,
            attributes: %{id: "button-ind-br", variant: "default", color: "info", bottom_right_indicator: true},
            slots: ["Bottom Right"]
          }
        ]
      },
      %VariationGroup{
        id: :pinging_indicators,
        description: "Pinging indicators",
        note: "Buttons with animated pinging indicators for attention.",
        variations: [
          %Variation{
            id: :pinging_left,
            attributes: %{
              id: "button-ping-left",
              variant: "default",
              color: "danger",
              left_indicator: true,
              pinging: true
            },
            slots: ["Pinging Left"]
          },
          %Variation{
            id: :pinging_right,
            attributes: %{
              id: "button-ping-right",
              variant: "default",
              color: "danger",
              right_indicator: true,
              pinging: true
            },
            slots: ["Pinging Right"]
          },
          %Variation{
            id: :pinging_top_right,
            attributes: %{
              id: "button-ping-tr",
              variant: "default",
              color: "success",
              top_right_indicator: true,
              pinging: true
            },
            slots: ["Pinging Top Right"]
          }
        ]
      },
      %VariationGroup{
        id: :circle_buttons,
        description: "Circle buttons",
        note: "Circular icon buttons in different sizes.",
        variations: [
          %Variation{
            id: :circle_extra_small,
            attributes: %{
              id: "button-circle-xs",
              variant: "default",
              color: "primary",
              size: "extra_small",
              circle: true,
              icon: "hero-plus"
            },
            slots: []
          },
          %Variation{
            id: :circle_small,
            attributes: %{
              id: "button-circle-sm",
              variant: "default",
              color: "primary",
              size: "small",
              circle: true,
              icon: "hero-plus"
            },
            slots: []
          },
          %Variation{
            id: :circle_medium,
            attributes: %{
              id: "button-circle-md",
              variant: "default",
              color: "primary",
              size: "medium",
              circle: true,
              icon: "hero-plus"
            },
            slots: []
          },
          %Variation{
            id: :circle_large,
            attributes: %{
              id: "button-circle-lg",
              variant: "default",
              color: "primary",
              size: "large",
              circle: true,
              icon: "hero-plus"
            },
            slots: []
          },
          %Variation{
            id: :circle_extra_large,
            attributes: %{
              id: "button-circle-xl",
              variant: "default",
              color: "primary",
              size: "extra_large",
              circle: true,
              icon: "hero-plus"
            },
            slots: []
          }
        ]
      },
      %VariationGroup{
        id: :content_positions,
        description: "Content positions",
        note: "Different content alignment options.",
        variations: [
          %Variation{
            id: :position_start,
            attributes: %{
              id: "button-pos-start",
              variant: "bordered",
              color: "natural",
              content_position: "start",
              class: "w-48"
            },
            slots: ["Start"]
          },
          %Variation{
            id: :position_center,
            attributes: %{
              id: "button-pos-center",
              variant: "bordered",
              color: "natural",
              content_position: "center",
              class: "w-48"
            },
            slots: ["Center"]
          },
          %Variation{
            id: :position_end,
            attributes: %{
              id: "button-pos-end",
              variant: "bordered",
              color: "natural",
              content_position: "end",
              class: "w-48"
            },
            slots: ["End"]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world button examples.",
        variations: [
          %Variation{
            id: :save_button,
            attributes: %{
              id: "button-save",
              variant: "default",
              color: "success",
              icon: "hero-check",
              type: "submit"
            },
            slots: ["Save Changes"]
          },
          %Variation{
            id: :delete_button,
            attributes: %{
              id: "button-delete",
              variant: "default",
              color: "danger",
              icon: "hero-trash"
            },
            slots: ["Delete"]
          },
          %Variation{
            id: :cancel_button,
            attributes: %{
              id: "button-cancel",
              variant: "outline",
              color: "natural"
            },
            slots: ["Cancel"]
          },
          %Variation{
            id: :add_to_cart,
            attributes: %{
              id: "button-cart",
              variant: "default",
              color: "primary",
              icon: "hero-shopping-cart",
              size: "large"
            },
            slots: ["Add to Cart"]
          },
          %Variation{
            id: :notification_button,
            attributes: %{
              id: "button-notification",
              variant: "bordered",
              color: "info",
              icon: "hero-bell",
              circle: true,
              top_right_indicator: true,
              pinging: true
            },
            slots: []
          },
          %Variation{
            id: :settings_button,
            attributes: %{
              id: "button-settings",
              variant: "transparent",
              color: "natural",
              icon: "hero-cog-6-tooth"
            },
            slots: ["Settings"]
          },
          %Variation{
            id: :share_button,
            attributes: %{
              id: "button-share",
              variant: "shadow",
              color: "misc",
              icon: "hero-share"
            },
            slots: ["Share"]
          },
          %Variation{
            id: :upload_button,
            attributes: %{
              id: "button-upload",
              variant: "bordered",
              color: "dawn",
              icon: "hero-arrow-up-tray"
            },
            slots: ["Upload File"]
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
