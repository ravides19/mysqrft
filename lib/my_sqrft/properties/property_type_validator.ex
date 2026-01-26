defmodule MySqrft.Properties.PropertyTypeValidator do
  @moduledoc """
  Validates property configuration based on property type.

  Each property type (apartment, villa, plot, etc.) has specific required
  and optional fields in the configuration map.
  """

  @doc """
  Validates property configuration based on type.

  Returns :ok or {:error, [field: message]}
  """
  def validate_configuration(type, configuration) when is_map(configuration) do
    case type do
      "apartment" -> validate_apartment(configuration)
      "villa" -> validate_villa(configuration)
      "independent_house" -> validate_independent_house(configuration)
      "plot" -> validate_plot(configuration)
      "commercial" -> validate_commercial(configuration)
      "managed" -> validate_managed(configuration)
      _ -> {:error, [type: "invalid property type"]}
    end
  end

  def validate_configuration(_type, _config), do: {:error, [configuration: "must be a map"]}

  # Apartment validation
  defp validate_apartment(config) do
    required = [:bhk, :bathrooms, :built_up_area]
    optional = [:floor, :total_floors, :balconies, :parking_slots, :project_name]

    with :ok <- validate_required_fields(config, required),
         :ok <- validate_bhk(config[:bhk]),
         :ok <- validate_positive_integer(config[:bathrooms], :bathrooms),
         :ok <- validate_positive_number(config[:built_up_area], :built_up_area),
         :ok <- validate_optional_floor(config) do
      :ok
    end
  end

  # Villa validation
  defp validate_villa(config) do
    required = [:plot_area, :built_up_area, :bathrooms]
    optional = [:bhk, :floors, :land_facing, :parking_slots]

    with :ok <- validate_required_fields(config, required),
         :ok <- validate_positive_number(config[:plot_area], :plot_area),
         :ok <- validate_positive_number(config[:built_up_area], :built_up_area),
         :ok <- validate_positive_integer(config[:bathrooms], :bathrooms) do
      :ok
    end
  end

  # Independent house validation
  defp validate_independent_house(config) do
    required = [:plot_area, :built_up_area, :bathrooms]
    optional = [:bhk, :floors, :land_facing, :parking_slots]

    with :ok <- validate_required_fields(config, required),
         :ok <- validate_positive_number(config[:plot_area], :plot_area),
         :ok <- validate_positive_number(config[:built_up_area], :built_up_area),
         :ok <- validate_positive_integer(config[:bathrooms], :bathrooms) do
      :ok
    end
  end

  # Plot validation
  defp validate_plot(config) do
    required = [:plot_area]
    optional = [:land_facing, :plot_dimensions, :boundary_wall]

    with :ok <- validate_required_fields(config, required),
         :ok <- validate_positive_number(config[:plot_area], :plot_area) do
      :ok
    end
  end

  # Commercial validation
  defp validate_commercial(config) do
    required = [:built_up_area, :commercial_type]
    optional = [:floor, :total_floors, :parking_slots, :washrooms]

    with :ok <- validate_required_fields(config, required),
         :ok <- validate_positive_number(config[:built_up_area], :built_up_area),
         :ok <- validate_commercial_type(config[:commercial_type]) do
      :ok
    end
  end

  # Managed (PG/Hostel) validation
  defp validate_managed(config) do
    required = [:total_beds, :occupancy_type]
    optional = [:bathrooms, :common_areas, :meal_plan, :gender_preference]

    with :ok <- validate_required_fields(config, required),
         :ok <- validate_positive_integer(config[:total_beds], :total_beds),
         :ok <- validate_occupancy_type(config[:occupancy_type]) do
      :ok
    end
  end

  # Helper validators
  defp validate_required_fields(config, required_fields) do
    missing =
      Enum.filter(required_fields, fn field ->
        value = Map.get(config, field) || Map.get(config, to_string(field))
        is_nil(value) or value == ""
      end)

    if Enum.empty?(missing) do
      :ok
    else
      {:error, Enum.map(missing, fn field -> {field, "is required"} end)}
    end
  end

  defp validate_bhk(bhk) when is_integer(bhk) and bhk >= 1 and bhk <= 10, do: :ok
  defp validate_bhk(_), do: {:error, [bhk: "must be between 1 and 10"]}

  defp validate_positive_integer(value, _field) when is_integer(value) and value > 0, do: :ok

  defp validate_positive_integer(value, _field) when is_binary(value) do
    case Integer.parse(value) do
      {int, ""} when int > 0 -> :ok
      _ -> {:error, "must be a positive integer"}
    end
  end

  defp validate_positive_integer(_, field),
    do: {:error, [{field, "must be a positive integer"}]}

  defp validate_positive_number(value, _field) when is_number(value) and value > 0, do: :ok

  defp validate_positive_number(value, _field) when is_binary(value) do
    case Float.parse(value) do
      {num, ""} when num > 0 -> :ok
      _ -> {:error, "must be a positive number"}
    end
  end

  defp validate_positive_number(_, field), do: {:error, [{field, "must be a positive number"}]}

  defp validate_optional_floor(config) do
    floor = Map.get(config, :floor) || Map.get(config, "floor")
    total_floors = Map.get(config, :total_floors) || Map.get(config, "total_floors")

    cond do
      is_nil(floor) and is_nil(total_floors) ->
        :ok

      is_integer(floor) and is_integer(total_floors) and floor > 0 and total_floors >= floor ->
        :ok

      true ->
        {:error, [floor: "floor must be <= total_floors and both must be positive"]}
    end
  end

  defp validate_commercial_type(type)
       when type in ["office", "retail", "warehouse", "industrial", "mixed_use"],
       do: :ok

  defp validate_commercial_type(_),
    do: {:error, [commercial_type: "must be office, retail, warehouse, industrial, or mixed_use"]}

  defp validate_occupancy_type(type) when type in ["single", "double", "triple", "dormitory"],
    do: :ok

  defp validate_occupancy_type(_),
    do: {:error, [occupancy_type: "must be single, double, triple, or dormitory"]}
end
