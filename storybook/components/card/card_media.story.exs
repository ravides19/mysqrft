defmodule Storybook.Components.Card.CardMedia do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Card.card_media/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic card media with full width.",
        attributes: %{
          id: "card-media-default",
          src: "https://picsum.photos/400/200",
          alt: "Sample image"
        }
      },
      %Variation{
        id: :with_rounded,
        description: "With rounded corners",
        note: "Card media with rounded corners.",
        attributes: %{
          id: "card-media-rounded",
          src: "https://picsum.photos/400/200",
          alt: "Rounded image",
          rounded: "large"
        }
      },
      %VariationGroup{
        id: :rounded,
        description: "Rounded corners",
        note: "Different border radius options.",
        variations: [
          %Variation{
            id: :rounded_none,
            attributes: %{id: "card-media-rounded-none", src: "https://picsum.photos/200/120", alt: "None", rounded: "none", width: "w-48"}
          },
          %Variation{
            id: :rounded_extra_small,
            attributes: %{id: "card-media-rounded-xs", src: "https://picsum.photos/200/120", alt: "Extra Small", rounded: "extra_small", width: "w-48"}
          },
          %Variation{
            id: :rounded_small,
            attributes: %{id: "card-media-rounded-sm", src: "https://picsum.photos/200/120", alt: "Small", rounded: "small", width: "w-48"}
          },
          %Variation{
            id: :rounded_medium,
            attributes: %{id: "card-media-rounded-md", src: "https://picsum.photos/200/120", alt: "Medium", rounded: "medium", width: "w-48"}
          },
          %Variation{
            id: :rounded_large,
            attributes: %{id: "card-media-rounded-lg", src: "https://picsum.photos/200/120", alt: "Large", rounded: "large", width: "w-48"}
          },
          %Variation{
            id: :rounded_extra_large,
            attributes: %{id: "card-media-rounded-xl", src: "https://picsum.photos/200/120", alt: "Extra Large", rounded: "extra_large", width: "w-48"}
          }
        ]
      },
      %VariationGroup{
        id: :widths,
        description: "Widths",
        note: "Different width options.",
        variations: [
          %Variation{
            id: :width_full,
            attributes: %{id: "card-media-w-full", src: "https://picsum.photos/400/100", alt: "Full width", width: "w-full"}
          },
          %Variation{
            id: :width_96,
            attributes: %{id: "card-media-w-96", src: "https://picsum.photos/400/100", alt: "w-96", width: "w-96"}
          },
          %Variation{
            id: :width_64,
            attributes: %{id: "card-media-w-64", src: "https://picsum.photos/300/100", alt: "w-64", width: "w-64"}
          },
          %Variation{
            id: :width_48,
            attributes: %{id: "card-media-w-48", src: "https://picsum.photos/200/100", alt: "w-48", width: "w-48"}
          },
          %Variation{
            id: :width_32,
            attributes: %{id: "card-media-w-32", src: "https://picsum.photos/150/100", alt: "w-32", width: "w-32"}
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world card media examples.",
        variations: [
          %Variation{
            id: :product_image,
            attributes: %{
              id: "card-media-product",
              src: "https://picsum.photos/300/300",
              alt: "Product image",
              width: "w-64",
              rounded: "medium"
            }
          },
          %Variation{
            id: :blog_thumbnail,
            attributes: %{
              id: "card-media-blog",
              src: "https://picsum.photos/400/200",
              alt: "Blog post thumbnail",
              width: "w-full",
              rounded: "large"
            }
          },
          %Variation{
            id: :avatar_image,
            attributes: %{
              id: "card-media-avatar",
              src: "https://picsum.photos/100/100",
              alt: "User avatar",
              width: "w-16",
              rounded: "extra_large"
            }
          },
          %Variation{
            id: :banner_image,
            attributes: %{
              id: "card-media-banner",
              src: "https://picsum.photos/600/150",
              alt: "Banner image",
              width: "w-full",
              rounded: "none"
            }
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
