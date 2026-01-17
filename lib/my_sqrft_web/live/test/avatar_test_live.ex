defmodule MySqrftWeb.Test.AvatarTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Avatar

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic avatar -->
        <.avatar />

        <!-- Avatar with src -->
        <.avatar src="https://example.com/avatar.jpg" />

        <!-- Avatar with different sizes -->
        <.avatar size="extra_small" />
        <.avatar size="small" />
        <.avatar size="medium" />
        <.avatar size="large" />
        <.avatar size="extra_large" />

        <!-- Avatar with different colors -->
        <%= for color <- ~w(transparent natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.avatar color={color} />
        <% end %>

        <!-- Avatar with different rounded styles -->
        <.avatar rounded="extra_small" />
        <.avatar rounded="small" />
        <.avatar rounded="medium" />
        <.avatar rounded="large" />
        <.avatar rounded="extra_large" />
        <.avatar rounded="full" />
        <.avatar rounded="none" />

        <!-- Avatar with different border sizes -->
        <.avatar border="extra_small" />
        <.avatar border="small" />
        <.avatar border="medium" />
        <.avatar border="large" />
        <.avatar border="extra_large" />
        <.avatar border="none" />

        <!-- Avatar with different shadow styles -->
        <.avatar shadow="none" />
        <.avatar shadow="small" />
        <.avatar shadow="medium" />
        <.avatar shadow="large" />
        <.avatar shadow="extra_large" />

        <!-- Avatar with icon slot -->
        <.avatar>
          <:icon name="hero-user" />
        </.avatar>

        <!-- Avatar with inner block -->
        <.avatar>AB</.avatar>

        <!-- Avatar with src and rounded full -->
        <.avatar src="https://example.com/avatar.jpg" rounded="full" />

        <!-- Avatar group -->
        <.avatar_group>
          <.avatar src="https://example.com/1.jpg" />
          <.avatar src="https://example.com/2.jpg" />
          <.avatar src="https://example.com/3.jpg" />
        </.avatar_group>

        <!-- Edge cases: custom binary values -->
        <.avatar size="custom-size-value" />
        <.avatar rounded="custom-rounded-value" />
        <.avatar border="custom-border-value" />
        <.avatar shadow="custom-shadow-value" />
        <.avatar color="custom-color-value" />
        <.avatar class="custom-class" />
      </div>
    </Layouts.app>
    """
  end
end
