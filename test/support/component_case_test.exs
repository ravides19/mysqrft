defmodule MySqrftWeb.ComponentCaseTest do
  use ExUnit.Case, async: true
  alias MySqrftWeb.ComponentCase

  defmodule TestComponent do
    use Phoenix.Component

    def test_component(assigns) do
      ~H"""
      <div id="test-component">
        {render_slot(@inner_block)}
      </div>
      """
    end
  end

  test "ComponentCase module exists and has render_component/2 function" do
    assert function_exported?(ComponentCase, :render_component, 2)
  end

  test "ComponentCase module has inner_block/1 function" do
    assert function_exported?(ComponentCase, :inner_block, 1)
  end

  test "render_component/2 renders a component with assigns" do
    html = ComponentCase.render_component(&TestComponent.test_component/1, %{inner_block: ComponentCase.inner_block("Test Content")})
    assert html =~ "test-component"
    assert html =~ "Test Content"
  end

  test "render_component/2 handles component without inner_block" do
    html = ComponentCase.render_component(&TestComponent.test_component/1, %{})
    assert html =~ "test-component"
  end

  test "inner_block/1 with binary content returns a function" do
    block = ComponentCase.inner_block("Test")
    assert is_function(block, 2)
    # Call it to ensure it works (render_slot calls with 2 args)
    result = block.(%{}, nil)
    assert result == Phoenix.HTML.raw("Test")
  end

  test "inner_block/1 with function template returns a wrapped function" do
    template = fn assigns -> assigns end
    block = ComponentCase.inner_block(template)
    assert is_function(block, 2)
    # The wrapped function should call the original template
    result = block.(%{test: "value"}, nil)
    assert result == %{test: "value"}
  end
end
