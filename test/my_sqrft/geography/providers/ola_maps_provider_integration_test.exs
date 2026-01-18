defmodule MySqrft.Geography.Providers.OlaMapsProviderIntegrationTest do
  @moduledoc """
  Integration tests for OLA Maps Provider with mocked HTTP responses using Bypass.

  These tests verify:
  - Successful API responses with proper JSON parsing
  - Error handling for different HTTP status codes (400, 404, 429, 500)
  - Response parsing for all API endpoints
  """

  use ExUnit.Case, async: true

  alias MySqrft.Geography.Providers.OlaMapsProvider

  # ============================================================================
  # Setup - Bypass Configuration
  # ============================================================================

  setup do
    bypass = Bypass.open()
    original_api_key = Application.get_env(:my_sqrft, :ola_maps_api_key)
    original_base_url = Application.get_env(:my_sqrft, :ola_maps_places_base_url)

    Application.put_env(:my_sqrft, :ola_maps_api_key, "test-api-key")
    Application.put_env(:my_sqrft, :ola_maps_places_base_url, "http://localhost:#{bypass.port}")

    on_exit(fn ->
      Application.put_env(:my_sqrft, :ola_maps_api_key, original_api_key)
      if original_base_url do
        Application.put_env(:my_sqrft, :ola_maps_places_base_url, original_base_url)
      else
        Application.delete_env(:my_sqrft, :ola_maps_places_base_url)
      end
    end)

    {:ok, bypass: bypass}
  end

  # ============================================================================
  # Geocoding Integration Tests
  # ============================================================================

  describe "geocode/2 with mocked HTTP" do
    test "returns success with valid response", %{bypass: bypass} do
      mock_geocode_response = %{
        "geocodingResults" => [
          %{
            "place_id" => "ola-platform:123",
            "formatted_address" => "Koramangala, Bangalore, Karnataka 560095, India",
            "name" => "Koramangala",
            "types" => ["locality", "political"],
            "layer" => ["locality"],
            "geometry" => %{
              "location" => %{"lat" => 12.9352, "lng" => 77.6245},
              "location_type" => "APPROXIMATE",
              "viewport" => %{
                "northeast" => %{"lat" => 12.9400, "lng" => 77.6300},
                "southwest" => %{"lat" => 12.9300, "lng" => 77.6200}
              }
            },
            "address_components" => [
              %{"long_name" => "Koramangala", "short_name" => "Koramangala", "types" => ["locality"]},
              %{"long_name" => "Bangalore", "short_name" => "BLR", "types" => ["city"]}
            ],
            "plus_code" => %{
              "compound_code" => "X9F7+QP Bangalore",
              "global_code" => "7J4X9F7+QP"
            }
          }
        ],
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/geocode", fn conn ->
        assert conn.query_params["address"] == "Koramangala"
        assert conn.query_params["language"] == "en"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_geocode_response))
      end)

      assert {:ok, result} = OlaMapsProvider.geocode("Koramangala", language: "en")
      assert result.latitude == Decimal.from_float(12.9352)
      assert result.longitude == Decimal.from_float(77.6245)
      assert result.formatted_address == "Koramangala, Bangalore, Karnataka 560095, India"
      assert result.source == "ola_maps"
    end

    test "returns error for 400 Bad Request", %{bypass: bypass} do
      mock_error_response = %{
        "status" => "error",
        "error_message" => "Invalid address format"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/geocode", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(400, Jason.encode!(mock_error_response))
      end)

      assert {:error, {:api_error, 400, "Invalid address format"}} =
               OlaMapsProvider.geocode("", language: "en")
    end

    test "returns error for 404 Not Found", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/places/v1/geocode", fn conn ->
        Plug.Conn.resp(conn, 404, "")
      end)

      assert {:error, :endpoint_not_found} = OlaMapsProvider.geocode("Test", language: "en")
    end

    test "returns error for 429 Rate Limit", %{bypass: bypass} do
      # Req might retry on errors, so we need to handle multiple requests
      Bypass.expect(bypass, "GET", "/places/v1/geocode", fn conn ->
        Plug.Conn.resp(conn, 429, "")
      end)

      assert {:error, :rate_limit_exceeded} = OlaMapsProvider.geocode("Test", language: "en")
    end

    test "returns error for 500 Server Error", %{bypass: bypass} do
      mock_error_response = %{
        "status" => "error",
        "error_message" => "Internal server error"
      }

      # Req might retry on errors, so we need to handle multiple requests
      Bypass.expect(bypass, "GET", "/places/v1/geocode", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(500, Jason.encode!(mock_error_response))
      end)

      assert {:error, {:api_error, 500, "Internal server error"}} =
               OlaMapsProvider.geocode("Test", language: "en")
    end

    test "returns error for 500 Server Error with no body", %{bypass: bypass} do
      # Req might retry on errors, so we need to handle multiple requests
      Bypass.expect(bypass, "GET", "/places/v1/geocode", fn conn ->
        Plug.Conn.resp(conn, 500, "")
      end)

      # Req's retry might cause the error message to be "Unknown error" after retries
      result = OlaMapsProvider.geocode("Test", language: "en")
      assert match?({:error, {:api_error, 500, _}}, result)
    end
  end

  # ============================================================================
  # Reverse Geocoding Integration Tests
  # ============================================================================

  describe "reverse_geocode/3 with mocked HTTP" do
    test "returns success with valid response", %{bypass: bypass} do
      mock_reverse_geocode_response = %{
        "results" => [
          %{
            "place_id" => "ola-platform:456",
            "formatted_address" => "Koramangala, Bangalore",
            "name" => "Koramangala",
            "types" => ["locality"],
            "layer" => ["locality"],
            "geometry" => %{
              "location" => %{"lat" => 12.9352, "lng" => 77.6245},
              "viewport" => %{
                "northeast" => %{"lat" => 12.9400, "lng" => 77.6300},
                "southwest" => %{"lat" => 12.9300, "lng" => 77.6200}
              }
            },
            "address_components" => [
              %{"long_name" => "Koramangala", "types" => ["locality"]}
            ],
            "plus_code" => %{
              "compound_code" => "X9F7+QP",
              "global_code" => "7J4X9F7+QP"
            }
          }
        ],
        "status" => "ok",
        "plus_code" => %{
          "compound_code" => "X9F7+QP Bangalore",
          "global_code" => "7J4X9F7+QP"
        }
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/reverse-geocode", fn conn ->
        assert conn.query_params["latlng"] == "12.9352,77.6245"
        assert conn.query_params["language"] == "en"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_reverse_geocode_response))
      end)

      assert {:ok, result} = OlaMapsProvider.reverse_geocode(12.9352, 77.6245, language: "en")
      assert result.formatted_address == "Koramangala, Bangalore"
      assert result.source == "ola_maps"
    end
  end

  # ============================================================================
  # Autocomplete Integration Tests
  # ============================================================================

  describe "autocomplete/2 with mocked HTTP" do
    test "returns success with predictions", %{bypass: bypass} do
      mock_autocomplete_response = %{
        "predictions" => [
          %{
            "place_id" => "ola-platform:789",
            "description" => "Koramangala, Bangalore",
            "main_text" => "Koramangala",
            "secondary_text" => "Bangalore",
            "types" => ["locality"],
            "structured_formatting" => %{
              "main_text" => "Koramangala",
              "secondary_text" => "Bangalore"
            },
            "geometry" => %{
              "location" => %{"lat" => 12.9352, "lng" => 77.6245}
            }
          }
        ],
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/autocomplete", fn conn ->
        assert conn.query_params["input"] == "Kora"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_autocomplete_response))
      end)

      assert {:ok, [prediction | _]} = OlaMapsProvider.autocomplete("Kora")
      assert prediction.place_id == "ola-platform:789"
      assert prediction.description == "Koramangala, Bangalore"
    end

    test "returns empty list for zero results", %{bypass: bypass} do
      mock_empty_response = %{
        "predictions" => [],
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/autocomplete", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_empty_response))
      end)

      assert {:ok, []} = OlaMapsProvider.autocomplete("NonExistentPlaceXYZ")
    end
  end

  # ============================================================================
  # Place Details Integration Tests
  # ============================================================================

  describe "get_place_details/2 with mocked HTTP" do
    test "returns success with place details", %{bypass: bypass} do
      mock_place_details_response = %{
        "result" => %{
          "place_id" => "ola-platform:123",
          "name" => "Koramangala",
          "formatted_address" => "Koramangala, Bangalore",
          "geometry" => %{
            "location" => %{"lat" => 12.9352, "lng" => 77.6245}
          },
          "types" => ["locality"],
          "rating" => 4.5,
          "user_ratings_total" => 100,
          "address_components" => [
            %{"long_name" => "Koramangala", "types" => ["locality"]}
          ]
        },
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/details", fn conn ->
        assert conn.query_params["place_id"] == "ola-platform:123"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_place_details_response))
      end)

      assert {:ok, details} =
               OlaMapsProvider.get_place_details("ola-platform:123", language: "en")

      assert details.place_id == "ola-platform:123"
      assert details.name == "Koramangala"
    end
  end

  # ============================================================================
  # Nearby Search Integration Tests
  # ============================================================================

  describe "nearby_search/3 with mocked HTTP" do
    test "returns success with nearby places", %{bypass: bypass} do
      mock_nearby_response = %{
        "predictions" => [
          %{
            "place_id" => "ola-platform:999",
            "description" => "Restaurant ABC",
            "main_text" => "Restaurant ABC",
            "secondary_text" => "Koramangala",
            "types" => ["restaurant"],
            "distance_meters" => 500
          }
        ],
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/nearbysearch", fn conn ->
        assert conn.query_params["location"] == "12.9352,77.6245"
        assert conn.query_params["radius"] == "1000"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_nearby_response))
      end)

      assert {:ok, [place | _]} =
               OlaMapsProvider.nearby_search(12.9352, 77.6245, radius: 1000, language: "en")

      assert place.place_id == "ola-platform:999"
      assert place.description == "Restaurant ABC"
    end
  end

  # ============================================================================
  # Text Search Integration Tests
  # ============================================================================

  describe "text_search/2 with mocked HTTP" do
    test "returns success with search results", %{bypass: bypass} do
      mock_text_search_response = %{
        "predictions" => [
          %{
            "place_id" => "ola-platform:888",
            "name" => "Restaurant XYZ",
            "formatted_address" => "MG Road, Bangalore",
            "location" => %{"lat" => 12.9716, "lng" => 77.5946},
            "types" => ["restaurant"],
            "geometry" => %{
              "location" => %{"lat" => 12.9716, "lng" => 77.5946}
            }
          }
        ],
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/textsearch", fn conn ->
        assert conn.query_params["input"] == "restaurant"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_text_search_response))
      end)

      assert {:ok, [result | _]} = OlaMapsProvider.text_search("restaurant", language: "en")
      assert result.place_id == "ola-platform:888"
      assert result.name == "Restaurant XYZ"
    end
  end

  # ============================================================================
  # Address Validation Integration Tests
  # ============================================================================

  describe "validate_address/2 with mocked HTTP" do
    test "returns success for valid address", %{bypass: bypass} do
      mock_validation_response = %{
        "result" => %{
          "validated" => true,
          "validated_address" => "Koramangala, Bangalore",
          "address_components" => [
            %{"long_name" => "Koramangala", "types" => ["locality"]}
          ]
        },
        "status" => "ok"
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/addressvalidation", fn conn ->
        assert conn.query_params["address"] == "Koramangala"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_validation_response))
      end)

      assert {:ok, result} = OlaMapsProvider.validate_address("Koramangala")
      assert result.validated == true
      assert result.validated_address == "Koramangala, Bangalore"
    end
  end

  # ============================================================================
  # Photo Integration Tests
  # ============================================================================

  describe "get_photo/2 with mocked HTTP" do
    test "returns success with photo details", %{bypass: bypass} do
      mock_photo_response = %{
        "photos" => [
          %{
            "height" => 400,
            "width" => 600,
            "photo_reference" => "photo-ref-123",
            "photoUri" => "https://example.com/photo.jpg"
          }
        ]
      }

      Bypass.expect_once(bypass, "GET", "/places/v1/photo", fn conn ->
        assert conn.query_params["photo_reference"] == "photo-ref-123"
        assert conn.query_params["api_key"] == "test-api-key"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(mock_photo_response))
      end)

      assert {:ok, [photo | _]} = OlaMapsProvider.get_photo("photo-ref-123")
      assert photo.photo_reference == "photo-ref-123"
      assert photo.height == 400
      assert photo.width == 600
    end
  end
end
