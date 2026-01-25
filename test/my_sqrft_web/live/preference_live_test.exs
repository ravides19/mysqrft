defmodule MySqrftWeb.PreferenceLiveTest do
  use MySqrftWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import MySqrft.AuthFixtures

  alias MySqrft.UserManagement

  describe "Preferences" do
    setup %{conn: conn} do
      user = user_fixture()

      {:ok, profile} =
        UserManagement.create_profile(%{
          user_id: user.id,
          first_name: "Test",
          last_name: "User",
          display_name: "Test User",
          email: user.email,
          phone: "+15555555555",
          status: "active"
        })

      %{conn: log_in_user(conn, user), user: user, profile: profile}
    end

    test "saves lifestyle preferences", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, ~p"/preferences/lifestyle/edit")

      view
      |> form("#preferences-form", %{
        "preferences" => %{
          "smoking" => "No",
          "pets" => "Dog",
          "dietary" => "Vegetarian",
          "drinking" => "Socially"
        }
      })
      |> render_submit()

      assert_redirect(view, ~p"/preferences")

      # Verify persistence
      preferences =
        UserManagement.get_preferences(
          UserManagement.get_profile_by_user_id(user.id),
          "lifestyle"
        )

      assert Enum.any?(preferences, fn p -> p.key == "smoking" and p.value == "No" end)
      assert Enum.any?(preferences, fn p -> p.key == "pets" and p.value == "Dog" end)
      assert Enum.any?(preferences, fn p -> p.key == "dietary" and p.value == "Vegetarian" end)
      assert Enum.any?(preferences, fn p -> p.key == "drinking" and p.value == "Socially" end)
    end

    test "saves notification preferences", %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, ~p"/preferences/notification/edit")

      view
      |> form("#preferences-form", %{
        "preferences" => %{
          "new_match_alerts" => "true",
          "marketing_promotions" => "false",
          "unread_message_reminders" => "true",
          "system_updates" => "true"
        }
      })
      |> render_submit()

      assert_redirect(view, ~p"/preferences")

      # Verify persistence
      preferences =
        UserManagement.get_preferences(
          UserManagement.get_profile_by_user_id(user.id),
          "notification"
        )

      assert Enum.any?(preferences, fn p -> p.key == "new_match_alerts" and p.value == "true" end)

      assert Enum.any?(preferences, fn p ->
               p.key == "marketing_promotions" and p.value == "false"
             end)

      assert Enum.any?(preferences, fn p ->
               p.key == "unread_message_reminders" and p.value == "true"
             end)

      assert Enum.any?(preferences, fn p -> p.key == "system_updates" and p.value == "true" end)
    end
  end
end
