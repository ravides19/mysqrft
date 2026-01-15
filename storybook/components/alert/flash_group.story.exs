defmodule Storybook.Components.Alert.FlashGroup do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Alert.flash_group/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note:
          "Flash group positioned at top-right with bordered variant. Shows info and error flash messages.",
        attributes: %{
          id: "flash-group-default",
          flash: %{info: "Your changes have been saved successfully!", error: nil},
          variant: "bordered",
          position: "top_right"
        }
      },
      %Variation{
        id: :with_error,
        description: "With error message",
        note: "Shows an error flash message.",
        attributes: %{
          id: "flash-group-error",
          flash: %{info: nil, error: "Something went wrong. Please try again."},
          variant: "bordered",
          position: "top_right"
        }
      },
      %Variation{
        id: :both_messages,
        description: "Both info and error",
        note: "Shows both info and error flash messages stacked.",
        attributes: %{
          id: "flash-group-both",
          flash: %{info: "Profile updated!", error: "Failed to sync settings."},
          variant: "bordered",
          position: "top_right"
        }
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for flash messages.",
        variations: [
          %Variation{
            id: :variant_bordered,
            attributes: %{
              id: "flash-group-variant-bordered",
              flash: %{info: "Bordered variant flash message"},
              variant: "bordered",
              position: ""
            }
          },
          %Variation{
            id: :variant_base,
            attributes: %{
              id: "flash-group-variant-base",
              flash: %{info: "Base variant flash message"},
              variant: "base",
              position: ""
            }
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              id: "flash-group-variant-outline",
              flash: %{info: "Outline variant flash message"},
              variant: "outline",
              position: ""
            }
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{
              id: "flash-group-variant-shadow",
              flash: %{info: "Shadow variant flash message"},
              variant: "shadow",
              position: ""
            }
          },
          %Variation{
            id: :variant_default,
            attributes: %{
              id: "flash-group-variant-default",
              flash: %{info: "Default variant flash message"},
              variant: "default",
              position: ""
            }
          }
        ]
      },
      %VariationGroup{
        id: :positions,
        description: "Positions",
        note:
          "Flash groups can be positioned in various corners. Note: In storybook, position is relative to the variation container.",
        variations: [
          %Variation{
            id: :position_top_right,
            attributes: %{
              id: "flash-group-pos-tr",
              flash: %{info: "Top right position"},
              variant: "bordered",
              position: "top_right"
            }
          },
          %Variation{
            id: :position_top_left,
            attributes: %{
              id: "flash-group-pos-tl",
              flash: %{info: "Top left position"},
              variant: "bordered",
              position: "top_left"
            }
          },
          %Variation{
            id: :position_bottom_right,
            attributes: %{
              id: "flash-group-pos-br",
              flash: %{info: "Bottom right position"},
              variant: "bordered",
              position: "bottom_right"
            }
          },
          %Variation{
            id: :position_bottom_left,
            attributes: %{
              id: "flash-group-pos-bl",
              flash: %{info: "Bottom left position"},
              variant: "bordered",
              position: "bottom_left"
            }
          },
          %Variation{
            id: :position_none,
            description: "No fixed position",
            attributes: %{
              id: "flash-group-pos-none",
              flash: %{info: "Inline (no fixed position)"},
              variant: "bordered",
              position: ""
            }
          }
        ]
      },
      %VariationGroup{
        id: :error_kinds,
        description: "Error message styles",
        note: "Error flash messages with different variants.",
        variations: [
          %Variation{
            id: :error_bordered,
            attributes: %{
              id: "flash-group-error-bordered",
              flash: %{error: "Operation failed. Please check your input."},
              variant: "bordered",
              position: ""
            }
          },
          %Variation{
            id: :error_base,
            attributes: %{
              id: "flash-group-error-base",
              flash: %{error: "Connection lost. Retrying..."},
              variant: "base",
              position: ""
            }
          },
          %Variation{
            id: :error_shadow,
            attributes: %{
              id: "flash-group-error-shadow",
              flash: %{error: "Server error. Contact support."},
              variant: "shadow",
              position: ""
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
