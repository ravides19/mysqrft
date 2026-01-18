defmodule MySqrft.GeographyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MySqrft.Geography` context.
  """

  alias MySqrft.Geography

  def country_fixture(attrs \\ %{}) do
    default_attrs = %{
      code: "IN",
      name: "India",
      status: "active"
    }

    {:ok, country} =
      attrs
      |> Enum.into(default_attrs)
      |> Geography.create_country()

    country
  end

  def state_fixture(country \\ nil, attrs \\ %{}) do
    country = country || country_fixture()

    default_attrs = %{
      country_id: country.id,
      code: "KA",
      name: "Karnataka",
      status: "active"
    }

    {:ok, state} =
      attrs
      |> Enum.into(default_attrs)
      |> Geography.create_state()

    state
  end

  def city_fixture(state \\ nil, attrs \\ %{}) do
    state = state || state_fixture()

    default_attrs = %{
      state_id: state.id,
      name: "Bangalore",
      latitude: Decimal.new("12.9716"),
      longitude: Decimal.new("77.5946"),
      status: "active"
    }

    {:ok, city} =
      attrs
      |> Enum.into(default_attrs)
      |> Geography.create_city()

    city
  end

  def locality_fixture(city \\ nil, attrs \\ %{}) do
    city = city || city_fixture()

    default_attrs = %{
      city_id: city.id,
      name: "Koramangala",
      latitude: Decimal.new("12.9352"),
      longitude: Decimal.new("77.6245"),
      status: "active"
    }

    {:ok, locality} =
      attrs
      |> Enum.into(default_attrs)
      |> Geography.create_locality()

    locality
  end

  def pincode_fixture(locality \\ nil, attrs \\ %{}) do
    locality = locality || locality_fixture()

    default_attrs = %{
      locality_id: locality.id,
      code: "560095",
      latitude: Decimal.new("12.9352"),
      longitude: Decimal.new("77.6245"),
      status: "active"
    }

    {:ok, pincode} =
      attrs
      |> Enum.into(default_attrs)
      |> Geography.create_pincode()

    pincode
  end

  def landmark_fixture(locality \\ nil, attrs \\ %{}) do
    locality = locality || locality_fixture()

    default_attrs = %{
      locality_id: locality.id,
      name: "Phoenix Mall",
      category: "shopping_mall",
      latitude: Decimal.new("12.9352"),
      longitude: Decimal.new("77.6245"),
      status: "active"
    }

    {:ok, landmark} =
      attrs
      |> Enum.into(default_attrs)
      |> Geography.create_landmark()

    landmark
  end

  def complete_hierarchy_fixture(attrs \\ %{}) do
    country = country_fixture(Map.get(attrs, :country, %{}))
    state = state_fixture(country, Map.get(attrs, :state, %{}))
    city = city_fixture(state, Map.get(attrs, :city, %{}))
    locality = locality_fixture(city, Map.get(attrs, :locality, %{}))
    pincode = pincode_fixture(locality, Map.get(attrs, :pincode, %{}))

    %{
      country: country,
      state: state,
      city: city,
      locality: locality,
      pincode: pincode
    }
  end
end
