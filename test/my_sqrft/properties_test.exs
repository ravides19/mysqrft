defmodule MySqrft.PropertiesTest do
  use MySqrft.DataCase

  alias MySqrft.Properties
  alias MySqrft.Properties.Property

  describe "properties" do
    import MySqrft.AuthFixtures
    import MySqrft.GeographyFixtures

    setup do
      user = user_fixture()
      profile = MySqrft.UserManagement.get_profile_by_user_id(user.id)
      city = city_fixture()
      locality = locality_fixture(%{city_id: city.id})

      {:ok, profile: profile, city: city, locality: locality}
    end

    test "create_property/2 creates a property with valid attributes", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      attrs = %{
        "type" => "apartment",
        "configuration" => %{
          "bhk" => 2,
          "bathrooms" => 2,
          "built_up_area" => 1200
        },
        "address_text" => "123 Test Street",
        "city_id" => city.id,
        "locality_id" => locality.id
      }

      assert {:ok, %Property{} = property} = Properties.create_property(profile, attrs)
      assert property.type == "apartment"
      assert property.configuration["bhk"] == 2
      assert property.owner_id == profile.id
      assert property.city_id == city.id
      assert property.locality_id == locality.id
    end

    test "create_property/2 validates type-specific configuration", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      # Missing required fields for apartment
      attrs = %{
        "type" => "apartment",
        "configuration" => %{
          "bhk" => 2
          # Missing bathrooms and built_up_area
        },
        "city_id" => city.id,
        "locality_id" => locality.id
      }

      assert {:error, changeset} = Properties.create_property(profile, attrs)
      assert %{configuration: _} = errors_on(changeset)
    end

    test "update_quality_scores/1 calculates scores correctly", %{
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

      {:ok, updated_property} = Properties.update_quality_scores(property)

      assert updated_property.quality_score > 0
      assert updated_property.data_completeness_score > 0
    end

    test "find_potential_duplicates/1 finds similar properties", %{
      profile: profile,
      city: city,
      locality: locality
    } do
      # Create first property
      {:ok, _property1} =
        Properties.create_property(profile, %{
          "type" => "apartment",
          "address_text" => "123 Main Street, Koramangala",
          "configuration" => %{"bhk" => 2, "bathrooms" => 2, "built_up_area" => 1200},
          "city_id" => city.id,
          "locality_id" => locality.id
        })

      # Try to create similar property
      attrs = %{
        "type" => "apartment",
        "address_text" => "123 Main St, Koramangala",
        "locality_id" => locality.id
      }

      duplicates = Properties.find_potential_duplicates(attrs)

      assert length(duplicates) > 0
      assert hd(duplicates).similarity_score > 50
    end

    test "validate_address_binding/1 validates city and locality relationship", %{
      city: city,
      locality: locality
    } do
      # Valid binding
      assert :ok ==
               Properties.validate_address_binding(%{
                 "city_id" => city.id,
                 "locality_id" => locality.id
               })

      # Invalid - locality from different city
      other_city = city_fixture()

      assert {:error, _} =
               Properties.validate_address_binding(%{
                 "city_id" => other_city.id,
                 "locality_id" => locality.id
               })
    end
  end

  describe "property documents" do
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

    test "create_property_document/2 creates a document", %{property: property} do
      attrs = %{
        "document_type" => "electricity_bill",
        "s3_key" => "documents/test.pdf",
        "file_name" => "electricity_bill.pdf"
      }

      assert {:ok, document} = Properties.create_property_document(property, attrs)
      assert document.document_type == "electricity_bill"
      assert document.verification_status == "pending"
    end

    test "verify_document/2 verifies a document and updates property", %{
      property: property,
      profile: profile
    } do
      {:ok, document} =
        Properties.create_property_document(property, %{
          "document_type" => "sale_deed",
          "s3_key" => "documents/sale_deed.pdf"
        })

      assert {:ok, verified_doc} = Properties.verify_document(document, profile.id)
      assert verified_doc.verification_status == "verified"
      assert verified_doc.verified_by_id == profile.id
    end
  end

  describe "media vault" do
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

    test "validate_media_upload_limit/1 enforces 20 image limit", %{property: property} do
      # Create 20 images
      for i <- 1..20 do
        Properties.create_property_image(property, %{
          "s3_key" => "images/test_#{i}.jpg",
          "type" => "interior"
        })
      end

      # 21st image should fail validation
      assert {:error, _} =
               Properties.create_property_image_with_validation(property, %{
                 "s3_key" => "images/test_21.jpg"
               })
    end

    test "get_property_media_stats/1 returns correct statistics", %{property: property} do
      Properties.create_property_image(property, %{"s3_key" => "img1.jpg", "type" => "exterior"})
      Properties.create_property_image(property, %{"s3_key" => "img2.jpg", "type" => "interior"})

      stats = Properties.get_property_media_stats(property.id)

      assert stats.total_images == 2
      assert stats.images_by_type["exterior"] == 1
      assert stats.images_by_type["interior"] == 1
      assert stats.remaining_slots == 18
    end
  end
end
