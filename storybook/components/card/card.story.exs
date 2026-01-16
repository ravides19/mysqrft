defmodule Storybook.Components.Card.Card do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Card.card/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic card with default styling.",
        attributes: %{
          id: "card-default",
          padding: "medium",
          rounded: "large"
        },
        slots: [
          ~s|<div class="font-semibold text-lg">Card Title</div>|,
          ~s|<p>This is the card content. Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>|
        ]
      },
      %Variation{
        id: :with_image,
        description: "With image",
        note: "Card with an image header.",
        attributes: %{
          id: "card-image",
          rounded: "large",
          variant: "bordered",
          color: "natural"
        },
        slots: [
          ~s|<img src="https://picsum.photos/400/200" alt="Card image" class="w-full" />|,
          ~s|<div class="p-4">A beautiful card with an image.</div>|
        ]
      },
      %Variation{
        id: :with_sections,
        description: "With sections",
        note: "Card with header, content, and footer sections.",
        attributes: %{
          id: "card-sections",
          padding: "medium",
          rounded: "large",
          variant: "bordered",
          color: "natural",
          space: "small"
        },
        slots: [
          ~s|<div class="font-semibold border-b pb-2">Featured Article</div>|,
          ~s|<p class="py-2">Discover the latest trends in web development and design.</p>|,
          ~s|<div class="flex justify-end gap-2 border-t pt-2"><button class="px-3 py-1 border rounded">Cancel</button><button class="px-3 py-1 bg-blue-500 text-white rounded">Read More</button></div>|
        ]
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for cards.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{id: "card-variant-base", variant: "base", color: "natural", padding: "medium", rounded: "medium"},
            slots: ["Base variant card"]
          },
          %Variation{
            id: :variant_default,
            attributes: %{id: "card-variant-default", variant: "default", color: "primary", padding: "medium", rounded: "medium"},
            slots: ["Default variant card"]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{id: "card-variant-outline", variant: "outline", color: "primary", padding: "medium", rounded: "medium"},
            slots: ["Outline variant card"]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{id: "card-variant-shadow", variant: "shadow", color: "primary", padding: "medium", rounded: "medium"},
            slots: ["Shadow variant card"]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{id: "card-variant-bordered", variant: "bordered", color: "primary", padding: "medium", rounded: "medium"},
            slots: ["Bordered variant card"]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{id: "card-variant-transparent", variant: "transparent", color: "primary", padding: "medium", rounded: "medium"},
            slots: ["Transparent variant card"]
          },
          %Variation{
            id: :variant_gradient,
            attributes: %{id: "card-variant-gradient", variant: "gradient", color: "primary", padding: "medium", rounded: "medium"},
            slots: ["Gradient variant card"]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for cards.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{id: "card-color-natural", variant: "default", color: "natural", padding: "small", rounded: "medium"},
            slots: ["Natural"]
          },
          %Variation{
            id: :color_primary,
            attributes: %{id: "card-color-primary", variant: "default", color: "primary", padding: "small", rounded: "medium"},
            slots: ["Primary"]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{id: "card-color-secondary", variant: "default", color: "secondary", padding: "small", rounded: "medium"},
            slots: ["Secondary"]
          },
          %Variation{
            id: :color_success,
            attributes: %{id: "card-color-success", variant: "default", color: "success", padding: "small", rounded: "medium"},
            slots: ["Success"]
          },
          %Variation{
            id: :color_warning,
            attributes: %{id: "card-color-warning", variant: "default", color: "warning", padding: "small", rounded: "medium"},
            slots: ["Warning"]
          },
          %Variation{
            id: :color_danger,
            attributes: %{id: "card-color-danger", variant: "default", color: "danger", padding: "small", rounded: "medium"},
            slots: ["Danger"]
          },
          %Variation{
            id: :color_info,
            attributes: %{id: "card-color-info", variant: "default", color: "info", padding: "small", rounded: "medium"},
            slots: ["Info"]
          },
          %Variation{
            id: :color_misc,
            attributes: %{id: "card-color-misc", variant: "default", color: "misc", padding: "small", rounded: "medium"},
            slots: ["Misc"]
          },
          %Variation{
            id: :color_dawn,
            attributes: %{id: "card-color-dawn", variant: "default", color: "dawn", padding: "small", rounded: "medium"},
            slots: ["Dawn"]
          },
          %Variation{
            id: :color_silver,
            attributes: %{id: "card-color-silver", variant: "default", color: "silver", padding: "small", rounded: "medium"},
            slots: ["Silver"]
          }
        ]
      },
      %VariationGroup{
        id: :rounded,
        description: "Rounded corners",
        note: "Different border radius options.",
        variations: [
          %Variation{
            id: :rounded_none,
            attributes: %{id: "card-rounded-none", variant: "bordered", color: "natural", padding: "small", rounded: "none"},
            slots: ["None"]
          },
          %Variation{
            id: :rounded_extra_small,
            attributes: %{id: "card-rounded-xs", variant: "bordered", color: "natural", padding: "small", rounded: "extra_small"},
            slots: ["Extra Small"]
          },
          %Variation{
            id: :rounded_small,
            attributes: %{id: "card-rounded-sm", variant: "bordered", color: "natural", padding: "small", rounded: "small"},
            slots: ["Small"]
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{id: "card-rounded-md", variant: "bordered", color: "natural", padding: "small", rounded: "medium"},
            slots: ["Medium"]
          },
          %Variation{
            id: :rounded_large,
            attributes: %{id: "card-rounded-lg", variant: "bordered", color: "natural", padding: "small", rounded: "large"},
            slots: ["Large"]
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{id: "card-rounded-xl", variant: "bordered", color: "natural", padding: "small", rounded: "extra_large"},
            slots: ["Extra Large"]
          }
        ]
      },
      %VariationGroup{
        id: :padding,
        description: "Padding",
        note: "Different padding options.",
        variations: [
          %Variation{
            id: :padding_extra_small,
            attributes: %{id: "card-padding-xs", variant: "bordered", color: "natural", padding: "extra_small", rounded: "medium"},
            slots: ["Extra Small Padding"]
          },
          %Variation{
            id: :padding_small,
            attributes: %{id: "card-padding-sm", variant: "bordered", color: "natural", padding: "small", rounded: "medium"},
            slots: ["Small Padding"]
          },
          %Variation{
            id: :padding_medium,
            attributes: %{id: "card-padding-md", variant: "bordered", color: "natural", padding: "medium", rounded: "medium"},
            slots: ["Medium Padding"]
          },
          %Variation{
            id: :padding_large,
            attributes: %{id: "card-padding-lg", variant: "bordered", color: "natural", padding: "large", rounded: "medium"},
            slots: ["Large Padding"]
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{id: "card-padding-xl", variant: "bordered", color: "natural", padding: "extra_large", rounded: "medium"},
            slots: ["Extra Large Padding"]
          }
        ]
      },
      %VariationGroup{
        id: :border_sizes,
        description: "Border sizes",
        note: "Different border width options.",
        variations: [
          %Variation{
            id: :border_none,
            attributes: %{id: "card-border-none", variant: "bordered", color: "primary", border: "none", padding: "small", rounded: "medium"},
            slots: ["None"]
          },
          %Variation{
            id: :border_extra_small,
            attributes: %{id: "card-border-xs", variant: "bordered", color: "primary", border: "extra_small", padding: "small", rounded: "medium"},
            slots: ["Extra Small"]
          },
          %Variation{
            id: :border_small,
            attributes: %{id: "card-border-sm", variant: "bordered", color: "primary", border: "small", padding: "small", rounded: "medium"},
            slots: ["Small"]
          },
          %Variation{
            id: :border_medium,
            attributes: %{id: "card-border-md", variant: "bordered", color: "primary", border: "medium", padding: "small", rounded: "medium"},
            slots: ["Medium"]
          },
          %Variation{
            id: :border_large,
            attributes: %{id: "card-border-lg", variant: "bordered", color: "primary", border: "large", padding: "small", rounded: "medium"},
            slots: ["Large"]
          },
          %Variation{
            id: :border_extra_large,
            attributes: %{id: "card-border-xl", variant: "bordered", color: "primary", border: "extra_large", padding: "small", rounded: "medium"},
            slots: ["Extra Large"]
          }
        ]
      },
      %VariationGroup{
        id: :space,
        description: "Space between items",
        note: "Different spacing options for card sections.",
        variations: [
          %Variation{
            id: :space_extra_small,
            attributes: %{id: "card-space-xs", variant: "bordered", color: "natural", space: "extra_small", padding: "medium", rounded: "medium"},
            slots: [~s|<div>Title</div><div>Content</div><div>Footer</div>|]
          },
          %Variation{
            id: :space_small,
            attributes: %{id: "card-space-sm", variant: "bordered", color: "natural", space: "small", padding: "medium", rounded: "medium"},
            slots: [~s|<div>Title</div><div>Content</div><div>Footer</div>|]
          },
          %Variation{
            id: :space_medium,
            attributes: %{id: "card-space-md", variant: "bordered", color: "natural", space: "medium", padding: "medium", rounded: "medium"},
            slots: [~s|<div>Title</div><div>Content</div><div>Footer</div>|]
          },
          %Variation{
            id: :space_large,
            attributes: %{id: "card-space-lg", variant: "bordered", color: "natural", space: "large", padding: "medium", rounded: "medium"},
            slots: [~s|<div>Title</div><div>Content</div><div>Footer</div>|]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world card examples.",
        variations: [
          %Variation{
            id: :product_card,
            attributes: %{id: "card-product", variant: "bordered", color: "natural", rounded: "large"},
            slots: [
              ~s|<img src="https://picsum.photos/300/200" alt="Product" class="w-full" />|,
              ~s|<div class="p-4"><h3 class="font-semibold">Product Name</h3><p class="text-sm opacity-70">$99.99</p></div>|,
              ~s|<div class="p-4 pt-0"><button class="w-full bg-blue-500 text-white py-2 rounded">Add to Cart</button></div>|
            ]
          },
          %Variation{
            id: :profile_card,
            attributes: %{id: "card-profile", variant: "shadow", color: "natural", padding: "large", rounded: "large"},
            slots: [
              ~s|<div class="text-center"><div class="text-xl font-semibold">John Doe</div><p class="opacity-70">Senior Developer</p><p class="text-sm opacity-50">San Francisco, CA</p></div>|
            ]
          },
          %Variation{
            id: :notification_card,
            attributes: %{id: "card-notification", variant: "bordered", color: "info", padding: "medium", rounded: "medium"},
            slots: [
              ~s|<div class="flex justify-between items-start"><strong>New Update Available</strong><span class="text-xs opacity-70">2 hours ago</span></div>|,
              ~s|<p class="mt-2 text-sm">A new version of the application is available. Update now to get the latest features.</p>|
            ]
          },
          %Variation{
            id: :stats_card,
            attributes: %{id: "card-stats", variant: "gradient", color: "primary", padding: "large", rounded: "large"},
            slots: [
              ~s|<div class="font-medium mb-2">Total Revenue</div>|,
              ~s|<div class="text-3xl font-bold">$45,231</div>|,
              ~s|<div class="text-sm opacity-70 mt-1">+12.5% from last month</div>|
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
