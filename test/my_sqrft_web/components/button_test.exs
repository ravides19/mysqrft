defmodule MySqrftWeb.Components.ButtonTest do
  use ExUnit.Case, async: true

  setup do
    Code.ensure_loaded!(MySqrftWeb.Components.Button)
    :ok
  end

  describe "component functions exist" do
    test "button/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Button, :button, 1)
    end

    test "button_group/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Button, :button_group, 1)
    end

    test "input_button/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Button, :input_button, 1)
    end

    test "button_link/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Button, :button_link, 1)
    end

    test "back/1 exists" do
      assert function_exported?(MySqrftWeb.Components.Button, :back, 1)
    end
  end
end
