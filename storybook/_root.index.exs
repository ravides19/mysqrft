defmodule Storybook.Root do
  # See https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Index.html for full index
  # documentation.

  use PhoenixStorybook.Index

  def folder_icon, do: {:local, "hero-book-open"}
  def folder_name, do: "MySqrft UI"

  def entry("welcome") do
    [
      name: "Welcome Page",
      icon: {:local, "hero-hand-raised"}
    ]
  end
end
