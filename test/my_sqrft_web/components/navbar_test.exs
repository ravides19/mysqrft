defmodule MySqrftWeb.Components.NavbarTest do
  use ExUnit.Case, async: true

  setup do
    Code.ensure_loaded!(MySqrftWeb.Components.Navbar)
    :ok
  end

  describe "component functions exist" do
    test "navbar/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Navbar, :navbar, 1)
    end

    test "header/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Navbar, :header, 1)
    end
  end
end
