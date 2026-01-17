defmodule MySqrftWeb.Components.NavbarIntegrationTest do
  use MySqrftWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "Navbar component integration tests" do
    test "renders all navbar variations", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/test/components/navbar")

      # Basic navbar
      assert html =~ ~r/id="navbar-basic"/
      assert html =~ ~r/role="navigation"/

      # Verify key navbars render
      assert html =~ ~r/id="navbar-name"/
      assert html =~ ~r/id="navbar-image"/

      # All color variants
      for color <- ["natural", "primary", "secondary", "success", "warning", "danger", "info", "misc", "dawn", "silver", "white", "dark"] do
        assert html =~ ~r/id="navbar-#{color}"/
      end

      # All variant styles
      for variant <- ["base", "shadow", "bordered", "gradient"] do
        assert html =~ ~r/id="navbar-#{variant}"/
      end

      # Content positions
      for position <- ["start", "end", "center", "between", "around"] do
        assert html =~ ~r/id="navbar-#{position}"/
      end
    end
  end
end
