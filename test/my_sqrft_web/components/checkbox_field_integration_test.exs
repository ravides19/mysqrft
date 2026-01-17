defmodule MySqrftWeb.Components.CheckboxFieldIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "CheckboxField component integration tests renders all checkbox field variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/checkbox-field")
    assert html =~ "accept"
    assert html =~ "primary"
    assert html =~ "secondary"
    assert html =~ "success"
    assert html =~ "Accept Terms"
    assert html =~ "Reverse"
    assert html =~ "Sports"
    assert html =~ "Music"
  end
end
