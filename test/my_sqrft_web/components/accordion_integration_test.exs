defmodule MySqrftWeb.Components.AccordionIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "Accordion component integration tests renders all accordion variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/accordion")
    assert html =~ "Item 1"
    assert html =~ "Content 1"
    assert html =~ "XS"
    assert html =~ "Default natural"
    assert html =~ "Shadow primary"
    assert html =~ "Bordered secondary"
    assert html =~ "XS Rounded"
    assert html =~ "XS Border"
    assert html =~ "XS Padding"
    assert html =~ "Left Chevron"
    assert html =~ "With Icon"
    assert html =~ "Custom Size"
  end
end
