defmodule Storybook.Components.Card.CardFooter do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Card.card_footer/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic card footer with default styling.",
        attributes: %{
          id: "card-footer-default"
        },
        slots: ["Footer content goes here"]
      },
      %Variation{
        id: :with_padding,
        description: "With padding",
        note: "Card footer with padding.",
        attributes: %{
          id: "card-footer-padding",
          padding: "large",
          class: "border-t"
        },
        slots: ["Footer with large padding"]
      },
      %Variation{
        id: :with_buttons,
        description: "With buttons",
        note: "Card footer with action buttons.",
        attributes: %{
          id: "card-footer-buttons",
          padding: "medium",
          class: "flex justify-end gap-2 border-t"
        },
        slots: [
          ~s|<button class="px-4 py-2 border rounded hover:bg-gray-50">Cancel</button><button class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">Save</button>|
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
              id: "card-footer-pad-xs",
              padding: "extra_small",
              class: "border border-dashed"
            },
            slots: ["Extra Small Padding"]
          },
          %Variation{
            id: :padding_small,
            attributes: %{
              id: "card-footer-pad-sm",
              padding: "small",
              class: "border border-dashed"
            },
            slots: ["Small Padding"]
          },
          %Variation{
            id: :padding_medium,
            attributes: %{
              id: "card-footer-pad-md",
              padding: "medium",
              class: "border border-dashed"
            },
            slots: ["Medium Padding"]
          },
          %Variation{
            id: :padding_large,
            attributes: %{
              id: "card-footer-pad-lg",
              padding: "large",
              class: "border border-dashed"
            },
            slots: ["Large Padding"]
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{
              id: "card-footer-pad-xl",
              padding: "extra_large",
              class: "border border-dashed"
            },
            slots: ["Extra Large Padding"]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world card footer examples.",
        variations: [
          %Variation{
            id: :action_buttons,
            attributes: %{
              id: "card-footer-actions",
              padding: "medium",
              class: "flex justify-end gap-2 border-t"
            },
            slots: [
              ~s|<button class="px-3 py-1.5 border rounded text-sm">Cancel</button><button class="px-3 py-1.5 bg-green-500 text-white rounded text-sm">✓ Confirm</button>|
            ]
          },
          %Variation{
            id: :full_width_button,
            attributes: %{id: "card-footer-full", padding: "medium"},
            slots: [
              ~s|<button class="w-full py-2 bg-blue-500 text-white rounded hover:bg-blue-600">Get Started</button>|
            ]
          },
          %Variation{
            id: :link_footer,
            attributes: %{
              id: "card-footer-link",
              padding: "medium",
              class: "text-center border-t"
            },
            slots: [
              ~s|<a href="#" class="text-sm text-blue-500 hover:underline">View all details →</a>|
            ]
          },
          %Variation{
            id: :social_footer,
            attributes: %{
              id: "card-footer-social",
              padding: "medium",
              class: "flex justify-center gap-4 border-t"
            },
            slots: [
              ~s|<button class="p-2 hover:bg-gray-100 rounded">♡</button><button class="p-2 hover:bg-gray-100 rounded">💬</button><button class="p-2 hover:bg-gray-100 rounded">↗</button>|
            ]
          },
          %Variation{
            id: :info_footer,
            attributes: %{
              id: "card-footer-info",
              padding: "small",
              class: "flex justify-between items-center border-t text-sm opacity-70"
            },
            slots: [
              ~s|<span>Updated 2 hours ago</span><span>By John Doe</span>|
            ]
          },
          %Variation{
            id: :pagination_footer,
            attributes: %{
              id: "card-footer-pagination",
              padding: "medium",
              class: "flex justify-between items-center border-t"
            },
            slots: [
              ~s|<span class="text-sm opacity-70">Page 1 of 5</span><div class="flex gap-1"><button class="px-2 py-1 border rounded text-sm">←</button><button class="px-2 py-1 border rounded text-sm">→</button></div>|
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
