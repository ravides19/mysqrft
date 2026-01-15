defmodule Storybook.Components.Blockquote.Blockquote do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Blockquote.blockquote/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic blockquote with left border and quote icon.",
        attributes: %{
          variant: "base",
          color: "natural",
          size: "medium",
          left_border: true
        },
        slots: [
          "The only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle."
        ]
      },
      %Variation{
        id: :with_caption,
        description: "With caption",
        note: "Blockquote with author caption and image.",
        attributes: %{
          variant: "bordered",
          color: "primary",
          size: "medium",
          left_border: true
        },
        slots: [
          "Innovation distinguishes between a leader and a follower.",
          ~s(<:caption image="https://i.pravatar.cc/100?img=11" position="left">Steve Jobs | Apple Inc.</:caption>)
        ]
      },
      %Variation{
        id: :without_icon,
        description: "Without icon",
        note: "Blockquote with the quote icon hidden.",
        attributes: %{
          variant: "outline",
          color: "secondary",
          size: "medium",
          left_border: true,
          hide_icon: true
        },
        slots: [
          "Simplicity is the ultimate sophistication.",
          ~s|<:caption position="left">Leonardo da Vinci</:caption>|
        ]
      },
      %Variation{
        id: :custom_icon,
        description: "Custom icon",
        note: "Blockquote with a custom hero icon.",
        attributes: %{
          variant: "bordered",
          color: "info",
          size: "medium",
          icon: "hero-chat-bubble-left-ellipsis",
          left_border: true
        },
        slots: [
          "The best time to plant a tree was 20 years ago. The second best time is now."
        ]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for blockquotes.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{
              variant: "base",
              color: "primary",
              left_border: true
            },
            slots: ["Base variant blockquote with clean styling."]
          },
          %Variation{
            id: :variant_default,
            attributes: %{
              variant: "default",
              color: "primary"
            },
            slots: ["Default variant with solid background."]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              variant: "outline",
              color: "primary",
              left_border: true
            },
            slots: ["Outline variant with colored border."]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{
              variant: "shadow",
              color: "primary"
            },
            slots: ["Shadow variant with elevated effect."]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{
              variant: "transparent",
              color: "primary"
            },
            slots: ["Transparent variant with colored text only."]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{
              variant: "bordered",
              color: "primary",
              left_border: true
            },
            slots: ["Bordered variant with soft background."]
          },
          %Variation{
            id: :variant_gradient,
            attributes: %{
              variant: "gradient",
              color: "primary"
            },
            slots: ["Gradient variant with beautiful gradient background."]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for blockquotes.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{
              variant: "bordered",
              color: "natural",
              left_border: true
            },
            slots: ["Natural color blockquote."]
          },
          %Variation{
            id: :color_primary,
            attributes: %{
              variant: "bordered",
              color: "primary",
              left_border: true
            },
            slots: ["Primary color blockquote."]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{
              variant: "bordered",
              color: "secondary",
              left_border: true
            },
            slots: ["Secondary color blockquote."]
          },
          %Variation{
            id: :color_success,
            attributes: %{
              variant: "bordered",
              color: "success",
              left_border: true
            },
            slots: ["Success color blockquote."]
          },
          %Variation{
            id: :color_warning,
            attributes: %{
              variant: "bordered",
              color: "warning",
              left_border: true
            },
            slots: ["Warning color blockquote."]
          },
          %Variation{
            id: :color_danger,
            attributes: %{
              variant: "bordered",
              color: "danger",
              left_border: true
            },
            slots: ["Danger color blockquote."]
          },
          %Variation{
            id: :color_info,
            attributes: %{
              variant: "bordered",
              color: "info",
              left_border: true
            },
            slots: ["Info color blockquote."]
          }
        ]
      },
      %VariationGroup{
        id: :border_positions,
        description: "Border positions",
        note: "Different border position options.",
        variations: [
          %Variation{
            id: :border_left,
            attributes: %{
              variant: "outline",
              color: "primary",
              left_border: true,
              border: "large"
            },
            slots: ["Left border blockquote."]
          },
          %Variation{
            id: :border_right,
            attributes: %{
              variant: "outline",
              color: "primary",
              right_border: true,
              border: "large"
            },
            slots: ["Right border blockquote."]
          },
          %Variation{
            id: :border_full,
            attributes: %{
              variant: "outline",
              color: "primary",
              full_border: true,
              border: "small"
            },
            slots: ["Full border blockquote."]
          },
          %Variation{
            id: :border_hidden,
            attributes: %{
              variant: "bordered",
              color: "primary",
              hide_border: true
            },
            slots: ["No border blockquote."]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for blockquotes.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              variant: "bordered",
              color: "secondary",
              size: "extra_small",
              left_border: true
            },
            slots: ["Extra small size blockquote."]
          },
          %Variation{
            id: :size_small,
            attributes: %{
              variant: "bordered",
              color: "secondary",
              size: "small",
              left_border: true
            },
            slots: ["Small size blockquote."]
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              variant: "bordered",
              color: "secondary",
              size: "medium",
              left_border: true
            },
            slots: ["Medium size blockquote."]
          },
          %Variation{
            id: :size_large,
            attributes: %{
              variant: "bordered",
              color: "secondary",
              size: "large",
              left_border: true
            },
            slots: ["Large size blockquote."]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{
              variant: "bordered",
              color: "secondary",
              size: "extra_large",
              left_border: true
            },
            slots: ["Extra large size blockquote."]
          }
        ]
      },
      %VariationGroup{
        id: :caption_positions,
        description: "Caption positions",
        note: "Different caption alignment options.",
        variations: [
          %Variation{
            id: :caption_left,
            attributes: %{
              variant: "bordered",
              color: "info",
              left_border: true
            },
            slots: [
              "A journey of a thousand miles begins with a single step.",
              ~s|<:caption image="https://i.pravatar.cc/100?img=33" position="left">Lao Tzu</:caption>|
            ]
          },
          %Variation{
            id: :caption_center,
            attributes: %{
              variant: "bordered",
              color: "info",
              left_border: true
            },
            slots: [
              "Be the change you wish to see in the world.",
              ~s|<:caption image="https://i.pravatar.cc/100?img=52" position="center">Mahatma Gandhi</:caption>|
            ]
          },
          %Variation{
            id: :caption_right,
            attributes: %{
              variant: "bordered",
              color: "info",
              left_border: true
            },
            slots: [
              "In the middle of difficulty lies opportunity.",
              ~s|<:caption image="https://i.pravatar.cc/100?img=60" position="right">Albert Einstein</:caption>|
            ]
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
              variant: "default",
              color: "success",
              rounded: "none"
            },
            slots: ["No rounded corners."]
          },
          %Variation{
            id: :rounded_small,
            attributes: %{
              variant: "default",
              color: "success",
              rounded: "small"
            },
            slots: ["Small rounded corners."]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{
              variant: "default",
              color: "success",
              rounded: "medium"
            },
            slots: ["Medium rounded corners."]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{
              variant: "default",
              color: "success",
              rounded: "large"
            },
            slots: ["Large rounded corners."]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{
              variant: "default",
              color: "success",
              rounded: "extra_large"
            },
            slots: ["Extra large rounded corners."]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world blockquote examples.",
        variations: [
          %Variation{
            id: :testimonial,
            attributes: %{
              variant: "shadow",
              color: "primary",
              size: "medium",
              rounded: "large"
            },
            slots: [
              "This product transformed our workflow completely. We've seen a 40% increase in productivity since implementing it.",
              ~s(<:caption image="https://i.pravatar.cc/100?img=25" position="left">Sarah Johnson, CTO at TechCorp</:caption>)
            ]
          },
          %Variation{
            id: :article_quote,
            attributes: %{
              variant: "outline",
              color: "natural",
              size: "large",
              left_border: true,
              border: "large"
            },
            slots: [
              "The future belongs to those who believe in the beauty of their dreams."
            ]
          },
          %Variation{
            id: :pullquote,
            attributes: %{
              variant: "gradient",
              color: "secondary",
              size: "large",
              rounded: "medium"
            },
            slots: [
              "Design is not just what it looks like and feels like. Design is how it works.",
              ~s|<:caption position="center">Steve Jobs</:caption>|
            ]
          },
          %Variation{
            id: :code_callout,
            attributes: %{
              variant: "bordered",
              color: "warning",
              size: "small",
              left_border: true,
              icon: "hero-exclamation-triangle",
              hide_icon: false
            },
            slots: [
              "Note: This API is deprecated and will be removed in v3.0. Please migrate to the new endpoints."
            ]
          },
          %Variation{
            id: :success_message,
            attributes: %{
              variant: "bordered",
              color: "success",
              size: "small",
              left_border: true,
              icon: "hero-check-circle"
            },
            slots: [
              "Your changes have been saved successfully. The new configuration will take effect immediately."
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
