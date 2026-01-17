defmodule MySqrftWeb.ComponentCase do
  @moduledoc """
  Helper module for testing Phoenix components.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.Component
      import MySqrftWeb.ComponentCase
    end
  end

  def render_component(component, assigns \\ %{}) do
    # Ensure __changed__ is set and inner_block exists
    changed = Map.get(assigns, :__changed__, %{})
    inner_block = Map.get(assigns, :inner_block)

    # Format inner_block as a slot entry - Phoenix expects slots to be lists of entries
    # Each entry is a map with :inner_block and :__slot__ keys
    inner_block_slot =
      cond do
        is_function(inner_block, 2) ->
          # Create a slot entry with the inner_block function
          entry = %{
            __slot__: :inner_block,
            inner_block: inner_block
          }
          [entry]
        is_nil(inner_block) ->
          []
        true ->
          inner_block
      end

    assigns =
      assigns
      |> Map.put(:__changed__, Map.put(changed, :inner_block, true))
      |> Map.put(:inner_block, inner_block_slot)

    try do
      template = component.(assigns)
      template |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
    rescue
      e ->
        # If rendering fails, re-raise the error
        # The component function reference is valid if we got here
        raise e
    end
  end

  def inner_block(content) when is_binary(content) do
    # Create a function that accepts 2 arguments (assigns and optional default)
    fn _assigns, _default -> Phoenix.HTML.raw(content) end
  end

  def inner_block(template) when is_function(template, 1) do
    # Wrap the function to handle being called with 2 arguments (assigns and optional default)
    fn assigns, _default -> template.(assigns) end
  end
end
