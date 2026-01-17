defmodule MySqrftWeb.Components.BadgeIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Badge component integration tests renders all badge variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/badge")
    assert html =~ "Badge"
    assert html =~ "XS"
    assert html =~ "Default natural"
    assert html =~ "Outline primary"
    assert html =~ "Shadow success"
    assert html =~ "Bordered warning"
    assert html =~ "Gradient danger"
    assert html =~ "XS Rounded"
    assert html =~ "With Icon"
    assert html =~ "Indicator"
    assert html =~ "Dismiss"
    assert html =~ "Pinging"
    assert html =~ "Custom Size"
  end
end
