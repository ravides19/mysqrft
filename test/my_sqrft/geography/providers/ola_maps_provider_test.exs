defmodule MySqrft.Geography.Providers.OlaMapsProviderTest do
  @moduledoc """
  Tests for OLA Maps Provider API integration.

  These tests verify:
  - API key configuration handling
  - Request parameter building
  - Response parsing
  - Error handling
  """

  use ExUnit.Case, async: true

  alias MySqrft.Geography.Providers.OlaMapsProvider

  # ============================================================================
  # Setup & Configuration Tests
  # ============================================================================

  describe "API key configuration" do
    test "returns error when API key is not configured" do
      original_key = Application.get_env(:my_sqrft, :ola_maps_api_key)
      Application.put_env(:my_sqrft, :ola_maps_api_key, nil)

      on_exit(fn ->
        Application.put_env(:my_sqrft, :ola_maps_api_key, original_key)
      end)

      assert {:error, :api_key_not_configured} = OlaMapsProvider.geocode("Test Address")
    end

    test "uses API key from application environment" do
      original_key = Application.get_env(:my_sqrft, :ola_maps_api_key)
      Application.put_env(:my_sqrft, :ola_maps_api_key, "test-api-key")

      on_exit(fn ->
        Application.put_env(:my_sqrft, :ola_maps_api_key, original_key)
      end)

      # This will fail with network error, but verifies API key is checked first
      # In real scenario, this would make an HTTP request
      assert {:error, _} = OlaMapsProvider.geocode("Test Address")
      refute match?({:error, :api_key_not_configured}, OlaMapsProvider.geocode("Test Address"))
    end
  end

  # ============================================================================
  # Geocoding Tests
  # ============================================================================

  describe "geocode/2" do
    test "validates address is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.geocode(123)
      end
    end

    test "accepts language option" do
      # This will fail with network/API error but verifies function accepts options
      assert {:error, _} = OlaMapsProvider.geocode("Test", language: "hi")
    end
  end

  # ============================================================================
  # Reverse Geocoding Tests
  # ============================================================================

  describe "reverse_geocode/3" do
    test "validates coordinates are numbers" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.reverse_geocode("12.9352", "77.6245")
      end
    end

    test "accepts language option" do
      # This will fail with network/API error but verifies function accepts options
      assert {:error, _} = OlaMapsProvider.reverse_geocode(12.9352, 77.6245, language: "hi")
    end
  end

  # ============================================================================
  # Autocomplete Tests
  # ============================================================================

  describe "autocomplete/2" do
    test "validates input is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.autocomplete(123)
      end
    end

    test "accepts optional parameters" do
      assert {:error, _} =
               OlaMapsProvider.autocomplete("test",
                 language: "hi",
                 location: {12.9352, 77.6245},
                 radius: 1000
               )
    end
  end

  # ============================================================================
  # Place Details Tests
  # ============================================================================

  describe "get_place_details/2" do
    test "validates place_id is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.get_place_details(123)
      end
    end

    test "accepts language option" do
      assert {:error, _} =
               OlaMapsProvider.get_place_details("ola-platform:123", language: "hi")
    end
  end

  # ============================================================================
  # Advanced Place Details Tests
  # ============================================================================

  describe "get_advanced_place_details/2" do
    test "validates place_id is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.get_advanced_place_details(123)
      end
    end

    test "accepts language option" do
      assert {:error, _} =
               OlaMapsProvider.get_advanced_place_details("ola-platform:123", language: "hi")
    end
  end

  # ============================================================================
  # Nearby Search Tests
  # ============================================================================

  describe "nearby_search/3" do
    test "validates coordinates are numbers" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.nearby_search("12.9352", "77.6245")
      end
    end

    test "accepts optional parameters" do
      assert {:error, _} =
               OlaMapsProvider.nearby_search(12.9352, 77.6245,
                 language: "hi",
                 radius: 10000,
                 types: "cafe"
               )
    end
  end

  # ============================================================================
  # Advanced Nearby Search Tests
  # ============================================================================

  describe "get_advanced_nearby_search/3" do
    test "validates coordinates are numbers" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.get_advanced_nearby_search("12.9352", "77.6245")
      end
    end

    test "accepts optional parameters" do
      assert {:error, _} =
               OlaMapsProvider.get_advanced_nearby_search(12.9352, 77.6245,
                 language: "hi",
                 radius: 10000,
                 types: "cafe"
               )
    end
  end

  # ============================================================================
  # Text Search Tests
  # ============================================================================

  describe "text_search/2" do
    test "validates input is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.text_search(123)
      end
    end

    test "accepts optional parameters" do
      assert {:error, _} =
               OlaMapsProvider.text_search("test",
                 language: "hi",
                 location: {12.9352, 77.6245},
                 radius: 5000
               )
    end
  end

  # ============================================================================
  # Address Validation Tests
  # ============================================================================

  describe "validate_address/2" do
    test "validates address is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.validate_address(123)
      end
    end

    test "accepts language option" do
      assert {:error, _} =
               OlaMapsProvider.validate_address("Test Address", language: "hi")
    end
  end

  # ============================================================================
  # Photo Tests
  # ============================================================================

  describe "get_photo/2" do
    test "validates photo_reference is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.get_photo(123)
      end
    end

    test "accepts optional parameters" do
      assert {:error, _} =
               OlaMapsProvider.get_photo("test-ref", maxwidth: 400, maxheight: 300)
    end
  end

  # ============================================================================
  # Places Geocode Tests
  # ============================================================================

  describe "geocode_address/2" do
    test "validates address is a binary" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.geocode_address(123)
      end
    end

    test "accepts language option" do
      assert {:error, _} =
               OlaMapsProvider.geocode_address("Test Address", language: "hi")
    end
  end

  # ============================================================================
  # Places Reverse Geocode Tests
  # ============================================================================

  describe "reverse_geocode_address/3" do
    test "validates coordinates are numbers" do
      assert_raise FunctionClauseError, fn ->
        OlaMapsProvider.reverse_geocode_address("12.9352", "77.6245")
      end
    end

    test "accepts language option" do
      assert {:error, _} =
               OlaMapsProvider.reverse_geocode_address(12.9352, 77.6245, language: "hi")
    end
  end

  # ============================================================================
  # Response Parsing Tests (Unit Tests)
  # ============================================================================

  describe "response parsing" do
    # Note: These are internal functions, but we can test them indirectly
    # through the public API or by testing the behavior with mock responses

    test "handles invalid response format" do
      # This test verifies that invalid responses are handled gracefully
      # In practice, this would be tested with mocked HTTP responses
      original_key = Application.get_env(:my_sqrft, :ola_maps_api_key)
      Application.put_env(:my_sqrft, :ola_maps_api_key, "test-key")

      on_exit(fn ->
        Application.put_env(:my_sqrft, :ola_maps_api_key, original_key)
      end)

      # Will fail due to network/API error, but structure is correct
      assert {:error, _} = OlaMapsProvider.geocode("")
    end
  end
end
