defmodule Storybook.Components.Button.InputButton do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Button.input_button/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic input button with default styling.",
        attributes: %{
          id: "input-button-default",
          value: "Click me"
        }
      },
      %Variation{
        id: :submit,
        description: "Submit",
        note: "Input button with type submit for forms.",
        attributes: %{
          id: "input-button-submit",
          type: "submit",
          value: "Submit Form",
          color: "success",
          variant: "default"
        }
      },
      %Variation{
        id: :reset,
        description: "Reset",
        note: "Input button with type reset for forms.",
        attributes: %{
          id: "input-button-reset",
          type: "reset",
          value: "Reset Form",
          color: "warning",
          variant: "outline"
        }
      },
      %Variation{
        id: :full_width,
        description: "Full width",
        note: "Input button spanning full container width.",
        attributes: %{
          id: "input-button-full",
          value: "Full Width Button",
          color: "primary",
          variant: "default",
          full_width: true
        }
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for input buttons.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{id: "input-button-variant-base", variant: "base", color: "primary", value: "Base"}
          },
          %Variation{
            id: :variant_default,
            attributes: %{id: "input-button-variant-default", variant: "default", color: "primary", value: "Default"}
          },
          %Variation{
            id: :variant_outline,
            attributes: %{id: "input-button-variant-outline", variant: "outline", color: "primary", value: "Outline"}
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{id: "input-button-variant-transparent", variant: "transparent", color: "primary", value: "Transparent"}
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{id: "input-button-variant-bordered", variant: "bordered", color: "primary", value: "Bordered"}
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{id: "input-button-variant-shadow", variant: "shadow", color: "primary", value: "Shadow"}
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for input buttons.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{id: "input-button-color-natural", variant: "default", color: "natural", value: "Natural"}
          },
          %Variation{
            id: :color_primary,
            attributes: %{id: "input-button-color-primary", variant: "default", color: "primary", value: "Primary"}
          },
          %Variation{
            id: :color_secondary,
            attributes: %{id: "input-button-color-secondary", variant: "default", color: "secondary", value: "Secondary"}
          },
          %Variation{
            id: :color_success,
            attributes: %{id: "input-button-color-success", variant: "default", color: "success", value: "Success"}
          },
          %Variation{
            id: :color_warning,
            attributes: %{id: "input-button-color-warning", variant: "default", color: "warning", value: "Warning"}
          },
          %Variation{
            id: :color_danger,
            attributes: %{id: "input-button-color-danger", variant: "default", color: "danger", value: "Danger"}
          },
          %Variation{
            id: :color_info,
            attributes: %{id: "input-button-color-info", variant: "default", color: "info", value: "Info"}
          },
          %Variation{
            id: :color_misc,
            attributes: %{id: "input-button-color-misc", variant: "default", color: "misc", value: "Misc"}
          },
          %Variation{
            id: :color_dawn,
            attributes: %{id: "input-button-color-dawn", variant: "default", color: "dawn", value: "Dawn"}
          },
          %Variation{
            id: :color_silver,
            attributes: %{id: "input-button-color-silver", variant: "default", color: "silver", value: "Silver"}
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for input buttons.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{id: "input-button-size-xs", variant: "default", color: "primary", size: "extra_small", value: "Extra Small"}
          },
          %Variation{
            id: :size_small,
            attributes: %{id: "input-button-size-sm", variant: "default", color: "primary", size: "small", value: "Small"}
          },
          %Variation{
            id: :size_medium,
            attributes: %{id: "input-button-size-md", variant: "default", color: "primary", size: "medium", value: "Medium"}
          },
          %Variation{
            id: :size_large,
            attributes: %{id: "input-button-size-lg", variant: "default", color: "primary", size: "large", value: "Large"}
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{id: "input-button-size-xl", variant: "default", color: "primary", size: "extra_large", value: "Extra Large"}
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
            attributes: %{id: "input-button-rounded-none", variant: "default", color: "secondary", rounded: "none", value: "None"}
          },
          %Variation{
            id: :rounded_extra_small,
            attributes: %{id: "input-button-rounded-xs", variant: "default", color: "secondary", rounded: "extra_small", value: "Extra Small"}
          },
          %Variation{
            id: :rounded_small,
            attributes: %{id: "input-button-rounded-sm", variant: "default", color: "secondary", rounded: "small", value: "Small"}
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{id: "input-button-rounded-md", variant: "default", color: "secondary", rounded: "medium", value: "Medium"}
          },
          %Variation{
            id: :rounded_large,
            attributes: %{id: "input-button-rounded-lg", variant: "default", color: "secondary", rounded: "large", value: "Large"}
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{id: "input-button-rounded-xl", variant: "default", color: "secondary", rounded: "extra_large", value: "Extra Large"}
          },
          %Variation{
            id: :rounded_full,
            attributes: %{id: "input-button-rounded-full", variant: "default", color: "secondary", rounded: "full", value: "Full"}
          }
        ]
      },
      %VariationGroup{
        id: :border_sizes,
        description: "Border sizes",
        note: "Different border width options for bordered variants.",
        variations: [
          %Variation{
            id: :border_none,
            attributes: %{id: "input-button-border-none", variant: "bordered", color: "primary", border: "none", value: "None"}
          },
          %Variation{
            id: :border_extra_small,
            attributes: %{id: "input-button-border-xs", variant: "bordered", color: "primary", border: "extra_small", value: "Extra Small"}
          },
          %Variation{
            id: :border_small,
            attributes: %{id: "input-button-border-sm", variant: "bordered", color: "primary", border: "small", value: "Small"}
          },
          %Variation{
            id: :border_medium,
            attributes: %{id: "input-button-border-md", variant: "bordered", color: "primary", border: "medium", value: "Medium"}
          },
          %Variation{
            id: :border_large,
            attributes: %{id: "input-button-border-lg", variant: "bordered", color: "primary", border: "large", value: "Large"}
          },
          %Variation{
            id: :border_extra_large,
            attributes: %{id: "input-button-border-xl", variant: "bordered", color: "primary", border: "extra_large", value: "Extra Large"}
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
              id: "input-button-pos-start",
              variant: "bordered",
              color: "natural",
              content_position: "start",
              value: "Start",
              class: "w-48"
            }
          },
          %Variation{
            id: :position_center,
            attributes: %{
              id: "input-button-pos-center",
              variant: "bordered",
              color: "natural",
              content_position: "center",
              value: "Center",
              class: "w-48"
            }
          },
          %Variation{
            id: :position_end,
            attributes: %{
              id: "input-button-pos-end",
              variant: "bordered",
              color: "natural",
              content_position: "end",
              value: "End",
              class: "w-48"
            }
          }
        ]
      },
      %VariationGroup{
        id: :types,
        description: "Input types",
        note: "Different input button types.",
        variations: [
          %Variation{
            id: :type_button,
            attributes: %{id: "input-button-type-button", type: "button", color: "natural", variant: "bordered", value: "Button"}
          },
          %Variation{
            id: :type_submit,
            attributes: %{id: "input-button-type-submit", type: "submit", color: "success", variant: "default", value: "Submit"}
          },
          %Variation{
            id: :type_reset,
            attributes: %{id: "input-button-type-reset", type: "reset", color: "warning", variant: "outline", value: "Reset"}
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world input button examples.",
        variations: [
          %Variation{
            id: :save_form,
            attributes: %{
              id: "input-button-save",
              type: "submit",
              value: "Save Changes",
              color: "success",
              variant: "default"
            }
          },
          %Variation{
            id: :cancel_form,
            attributes: %{
              id: "input-button-cancel",
              type: "button",
              value: "Cancel",
              color: "natural",
              variant: "outline"
            }
          },
          %Variation{
            id: :reset_form,
            attributes: %{
              id: "input-button-reset-form",
              type: "reset",
              value: "Clear All",
              color: "warning",
              variant: "bordered"
            }
          },
          %Variation{
            id: :search_submit,
            attributes: %{
              id: "input-button-search",
              type: "submit",
              value: "Search",
              color: "primary",
              variant: "default",
              size: "medium"
            }
          },
          %Variation{
            id: :apply_filters,
            attributes: %{
              id: "input-button-apply",
              type: "submit",
              value: "Apply Filters",
              color: "info",
              variant: "shadow"
            }
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
