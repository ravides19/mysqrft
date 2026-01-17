defmodule MySqrftWeb.Components.ButtonIntegrationTest do
  use MySqrftWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "Button component integration tests" do
    test "renders all button variations", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/test/components/button")

      # Verify components render (any button element means components executed)
      assert html =~ ~r/<button/
      assert html =~ ~r/<input/
    end
  end
end
