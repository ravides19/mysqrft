defmodule MySqrftWeb.Test.AccordionTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Accordion

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic accordion -->
        <.accordion id="accordion-basic">
          <:item title="Item 1">Content 1</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>

        <!-- Accordion with multiple open -->
        <.accordion id="accordion-multiple" multiple>
          <:item title="Item 1">Content 1</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>

        <!-- Accordion with collapsible false -->
        <.accordion id="accordion-non-collapsible" collapsible={false}>
          <:item title="Item 1">Content 1</:item>
        </.accordion>

        <!-- Accordion with different sizes -->
        <.accordion id="accordion-xs" size="extra_small">
          <:item title="XS">Content</:item>
        </.accordion>
        <.accordion id="accordion-sm" size="small">
          <:item title="Small">Content</:item>
        </.accordion>
        <.accordion id="accordion-md" size="medium">
          <:item title="Medium">Content</:item>
        </.accordion>
        <.accordion id="accordion-lg" size="large">
          <:item title="Large">Content</:item>
        </.accordion>
        <.accordion id="accordion-xl" size="extra_large">
          <:item title="XL">Content</:item>
        </.accordion>

        <!-- Accordion with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.accordion id={"accordion-default-#{color}"} color={color}>
            <:item title={"Default #{color}"}>Content</:item>
          </.accordion>
          <.accordion id={"accordion-shadow-#{color}"} variant="shadow" color={color}>
            <:item title={"Shadow #{color}"}>Content</:item>
          </.accordion>
          <.accordion id={"accordion-bordered-#{color}"} variant="bordered" color={color}>
            <:item title={"Bordered #{color}"}>Content</:item>
          </.accordion>
          <.accordion id={"accordion-transparent-#{color}"} variant="transparent" color={color}>
            <:item title={"Transparent #{color}"}>Content</:item>
          </.accordion>
        <% end %>

        <!-- Accordion with different rounded styles -->
        <.accordion id="accordion-rounded-xs" rounded="extra_small">
          <:item title="XS Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-rounded-sm" rounded="small">
          <:item title="Small Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-rounded-md" rounded="medium">
          <:item title="Medium Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-rounded-lg" rounded="large">
          <:item title="Large Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-rounded-xl" rounded="extra_large">
          <:item title="XL Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-rounded-full" rounded="full">
          <:item title="Full Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-rounded-none" rounded="none">
          <:item title="No Rounded">Content</:item>
        </.accordion>

        <!-- Accordion with different border sizes -->
        <.accordion id="accordion-border-xs" border="extra_small">
          <:item title="XS Border">Content</:item>
        </.accordion>
        <.accordion id="accordion-border-sm" border="small">
          <:item title="Small Border">Content</:item>
        </.accordion>
        <.accordion id="accordion-border-md" border="medium">
          <:item title="Medium Border">Content</:item>
        </.accordion>
        <.accordion id="accordion-border-lg" border="large">
          <:item title="Large Border">Content</:item>
        </.accordion>
        <.accordion id="accordion-border-xl" border="extra_large">
          <:item title="XL Border">Content</:item>
        </.accordion>
        <.accordion id="accordion-border-none" border="none">
          <:item title="No Border">Content</:item>
        </.accordion>

        <!-- Accordion with different padding sizes -->
        <.accordion id="accordion-padding-xs" padding="extra_small">
          <:item title="XS Padding">Content</:item>
        </.accordion>
        <.accordion id="accordion-padding-sm" padding="small">
          <:item title="Small Padding">Content</:item>
        </.accordion>
        <.accordion id="accordion-padding-md" padding="medium">
          <:item title="Medium Padding">Content</:item>
        </.accordion>
        <.accordion id="accordion-padding-lg" padding="large">
          <:item title="Large Padding">Content</:item>
        </.accordion>
        <.accordion id="accordion-padding-xl" padding="extra_large">
          <:item title="XL Padding">Content</:item>
        </.accordion>
        <.accordion id="accordion-padding-none" padding="none">
          <:item title="No Padding">Content</:item>
        </.accordion>

        <!-- Accordion with different space sizes -->
        <.accordion id="accordion-space-xs" space="extra_small">
          <:item title="XS Space">Content</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>
        <.accordion id="accordion-space-sm" space="small">
          <:item title="Small Space">Content</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>
        <.accordion id="accordion-space-md" space="medium">
          <:item title="Medium Space">Content</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>
        <.accordion id="accordion-space-lg" space="large">
          <:item title="Large Space">Content</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>
        <.accordion id="accordion-space-xl" space="extra_large">
          <:item title="XL Space">Content</:item>
          <:item title="Item 2">Content 2</:item>
        </.accordion>

        <!-- Accordion with chevron positions -->
        <.accordion id="accordion-chevron-left" chevron_position="left">
          <:item title="Left Chevron">Content</:item>
        </.accordion>
        <.accordion id="accordion-chevron-right" chevron_position="right">
          <:item title="Right Chevron">Content</:item>
        </.accordion>
        <.accordion id="accordion-left-chevron" left_chevron>
          <:item title="Left Chevron Attr">Content</:item>
        </.accordion>
        <.accordion id="accordion-right-chevron" right_chevron>
          <:item title="Right Chevron Attr">Content</:item>
        </.accordion>
        <.accordion id="accordion-hide-chevron" hide_chevron>
          <:item title="No Chevron">Content</:item>
        </.accordion>

        <!-- Accordion with items that have icons and descriptions -->
        <.accordion id="accordion-with-icons">
          <:item title="With Icon" icon="hero-home">Content</:item>
          <:item title="With Description" description="Description text">Content</:item>
          <:item title="With Both" icon="hero-star" description="Both icon and description">Content</:item>
          <:item title="With Image" image="https://example.com/image.jpg">Content</:item>
          <:item title="With Image and Icon" image="https://example.com/image.jpg" icon="hero-star">Content</:item>
        </.accordion>

        <!-- Accordion with items that have open attribute -->
        <.accordion id="accordion-with-open">
          <:item title="Open Item" open>Content</:item>
          <:item title="Closed Item">Content</:item>
        </.accordion>

        <!-- Accordion with custom chevron icon -->
        <.accordion id="accordion-custom-chevron" chevron_icon="hero-arrow-down">
          <:item title="Custom Chevron">Content</:item>
        </.accordion>

        <!-- Accordion with initial open items -->
        <.accordion id="accordion-initial-open" initial_open={["item-1"]}>
          <:item id="item-1" title="Initially Open">Content</:item>
          <:item id="item-2" title="Initially Closed">Content</:item>
        </.accordion>

        <!-- Accordion with keep_mounted -->
        <.accordion id="accordion-keep-mounted" keep_mounted>
          <:item title="Keep Mounted">Content</:item>
        </.accordion>

        <!-- Accordion with server_events -->
        <.accordion id="accordion-server-events" server_events event_handler="handle_accordion">
          <:item title="Server Events">Content</:item>
        </.accordion>

        <!-- Accordion with custom classes -->
        <.accordion id="accordion-custom" class="custom-class" chevron_class="custom-chevron">
          <:item title="Custom" trigger_class="custom-trigger" content_class="custom-content">Content</:item>
        </.accordion>

        <!-- Edge cases: custom binary values -->
        <.accordion id="accordion-custom-size" size="custom-size-value">
          <:item title="Custom Size">Content</:item>
        </.accordion>
        <.accordion id="accordion-custom-rounded" rounded="custom-rounded-value">
          <:item title="Custom Rounded">Content</:item>
        </.accordion>
        <.accordion id="accordion-custom-border" border="custom-border-value">
          <:item title="Custom Border">Content</:item>
        </.accordion>
        <.accordion id="accordion-custom-padding" padding="custom-padding-value">
          <:item title="Custom Padding">Content</:item>
        </.accordion>
        <.accordion id="accordion-custom-space" space="custom-space-value">
          <:item title="Custom Space">Content</:item>
        </.accordion>
        <.accordion id="accordion-custom-color-variant" color="custom-color" variant="custom-variant">
          <:item title="Custom Color/Variant">Content</:item>
        </.accordion>
      </div>
    </Layouts.app>
    """
  end
end
