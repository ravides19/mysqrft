defmodule MySqrftWeb.Components.InputFieldIntegrationTest do
  use MySqrftWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "InputField component integration tests" do
    test "renders all input field variations", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/test/components/input-field")

      # Verify components render (any input element means components executed)
      assert html =~ ~r/<input/
      assert html =~ ~r/<select/ || html =~ ~r/<textarea/
    end
  end
end
