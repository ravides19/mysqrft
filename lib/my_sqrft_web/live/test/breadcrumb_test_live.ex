defmodule MySqrftWeb.Test.BreadcrumbTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Breadcrumb

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic breadcrumb -->
        <.breadcrumb>
          <:item>Home</:item>
          <:item>About</:item>
        </.breadcrumb>

        <!-- Breadcrumb with different sizes -->
        <.breadcrumb size="extra_small">
          <:item>XS</:item>
        </.breadcrumb>
        <.breadcrumb size="small">
          <:item>Small</:item>
        </.breadcrumb>
        <.breadcrumb size="medium">
          <:item>Medium</:item>
        </.breadcrumb>
        <.breadcrumb size="large">
          <:item>Large</:item>
        </.breadcrumb>
        <.breadcrumb size="extra_large">
          <:item>XL</:item>
        </.breadcrumb>

        <!-- Breadcrumb with different colors -->
        <%= for color <- ~w(base natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.breadcrumb color={color}>
            <:item>Default <%= color %></:item>
            <:item>Item 2</:item>
          </.breadcrumb>
        <% end %>

        <!-- Breadcrumb with items that have icons -->
        <.breadcrumb>
          <:item icon="hero-home">Home</:item>
          <:item icon="hero-user">User</:item>
        </.breadcrumb>

        <!-- Breadcrumb with items that have links -->
        <.breadcrumb>
          <:item link="/">Home</:item>
          <:item link="/about">About</:item>
        </.breadcrumb>

        <!-- Breadcrumb with items that have titles -->
        <.breadcrumb>
          <:item title="Home">Home</:item>
          <:item title="About">About</:item>
        </.breadcrumb>

        <!-- Breadcrumb with custom separator icon -->
        <.breadcrumb separator_icon="hero-arrow-right">
          <:item>Item 1</:item>
          <:item>Item 2</:item>
        </.breadcrumb>

        <!-- Breadcrumb with separator text -->
        <.breadcrumb separator_text="/">
          <:item>Item 1</:item>
          <:item>Item 2</:item>
        </.breadcrumb>

        <!-- Breadcrumb with custom classes -->
        <.breadcrumb class="custom-class" items_wrapper_class="custom-wrapper">
          <:item class="custom-item" icon_class="custom-icon" link_class="custom-link">Custom</:item>
        </.breadcrumb>

        <!-- Edge cases: custom binary values -->
        <.breadcrumb size="custom-size-value">
          <:item>Custom Size</:item>
        </.breadcrumb>
        <.breadcrumb color="custom-color-value">
          <:item>Custom Color</:item>
        </.breadcrumb>
      </div>
    </Layouts.app>
    """
  end
end
