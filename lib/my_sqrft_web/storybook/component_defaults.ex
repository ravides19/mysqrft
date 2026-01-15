defmodule MySqrftWeb.Storybook.ComponentDefaults do
  @moduledoc false

  alias PhoenixStorybook.Stories.{Attr, Slot, Variation}

  @doc """
  Builds a single variation that tries to populate **every declared attr and slot** with a sane
  sample value, based on declarative `attr/slot` metadata.
  """
  def all_params_variation(fun, opts \\ []) when is_function(fun) do
    id = Keyword.get(opts, :id, :all_params)
    description = Keyword.get(opts, :description, "All params")
    note = Keyword.get(opts, :note, "Auto-generated from declarative attr/slot definitions.")

    merged_attrs = Attr.merge_attributes(fun, [])
    merged_slots = Slot.merge_slots(fun, [])

    %Variation{
      id: id,
      description: description,
      note: note,
      attributes: build_attributes(merged_attrs),
      slots: build_slots(merged_slots)
    }
  end

  defp build_attributes(attrs) do
    Enum.reduce(attrs, %{}, fn attr = %Attr{id: id}, acc ->
      Map.put(acc, id, sample_value(attr))
    end)
  end

  defp build_slots([]), do: []

  defp build_slots(slots) do
    slots
    |> Enum.map(&slot_markup/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.intersperse("\n")
  end

  defp slot_markup(%Slot{id: :inner_block}) do
    "Example"
  end

  defp slot_markup(slot = %Slot{id: id}) do
    attrs = slot_attrs_markup(slot.attrs)
    content = "#{id} content"

    if attrs == "" do
      ~s|<:#{id}>#{content}</:#{id}>|
    else
      ~s|<:#{id} #{attrs}>#{content}</:#{id}>|
    end
  end

  defp slot_attrs_markup([]), do: ""

  defp slot_attrs_markup(attrs) do
    attrs
    |> Enum.map(&attr_markup/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
  end

  defp attr_markup(attr = %Attr{id: id}) do
    case sample_value(attr) do
      false -> nil
      true -> to_string(id)
      val when is_binary(val) -> ~s|#{id}="#{val}"|
      val -> ~s|#{id}={#{inspect(val)}}|
    end
  end

  defp sample_value(%Attr{required: true} = attr) do
    sample_value_required(attr)
  end

  defp sample_value(%Attr{} = attr) do
    sample_value_optional(attr)
  end

  defp sample_value_required(%Attr{} = attr) do
    val = sample_value_optional(attr)
    if is_nil(val), do: fallback_value(attr), else: val
  end

  defp sample_value_optional(%Attr{type: :global}), do: %{}

  defp sample_value_optional(%Attr{default: default, values: values} = attr) do
    cond do
      attr.id == :for ->
        sample_form()

      attr.id == :as ->
        :demo

      attr.id == :uploads ->
        %{}

      icon_attr?(attr.id) ->
        "hero-x-mark"

      true ->
        :ok
    end
    |> case do
      :ok ->
        cond do
          not is_nil(default) ->
            default

          is_list(values) and values != [] ->
            Enum.find(values, fn v -> not is_nil(v) end) || List.first(values)

          true ->
            fallback_value(attr)
        end

      val ->
        val
    end
  end

  defp icon_attr?(id) when is_atom(id) do
    id == :icon or String.ends_with?(Atom.to_string(id), "_icon")
  end

  defp fallback_value(%Attr{type: :string}), do: "example"
  defp fallback_value(%Attr{type: :boolean}), do: true
  defp fallback_value(%Attr{type: :integer}), do: 1
  defp fallback_value(%Attr{type: :float}), do: 1.0
  defp fallback_value(%Attr{type: :atom}), do: :example
  defp fallback_value(%Attr{type: :map}), do: %{}
  defp fallback_value(%Attr{type: :list}), do: []
  defp fallback_value(%Attr{type: :any}), do: "example"
  defp fallback_value(%Attr{type: Phoenix.LiveView.JS}), do: %Phoenix.LiveView.JS{}
  defp fallback_value(%Attr{type: Phoenix.HTML.FormField}), do: sample_form_field()
  defp fallback_value(%Attr{type: {:struct, Phoenix.HTML.FormField}}), do: sample_form_field()

  defp fallback_value(%Attr{type: module}) when is_atom(module) do
    try do
      struct(module)
    rescue
      _ -> nil
    end
  end

  defp sample_form do
    Phoenix.Component.to_form(%{"field" => "value"}, as: :demo)
  end

  defp sample_form_field do
    sample_form()[:field]
  end
end
