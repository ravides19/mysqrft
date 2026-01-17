defmodule MySqrftWeb.Components.BlockquoteIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Blockquote component integration tests renders all blockquote variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/blockquote")
    assert html =~ "Basic blockquote content"
    assert html =~ "Extra small"
    assert html =~ "Default natural"
    assert html =~ "Outline primary"
    assert html =~ "Transparent secondary"
    assert html =~ "Shadow success"
    assert html =~ "Bordered warning"
    assert html =~ "XS Border"
    assert html =~ "With Icon"
    assert html =~ "Author Name"
    assert html =~ "Left Border"
    assert html =~ "Custom Size"
  end
end
