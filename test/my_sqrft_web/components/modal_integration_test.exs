defmodule MySqrftWeb.Components.ModalIntegrationTest do
  use MySqrftWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "Modal component integration tests" do
    test "renders all modal variations", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/test/components/modal")

      # Verify key modals render
      assert html =~ ~r/id="modal-basic"/
      assert html =~ ~r/id="modal-title"/
      assert html =~ ~r/id="modal-show"/

      # Verify all color variants render
      for color <- ["natural", "primary", "secondary", "success", "warning", "danger", "info", "misc", "dawn", "silver", "white", "dark"] do
        assert html =~ ~r/id="modal-#{color}"/
      end

      # Verify all variant styles render
      for variant <- ["base", "shadow", "bordered", "gradient"] do
        assert html =~ ~r/id="modal-#{variant}"/
      end

      # Verify all sizes render
      for size <- ["xs", "sm", "md", "lg", "xl"] do
        assert html =~ ~r/id="modal-#{size}"/
      end

      # Verify role and aria attributes
      assert html =~ ~r/role="dialog"/
      assert html =~ ~r/aria-modal="true"/
    end
  end
end
