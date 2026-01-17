defmodule MySqrftWeb.Components.CarouselIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Carousel component integration tests renders all carousel variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/carousel")
    assert html =~ "Slide 1"
    assert html =~ "Slide 2"
    assert html =~ "XS"
    assert html =~ "XS Padding"
    assert html =~ "Left"
    assert html =~ "Center"
    assert html =~ "Right"
    assert html =~ "Base Overlay"
    assert html =~ "With Indicator"
    assert html =~ "Autoplay"
    assert html =~ "Custom Size"
  end
end
