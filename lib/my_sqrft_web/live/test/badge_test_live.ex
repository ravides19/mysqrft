defmodule MySqrftWeb.Test.BadgeTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Badge

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic badge -->
        <.badge>Badge</.badge>

        <!-- Badge with different sizes -->
        <.badge size="extra_small">XS</.badge>
        <.badge size="small">Small</.badge>
        <.badge size="medium">Medium</.badge>
        <.badge size="large">Large</.badge>
        <.badge size="extra_large">XL</.badge>

        <!-- Badge with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.badge color={color}>Default <%= color %></.badge>
          <.badge color={color} variant="outline">Outline <%= color %></.badge>
          <.badge color={color} variant="shadow">Shadow <%= color %></.badge>
          <.badge color={color} variant="bordered">Bordered <%= color %></.badge>
          <.badge color={color} variant="gradient">Gradient <%= color %></.badge>
        <% end %>

        <!-- Badge with different rounded styles -->
        <.badge rounded="extra_small">XS Rounded</.badge>
        <.badge rounded="small">Small Rounded</.badge>
        <.badge rounded="medium">Medium Rounded</.badge>
        <.badge rounded="large">Large Rounded</.badge>
        <.badge rounded="extra_large">XL Rounded</.badge>
        <.badge rounded="full">Full Rounded</.badge>
        <.badge rounded="none">No Rounded</.badge>

        <!-- Badge with different border sizes -->
        <.badge border="extra_small">XS Border</.badge>
        <.badge border="small">Small Border</.badge>
        <.badge border="medium">Medium Border</.badge>
        <.badge border="large">Large Border</.badge>
        <.badge border="extra_large">XL Border</.badge>
        <.badge border="none">No Border</.badge>

        <!-- Badge with icon -->
        <.badge icon="hero-star">With Icon</.badge>
        <.badge icon="hero-star" left_icon>Left Icon</.badge>
        <.badge icon="hero-star" right_icon>Right Icon</.badge>

        <!-- Badge with all indicator positions -->
        <.badge indicator>Indicator</.badge>
        <.badge right_indicator>Right Indicator</.badge>
        <.badge left_indicator>Left Indicator</.badge>
        <.badge top_left_indicator>Top Left Indicator</.badge>
        <.badge top_center_indicator>Top Center Indicator</.badge>
        <.badge top_right_indicator>Top Right Indicator</.badge>
        <.badge middle_left_indicator>Middle Left Indicator</.badge>
        <.badge middle_right_indicator>Middle Right Indicator</.badge>
        <.badge bottom_left_indicator>Bottom Left Indicator</.badge>
        <.badge bottom_center_indicator>Bottom Center Indicator</.badge>
        <.badge bottom_right_indicator>Bottom Right Indicator</.badge>

        <!-- Badge with dismiss -->
        <.badge dismiss>Dismiss</.badge>
        <.badge right_dismiss>Right Dismiss</.badge>
        <.badge left_dismiss>Left Dismiss</.badge>

        <!-- Badge with pinging -->
        <.badge pinging>Pinging</.badge>

        <!-- Badge with custom classes -->
        <.badge class="custom-class" icon_class="custom-icon" content_class="custom-content" dismiss_class="custom-dismiss" indicator_class="custom-indicator">Custom Classes</.badge>

        <!-- Edge cases: custom binary values -->
        <.badge size="custom-size-value">Custom Size</.badge>
        <.badge rounded="custom-rounded-value">Custom Rounded</.badge>
        <.badge border="custom-border-value">Custom Border</.badge>
        <.badge color="custom-color" variant="custom-variant">Custom Color/Variant</.badge>
        <.badge indicator_size="custom-indicator-size" indicator>Custom Indicator Size</.badge>
      </div>
    </Layouts.app>
    """
  end
end
