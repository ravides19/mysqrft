defmodule MySqrft.ListingsTest do
  use MySqrft.DataCase

  alias MySqrft.Listings
  alias MySqrft.Listings.Listing
  alias MySqrft.Properties

  describe "listings" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      {:ok, property: property, profile: profile}
    end

    test "create_listing/2 creates a listing with valid attributes", %{property: property} do
      attrs = %{
        "transaction_type" => "rent",
        "ask_price" => "25000",
        "available_from" => ~D[2026-02-01]
      }

      assert {:ok, %Listing{} = listing} = Listings.create_listing(property, attrs)
      assert listing.transaction_type == "rent"
      assert Decimal.equal?(listing.ask_price, Decimal.new("25000"))
      assert listing.status == "draft"
      assert listing.property_id == property.id
    end

    test "create_listing/2 enforces unique active listing per property-transaction type", %{
      property: property
    } do
      # Create first listing
      {:ok, listing1} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      # Publish it
      {:ok, _} = Listings.publish_listing(listing1)

      # Try to create another active rent listing - should fail
      {:ok, listing2} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "26000"
        })

      assert {:error, changeset} = Listings.publish_listing(listing2)
      assert %{property_id: _} = errors_on(changeset)
    end

    test "publish_listing/1 transitions from draft to active", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000",
          "available_from" => ~D[2026-02-01]
        })

      assert {:ok, published} = Listings.publish_listing(listing)
      assert published.status == "active"
      assert published.expires_at != nil
    end

    test "pause_listing/1 transitions from active to paused", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)
      assert {:ok, paused} = Listings.pause_listing(published)
      assert paused.status == "paused"
    end

    test "close_listing/2 transitions to closed and creates price history", %{
      property: property
    } do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)

      assert {:ok, closed} =
               Listings.close_listing(published, %{
                 "closure_reason" => "rented",
                 "final_price" => "24000"
               })

      assert closed.status == "closed"
      assert closed.closure_reason == "rented"
      assert Decimal.equal?(closed.final_price, Decimal.new("24000"))

      # Check price history was created
      history = Listings.list_listing_price_history(listing.id)
      assert length(history) > 0
    end

    test "repost_listing/2 creates new listing from closed one", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)
      {:ok, closed} = Listings.close_listing(published, %{"closure_reason" => "rented"})

      assert {:ok, reposted} =
               Listings.repost_listing(closed, %{
                 "ask_price" => "26000"
               })

      assert reposted.status == "draft"
      assert Decimal.equal?(reposted.ask_price, Decimal.new("26000"))
      assert reposted.property_id == property.id
    end

    test "refresh_listing/1 extends expiry date", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)
      original_expiry = published.expires_at

      # Wait a moment to ensure time difference
      Process.sleep(100)

      assert {:ok, refreshed} = Listings.refresh_listing(published)
      assert DateTime.compare(refreshed.expires_at, original_expiry) == :gt
      assert refreshed.last_refreshed_at != nil
    end
  end

  describe "price history" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, property: property, listing: listing}
    end

    test "update_listing_price/2 creates price history entry", %{listing: listing} do
      {:ok, updated} = Listings.update_listing_price(listing, "26000")

      assert Decimal.equal?(updated.ask_price, Decimal.new("26000"))

      history = Listings.list_listing_price_history(listing.id)
      assert length(history) > 0
      assert hd(history).new_price |> Decimal.equal?(Decimal.new("26000"))
    end

    test "list_property_price_history/2 returns price history for property", %{
      property: property
    } do
      # Create and close multiple listings
      for price <- ["25000", "26000", "27000"] do
        {:ok, listing} =
          Listings.create_listing(property, %{
            "transaction_type" => "rent",
            "ask_price" => price
          })

        {:ok, published} = Listings.publish_listing(listing)

        Listings.close_listing(published, %{
          "closure_reason" => "rented",
          "final_price" => price
        })
      end

      history = Listings.list_property_price_history(property.id, "rent")
      assert length(history) >= 3
    end
  end

  describe "scoring" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, property: property, listing: listing}
    end

    test "update_freshness_score/1 calculates freshness score", %{listing: listing} do
      {:ok, updated} = Listings.update_freshness_score(listing)
      assert updated.freshness_score != nil
      assert updated.freshness_score >= 0
      assert updated.freshness_score <= 100
    end

    test "update_market_readiness_score/1 calculates market readiness", %{listing: listing} do
      {:ok, updated} = Listings.update_market_readiness_score(listing)
      assert updated.market_readiness_score != nil
      assert updated.market_readiness_score >= 0
      assert updated.market_readiness_score <= 100
    end

    test "is_fresh?/1 returns correct freshness status", %{listing: listing} do
      {:ok, updated} = Listings.update_freshness_score(listing)
      # New listing should be fresh
      assert Listings.is_fresh?(updated)
    end

    test "get_improvement_suggestions/1 returns actionable suggestions", %{listing: listing} do
      suggestions = Listings.get_improvement_suggestions(listing)
      assert is_list(suggestions)
    end
  end

  describe "state machine" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      {:ok, property: property}
    end

    test "cannot pause a draft listing", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      assert {:error, _} = Listings.pause_listing(listing)
    end

    test "cannot publish a paused listing directly", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)
      {:ok, paused} = Listings.pause_listing(published)

      # Should use resume, not publish
      assert {:error, _} = Listings.publish_listing(paused)
    end

    test "full lifecycle: draft -> active -> paused -> active -> closed", %{property: property} do
      # Create (draft)
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      assert listing.status == "draft"

      # Publish (active)
      {:ok, active} = Listings.publish_listing(listing)
      assert active.status == "active"

      # Pause
      {:ok, paused} = Listings.pause_listing(active)
      assert paused.status == "paused"

      # Resume (active again)
      {:ok, resumed} = Listings.resume_listing(paused)
      assert resumed.status == "active"

      # Close
      {:ok, closed} = Listings.close_listing(resumed, %{"closure_reason" => "rented"})
      assert closed.status == "closed"
    end
  end
end
