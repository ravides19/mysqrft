defmodule MySqrftWeb.Components.CheckboxCardIntegrationTest do
  use MySqrftWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "CheckboxCard component integration tests renders all checkbox card variations", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/test/components/checkbox-card")
    assert html =~ "Basic Plan"
    assert html =~ "Pro Plan"
    assert html =~ "XS"
    assert html =~ "Default natural"
    assert html =~ "Outline primary"
    assert html =~ "Shadow secondary"
    assert html =~ "Bordered success"
    assert html =~ "XS Border"
    assert html =~ "XS Rounded"
    assert html =~ "Reverse"
    assert html =~ "Show Checkbox"
    assert html =~ "Select Plan"
    assert html =~ "Checkbox Icon"
    assert html =~ "Custom Size"
  end
end
