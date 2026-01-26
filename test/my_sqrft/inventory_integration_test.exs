defmodule MySqrft.InventoryIntegrationTest do
  use MySqrft.DataCase

  alias MySqrft.{Listings, Properties}

  describe "property-listing lifecycle integration" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, profile: profile, city: city, locality: locality}
    end

    test "complete property creation to listing closure workflow", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      # Step 1: Create property
      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "address_text" => "123 Test Street",
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      assert property.status == "draft"

      # Step 2: Upload images
      {:ok, _image1} =
        Properties.create_property_image(property, %{
          "s3_key" => "images/exterior.jpg",
          "type" => "exterior",
          "is_primary" => true
        })

      {:ok, _image2} =
        Properties.create_property_image(property, %{
          "s3_key" => "images/interior.jpg",
          "type" => "interior"
        })

      # Step 3: Upload documents
      {:ok, document} =
        Properties.create_property_document(property, %{
          "document_type" => "sale_deed",
          "s3_key" => "documents/sale_deed.pdf"
        })

      # Step 4: Verify document
      {:ok, _verified_doc} = Properties.verify_document(document, profile.id)

      # Step 5: Update quality scores
      {:ok, updated_property} = Properties.update_quality_scores(property)
      assert updated_property.quality_score > 0

      # Step 6: Create listing
      {:ok, listing} =
        Listings.create_listing(updated_property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000",
          "available_from" => ~D[2026-02-01],
          "tenant_preference" => "family",
          "diet_preference" => "vegetarian"
        })

      assert listing.status == "draft"

      # Step 7: Update scores
      {:ok, scored_listing} = Listings.update_all_scores(listing)
      assert scored_listing.freshness_score > 0
      assert scored_listing.market_readiness_score > 0

      # Step 8: Publish listing
      {:ok, published} = Listings.publish_listing(scored_listing)
      assert published.status == "active"
      assert published.expires_at != nil

      # Step 9: Update price
      {:ok, price_updated} = Listings.update_listing_price(published, "26000")
      assert Decimal.equal?(price_updated.ask_price, Decimal.new("26000"))

      # Step 10: Refresh listing
      {:ok, refreshed} = Listings.refresh_listing(price_updated)
      assert refreshed.last_refreshed_at != nil

      # Step 11: Close listing
      {:ok, closed} =
        Listings.close_listing(refreshed, %{
          "closure_reason" => "rented",
          "final_price" => "25500"
        })

      assert closed.status == "closed"
      assert Decimal.equal?(closed.final_price, Decimal.new("25500"))

      # Verify price history
      listing_history = Listings.list_listing_price_history(listing.id)
      assert length(listing_history) > 0

      property_history = Listings.list_property_price_history(property.id, "rent")
      assert length(property_history) > 0
    end

    test "property with multiple listings (rent and sale)", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      # Create rent listing
      {:ok, rent_listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, rent_published} = Listings.publish_listing(rent_listing)

      # Create sale listing (should succeed - different transaction type)
      {:ok, sale_listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "sale",
          "ask_price" => "5000000"
        })

      {:ok, sale_published} = Listings.publish_listing(sale_listing)

      # Both should be active
      assert rent_published.status == "active"
      assert sale_published.status == "active"

      # Close rent listing
      {:ok, _closed_rent} =
        Listings.close_listing(rent_published, %{"closure_reason" => "rented"})

      # Sale listing should still be active
      sale_reloaded = Listings.get_listing!(sale_published.id)
      assert sale_reloaded.status == "active"
    end

    test "repost workflow preserves property details", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      {:ok, property} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      # Create and close listing
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000",
          "tenant_preference" => "family"
        })

      {:ok, published} = Listings.publish_listing(listing)
      {:ok, closed} = Listings.close_listing(published, %{"closure_reason" => "rented"})

      # Repost with new price
      {:ok, reposted} =
        Listings.repost_listing(closed, %{
          "ask_price" => "26000"
        })

      # Verify property details preserved
      assert reposted.property_id == property.id
      assert reposted.transaction_type == "rent"
      assert reposted.tenant_preference == "family"
      assert Decimal.equal?(reposted.ask_price, Decimal.new("26000"))
    end
  end

  describe "auto-expiry functionality" do
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

    test "expire_stale_listings/0 expires listings past expiry date", %{property: property} do
      # Create listing with past expiry
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)

      # Manually set expiry to past
      past_date = DateTime.add(DateTime.utc_now(), -1, :day)

      {:ok, _} =
        Repo.update(Ecto.Changeset.change(published, %{expires_at: past_date}))

      # Run expiry job
      {:ok, count} = Listings.expire_stale_listings()

      assert count >= 1

      # Verify listing is expired
      expired = Listings.get_listing!(listing.id)
      assert expired.status == "expired"
    end

    test "expire_stale_listings/0 does not expire fresh listings", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)

      # Run expiry job
      {:ok, count} = Listings.expire_stale_listings()

      # Fresh listing should not be expired
      fresh = Listings.get_listing!(published.id)
      assert fresh.status == "active"

      # Count should be 0 or not include this listing
      assert count >= 0
    end

    test "refreshing listing extends expiry date", %{property: property} do
      {:ok, listing} =
        Listings.create_listing(property, %{
          "transaction_type" => "rent",
          "ask_price" => "25000"
        })

      {:ok, published} = Listings.publish_listing(listing)
      original_expiry = published.expires_at

      # Set expiry to near future
      near_expiry = DateTime.add(DateTime.utc_now(), 5, :day)

      {:ok, near_expired} =
        Repo.update(Ecto.Changeset.change(published, %{expires_at: near_expiry}))

      # Refresh listing
      {:ok, refreshed} = Listings.refresh_listing(near_expired)

      # Expiry should be extended
      assert DateTime.compare(refreshed.expires_at, near_expiry) == :gt
      assert DateTime.compare(refreshed.expires_at, original_expiry) == :gt
    end
  end

  describe "duplicate detection integration" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, profile: profile, city: city, locality: locality}
    end

    test "finds duplicates based on address similarity", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      # Create first property
      {:ok, _property1} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "address_text" => "Flat 101, Green Valley Apartments, Koramangala",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      # Try to find duplicates with similar address
      duplicates =
        Properties.find_potential_duplicates(%{
          "type" => "apartment",
          "address_text" => "Flat 102, Green Valley Apartments, Koramangala",
          "locality_id" => locality.id
        })

      assert length(duplicates) > 0
      assert hd(duplicates).similarity_score > 50
    end
  end
end
