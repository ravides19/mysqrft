defmodule MySqrftWeb.Components.ModalTest do
  use ExUnit.Case, async: true

  import MySqrftWeb.Components.Modal

  describe "show_modal/2" do
    test "returns JS commands" do
      js = show_modal("test-modal")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "works with JS parameter" do
      js = %Phoenix.LiveView.JS{}
      result = show_modal(js, "test-modal")
      assert %Phoenix.LiveView.JS{} = result
    end
  end

  describe "hide_modal/2" do
    test "returns JS commands" do
      js = hide_modal("test-modal")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "works with JS parameter" do
      js = %Phoenix.LiveView.JS{}
      result = hide_modal(js, "test-modal")
      assert %Phoenix.LiveView.JS{} = result
    end
  end

  describe "show/2" do
    test "returns JS commands" do
      js = show("#selector")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "hide/2" do
    test "returns JS commands" do
      js = hide("#selector")
      assert %Phoenix.LiveView.JS{} = js
    end
  end
end
