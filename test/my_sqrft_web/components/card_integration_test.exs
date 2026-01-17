defmodule MySqrftWeb.Components.CardIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Card component integration tests renders all card variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/card")
    assert html =~ "Basic card content"
    assert html =~ "Default natural"
    assert html =~ "Outline primary"
    assert html =~ "Shadow secondary"
    assert html =~ "Bordered success"
    assert html =~ "XS Rounded"
    assert html =~ "Card Title"
    assert html =~ "With Icon"
    assert html =~ "https://example.com/image.jpg"
    assert html =~ "Card content"
    assert html =~ "Footer"
    assert html =~ "Custom Rounded"
  end
end
