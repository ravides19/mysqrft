defmodule Storybook.Components.Chat.Chat do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Chat.chat/1
  def render_source, do: :function
  def imports, do: [{MySqrftWeb.Components.Chat, chat_section: 1}]

  @sample_message "That's awesome. I think our users will really appreciate the improvements."

  defp chat_content(opts \\ []) do
    name = Keyword.get(opts, :name, "Bonnie Green")
    message = Keyword.get(opts, :message, @sample_message)
    time = Keyword.get(opts, :time, "22:10")
    deliver = Keyword.get(opts, :deliver, "Delivered")

    """
    <.chat_section>
      <div class="font-semibold">#{name}</div>
      <p>#{message}</p>
      <:status time="#{time}" deliver="#{deliver}"/>
    </.chat_section>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic chat bubble with default styling.",
        attributes: %{
          id: "chat-default"
        },
        slots: [chat_content()]
      },
      %Variation{
        id: :flipped,
        description: "Flipped position",
        note: "Chat bubble aligned to the right (for sent messages).",
        attributes: %{
          id: "chat-flipped",
          position: "flipped"
        },
        slots: [chat_content(name: "You", message: "Thanks! I'm glad you like it.")]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for the chat component.",
        variations: [
          %Variation{
            id: :variant_default,
            attributes: %{
              id: "chat-variant-default",
              variant: "default",
              color: "primary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              id: "chat-variant-outline",
              variant: "outline",
              color: "primary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{
              id: "chat-variant-shadow",
              variant: "shadow",
              color: "primary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{
              id: "chat-variant-bordered",
              variant: "bordered",
              color: "primary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{
              id: "chat-variant-transparent",
              variant: "transparent",
              color: "primary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :variant_gradient,
            attributes: %{
              id: "chat-variant-gradient",
              variant: "gradient",
              color: "primary"
            },
            slots: [chat_content()]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for chat bubbles.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{
              id: "chat-color-natural",
              variant: "default",
              color: "natural"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :color_primary,
            attributes: %{
              id: "chat-color-primary",
              variant: "default",
              color: "primary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{
              id: "chat-color-secondary",
              variant: "default",
              color: "secondary"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :color_success,
            attributes: %{
              id: "chat-color-success",
              variant: "default",
              color: "success"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :color_warning,
            attributes: %{
              id: "chat-color-warning",
              variant: "default",
              color: "warning"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :color_danger,
            attributes: %{
              id: "chat-color-danger",
              variant: "default",
              color: "danger"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :color_info,
            attributes: %{
              id: "chat-color-info",
              variant: "default",
              color: "info"
            },
            slots: [chat_content()]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options affecting text and max-width.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              id: "chat-size-xs",
              variant: "bordered",
              color: "primary",
              size: "extra_small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :size_small,
            attributes: %{
              id: "chat-size-sm",
              variant: "bordered",
              color: "primary",
              size: "small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              id: "chat-size-md",
              variant: "bordered",
              color: "primary",
              size: "medium"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :size_large,
            attributes: %{
              id: "chat-size-lg",
              variant: "bordered",
              color: "primary",
              size: "large"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{
              id: "chat-size-xl",
              variant: "bordered",
              color: "primary",
              size: "extra_large"
            },
            slots: [chat_content()]
          }
        ]
      },
      %VariationGroup{
        id: :rounded,
        description: "Rounded corners",
        note: "Different border radius options for chat bubbles.",
        variations: [
          %Variation{
            id: :rounded_none,
            attributes: %{
              id: "chat-rounded-none",
              variant: "bordered",
              color: "success",
              rounded: "none"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :rounded_extra_small,
            attributes: %{
              id: "chat-rounded-xs",
              variant: "bordered",
              color: "success",
              rounded: "extra_small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :rounded_small,
            attributes: %{
              id: "chat-rounded-sm",
              variant: "bordered",
              color: "success",
              rounded: "small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{
              id: "chat-rounded-md",
              variant: "bordered",
              color: "success",
              rounded: "medium"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{
              id: "chat-rounded-lg",
              variant: "bordered",
              color: "success",
              rounded: "large"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{
              id: "chat-rounded-xl",
              variant: "bordered",
              color: "success",
              rounded: "extra_large"
            },
            slots: [chat_content()]
          }
        ]
      },
      %VariationGroup{
        id: :borders,
        description: "Border sizes",
        note: "Different border thickness options.",
        variations: [
          %Variation{
            id: :border_none,
            attributes: %{
              id: "chat-border-none",
              variant: "bordered",
              color: "info",
              border: "none"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :border_extra_small,
            attributes: %{
              id: "chat-border-xs",
              variant: "bordered",
              color: "info",
              border: "extra_small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :border_small,
            attributes: %{
              id: "chat-border-sm",
              variant: "bordered",
              color: "info",
              border: "small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :border_medium,
            attributes: %{
              id: "chat-border-md",
              variant: "bordered",
              color: "info",
              border: "medium"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :border_large,
            attributes: %{
              id: "chat-border-lg",
              variant: "bordered",
              color: "info",
              border: "large"
            },
            slots: [chat_content()]
          }
        ]
      },
      %VariationGroup{
        id: :paddings,
        description: "Padding sizes",
        note: "Different padding options for chat content.",
        variations: [
          %Variation{
            id: :padding_extra_small,
            attributes: %{
              id: "chat-padding-xs",
              variant: "default",
              color: "secondary",
              padding: "extra_small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :padding_small,
            attributes: %{
              id: "chat-padding-sm",
              variant: "default",
              color: "secondary",
              padding: "small"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :padding_medium,
            attributes: %{
              id: "chat-padding-md",
              variant: "default",
              color: "secondary",
              padding: "medium"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :padding_large,
            attributes: %{
              id: "chat-padding-lg",
              variant: "default",
              color: "secondary",
              padding: "large"
            },
            slots: [chat_content()]
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{
              id: "chat-padding-xl",
              variant: "default",
              color: "secondary",
              padding: "extra_large"
            },
            slots: [chat_content()]
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
