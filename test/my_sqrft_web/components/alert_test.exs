defmodule MySqrftWeb.Components.AlertTest do
  use ExUnit.Case, async: true

  import MySqrftWeb.Components.Alert

  describe "show_alert/2" do
    test "returns JS commands" do
      js = show_alert("#alert-id")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "works with JS parameter" do
      js = %Phoenix.LiveView.JS{}
      result = show_alert(js, "#alert-id")
      assert %Phoenix.LiveView.JS{} = result
    end
  end

  describe "hide_alert/2" do
    test "returns JS commands" do
      js = hide_alert("#alert-id")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "works with JS parameter" do
      js = %Phoenix.LiveView.JS{}
      result = hide_alert(js, "#alert-id")
      assert %Phoenix.LiveView.JS{} = result
    end
  end
end
