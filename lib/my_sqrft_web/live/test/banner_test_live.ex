defmodule MySqrftWeb.Test.BannerTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Banner

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic banner -->
        <.banner id="banner-basic">
          <div>Basic banner content</div>
        </.banner>

        <!-- Banner with different sizes -->
        <.banner id="banner-xs" size="extra_small">
          <div>Extra small</div>
        </.banner>
        <.banner id="banner-sm" size="small">
          <div>Small</div>
        </.banner>
        <.banner id="banner-md" size="medium">
          <div>Medium</div>
        </.banner>
        <.banner id="banner-lg" size="large">
          <div>Large</div>
        </.banner>
        <.banner id="banner-xl" size="extra_large">
          <div>Extra large</div>
        </.banner>

        <!-- Banner with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.banner id={"banner-default-#{color}"} color={color}>
            <div>Default <%= color %></div>
          </.banner>
          <.banner id={"banner-shadow-#{color}"} variant="shadow" color={color}>
            <div>Shadow <%= color %></div>
          </.banner>
          <.banner id={"banner-bordered-#{color}"} variant="bordered" color={color}>
            <div>Bordered <%= color %></div>
          </.banner>
          <.banner id={"banner-outline-#{color}"} variant="outline" color={color}>
            <div>Outline <%= color %></div>
          </.banner>
          <.banner id={"banner-transparent-#{color}"} variant="transparent" color={color}>
            <div>Transparent <%= color %></div>
          </.banner>
          <.banner id={"banner-gradient-#{color}"} variant="gradient" color={color}>
            <div>Gradient <%= color %></div>
          </.banner>
        <% end %>

        <!-- Banner with different positions -->
        <.banner id="banner-top-left" vertical_position="top" position="top_left">
          <div>Top Left</div>
        </.banner>
        <.banner id="banner-top-right" vertical_position="top" position="top_right">
          <div>Top Right</div>
        </.banner>
        <.banner id="banner-bottom-left" vertical_position="bottom" position="bottom_left">
          <div>Bottom Left</div>
        </.banner>
        <.banner id="banner-bottom-right" vertical_position="bottom" position="bottom_right">
          <div>Bottom Right</div>
        </.banner>
        <.banner id="banner-center" vertical_position="top" position="center">
          <div>Center</div>
        </.banner>
        <.banner id="banner-full" vertical_position="top" position="full">
          <div>Full</div>
        </.banner>

        <!-- Banner with different border positions and sizes -->
        <.banner id="banner-border-top-xs" border="extra_small" border_position="top">
          <div>Border Top XS</div>
        </.banner>
        <.banner id="banner-border-top-sm" border="small" border_position="top">
          <div>Border Top Small</div>
        </.banner>
        <.banner id="banner-border-top-md" border="medium" border_position="top">
          <div>Border Top Medium</div>
        </.banner>
        <.banner id="banner-border-top-lg" border="large" border_position="top">
          <div>Border Top Large</div>
        </.banner>
        <.banner id="banner-border-top-xl" border="extra_large" border_position="top">
          <div>Border Top XL</div>
        </.banner>
        <.banner id="banner-border-bottom-xs" border="extra_small" border_position="bottom">
          <div>Border Bottom XS</div>
        </.banner>
        <.banner id="banner-border-bottom-sm" border="small" border_position="bottom">
          <div>Border Bottom Small</div>
        </.banner>
        <.banner id="banner-border-bottom-md" border="medium" border_position="bottom">
          <div>Border Bottom Medium</div>
        </.banner>
        <.banner id="banner-border-bottom-lg" border="large" border_position="bottom">
          <div>Border Bottom Large</div>
        </.banner>
        <.banner id="banner-border-bottom-xl" border="extra_large" border_position="bottom">
          <div>Border Bottom XL</div>
        </.banner>
        <.banner id="banner-border-full-xs" border="extra_small" border_position="full">
          <div>Border Full XS</div>
        </.banner>
        <.banner id="banner-border-full-sm" border="small" border_position="full">
          <div>Border Full Small</div>
        </.banner>
        <.banner id="banner-border-full-md" border="medium" border_position="full">
          <div>Border Full Medium</div>
        </.banner>
        <.banner id="banner-border-full-lg" border="large" border_position="full">
          <div>Border Full Large</div>
        </.banner>
        <.banner id="banner-border-full-xl" border="extra_large" border_position="full">
          <div>Border Full XL</div>
        </.banner>
        <.banner id="banner-border-none" border="none" border_position="none">
          <div>Border None</div>
        </.banner>
        <.banner id="banner-border-none-top" border="none" border_position="top">
          <div>Border None Top</div>
        </.banner>
        <.banner id="banner-border-none-bottom" border="none" border_position="bottom">
          <div>Border None Bottom</div>
        </.banner>
        <.banner id="banner-border-none-full" border="none" border_position="full">
          <div>Border None Full</div>
        </.banner>
        <!-- Banner with border and variant combinations that return nil -->
        <.banner id="banner-border-default-variant" border="extra_small" border_position="top" variant="default">
          <div>Border Default Variant</div>
        </.banner>
        <.banner id="banner-border-shadow-variant" border="extra_small" border_position="top" variant="shadow">
          <div>Border Shadow Variant</div>
        </.banner>
        <.banner id="banner-border-transparent-variant" border="extra_small" border_position="top" variant="transparent">
          <div>Border Transparent Variant</div>
        </.banner>
        <.banner id="banner-border-gradient-variant" border="extra_small" border_position="top" variant="gradient">
          <div>Border Gradient Variant</div>
        </.banner>

        <!-- Banner with different rounded positions -->
        <.banner id="banner-rounded-top-xs" rounded="extra_small" rounded_position="top">
          <div>Rounded Top XS</div>
        </.banner>
        <.banner id="banner-rounded-top-sm" rounded="small" rounded_position="top">
          <div>Rounded Top Small</div>
        </.banner>
        <.banner id="banner-rounded-top-md" rounded="medium" rounded_position="top">
          <div>Rounded Top Medium</div>
        </.banner>
        <.banner id="banner-rounded-top-lg" rounded="large" rounded_position="top">
          <div>Rounded Top Large</div>
        </.banner>
        <.banner id="banner-rounded-top-xl" rounded="extra_large" rounded_position="top">
          <div>Rounded Top XL</div>
        </.banner>
        <.banner id="banner-rounded-bottom-xs" rounded="extra_small" rounded_position="bottom">
          <div>Rounded Bottom XS</div>
        </.banner>
        <.banner id="banner-rounded-bottom-sm" rounded="small" rounded_position="bottom">
          <div>Rounded Bottom Small</div>
        </.banner>
        <.banner id="banner-rounded-bottom-md" rounded="medium" rounded_position="bottom">
          <div>Rounded Bottom Medium</div>
        </.banner>
        <.banner id="banner-rounded-bottom-lg" rounded="large" rounded_position="bottom">
          <div>Rounded Bottom Large</div>
        </.banner>
        <.banner id="banner-rounded-bottom-xl" rounded="extra_large" rounded_position="bottom">
          <div>Rounded Bottom XL</div>
        </.banner>
        <.banner id="banner-rounded-all-xs" rounded="extra_small" rounded_position="all">
          <div>Rounded All XS</div>
        </.banner>
        <.banner id="banner-rounded-all-sm" rounded="small" rounded_position="all">
          <div>Rounded All Small</div>
        </.banner>
        <.banner id="banner-rounded-all-md" rounded="medium" rounded_position="all">
          <div>Rounded All Medium</div>
        </.banner>
        <.banner id="banner-rounded-all-lg" rounded="large" rounded_position="all">
          <div>Rounded All Large</div>
        </.banner>
        <.banner id="banner-rounded-all-xl" rounded="extra_large" rounded_position="all">
          <div>Rounded All XL</div>
        </.banner>
        <.banner id="banner-rounded-all-full" rounded="full" rounded_position="all">
          <div>Rounded All Full</div>
        </.banner>
        <.banner id="banner-rounded-none" rounded_position="none">
          <div>Rounded None</div>
        </.banner>

        <!-- Banner with different border sizes -->
        <.banner id="banner-border-xs" border="extra_small">
          <div>XS Border</div>
        </.banner>
        <.banner id="banner-border-sm" border="small">
          <div>Small Border</div>
        </.banner>
        <.banner id="banner-border-md" border="medium">
          <div>Medium Border</div>
        </.banner>
        <.banner id="banner-border-lg" border="large">
          <div>Large Border</div>
        </.banner>
        <.banner id="banner-border-xl" border="extra_large">
          <div>XL Border</div>
        </.banner>
        <.banner id="banner-border-none" border="none">
          <div>No Border</div>
        </.banner>

        <!-- Banner with different rounded styles -->
        <.banner id="banner-rounded-xs" rounded="extra_small">
          <div>XS Rounded</div>
        </.banner>
        <.banner id="banner-rounded-sm" rounded="small">
          <div>Small Rounded</div>
        </.banner>
        <.banner id="banner-rounded-md" rounded="medium">
          <div>Medium Rounded</div>
        </.banner>
        <.banner id="banner-rounded-lg" rounded="large">
          <div>Large Rounded</div>
        </.banner>
        <.banner id="banner-rounded-xl" rounded="extra_large">
          <div>XL Rounded</div>
        </.banner>
        <.banner id="banner-rounded-full" rounded="full">
          <div>Full Rounded</div>
        </.banner>
        <.banner id="banner-rounded-none" rounded="none">
          <div>No Rounded</div>
        </.banner>

        <!-- Banner with different space sizes -->
        <.banner id="banner-space-none" space="none">
          <div>No Space</div>
          <div>Item 2</div>
        </.banner>
        <.banner id="banner-space-xs" space="extra_small">
          <div>XS Space</div>
          <div>Item 2</div>
        </.banner>
        <.banner id="banner-space-sm" space="small">
          <div>Small Space</div>
          <div>Item 2</div>
        </.banner>
        <.banner id="banner-space-md" space="medium">
          <div>Medium Space</div>
          <div>Item 2</div>
        </.banner>
        <.banner id="banner-space-lg" space="large">
          <div>Large Space</div>
          <div>Item 2</div>
        </.banner>
        <.banner id="banner-space-xl" space="extra_large">
          <div>XL Space</div>
          <div>Item 2</div>
        </.banner>

        <!-- Banner with dismiss -->
        <.banner id="banner-dismiss" right_dismiss>
          <div>Dismissable Banner</div>
        </.banner>
        <.banner id="banner-dismiss-left" left_dismiss>
          <div>Dismissable Banner Left</div>
        </.banner>
        <.banner id="banner-hide-dismiss" hide_dismiss>
          <div>Hide Dismiss</div>
        </.banner>

        <!-- Banner with vertical_size -->
        <.banner id="banner-vertical-size-none" vertical_size="none">
          <div>Vertical Size None</div>
        </.banner>
        <.banner id="banner-vertical-size-xs" vertical_size="extra_small">
          <div>Vertical Size XS</div>
        </.banner>
        <.banner id="banner-vertical-size-sm" vertical_size="small">
          <div>Vertical Size Small</div>
        </.banner>
        <.banner id="banner-vertical-size-md" vertical_size="medium">
          <div>Vertical Size Medium</div>
        </.banner>
        <.banner id="banner-vertical-size-lg" vertical_size="large">
          <div>Vertical Size Large</div>
        </.banner>
        <.banner id="banner-vertical-size-xl" vertical_size="extra_large">
          <div>Vertical Size XL</div>
        </.banner>
        <.banner id="banner-vertical-size-top-24" vertical_size="top-24">
          <div>Vertical Size Top 24</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-24" vertical_position="bottom" vertical_size="bottom-24">
          <div>Vertical Size Bottom 24</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-none" vertical_position="bottom" vertical_size="none">
          <div>Vertical Size Bottom None</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-xs" vertical_position="bottom" vertical_size="extra_small">
          <div>Vertical Size Bottom XS</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-sm" vertical_position="bottom" vertical_size="small">
          <div>Vertical Size Bottom Small</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-md" vertical_position="bottom" vertical_size="medium">
          <div>Vertical Size Bottom Medium</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-lg" vertical_position="bottom" vertical_size="large">
          <div>Vertical Size Bottom Large</div>
        </.banner>
        <.banner id="banner-vertical-size-bottom-xl" vertical_position="bottom" vertical_size="extra_large">
          <div>Vertical Size Bottom XL</div>
        </.banner>

        <!-- Banner with position_size -->
        <.banner id="banner-position-size-none" position_size="none">
          <div>Position Size None</div>
        </.banner>
        <.banner id="banner-position-size-xs" position_size="extra_small">
          <div>Position Size XS</div>
        </.banner>
        <.banner id="banner-position-size-sm" position_size="small">
          <div>Position Size Small</div>
        </.banner>
        <.banner id="banner-position-size-md" position_size="medium">
          <div>Position Size Medium</div>
        </.banner>
        <.banner id="banner-position-size-lg" position_size="large">
          <div>Position Size Large</div>
        </.banner>
        <.banner id="banner-position-size-xl" position_size="extra_large">
          <div>Position Size XL</div>
        </.banner>
        <.banner id="banner-position-size-left-4" position_size="left-4">
          <div>Position Size Left 4</div>
        </.banner>
        <.banner id="banner-position-size-right-4" position_size="right-4">
          <div>Position Size Right 4</div>
        </.banner>
        <.banner id="banner-position-top-left-none" position="top_left" position_size="none">
          <div>Top Left None</div>
        </.banner>
        <.banner id="banner-position-top-left-xs" position="top_left" position_size="extra_small">
          <div>Top Left XS</div>
        </.banner>
        <.banner id="banner-position-top-right-none" position="top_right" position_size="none">
          <div>Top Right None</div>
        </.banner>
        <.banner id="banner-position-top-right-xs" position="top_right" position_size="extra_small">
          <div>Top Right XS</div>
        </.banner>
        <.banner id="banner-position-bottom-left-none" position="bottom_left" position_size="none">
          <div>Bottom Left None</div>
        </.banner>
        <.banner id="banner-position-bottom-left-xs" position="bottom_left" position_size="extra_small">
          <div>Bottom Left XS</div>
        </.banner>
        <.banner id="banner-position-bottom-right-none" position="bottom_right" position_size="none">
          <div>Bottom Right None</div>
        </.banner>
        <.banner id="banner-position-bottom-right-xs" position="bottom_right" position_size="extra_small">
          <div>Bottom Right XS</div>
        </.banner>
        <.banner id="banner-position-center" position="center">
          <div>Center Position</div>
        </.banner>
        <.banner id="banner-position-full" position="full">
          <div>Full Position</div>
        </.banner>

        <!-- Banner with dismiss_size -->
        <.banner id="banner-dismiss-xs" dismiss_size="extra_small">
          <div>Dismiss XS</div>
        </.banner>
        <.banner id="banner-dismiss-sm" dismiss_size="small">
          <div>Dismiss Small</div>
        </.banner>
        <.banner id="banner-dismiss-md" dismiss_size="medium">
          <div>Dismiss Medium</div>
        </.banner>
        <.banner id="banner-dismiss-lg" dismiss_size="large">
          <div>Dismiss Large</div>
        </.banner>
        <.banner id="banner-dismiss-xl" dismiss_size="extra_large">
          <div>Dismiss XL</div>
        </.banner>

        <!-- Banner with font_weight -->
        <.banner id="banner-font-bold" font_weight="font-bold">
          <div>Bold Font</div>
        </.banner>
        <.banner id="banner-font-semibold" font_weight="font-semibold">
          <div>Semibold Font</div>
        </.banner>

        <!-- Banner with params -->
        <.banner id="banner-params" params={%{kind: "custom"}}>
          <div>Custom Params</div>
        </.banner>


        <!-- Edge cases: custom binary values -->
        <.banner id="banner-custom-size" size="custom-size-value">
          <div>Custom Size</div>
        </.banner>
        <.banner id="banner-custom-rounded" rounded="custom-rounded-value">
          <div>Custom Rounded</div>
        </.banner>
        <.banner id="banner-custom-border" border="custom-border-value">
          <div>Custom Border</div>
        </.banner>
        <.banner id="banner-custom-space" space="custom-space-value">
          <div>Custom Space</div>
        </.banner>
        <.banner id="banner-custom-color-variant" color="custom-color" variant="custom-variant">
          <div>Custom Color/Variant</div>
        </.banner>
        <.banner id="banner-custom-vertical-size" vertical_size="custom-vertical-size">
          <div>Custom Vertical Size</div>
        </.banner>
        <.banner id="banner-custom-position-size" position_size="custom-position-size">
          <div>Custom Position Size</div>
        </.banner>
        <.banner id="banner-custom-dismiss-size" dismiss_size="custom-dismiss-size">
          <div>Custom Dismiss Size</div>
        </.banner>
        <.banner id="banner-custom-padding" padding="custom-padding-value">
          <div>Custom Padding</div>
        </.banner>
      </div>
    </Layouts.app>
    """
  end
end
