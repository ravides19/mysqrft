defmodule MySqrftWeb.Components.BreadcrumbIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Breadcrumb component integration tests renders all breadcrumb variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/breadcrumb")
    assert html =~ "Home"
    assert html =~ "About"
    assert html =~ "XS"
    assert html =~ "Default base"
    assert html =~ "Default natural"
    assert html =~ "Default primary"
    assert html =~ "Item 1"
    assert html =~ "Item 2"
    assert html =~ "Custom Size"
  end
end
