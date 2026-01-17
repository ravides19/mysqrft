defmodule MySqrftWeb.Components.AvatarIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Avatar component integration tests renders all avatar variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/avatar")
    assert html =~ "https://example.com/avatar.jpg"
    assert html =~ "AB"
    assert html =~ "https://example.com/1.jpg"
    assert html =~ "transparent"
    assert html =~ "natural"
    assert html =~ "primary"
  end
end
