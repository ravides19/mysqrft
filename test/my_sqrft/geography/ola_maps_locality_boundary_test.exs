defmodule MySqrft.Geography.OlaMapsLocalityBoundaryTest do
  use MySqrft.DataCase, async: false

  alias MySqrft.Geography
  alias MySqrft.Geography.Locality

  import Ecto.Query

  @moduletag :geography

  setup do
    # Ensure Ola Maps fallback is enabled and MapProvider is OlaMapsProvider
    original_enabled = Application.get_env(:my_sqrft, :ola_maps_enabled)
    original_provider = Application.get_env(:my_sqrft, :map_provider)

    Application.put_env(:my_sqrft, :ola_maps_enabled, true)
    Application.put_env(:my_sqrft, :map_provider, MySqrft.Geography.Providers.OlaMapsProvider)

    on_exit(fn ->
      if is_nil(original_enabled) do
        Application.delete_env(:my_sqrft, :ola_maps_enabled)
      else
        Application.put_env(:my_sqrft, :ola_maps_enabled, original_enabled)
      end

      if is_nil(original_provider) do
        Application.delete_env(:my_sqrft, :map_provider)
      else
        Application.put_env(:my_sqrft, :map_provider, original_provider)
      end
    end)

    :ok
  end

  describe "persist_ola_maps_geocoding/2 locality boundary" do
    test "sets locality.boundary from Ola Maps viewport when creating new locality" do
      # Create minimal city so that persistence can attach locality correctly
      {:ok, country} =
        Geography.create_country(%{
          code: "IN",
          name: "India",
          status: "active"
        })

      {:ok, state} =
        Geography.create_state(%{
          country_id: country.id,
          code: "KA",
          name: "Karnataka",
          status: "active"
        })

      {:ok, city} =
        Geography.create_city(%{
          state_id: state.id,
          name: "Bangalore",
          status: "active"
        })

      # Fake Ola Maps geocode result with viewport + address components
      result = %{
        latitude: Decimal.new("12.9352"),
        longitude: Decimal.new("77.6245"),
        formatted_address: "Koramangala, Bangalore, Karnataka 560095, India",
        address_components: %{
          country: "India",
          country_code: "IN",
          state: "Karnataka",
          city: "Bangalore",
          locality: "Koramangala",
          pincode: "560095",
          viewport: %{
            northeast: %{lat: 12.94, lng: 77.63},
            southwest: %{lat: 12.93, lng: 77.62}
          }
        }
      }

      # Call internal persistence via public API by stubbing MapProvider to return our result
      # For this test we directly invoke the internal helper to avoid HTTP and provider wiring
      apply(Geography, :persist_ola_maps_geocoding, ["Koramangala, Bangalore", result])

      # Assert locality was created with boundary set
      locality =
        Locality
        |> where([l], l.city_id == ^city.id)
        |> where([l], l.name == "Koramangala")
        |> Repo.one!()

      assert %Geo.Polygon{srid: 4326} = locality.boundary
    end

    test "sets locality.boundary from Ola Maps viewport when existing locality has no boundary" do
      # Create minimal hierarchy and an existing locality without boundary
      {:ok, country} =
        Geography.create_country(%{
          code: "IN",
          name: "India",
          status: "active"
        })

      {:ok, state} =
        Geography.create_state(%{
          country_id: country.id,
          code: "KA",
          name: "Karnataka",
          status: "active"
        })

      {:ok, city} =
        Geography.create_city(%{
          state_id: state.id,
          name: "Bangalore",
          status: "active"
        })

      {:ok, locality} =
        Geography.create_locality(%{
          city_id: city.id,
          name: "Koramangala",
          latitude: Decimal.new("12.9350"),
          longitude: Decimal.new("77.6240"),
          status: "active"
        })

      assert locality.boundary == nil

      # Ola Maps result near the existing locality with viewport
      result = %{
        latitude: Decimal.new("12.9352"),
        longitude: Decimal.new("77.6245"),
        formatted_address: "Koramangala, Bangalore, Karnataka 560095, India",
        address_components: %{
          country: "India",
          country_code: "IN",
          state: "Karnataka",
          city: "Bangalore",
          locality: "Koramangala",
          pincode: "560095",
          viewport: %{
            northeast: %{lat: 12.94, lng: 77.63},
            southwest: %{lat: 12.93, lng: 77.62}
          }
        }
      }

      Geography.persist_ola_maps_geocoding("Koramangala, Bangalore", result)

      # Reload locality and assert boundary has been set
      locality =
        Locality
        |> where([l], l.id == ^locality.id)
        |> Repo.one!()

      assert %Geo.Polygon{srid: 4326} = locality.boundary
    end

    test "coordinates_in_locality?/3 uses boundary created from Ola Maps viewport" do
      # Create hierarchy and populate locality + boundary via Ola Maps persistence
      {:ok, country} =
        Geography.create_country(%{
          code: "IN",
          name: "India",
          status: "active"
        })

      {:ok, state} =
        Geography.create_state(%{
          country_id: country.id,
          code: "KA",
          name: "Karnataka",
          status: "active"
        })

      {:ok, city} =
        Geography.create_city(%{
          state_id: state.id,
          name: "Bangalore",
          status: "active"
        })

      result = %{
        latitude: Decimal.new("12.9352"),
        longitude: Decimal.new("77.6245"),
        formatted_address: "Koramangala, Bangalore, Karnataka 560095, India",
        address_components: %{
          country: "India",
          country_code: "IN",
          state: "Karnataka",
          city: "Bangalore",
          locality: "Koramangala",
          pincode: "560095",
          viewport: %{
            northeast: %{lat: 12.94, lng: 77.63},
            southwest: %{lat: 12.93, lng: 77.62}
          }
        }
      }

      Geography.persist_ola_maps_geocoding("Koramangala, Bangalore", result)

      locality =
        Locality
        |> where([l], l.city_id == ^city.id)
        |> where([l], l.name == "Koramangala")
        |> Repo.one!()

      assert %Geo.Polygon{srid: 4326} = locality.boundary

      # Point inside the viewport
      assert Geography.coordinates_in_locality?(12.9352, 77.6245, locality.id)

      # Point clearly outside the viewport
      refute Geography.coordinates_in_locality?(13.5, 78.0, locality.id)
    end
  end
end
