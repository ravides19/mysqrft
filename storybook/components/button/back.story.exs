defmodule Storybook.Components.Button.Back do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Button.back/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic back navigation link.",
        attributes: %{
          navigate: "/"
        },
        slots: ["Back to home"]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world back navigation examples.",
        variations: [
          %Variation{
            id: :back_to_list,
            attributes: %{navigate: "/posts"},
            slots: ["Back to posts"]
          },
          %Variation{
            id: :back_to_dashboard,
            attributes: %{navigate: "/dashboard"},
            slots: ["Back to dashboard"]
          },
          %Variation{
            id: :back_to_settings,
            attributes: %{navigate: "/settings"},
            slots: ["Back to settings"]
          },
          %Variation{
            id: :back_to_products,
            attributes: %{navigate: "/products"},
            slots: ["Back to products"]
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
