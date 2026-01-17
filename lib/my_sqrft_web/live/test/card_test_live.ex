defmodule MySqrftWeb.Test.CardTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Card

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic card -->
        <.card>
          <p>Basic card content</p>
        </.card>

        <!-- Card with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.card color={color}>
            <p>Default <%= color %></p>
          </.card>
          <.card variant="outline" color={color}>
            <p>Outline <%= color %></p>
          </.card>
          <.card variant="shadow" color={color}>
            <p>Shadow <%= color %></p>
          </.card>
          <.card variant="bordered" color={color}>
            <p>Bordered <%= color %></p>
          </.card>
        <% end %>

        <!-- Card with different rounded styles -->
        <.card rounded="extra_small">
          <p>XS Rounded</p>
        </.card>
        <.card rounded="small">
          <p>Small Rounded</p>
        </.card>
        <.card rounded="medium">
          <p>Medium Rounded</p>
        </.card>
        <.card rounded="large">
          <p>Large Rounded</p>
        </.card>
        <.card rounded="extra_large">
          <p>XL Rounded</p>
        </.card>
        <.card rounded="full">
          <p>Full Rounded</p>
        </.card>
        <.card rounded="none">
          <p>No Rounded</p>
        </.card>

        <!-- Card with different border sizes -->
        <.card border="extra_small">
          <p>XS Border</p>
        </.card>
        <.card border="small">
          <p>Small Border</p>
        </.card>
        <.card border="medium">
          <p>Medium Border</p>
        </.card>
        <.card border="large">
          <p>Large Border</p>
        </.card>
        <.card border="extra_large">
          <p>XL Border</p>
        </.card>
        <.card border="none">
          <p>No Border</p>
        </.card>

        <!-- Card with different padding sizes -->
        <.card padding="extra_small">
          <p>XS Padding</p>
        </.card>
        <.card padding="small">
          <p>Small Padding</p>
        </.card>
        <.card padding="medium">
          <p>Medium Padding</p>
        </.card>
        <.card padding="large">
          <p>Large Padding</p>
        </.card>
        <.card padding="extra_large">
          <p>XL Padding</p>
        </.card>
        <.card padding="none">
          <p>No Padding</p>
        </.card>

        <!-- Card with different space sizes -->
        <.card space="extra_small">
          <p>XS Space</p>
          <p>Item 2</p>
        </.card>
        <.card space="small">
          <p>Small Space</p>
          <p>Item 2</p>
        </.card>
        <.card space="medium">
          <p>Medium Space</p>
          <p>Item 2</p>
        </.card>
        <.card space="large">
          <p>Large Space</p>
          <p>Item 2</p>
        </.card>
        <.card space="extra_large">
          <p>XL Space</p>
          <p>Item 2</p>
        </.card>

        <!-- Card with card_title -->
        <.card>
          <.card_title title="Card Title" />
          <p>Content</p>
        </.card>
        <.card>
          <.card_title title="With Icon" icon="hero-star" />
          <p>Content</p>
        </.card>
        <.card>
          <.card_title position="start">Start Position</.card_title>
          <p>Content</p>
        </.card>
        <.card>
          <.card_title position="center">Center Position</.card_title>
          <p>Content</p>
        </.card>
        <.card>
          <.card_title position="end">End Position</.card_title>
          <p>Content</p>
        </.card>
        <.card>
          <.card_title position="between">Between Position</.card_title>
          <p>Content</p>
        </.card>
        <.card>
          <.card_title position="around">Around Position</.card_title>
          <p>Content</p>
        </.card>

        <!-- Card with card_media -->
        <.card>
          <.card_media src="https://example.com/image.jpg" alt="Image" />
          <p>Content</p>
        </.card>
        <.card>
          <.card_media src="https://example.com/image.jpg" alt="Image" rounded="large" />
          <p>Content</p>
        </.card>

        <!-- Card with card_content -->
        <.card>
          <.card_content>
            <p>Card content</p>
          </.card_content>
        </.card>
        <.card>
          <.card_content padding="large">
            <p>Card content with padding</p>
          </.card_content>
        </.card>

        <!-- Card with card_footer -->
        <.card>
          <p>Content</p>
          <.card_footer>
            <p>Footer</p>
          </.card_footer>
        </.card>
        <.card>
          <p>Content</p>
          <.card_footer padding="large">
            <p>Footer with padding</p>
          </.card_footer>
        </.card>

        <!-- Edge cases: custom binary values -->
        <.card rounded="custom-rounded-value">
          <p>Custom Rounded</p>
        </.card>
        <.card border="custom-border-value">
          <p>Custom Border</p>
        </.card>
        <.card padding="custom-padding-value">
          <p>Custom Padding</p>
        </.card>
        <.card space="custom-space-value">
          <p>Custom Space</p>
        </.card>
        <.card color="custom-color" variant="custom-variant">
          <p>Custom Color/Variant</p>
        </.card>
      </div>
    </Layouts.app>
    """
  end
end
