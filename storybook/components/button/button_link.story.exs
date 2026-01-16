defmodule Storybook.Components.Button.ButtonLink do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Button.button_link/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default (navigate)",
        note: "Basic button link using LiveView navigate.",
        attributes: %{
          id: "button-link-default",
          navigate: "/"
        },
        slots: ["Go Home"]
      },
      %Variation{
        id: :with_patch,
        description: "With patch",
        note: "Button link using LiveView patch for same-page navigation.",
        attributes: %{
          id: "button-link-patch",
          patch: "/settings",
          color: "secondary"
        },
        slots: ["Open Settings"]
      },
      %Variation{
        id: :with_href,
        description: "With href",
        note: "Button link using regular href for external links.",
        attributes: %{
          id: "button-link-href",
          href: "https://example.com",
          color: "info",
          target: "_blank"
        },
        slots: ["Visit Website"]
      },
      %Variation{
        id: :with_icon,
        description: "With icon",
        note: "Button link with an icon.",
        attributes: %{
          id: "button-link-icon",
          navigate: "/dashboard",
          icon: "hero-arrow-right",
          right_icon: true,
          color: "primary",
          variant: "default"
        },
        slots: ["Dashboard"]
      },
      %Variation{
        id: :icon_only,
        description: "Icon only",
        note: "Circular button link with only an icon.",
        attributes: %{
          id: "button-link-icon-only",
          navigate: "/notifications",
          icon: "hero-bell",
          circle: true,
          color: "warning",
          variant: "default"
        },
        slots: []
      },
      %VariationGroup{
        id: :variants,
        description: "Variants",
        note: "Different visual styles for button links.",
        variations: [
          %Variation{
            id: :variant_base,
            attributes: %{id: "button-link-variant-base", navigate: "/", variant: "base", color: "primary"},
            slots: ["Base"]
          },
          %Variation{
            id: :variant_default,
            attributes: %{id: "button-link-variant-default", navigate: "/", variant: "default", color: "primary"},
            slots: ["Default"]
          },
          %Variation{
            id: :variant_outline,
            attributes: %{id: "button-link-variant-outline", navigate: "/", variant: "outline", color: "primary"},
            slots: ["Outline"]
          },
          %Variation{
            id: :variant_transparent,
            attributes: %{id: "button-link-variant-transparent", navigate: "/", variant: "transparent", color: "primary"},
            slots: ["Transparent"]
          },
          %Variation{
            id: :variant_bordered,
            attributes: %{id: "button-link-variant-bordered", navigate: "/", variant: "bordered", color: "primary"},
            slots: ["Bordered"]
          },
          %Variation{
            id: :variant_shadow,
            attributes: %{id: "button-link-variant-shadow", navigate: "/", variant: "shadow", color: "primary"},
            slots: ["Shadow"]
          }
        ]
      },
      %VariationGroup{
        id: :colors,
        description: "Colors",
        note: "Different color themes for button links.",
        variations: [
          %Variation{
            id: :color_natural,
            attributes: %{id: "button-link-color-natural", navigate: "/", variant: "default", color: "natural"},
            slots: ["Natural"]
          },
          %Variation{
            id: :color_primary,
            attributes: %{id: "button-link-color-primary", navigate: "/", variant: "default", color: "primary"},
            slots: ["Primary"]
          },
          %Variation{
            id: :color_secondary,
            attributes: %{id: "button-link-color-secondary", navigate: "/", variant: "default", color: "secondary"},
            slots: ["Secondary"]
          },
          %Variation{
            id: :color_success,
            attributes: %{id: "button-link-color-success", navigate: "/", variant: "default", color: "success"},
            slots: ["Success"]
          },
          %Variation{
            id: :color_warning,
            attributes: %{id: "button-link-color-warning", navigate: "/", variant: "default", color: "warning"},
            slots: ["Warning"]
          },
          %Variation{
            id: :color_danger,
            attributes: %{id: "button-link-color-danger", navigate: "/", variant: "default", color: "danger"},
            slots: ["Danger"]
          },
          %Variation{
            id: :color_info,
            attributes: %{id: "button-link-color-info", navigate: "/", variant: "default", color: "info"},
            slots: ["Info"]
          },
          %Variation{
            id: :color_misc,
            attributes: %{id: "button-link-color-misc", navigate: "/", variant: "default", color: "misc"},
            slots: ["Misc"]
          },
          %Variation{
            id: :color_dawn,
            attributes: %{id: "button-link-color-dawn", navigate: "/", variant: "default", color: "dawn"},
            slots: ["Dawn"]
          },
          %Variation{
            id: :color_silver,
            attributes: %{id: "button-link-color-silver", navigate: "/", variant: "default", color: "silver"},
            slots: ["Silver"]
          }
        ]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for button links.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{id: "button-link-size-xs", navigate: "/", variant: "default", color: "primary", size: "extra_small"},
            slots: ["Extra Small"]
          },
          %Variation{
            id: :size_small,
            attributes: %{id: "button-link-size-sm", navigate: "/", variant: "default", color: "primary", size: "small"},
            slots: ["Small"]
          },
          %Variation{
            id: :size_medium,
            attributes: %{id: "button-link-size-md", navigate: "/", variant: "default", color: "primary", size: "medium"},
            slots: ["Medium"]
          },
          %Variation{
            id: :size_large,
            attributes: %{id: "button-link-size-lg", navigate: "/", variant: "default", color: "primary", size: "large"},
            slots: ["Large"]
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{id: "button-link-size-xl", navigate: "/", variant: "default", color: "primary", size: "extra_large"},
            slots: ["Extra Large"]
          }
        ]
      },
      %VariationGroup{
        id: :indicators,
        description: "Indicators",
        note: "Button links with status indicators.",
        variations: [
          %Variation{
            id: :indicator_left,
            attributes: %{
              id: "button-link-ind-left",
              navigate: "/",
              variant: "default",
              color: "success",
              left_indicator: true
            },
            slots: ["Online"]
          },
          %Variation{
            id: :indicator_right,
            attributes: %{
              id: "button-link-ind-right",
              navigate: "/",
              variant: "default",
              color: "danger",
              right_indicator: true
            },
            slots: ["Alerts"]
          },
          %Variation{
            id: :indicator_pinging,
            attributes: %{
              id: "button-link-ind-ping",
              navigate: "/notifications",
              variant: "bordered",
              color: "info",
              icon: "hero-bell",
              circle: true,
              top_right_indicator: true,
              pinging: true
            },
            slots: []
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world button link examples.",
        variations: [
          %Variation{
            id: :view_details,
            attributes: %{
              id: "button-link-view",
              navigate: "/products/123",
              variant: "outline",
              color: "primary",
              icon: "hero-eye"
            },
            slots: ["View Details"]
          },
          %Variation{
            id: :edit_link,
            attributes: %{
              id: "button-link-edit",
              navigate: "/posts/edit",
              variant: "bordered",
              color: "secondary",
              icon: "hero-pencil"
            },
            slots: ["Edit"]
          },
          %Variation{
            id: :download_link,
            attributes: %{
              id: "button-link-download",
              href: "/files/report.pdf",
              variant: "default",
              color: "success",
              icon: "hero-arrow-down-tray",
              download: true
            },
            slots: ["Download PDF"]
          },
          %Variation{
            id: :external_link,
            attributes: %{
              id: "button-link-external",
              href: "https://github.com",
              variant: "shadow",
              color: "natural",
              icon: "hero-arrow-top-right-on-square",
              right_icon: true,
              target: "_blank"
            },
            slots: ["GitHub"]
          },
          %Variation{
            id: :get_started,
            attributes: %{
              id: "button-link-cta",
              navigate: "/signup",
              variant: "default",
              color: "primary",
              size: "large",
              icon: "hero-rocket-launch"
            },
            slots: ["Get Started"]
          },
          %Variation{
            id: :learn_more,
            attributes: %{
              id: "button-link-learn",
              navigate: "/docs",
              variant: "transparent",
              color: "info",
              icon: "hero-arrow-right",
              right_icon: true
            },
            slots: ["Learn More"]
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
