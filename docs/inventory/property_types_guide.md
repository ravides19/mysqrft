# Property Types and Configurations Guide

This guide documents all supported property types and their required/optional configuration fields in the MySqrft Inventory domain.

## Overview

Properties in MySqrft are polymorphic - each property type has specific required and optional fields stored in the `configuration` JSONB field. The `PropertyTypeValidator` module enforces these rules.

---

## Property Types

### 1. Apartment

**Type Code**: `apartment`

**Required Configuration**:
- `bhk` (integer, 1-10): Number of bedrooms
- `bathrooms` (integer, > 0): Number of bathrooms
- `built_up_area` (number, > 0): Built-up area in square feet

**Optional Configuration**:
- `floor` (integer, > 0): Floor number
- `total_floors` (integer, >= floor): Total floors in building
- `balconies` (integer, >= 0): Number of balconies
- `parking_slots` (integer, >= 0): Number of parking slots
- `project_name` (string): Name of the apartment complex

**Example**:
```elixir
%{
  "type" => "apartment",
  "configuration" => %{
    "bhk" => 2,
    "bathrooms" => 2,
    "built_up_area" => 1200,
    "floor" => 5,
    "total_floors" => 15,
    "balconies" => 2,
    "parking_slots" => 1,
    "project_name" => "Green Valley Apartments"
  }
}
```

---

### 2. Villa

**Type Code**: `villa`

**Required Configuration**:
- `plot_area` (number, > 0): Plot area in square feet
- `built_up_area` (number, > 0): Built-up area in square feet
- `bathrooms` (integer, > 0): Number of bathrooms

**Optional Configuration**:
- `bhk` (integer, 1-10): Number of bedrooms
- `floors` (integer, > 0): Number of floors
- `land_facing` (string): Direction the land faces (e.g., "north", "east")
- `parking_slots` (integer, >= 0): Number of parking slots

**Example**:
```elixir
%{
  "type" => "villa",
  "configuration" => %{
    "plot_area" => 2400,
    "built_up_area" => 3000,
    "bathrooms" => 4,
    "bhk" => 4,
    "floors" => 2,
    "land_facing" => "east",
    "parking_slots" => 2
  }
}
```

---

### 3. Independent House

**Type Code**: `independent_house`

**Required Configuration**:
- `plot_area` (number, > 0): Plot area in square feet
- `built_up_area` (number, > 0): Built-up area in square feet
- `bathrooms` (integer, > 0): Number of bathrooms

**Optional Configuration**:
- `bhk` (integer, 1-10): Number of bedrooms
- `floors` (integer, > 0): Number of floors
- `land_facing` (string): Direction the land faces
- `parking_slots` (integer, >= 0): Number of parking slots

**Example**:
```elixir
%{
  "type" => "independent_house",
  "configuration" => %{
    "plot_area" => 1800,
    "built_up_area" => 2200,
    "bathrooms" => 3,
    "bhk" => 3,
    "floors" => 2,
    "land_facing" => "north",
    "parking_slots" => 2
  }
}
```

---

### 4. Plot

**Type Code**: `plot`

**Required Configuration**:
- `plot_area` (number, > 0): Plot area in square feet

**Optional Configuration**:
- `land_facing` (string): Direction the land faces
- `plot_dimensions` (string): Dimensions (e.g., "40x60 feet")
- `boundary_wall` (boolean): Whether boundary wall exists

**Example**:
```elixir
%{
  "type" => "plot",
  "configuration" => %{
    "plot_area" => 2400,
    "land_facing" => "east",
    "plot_dimensions" => "40x60",
    "boundary_wall" => true
  }
}
```

---

### 5. Commercial

**Type Code**: `commercial`

**Required Configuration**:
- `built_up_area` (number, > 0): Built-up area in square feet
- `commercial_type` (string): Type of commercial property

**Commercial Types**:
- `office`: Office space
- `retail`: Retail shop
- `warehouse`: Warehouse/storage
- `industrial`: Industrial unit
- `mixed_use`: Mixed-use commercial

**Optional Configuration**:
- `floor` (integer, > 0): Floor number
- `total_floors` (integer, >= floor): Total floors in building
- `parking_slots` (integer, >= 0): Number of parking slots
- `washrooms` (integer, >= 0): Number of washrooms

**Example**:
```elixir
%{
  "type" => "commercial",
  "configuration" => %{
    "built_up_area" => 1500,
    "commercial_type" => "office",
    "floor" => 3,
    "total_floors" => 10,
    "parking_slots" => 3,
    "washrooms" => 2
  }
}
```

---

### 6. Managed (PG/Hostel)

**Type Code**: `managed`

**Required Configuration**:
- `total_beds` (integer, > 0): Total number of beds
- `occupancy_type` (string): Type of occupancy

**Occupancy Types**:
- `single`: Single occupancy
- `double`: Double occupancy
- `triple`: Triple occupancy
- `dormitory`: Dormitory style

**Optional Configuration**:
- `bathrooms` (integer, >= 0): Number of bathrooms
- `common_areas` (array): List of common areas (e.g., ["kitchen", "lounge"])
- `meal_plan` (string): Meal plan offered (e.g., "breakfast", "full_board")
- `gender_preference` (string): Gender preference (e.g., "male", "female", "any")

**Example**:
```elixir
%{
  "type" => "managed",
  "configuration" => %{
    "total_beds" => 20,
    "occupancy_type" => "double",
    "bathrooms" => 4,
    "common_areas" => ["kitchen", "lounge", "study_room"],
    "meal_plan" => "breakfast",
    "gender_preference" => "male"
  }
}
```

---

## Validation

All property configurations are validated using the `PropertyTypeValidator` module:

```elixir
# Automatic validation during property creation/update
{:ok, property} = Properties.create_property(owner, attrs)

# Manual validation
case PropertyTypeValidator.validate_configuration(type, configuration) do
  :ok -> # Valid
  {:error, errors} -> # Invalid, errors is a keyword list
end
```

## Best Practices

1. **Always include required fields** - The system will reject properties without required configuration
2. **Use consistent units** - All areas are in square feet
3. **Validate before submission** - Use the validator to check configurations before saving
4. **Keep configurations up-to-date** - Update configurations when property details change
5. **Use appropriate types** - Choose the most specific property type that matches your property
