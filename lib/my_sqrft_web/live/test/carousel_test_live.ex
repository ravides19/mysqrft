defmodule MySqrftWeb.Test.CarouselTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Carousel

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic carousel -->
        <.carousel id="carousel-basic">
          <:slide image="https://example.com/slide1.jpg" title="Slide 1" />
          <:slide image="https://example.com/slide2.jpg" title="Slide 2" />
        </.carousel>

        <!-- Carousel with different sizes -->
        <.carousel id="carousel-xs" size="extra_small">
          <:slide image="https://example.com/slide1.jpg" title="XS" />
        </.carousel>
        <.carousel id="carousel-sm" size="small">
          <:slide image="https://example.com/slide1.jpg" title="Small" />
        </.carousel>
        <.carousel id="carousel-md" size="medium">
          <:slide image="https://example.com/slide1.jpg" title="Medium" />
        </.carousel>
        <.carousel id="carousel-lg" size="large">
          <:slide image="https://example.com/slide1.jpg" title="Large" />
        </.carousel>
        <.carousel id="carousel-xl" size="extra_large">
          <:slide image="https://example.com/slide1.jpg" title="XL" />
        </.carousel>

        <!-- Carousel with different padding sizes -->
        <.carousel id="carousel-padding-xs" padding="extra_small">
          <:slide image="https://example.com/slide1.jpg" title="XS Padding" />
        </.carousel>
        <.carousel id="carousel-padding-sm" padding="small">
          <:slide image="https://example.com/slide1.jpg" title="Small Padding" />
        </.carousel>
        <.carousel id="carousel-padding-md" padding="medium">
          <:slide image="https://example.com/slide1.jpg" title="Medium Padding" />
        </.carousel>
        <.carousel id="carousel-padding-lg" padding="large">
          <:slide image="https://example.com/slide1.jpg" title="Large Padding" />
        </.carousel>
        <.carousel id="carousel-padding-xl" padding="extra_large">
          <:slide image="https://example.com/slide1.jpg" title="XL Padding" />
        </.carousel>
        <.carousel id="carousel-padding-none" padding="none">
          <:slide image="https://example.com/slide1.jpg" title="No Padding" />
        </.carousel>

        <!-- Carousel with different text positions -->
        <.carousel id="carousel-text-left" text_position="left">
          <:slide image="https://example.com/slide1.jpg" title="Left" />
        </.carousel>
        <.carousel id="carousel-text-center" text_position="center">
          <:slide image="https://example.com/slide1.jpg" title="Center" />
        </.carousel>
        <.carousel id="carousel-text-right" text_position="right">
          <:slide image="https://example.com/slide1.jpg" title="Right" />
        </.carousel>

        <!-- Carousel with different overlays -->
        <.carousel id="carousel-overlay-base" overlay="base">
          <:slide image="https://example.com/slide1.jpg" title="Base Overlay" />
        </.carousel>
        <.carousel id="carousel-overlay-dark" overlay="dark">
          <:slide image="https://example.com/slide1.jpg" title="Dark Overlay" />
        </.carousel>
        <.carousel id="carousel-overlay-light" overlay="light">
          <:slide image="https://example.com/slide1.jpg" title="Light Overlay" />
        </.carousel>

        <!-- Carousel with indicator -->
        <.carousel id="carousel-indicator" indicator>
          <:slide image="https://example.com/slide1.jpg" title="With Indicator" />
          <:slide image="https://example.com/slide2.jpg" title="Slide 2" />
        </.carousel>

        <!-- Carousel without control -->
        <.carousel id="carousel-no-control" control={false}>
          <:slide image="https://example.com/slide1.jpg" title="No Control" />
        </.carousel>

        <!-- Carousel with autoplay -->
        <.carousel id="carousel-autoplay" autoplay>
          <:slide image="https://example.com/slide1.jpg" title="Autoplay" />
          <:slide image="https://example.com/slide2.jpg" title="Slide 2" />
        </.carousel>

        <!-- Carousel with active index -->
        <.carousel id="carousel-active-index" active_index={1}>
          <:slide image="https://example.com/slide1.jpg" title="Slide 1" />
          <:slide image="https://example.com/slide2.jpg" title="Slide 2" />
        </.carousel>

        <!-- Carousel with slides that have descriptions -->
        <.carousel id="carousel-with-description">
          <:slide image="https://example.com/slide1.jpg" title="Title" description="Description" />
        </.carousel>

        <!-- Carousel with slides that have navigation -->
        <.carousel id="carousel-with-navigate">
          <:slide image="https://example.com/slide1.jpg" title="Title" navigate="/" />
        </.carousel>
        <.carousel id="carousel-with-patch">
          <:slide image="https://example.com/slide1.jpg" title="Title" patch="/" />
        </.carousel>
        <.carousel id="carousel-with-href">
          <:slide image="https://example.com/slide1.jpg" title="Title" href="https://example.com" />
        </.carousel>

        <!-- Carousel with slides that have content_position -->
        <.carousel id="carousel-content-start">
          <:slide image="https://example.com/slide1.jpg" title="Title" content_position="start" />
        </.carousel>
        <.carousel id="carousel-content-center">
          <:slide image="https://example.com/slide1.jpg" title="Title" content_position="center" />
        </.carousel>
        <.carousel id="carousel-content-end">
          <:slide image="https://example.com/slide1.jpg" title="Title" content_position="end" />
        </.carousel>

        <!-- Edge cases: custom binary values -->
        <.carousel id="carousel-custom-size" size="custom-size-value">
          <:slide image="https://example.com/slide1.jpg" title="Custom Size" />
        </.carousel>
        <.carousel id="carousel-custom-padding" padding="custom-padding-value">
          <:slide image="https://example.com/slide1.jpg" title="Custom Padding" />
        </.carousel>
        <.carousel id="carousel-custom-overlay" overlay="custom-overlay-value">
          <:slide image="https://example.com/slide1.jpg" title="Custom Overlay" />
        </.carousel>
      </div>
    </Layouts.app>
    """
  end
end
