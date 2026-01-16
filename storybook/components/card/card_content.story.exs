defmodule Storybook.Components.Card.CardContent do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Card.card_content/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic card content with default styling.",
        attributes: %{
          id: "card-content-default"
        },
        slots: [
          "This is the card content. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ]
      },
      %Variation{
        id: :with_padding,
        description: "With padding",
        note: "Card content with padding.",
        attributes: %{
          id: "card-content-padding",
          padding: "large",
          class: "border border-dashed"
        },
        slots: ["Content with large padding applied."]
      },
      %Variation{
        id: :with_space,
        description: "With space",
        note: "Card content with vertical spacing between elements.",
        attributes: %{
          id: "card-content-space",
          space: "medium",
          class: "border border-dashed"
        },
        slots: [
          ~s|<p>First paragraph of content.</p><p>Second paragraph with some spacing.</p><p>Third paragraph to show the gap.</p>|
        ]
      },
      %VariationGroup{
        id: :padding,
        description: "Padding",
        note: "Different padding options.",
        variations: [
          %Variation{
            id: :padding_extra_small,
            attributes: %{
              id: "card-content-pad-xs",
              padding: "extra_small",
              class: "border border-dashed"
            },
            slots: ["Extra Small Padding"]
          },
          %Variation{
            id: :padding_small,
            attributes: %{
              id: "card-content-pad-sm",
              padding: "small",
              class: "border border-dashed"
            },
            slots: ["Small Padding"]
          },
          %Variation{
            id: :padding_medium,
            attributes: %{
              id: "card-content-pad-md",
              padding: "medium",
              class: "border border-dashed"
            },
            slots: ["Medium Padding"]
          },
          %Variation{
            id: :padding_large,
            attributes: %{
              id: "card-content-pad-lg",
              padding: "large",
              class: "border border-dashed"
            },
            slots: ["Large Padding"]
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{
              id: "card-content-pad-xl",
              padding: "extra_large",
              class: "border border-dashed"
            },
            slots: ["Extra Large Padding"]
          }
        ]
      },
      %VariationGroup{
        id: :space,
        description: "Space between items",
        note: "Different vertical spacing options.",
        variations: [
          %Variation{
            id: :space_extra_small,
            attributes: %{
              id: "card-content-space-xs",
              space: "extra_small",
              class: "border border-dashed p-2"
            },
            slots: [~s|<p>Item 1</p><p>Item 2</p><p>Item 3</p>|]
          },
          %Variation{
            id: :space_small,
            attributes: %{
              id: "card-content-space-sm",
              space: "small",
              class: "border border-dashed p-2"
            },
            slots: [~s|<p>Item 1</p><p>Item 2</p><p>Item 3</p>|]
          },
          %Variation{
            id: :space_medium,
            attributes: %{
              id: "card-content-space-md",
              space: "medium",
              class: "border border-dashed p-2"
            },
            slots: [~s|<p>Item 1</p><p>Item 2</p><p>Item 3</p>|]
          },
          %Variation{
            id: :space_large,
            attributes: %{
              id: "card-content-space-lg",
              space: "large",
              class: "border border-dashed p-2"
            },
            slots: [~s|<p>Item 1</p><p>Item 2</p><p>Item 3</p>|]
          },
          %Variation{
            id: :space_extra_large,
            attributes: %{
              id: "card-content-space-xl",
              space: "extra_large",
              class: "border border-dashed p-2"
            },
            slots: [~s|<p>Item 1</p><p>Item 2</p><p>Item 3</p>|]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world card content examples.",
        variations: [
          %Variation{
            id: :article_content,
            attributes: %{id: "card-content-article", padding: "medium"},
            slots: [
              ~s|<h4 class="font-semibold mb-2">Introduction to Web Development</h4><p class="text-sm opacity-80">Learn the fundamentals of building modern web applications with the latest technologies and best practices.</p>|
            ]
          },
          %Variation{
            id: :stats_content,
            attributes: %{id: "card-content-stats", padding: "large", class: "text-center"},
            slots: [
              ~s|<span class="text-4xl font-bold">1,234</span><p class="text-sm opacity-70 mt-1">Active Users</p>|
            ]
          },
          %Variation{
            id: :list_content,
            attributes: %{id: "card-content-list", padding: "medium", space: "small"},
            slots: [
              ~s|<div class="flex items-center gap-2"><span class="text-green-500">✓</span><span>Feature one</span></div><div class="flex items-center gap-2"><span class="text-green-500">✓</span><span>Feature two</span></div><div class="flex items-center gap-2"><span class="text-green-500">✓</span><span>Feature three</span></div>|
            ]
          },
          %Variation{
            id: :product_details,
            attributes: %{id: "card-content-product", padding: "medium"},
            slots: [
              ~s|<h4 class="font-semibold">Premium Headphones</h4><p class="text-xl font-bold text-blue-500 mt-1">$299.99</p><p class="text-sm opacity-70 mt-2">Wireless, Noise-Canceling, 40hr Battery</p>|
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
