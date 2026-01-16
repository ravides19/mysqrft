defmodule Storybook.Components.Carousel.Carousel do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Carousel.carousel/1
  def render_source, do: :function

  @sample_images [
    "https://picsum.photos/seed/carousel1/800/400",
    "https://picsum.photos/seed/carousel2/800/400",
    "https://picsum.photos/seed/carousel3/800/400"
  ]

  defp slide_slots(opts \\ []) do
    positions = Keyword.get(opts, :positions, ["start", "center", "end"])
    with_descriptions = Keyword.get(opts, :with_descriptions, true)

    @sample_images
    |> Enum.zip(positions)
    |> Enum.with_index(1)
    |> Enum.map(fn {{image, position}, idx} ->
      description =
        if with_descriptions,
          do: ~s| description="Description for slide #{idx}"|,
          else: ""

      ~s|<:slide image="#{image}" title="Slide #{idx}" content_position="#{position}"#{description}/>|
    end)
    |> Enum.join("\n")
  end

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic carousel with navigation controls and multiple slides.",
        attributes: %{
          id: "carousel-default"
        },
        slots: [slide_slots()]
      },
      %Variation{
        id: :with_indicators,
        description: "With indicators",
        note: "Carousel with slide indicators for direct navigation.",
        attributes: %{
          id: "carousel-indicators",
          indicator: true
        },
        slots: [slide_slots()]
      },
      %Variation{
        id: :without_controls,
        description: "Without controls",
        note: "Carousel without prev/next navigation buttons.",
        attributes: %{
          id: "carousel-no-controls",
          control: false,
          indicator: true
        },
        slots: [slide_slots()]
      },
      %Variation{
        id: :with_autoplay,
        description: "With autoplay",
        note: "Carousel that automatically advances slides every 3 seconds.",
        attributes: %{
          id: "carousel-autoplay",
          autoplay: true,
          autoplay_interval: 3000,
          indicator: true
        },
        slots: [slide_slots()]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different text and layout sizes for the carousel.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              id: "carousel-size-xs",
              size: "extra_small",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :size_small,
            attributes: %{
              id: "carousel-size-sm",
              size: "small",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              id: "carousel-size-md",
              size: "medium",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :size_large,
            attributes: %{
              id: "carousel-size-lg",
              size: "large",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{
              id: "carousel-size-xl",
              size: "extra_large",
              indicator: true
            },
            slots: [slide_slots()]
          }
        ]
      },
      %VariationGroup{
        id: :overlays,
        description: "Overlay colors",
        note: "Different overlay color themes for the carousel.",
        variations: [
          %Variation{
            id: :overlay_base,
            attributes: %{
              id: "carousel-overlay-base",
              overlay: "base",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_natural,
            attributes: %{
              id: "carousel-overlay-natural",
              overlay: "natural",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_primary,
            attributes: %{
              id: "carousel-overlay-primary",
              overlay: "primary",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_secondary,
            attributes: %{
              id: "carousel-overlay-secondary",
              overlay: "secondary",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_success,
            attributes: %{
              id: "carousel-overlay-success",
              overlay: "success",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_warning,
            attributes: %{
              id: "carousel-overlay-warning",
              overlay: "warning",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_danger,
            attributes: %{
              id: "carousel-overlay-danger",
              overlay: "danger",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_info,
            attributes: %{
              id: "carousel-overlay-info",
              overlay: "info",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :overlay_dark,
            attributes: %{
              id: "carousel-overlay-dark",
              overlay: "dark",
              indicator: true
            },
            slots: [slide_slots()]
          }
        ]
      },
      %VariationGroup{
        id: :paddings,
        description: "Padding sizes",
        note: "Different padding options for slide content.",
        variations: [
          %Variation{
            id: :padding_extra_small,
            attributes: %{
              id: "carousel-padding-xs",
              padding: "extra_small",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :padding_small,
            attributes: %{
              id: "carousel-padding-sm",
              padding: "small",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :padding_medium,
            attributes: %{
              id: "carousel-padding-md",
              padding: "medium",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :padding_large,
            attributes: %{
              id: "carousel-padding-lg",
              padding: "large",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{
              id: "carousel-padding-xl",
              padding: "extra_large",
              indicator: true
            },
            slots: [slide_slots()]
          }
        ]
      },
      %VariationGroup{
        id: :text_positions,
        description: "Text positions",
        note: "Different text alignment options for slide content.",
        variations: [
          %Variation{
            id: :text_start,
            attributes: %{
              id: "carousel-text-start",
              text_position: "start",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :text_center,
            attributes: %{
              id: "carousel-text-center",
              text_position: "center",
              indicator: true
            },
            slots: [slide_slots()]
          },
          %Variation{
            id: :text_end,
            attributes: %{
              id: "carousel-text-end",
              text_position: "end",
              indicator: true
            },
            slots: [slide_slots()]
          }
        ]
      },
      %Variation{
        id: :with_links,
        description: "With navigation links",
        note: "Slides with clickable links using navigate, patch, or href.",
        attributes: %{
          id: "carousel-with-links",
          indicator: true
        },
        slots: [
          """
          <:slide image="https://picsum.photos/seed/link1/800/400" title="Navigate Link" description="Click to navigate" content_position="center" navigate="/examples"/>
          <:slide image="https://picsum.photos/seed/link2/800/400" title="Patch Link" description="Click to patch" content_position="center" patch="/examples"/>
          <:slide image="https://picsum.photos/seed/link3/800/400" title="External Link" description="Click to visit" content_position="center" href="https://example.com"/>
          """
        ]
      },
      %Variation{
        id: :minimal,
        description: "Minimal (images only)",
        note: "Carousel with images only, no titles or descriptions.",
        attributes: %{
          id: "carousel-minimal",
          control: true,
          indicator: true
        },
        slots: [
          """
          <:slide image="https://picsum.photos/seed/minimal1/800/400"/>
          <:slide image="https://picsum.photos/seed/minimal2/800/400"/>
          <:slide image="https://picsum.photos/seed/minimal3/800/400"/>
          """
        ]
      },
      %Variation{
        id: :custom_active,
        description: "Custom active index",
        note: "Carousel starting at a specific slide (index 1 = second slide).",
        attributes: %{
          id: "carousel-custom-active",
          active_index: 1,
          indicator: true
        },
        slots: [slide_slots()]
      },
      MySqrftWeb.Storybook.ComponentDefaults.all_params_variation(function(),
        id: :all_params,
        description: "All params"
      )
    ]
  end
end
