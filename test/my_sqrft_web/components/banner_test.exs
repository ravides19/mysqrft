defmodule MySqrftWeb.Components.BannerTest do
  use ExUnit.Case, async: true

  import MySqrftWeb.Components.Banner

  describe "show_banner/2" do
    test "returns JS commands" do
      js = show_banner("#banner-id")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "works with JS parameter" do
      js = %Phoenix.LiveView.JS{}
      result = show_banner(js, "#banner-id")
      assert %Phoenix.LiveView.JS{} = result
    end
  end

  describe "hide_banner/2" do
    test "returns JS commands" do
      js = hide_banner("#banner-id")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "works with JS parameter" do
      js = %Phoenix.LiveView.JS{}
      result = hide_banner(js, "#banner-id")
      assert %Phoenix.LiveView.JS{} = result
    end
  end
end
