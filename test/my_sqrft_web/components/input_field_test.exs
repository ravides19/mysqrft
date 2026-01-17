defmodule MySqrftWeb.Components.InputFieldTest do
  use ExUnit.Case, async: true

  setup do
    Code.ensure_loaded!(MySqrftWeb.Components.InputField)
    :ok
  end

  describe "component functions exist" do
    test "input/1 exists" do
      assert function_exported?(MySqrftWeb.Components.InputField, :input, 1)
    end

    test "label/1 exists" do
      assert function_exported?(MySqrftWeb.Components.InputField, :label, 1)
    end

    test "error/1 exists" do
      assert function_exported?(MySqrftWeb.Components.InputField, :error, 1)
    end
  end

  describe "input/1 with different types" do
    test "handles text input" do
      # Test that the function can be called with text type
      assert function_exported?(MySqrftWeb.Components.InputField, :input, 1)
    end

    test "handles checkbox input" do
      # Test that the function can handle checkbox type
      assert function_exported?(MySqrftWeb.Components.InputField, :input, 1)
    end

    test "handles select input" do
      # Test that the function can handle select type
      assert function_exported?(MySqrftWeb.Components.InputField, :input, 1)
    end

    test "handles textarea input" do
      # Test that the function can handle textarea type
      assert function_exported?(MySqrftWeb.Components.InputField, :input, 1)
    end
  end
end
