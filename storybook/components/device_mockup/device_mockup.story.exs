defmodule Storybook.Components.DeviceMockup.DeviceMockup do
  use PhoenixStorybook.Story, :component

  def function, do: &MySqrftWeb.Components.DeviceMockup.device_mockup/1
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
