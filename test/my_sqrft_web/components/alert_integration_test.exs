defmodule MySqrftWeb.Components.AlertIntegrationTest do
  use MySqrftWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "Alert component integration tests" do
    test "renders all alert variations", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/test/components/alert")

      # Basic alert renders
      assert html =~ ~r/role="alert"/

      # Flash group renders
      assert html =~ ~r/id="flash-group"/
    end
  end
end
