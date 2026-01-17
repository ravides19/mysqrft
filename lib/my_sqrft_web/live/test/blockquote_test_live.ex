defmodule MySqrftWeb.Test.BlockquoteTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Blockquote

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic blockquote -->
        <.blockquote>
          <p>Basic blockquote content</p>
        </.blockquote>

        <!-- Blockquote with different sizes -->
        <.blockquote size="extra_small">
          <p>Extra small</p>
        </.blockquote>
        <.blockquote size="small">
          <p>Small</p>
        </.blockquote>
        <.blockquote size="medium">
          <p>Medium</p>
        </.blockquote>
        <.blockquote size="large">
          <p>Large</p>
        </.blockquote>
        <.blockquote size="extra_large">
          <p>Extra large</p>
        </.blockquote>

        <!-- Blockquote with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.blockquote color={color}>
            <p>Default <%= color %></p>
          </.blockquote>
          <.blockquote variant="outline" color={color}>
            <p>Outline <%= color %></p>
          </.blockquote>
          <.blockquote variant="transparent" color={color}>
            <p>Transparent <%= color %></p>
          </.blockquote>
          <.blockquote variant="shadow" color={color}>
            <p>Shadow <%= color %></p>
          </.blockquote>
          <.blockquote variant="bordered" color={color}>
            <p>Bordered <%= color %></p>
          </.blockquote>
        <% end %>

        <!-- Blockquote with different border sizes -->
        <.blockquote border="extra_small">
          <p>XS Border</p>
        </.blockquote>
        <.blockquote border="small">
          <p>Small Border</p>
        </.blockquote>
        <.blockquote border="medium">
          <p>Medium Border</p>
        </.blockquote>
        <.blockquote border="large">
          <p>Large Border</p>
        </.blockquote>
        <.blockquote border="extra_large">
          <p>XL Border</p>
        </.blockquote>
        <.blockquote border="none">
          <p>No Border</p>
        </.blockquote>

        <!-- Blockquote with different rounded styles -->
        <.blockquote rounded="extra_small">
          <p>XS Rounded</p>
        </.blockquote>
        <.blockquote rounded="small">
          <p>Small Rounded</p>
        </.blockquote>
        <.blockquote rounded="medium">
          <p>Medium Rounded</p>
        </.blockquote>
        <.blockquote rounded="large">
          <p>Large Rounded</p>
        </.blockquote>
        <.blockquote rounded="extra_large">
          <p>XL Rounded</p>
        </.blockquote>
        <.blockquote rounded="full">
          <p>Full Rounded</p>
        </.blockquote>
        <.blockquote rounded="none">
          <p>No Rounded</p>
        </.blockquote>

        <!-- Blockquote with icon -->
        <.blockquote icon="hero-quote">
          <p>With Icon</p>
        </.blockquote>
        <.blockquote icon="hero-quote" hide_icon>
          <p>Hide Icon</p>
        </.blockquote>

        <!-- Blockquote with caption -->
        <.blockquote>
          <p>Content</p>
          <:caption>Author Name</:caption>
        </.blockquote>
        <.blockquote>
          <p>Content</p>
          <:caption image="https://example.com/avatar.jpg">Author with Image</:caption>
        </.blockquote>
        <.blockquote>
          <p>Content</p>
          <:caption position="left">Left Caption</:caption>
        </.blockquote>
        <.blockquote>
          <p>Content</p>
          <:caption position="right">Right Caption</:caption>
        </.blockquote>

        <!-- Blockquote with border attributes -->
        <.blockquote left_border>
          <p>Left Border</p>
        </.blockquote>
        <.blockquote right_border>
          <p>Right Border</p>
        </.blockquote>
        <.blockquote hide_border>
          <p>Hide Border</p>
        </.blockquote>
        <.blockquote full_border>
          <p>Full Border</p>
        </.blockquote>

        <!-- Edge cases: custom binary values -->
        <.blockquote size="custom-size-value">
          <p>Custom Size</p>
        </.blockquote>
        <.blockquote rounded="custom-rounded-value">
          <p>Custom Rounded</p>
        </.blockquote>
        <.blockquote border="custom-border-value">
          <p>Custom Border</p>
        </.blockquote>
        <.blockquote color="custom-color" variant="custom-variant">
          <p>Custom Color/Variant</p>
        </.blockquote>
      </div>
    </Layouts.app>
    """
  end
end
