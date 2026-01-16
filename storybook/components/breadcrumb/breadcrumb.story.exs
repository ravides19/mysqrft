defmodule Storybook.Components.Breadcrumb.Breadcrumb do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Breadcrumb.breadcrumb/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic breadcrumb navigation with default styling.",
        attributes: %{
          id: "breadcrumb-default"
        },
        slots: [
          ~s|<:item link="/">Home</:item>|,
          ~s|<:item link="/products">Products</:item>|,
          ~s|<:item>Current Page</:item>|
        ]
      },
      %Variation{
        id: :with_icons,
        description: "With icons",
        note: "Breadcrumb items with icons for visual context.",
        attributes: %{
          id: "breadcrumb-icons",
          color: "primary"
        },
        slots: [
          ~s|<:item icon="hero-home" link="/">Home</:item>|,
          ~s|<:item icon="hero-folder" link="/docs">Documents</:item>|,
          ~s|<:item icon="hero-document-text">Report.pdf</:item>|
        ]
      },
      %Variation{
        id: :text_separator,
        description: "Text separator",
        note: "Using text as separator instead of icon.",
        attributes: %{
          id: "breadcrumb-text-sep",
          separator_icon: nil,
          separator_text: "/",
          color: "secondary"
        },
        slots: [
          ~s|<:item link="/">Home</:item>|,
          ~s|<:item link="/blog">Blog</:item>|,
          ~s|<:item link="/blog/posts">Posts</:item>|,
          ~s|<:item>Article Title</:item>|
        ]
      },
      %Variation{
        id: :custom_separator_icon,
        description: "Custom separator icon",
        note: "Using a different icon as separator.",
        attributes: %{
          id: "breadcrumb-custom-sep",
          separator_icon: "hero-arrow-right",
          color: "info"
        },
        slots: [
          ~s|<:item link="/">Start</:item>|,
          ~s|<:item link="/step1">Step 1</:item>|,
          ~s|<:item link="/step2">Step 2</:item>|,
          ~s|<:item>Finish</:item>|
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for breadcrumb navigation.",
        variations: [
          %Variation{
            id: :color_base,
            attributes: %{id: "breadcrumb-color-base", color: "base", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Base</:item>|
            ]
          },
          %Variation{
            id: :color_natural,
            attributes: %{id: "breadcrumb-color-natural", color: "natural", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Natural</:item>|
            ]
          },
          %Variation{
            id: :color_primary,
            attributes: %{id: "breadcrumb-color-primary", color: "primary", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Primary</:item>|
            ]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{id: "breadcrumb-color-secondary", color: "secondary", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Secondary</:item>|
            ]
          },
          %Variation{
            id: :color_success,
            attributes: %{id: "breadcrumb-color-success", color: "success", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Success</:item>|
            ]
          },
          %Variation{
            id: :color_warning,
            attributes: %{id: "breadcrumb-color-warning", color: "warning", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Warning</:item>|
            ]
          },
          %Variation{
            id: :color_danger,
            attributes: %{id: "breadcrumb-color-danger", color: "danger", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Danger</:item>|
            ]
          },
          %Variation{
            id: :color_info,
            attributes: %{id: "breadcrumb-color-info", color: "info", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Info</:item>|
            ]
          },
          %Variation{
            id: :color_misc,
            attributes: %{id: "breadcrumb-color-misc", color: "misc", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Misc</:item>|
            ]
          },
          %Variation{
            id: :color_dawn,
            attributes: %{id: "breadcrumb-color-dawn", color: "dawn", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Dawn</:item>|
            ]
          },
          %Variation{
            id: :color_silver,
            attributes: %{id: "breadcrumb-color-silver", color: "silver", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/page">Page</:item>|,
              ~s|<:item>Silver</:item>|
            ]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for breadcrumb navigation.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{id: "breadcrumb-size-xs", color: "primary", size: "extra_small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/section">Section</:item>|,
              ~s|<:item>Extra Small</:item>|
            ]
          },
          %Variation{
            id: :size_small,
            attributes: %{id: "breadcrumb-size-sm", color: "primary", size: "small"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/section">Section</:item>|,
              ~s|<:item>Small</:item>|
            ]
          },
          %Variation{
            id: :size_medium,
            attributes: %{id: "breadcrumb-size-md", color: "primary", size: "medium"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/section">Section</:item>|,
              ~s|<:item>Medium</:item>|
            ]
          },
          %Variation{
            id: :size_large,
            attributes: %{id: "breadcrumb-size-lg", color: "primary", size: "large"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/section">Section</:item>|,
              ~s|<:item>Large</:item>|
            ]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{id: "breadcrumb-size-xl", color: "primary", size: "extra_large"},
            slots: [
              ~s|<:item link="/">Home</:item>|,
              ~s|<:item link="/section">Section</:item>|,
              ~s|<:item>Extra Large</:item>|
            ]
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world breadcrumb examples.",
        variations: [
          %Variation{
            id: :e_commerce,
            attributes: %{id: "breadcrumb-ecommerce", color: "natural", size: "small"},
            slots: [
              ~s|<:item icon="hero-home" link="/">Home</:item>|,
              ~s|<:item link="/electronics">Electronics</:item>|,
              ~s|<:item link="/electronics/phones">Phones</:item>|,
              ~s|<:item link="/electronics/phones/smartphones">Smartphones</:item>|,
              ~s|<:item>iPhone 15 Pro</:item>|
            ]
          },
          %Variation{
            id: :documentation,
            attributes: %{id: "breadcrumb-docs", color: "info", size: "small"},
            slots: [
              ~s|<:item icon="hero-book-open" link="/">Docs</:item>|,
              ~s|<:item link="/getting-started">Getting Started</:item>|,
              ~s|<:item link="/getting-started/installation">Installation</:item>|,
              ~s|<:item>macOS</:item>|
            ]
          },
          %Variation{
            id: :admin_panel,
            attributes: %{id: "breadcrumb-admin", color: "secondary", size: "medium"},
            slots: [
              ~s|<:item icon="hero-cog-6-tooth" link="/admin">Admin</:item>|,
              ~s|<:item icon="hero-users" link="/admin/users">Users</:item>|,
              ~s|<:item>Edit Profile</:item>|
            ]
          },
          %Variation{
            id: :file_browser,
            attributes: %{
              id: "breadcrumb-files",
              color: "dawn",
              size: "small",
              separator_icon: "hero-chevron-right"
            },
            slots: [
              ~s|<:item icon="hero-folder" link="/">Root</:item>|,
              ~s|<:item icon="hero-folder" link="/documents">Documents</:item>|,
              ~s|<:item icon="hero-folder" link="/documents/work">Work</:item>|,
              ~s|<:item icon="hero-document">presentation.pptx</:item>|
            ]
          },
          %Variation{
            id: :workflow_steps,
            attributes: %{
              id: "breadcrumb-workflow",
              color: "success",
              size: "medium",
              separator_icon: "hero-arrow-right"
            },
            slots: [
              ~s|<:item icon="hero-clipboard-document-check" link="/cart">Cart</:item>|,
              ~s|<:item icon="hero-truck" link="/shipping">Shipping</:item>|,
              ~s|<:item icon="hero-credit-card">Payment</:item>|
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
