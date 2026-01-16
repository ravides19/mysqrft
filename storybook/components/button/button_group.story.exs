defmodule Storybook.Components.Button.ButtonGroup do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Button.button_group/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic button group with horizontal layout.",
        attributes: %{
          id: "button-group-default"
        },
        slots: [
          ~s|<button class="px-4 py-2 hover:bg-gray-100">First</button>|,
          ~s|<button class="px-4 py-2 hover:bg-gray-100">Second</button>|,
          ~s|<button class="px-4 py-2 hover:bg-gray-100">Third</button>|
        ]
      },
      %Variation{
        id: :vertical,
        description: "Vertical",
        note: "Button group with vertical layout.",
        attributes: %{
          id: "button-group-vertical",
          variation: "vertical"
        },
        slots: [
          ~s|<button class="px-4 py-2 hover:bg-gray-100">Top</button>|,
          ~s|<button class="px-4 py-2 hover:bg-gray-100">Middle</button>|,
          ~s|<button class="px-4 py-2 hover:bg-gray-100">Bottom</button>|
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for button groups.",
        variations: [
          %Variation{
            id: :color_base,
            attributes: %{id: "button-group-color-base", color: "base"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :color_natural,
            attributes: %{id: "button-group-color-natural", color: "natural"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :color_primary,
            attributes: %{id: "button-group-color-primary", color: "primary"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{id: "button-group-color-secondary", color: "secondary"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :color_success,
            attributes: %{id: "button-group-color-success", color: "success"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :color_danger,
            attributes: %{id: "button-group-color-danger", color: "danger"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
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
            id: :rounded_small,
            attributes: %{id: "button-group-rounded-sm", rounded: "small"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{id: "button-group-rounded-md", rounded: "medium"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{id: "button-group-rounded-lg", rounded: "large"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{id: "button-group-rounded-xl", rounded: "extra_large"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          },
          %Variation{
            id: :rounded_full,
            attributes: %{id: "button-group-rounded-full", rounded: "full"},
            slots: [
              ~s|<button class="px-3 py-1.5">One</button>|,
              ~s|<button class="px-3 py-1.5">Two</button>|,
              ~s|<button class="px-3 py-1.5">Three</button>|
            ]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world button group examples.",
        variations: [
          %Variation{
            id: :text_formatting,
            attributes: %{id: "button-group-formatting", color: "natural"},
            slots: [
              ~s|<button class="px-3 py-2 font-bold">B</button>|,
              ~s|<button class="px-3 py-2 italic">I</button>|,
              ~s|<button class="px-3 py-2 underline">U</button>|,
              ~s|<button class="px-3 py-2 line-through">S</button>|
            ]
          },
          %Variation{
            id: :pagination,
            attributes: %{id: "button-group-pagination", color: "primary"},
            slots: [
              ~s|<button class="px-3 py-2">←</button>|,
              ~s|<button class="px-3 py-2">1</button>|,
              ~s|<button class="px-3 py-2">2</button>|,
              ~s|<button class="px-3 py-2">3</button>|,
              ~s|<button class="px-3 py-2">→</button>|
            ]
          },
          %Variation{
            id: :view_toggle,
            attributes: %{id: "button-group-view", color: "secondary"},
            slots: [
              ~s|<button class="px-3 py-2">☰</button>|,
              ~s|<button class="px-3 py-2">▦</button>|,
              ~s|<button class="px-3 py-2">▤</button>|
            ]
          },
          %Variation{
            id: :actions,
            attributes: %{id: "button-group-actions", color: "natural", variation: "vertical"},
            slots: [
              ~s|<button class="px-4 py-2 text-left">✎ Edit</button>|,
              ~s|<button class="px-4 py-2 text-left">⧉ Duplicate</button>|,
              ~s|<button class="px-4 py-2 text-left">🗑 Delete</button>|
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
