defmodule Storybook.Components do
  # See https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Index.html for full index
  # documentation.
  use PhoenixStorybook.Index

  def folder_name, do: "MySqrft UI"
  def folder_icon, do: {:fa, "layer-group", :thin}
  def folder_open?, do: true
end
