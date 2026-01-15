defmodule Storybook.Components.Accordion.Accordion do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Accordion.accordion/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Most common accordion setup: single open at a time, with the right chevron.",
        attributes: %{
          id: "accordion-default",
          variant: "base",
          color: "natural",
          size: "medium",
          rounded: "medium",
          border: "extra_small",
          padding: "small"
        },
        slots: [
          ~s|<:item id="accordion-default-item-1" title="Shipping" description="Delivery times & tracking">We ship within 1–2 business days.</:item>|,
          ~s|<:item id="accordion-default-item-2" title="Returns" description="Easy 30‑day returns">Return your item in its original condition.</:item>|,
          ~s|<:item id="accordion-default-item-3" title="Support" description="We’re here to help">Email us at support@example.com.</:item>|
        ]
      },
      %Variation{
        id: :multiple_open,
        description: "Multiple open",
        note: "Allows multiple panels to be open simultaneously.",
        attributes: %{
          id: "accordion-multiple",
          multiple: true,
          initial_open: ["accordion-multiple-item-1", "accordion-multiple-item-2"],
          variant: "outline",
          color: "primary",
          size: "medium"
        },
        slots: [
          ~s|<:item id="accordion-multiple-item-1" title="Account" icon="hero-user-circle">Manage your profile and preferences.</:item>|,
          ~s|<:item id="accordion-multiple-item-2" title="Billing" icon="hero-credit-card">Update payment methods and invoices.</:item>|,
          ~s|<:item id="accordion-multiple-item-3" title="Security" icon="hero-shield-check">Set up MFA and review recent logins.</:item>|
        ]
      },
      %Variation{
        id: :no_chevron,
        description: "No chevron",
        note: "Chevron hidden, useful for custom trigger styling or minimal UIs.",
        attributes: %{
          id: "accordion-no-chevron",
          hide_chevron: true,
          variant: "transparent",
          color: "natural",
          size: "medium"
        },
        slots: [
          ~s|<:item id="accordion-no-chevron-item-1" title="Details">This is a minimalist accordion without a chevron.</:item>|,
          ~s|<:item id="accordion-no-chevron-item-2" title="More info">Great for dense layouts.</:item>|
        ]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Same content rendered across common visual variants.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{
              id: "accordion-variant-base",
              variant: "base",
              color: "natural",
              size: "medium"
            },
            slots: [
              ~s|<:item id="accordion-variant-base-item-1" title="Base">Base variant content.</:item>|,
              ~s|<:item id="accordion-variant-base-item-2" title="Base 2">Another item.</:item>|
            ]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{
              id: "accordion-variant-outline",
              variant: "outline",
              color: "secondary",
              size: "medium"
            },
            slots: [
              ~s|<:item id="accordion-variant-outline-item-1" title="Outline">Outline variant content.</:item>|,
              ~s|<:item id="accordion-variant-outline-item-2" title="Outline 2">Another item.</:item>|
            ]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{
              id: "accordion-variant-bordered",
              variant: "bordered",
              color: "success",
              size: "medium"
            },
            slots: [
              ~s|<:item id="accordion-variant-bordered-item-1" title="Bordered">Bordered variant content.</:item>|,
              ~s|<:item id="accordion-variant-bordered-item-2" title="Bordered 2">Another item.</:item>|
            ]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Typography and spacing scale with `size`.",
        variations: [
          %Variation{
            id: :size_small,
            attributes: %{
              id: "accordion-size-small",
              size: "small",
              variant: "base",
              color: "natural"
            },
            slots: [
              ~s|<:item id="accordion-size-small-item-1" title="Small">Smaller type + tighter spacing.</:item>|
            ]
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              id: "accordion-size-medium",
              size: "medium",
              variant: "base",
              color: "natural"
            },
            slots: [
              ~s|<:item id="accordion-size-medium-item-1" title="Medium">Default sizing.</:item>|
            ]
          },
          %Variation{
            id: :size_large,
            attributes: %{
              id: "accordion-size-large",
              size: "large",
              variant: "base",
              color: "natural"
            },
            slots: [
              ~s|<:item id="accordion-size-large-item-1" title="Large">Larger type + more breathing room.</:item>|
            ]
          }
        ]
      },
      MySqrftWeb.Storybook.ComponentDefaults.all_params_variation(function(),
        id: :all_params,
        description: "All params"
      )
    ]
  end
end
