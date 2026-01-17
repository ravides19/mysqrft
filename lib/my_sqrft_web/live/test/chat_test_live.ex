defmodule MySqrftWeb.Test.ChatTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Chat

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic chat -->
        <.chat>
          <p>Basic chat message</p>
        </.chat>

        <!-- Chat with different positions -->
        <.chat position="normal">
          <p>Normal position</p>
        </.chat>
        <.chat position="flipped">
          <p>Flipped position</p>
        </.chat>

        <!-- Chat with different sizes -->
        <.chat size="extra_small">
          <p>XS</p>
        </.chat>
        <.chat size="small">
          <p>Small</p>
        </.chat>
        <.chat size="medium">
          <p>Medium</p>
        </.chat>
        <.chat size="large">
          <p>Large</p>
        </.chat>
        <.chat size="extra_large">
          <p>XL</p>
        </.chat>

        <!-- Chat with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.chat color={color}>
            <p>Default <%= color %></p>
          </.chat>
          <.chat variant="outline" color={color}>
            <p>Outline <%= color %></p>
          </.chat>
          <.chat variant="shadow" color={color}>
            <p>Shadow <%= color %></p>
          </.chat>
          <.chat variant="bordered" color={color}>
            <p>Bordered <%= color %></p>
          </.chat>
        <% end %>

        <!-- Chat with different border sizes -->
        <.chat border="extra_small">
          <p>XS Border</p>
        </.chat>
        <.chat border="small">
          <p>Small Border</p>
        </.chat>
        <.chat border="medium">
          <p>Medium Border</p>
        </.chat>
        <.chat border="large">
          <p>Large Border</p>
        </.chat>
        <.chat border="extra_large">
          <p>XL Border</p>
        </.chat>
        <.chat border="none">
          <p>No Border</p>
        </.chat>

        <!-- Chat with different rounded styles -->
        <.chat rounded="extra_small">
          <p>XS Rounded</p>
        </.chat>
        <.chat rounded="small">
          <p>Small Rounded</p>
        </.chat>
        <.chat rounded="medium">
          <p>Medium Rounded</p>
        </.chat>
        <.chat rounded="large">
          <p>Large Rounded</p>
        </.chat>
        <.chat rounded="extra_large">
          <p>XL Rounded</p>
        </.chat>
        <.chat rounded="full">
          <p>Full Rounded</p>
        </.chat>
        <.chat rounded="none">
          <p>No Rounded</p>
        </.chat>

        <!-- Chat with different padding sizes -->
        <.chat padding="extra_small">
          <p>XS Padding</p>
        </.chat>
        <.chat padding="small">
          <p>Small Padding</p>
        </.chat>
        <.chat padding="medium">
          <p>Medium Padding</p>
        </.chat>
        <.chat padding="large">
          <p>Large Padding</p>
        </.chat>
        <.chat padding="extra_large">
          <p>XL Padding</p>
        </.chat>
        <.chat padding="none">
          <p>No Padding</p>
        </.chat>

        <!-- Chat with different space sizes -->
        <.chat space="extra_small">
          <p>XS Space</p>
          <p>Item 2</p>
        </.chat>
        <.chat space="small">
          <p>Small Space</p>
          <p>Item 2</p>
        </.chat>
        <.chat space="medium">
          <p>Medium Space</p>
          <p>Item 2</p>
        </.chat>
        <.chat space="large">
          <p>Large Space</p>
          <p>Item 2</p>
        </.chat>
        <.chat space="extra_large">
          <p>XL Space</p>
          <p>Item 2</p>
        </.chat>

        <!-- Chat with chat_section -->
        <.chat>
          <.chat_section>
            <p>Chat section content</p>
          </.chat_section>
        </.chat>
        <.chat>
          <.chat_section>
            <p>Content</p>
            <:status time="10:00" deliver="Delivered" />
          </.chat_section>
        </.chat>
        <.chat>
          <.chat_section>
            <p>Content</p>
            <:meta>Metadata</:meta>
          </.chat_section>
        </.chat>

        <!-- Edge cases: custom binary values -->
        <.chat size="custom-size-value">
          <p>Custom Size</p>
        </.chat>
        <.chat rounded="custom-rounded-value">
          <p>Custom Rounded</p>
        </.chat>
        <.chat border="custom-border-value">
          <p>Custom Border</p>
        </.chat>
        <.chat padding="custom-padding-value">
          <p>Custom Padding</p>
        </.chat>
        <.chat space="custom-space-value">
          <p>Custom Space</p>
        </.chat>
        <.chat color="custom-color" variant="custom-variant">
          <p>Custom Color/Variant</p>
        </.chat>
      </div>
    </Layouts.app>
    """
  end
end
