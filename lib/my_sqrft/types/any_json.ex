defmodule MySqrft.Type.AnyJSON do
  @moduledoc """
  A custom Ecto type that allows any valid JSON value (map, list, string, number, boolean, nil).
  Standard :map type in Ecto enforces that the value must be a Map, which is too restrictive for our use case.
  """
  use Ecto.Type

  def type, do: :map

  def cast(value), do: {:ok, value}

  def load(value), do: {:ok, value}

  def dump(value), do: {:ok, value}

  def embed_as(_), do: :self

  def equal?(a, b), do: a == b
end
