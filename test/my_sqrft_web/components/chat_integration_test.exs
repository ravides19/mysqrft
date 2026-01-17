defmodule MySqrftWeb.Components.ChatIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Chat component integration tests renders all chat variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/chat")
    assert html =~ "Basic chat message"
    assert html =~ "Normal position"
    assert html =~ "Flipped position"
    assert html =~ "XS"
    assert html =~ "Default natural"
    assert html =~ "Outline primary"
    assert html =~ "Shadow secondary"
    assert html =~ "Bordered success"
    assert html =~ "XS Border"
    assert html =~ "Chat section content"
    assert html =~ "Delivered"
    assert html =~ "Metadata"
    assert html =~ "Custom Size"
  end
end
