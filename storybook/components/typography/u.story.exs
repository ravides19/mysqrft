defmodule Storybook.Components.Typography.U do
  use PhoenixStorybook.Story, :component

  def function, do: &MySqrftWeb.Components.Typography.u/1
  def render_source, do: :function

  def variations do
    [
      MySqrftWeb.Storybook.ComponentDefaults.all_params_variation(function(),
        id: :all_params,
        description: "All params"
      )
    ]
  end
end
