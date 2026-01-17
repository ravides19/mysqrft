defmodule MySqrftWeb.Components.BannerIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Banner component integration tests renders all banner variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/banner")
    assert html =~ "Basic banner content"
    assert html =~ "Extra small"
    assert html =~ "Default natural"
    assert html =~ "Shadow primary"
    assert html =~ "Bordered secondary"
    assert html =~ "Top Left"
    assert html =~ "Bottom Right"
    assert html =~ "Border Top"
    assert html =~ "Rounded Top"
    assert html =~ "XS Border"
    assert html =~ "Custom Size"
  end
end
