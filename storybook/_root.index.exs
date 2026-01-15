defmodule Storybook.Root do
  # See https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Index.html for full index
  # documentation.

  use PhoenixStorybook.Index

  def folder_icon, do: {:local, "hero-book-open"}
  def folder_name, do: "Storybook"

  def entry("welcome") do
    [
      name: "Welcome Page",
      icon: {:local, "hero-hand-raised"}
    ]
  end

  def entry("components") do
    [
      name: "MySqrft Components",
      icon: {:local, "hero-squares-2x2"}
    ]
  end
end
