defmodule Storybook.Components.Card.CardTitle do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Card.card_title/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic card title with default styling.",
        attributes: %{
          id: "card-title-default",
          title: "Card Title"
        }
      },
      %Variation{
        id: :with_icon,
        description: "With icon",
        note: "Card title with an icon.",
        attributes: %{
          id: "card-title-icon",
          title: "Settings",
          icon: "hero-cog-6-tooth"
        }
      },
      %Variation{
        id: :with_inner_content,
        description: "With inner content",
        note: "Card title with additional content via inner block.",
        attributes: %{
          id: "card-title-inner",
          title: "Dashboard",
          icon: "hero-chart-bar",
          position: "between"
        },
        slots: [~s|<span class="text-sm opacity-70">View All</span>|]
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        note: "Different size options for card titles.",
        variations: [
          %Variation{
            id: :size_extra_small,
            attributes: %{
              id: "card-title-size-xs",
              title: "Extra Small",
              icon: "hero-star",
              size: "extra_small"
            }
          },
          %Variation{
            id: :size_small,
            attributes: %{
              id: "card-title-size-sm",
              title: "Small",
              icon: "hero-star",
              size: "small"
            }
          },
          %Variation{
            id: :size_medium,
            attributes: %{
              id: "card-title-size-md",
              title: "Medium",
              icon: "hero-star",
              size: "medium"
            }
          },
          %Variation{
            id: :size_large,
            attributes: %{
              id: "card-title-size-lg",
              title: "Large",
              icon: "hero-star",
              size: "large"
            }
          },
          %Variation{
            id: :size_extra_large,
            attributes: %{
              id: "card-title-size-xl",
              title: "Extra Large",
              icon: "hero-star",
              size: "extra_large"
            }
          }
        ]
      },
      %VariationGroup{
        id: :positions,
        description: "Positions",
        note: "Different content alignment options.",
        variations: [
          %Variation{
            id: :position_start,
            attributes: %{
              id: "card-title-pos-start",
              title: "Start Position",
              position: "start",
              class: "w-64 border border-dashed"
            }
          },
          %Variation{
            id: :position_center,
            attributes: %{
              id: "card-title-pos-center",
              title: "Center Position",
              position: "center",
              class: "w-64 border border-dashed"
            }
          },
          %Variation{
            id: :position_end,
            attributes: %{
              id: "card-title-pos-end",
              title: "End Position",
              position: "end",
              class: "w-64 border border-dashed"
            }
          },
          %Variation{
            id: :position_between,
            attributes: %{
              id: "card-title-pos-between",
              title: "Between",
              position: "between",
              class: "w-64 border border-dashed"
            },
            slots: [~s|<span>Action</span>|]
          },
          %Variation{
            id: :position_around,
            attributes: %{
              id: "card-title-pos-around",
              title: "Around",
              position: "around",
              class: "w-64 border border-dashed"
            },
            slots: [~s|<span>Action</span>|]
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
            attributes: %{
              id: "card-title-pad-xs",
              title: "Extra Small",
              padding: "extra_small",
              class: "border border-dashed"
            }
          },
          %Variation{
            id: :padding_small,
            attributes: %{
              id: "card-title-pad-sm",
              title: "Small",
              padding: "small",
              class: "border border-dashed"
            }
          },
          %Variation{
            id: :padding_medium,
            attributes: %{
              id: "card-title-pad-md",
              title: "Medium",
              padding: "medium",
              class: "border border-dashed"
            }
          },
          %Variation{
            id: :padding_large,
            attributes: %{
              id: "card-title-pad-lg",
              title: "Large",
              padding: "large",
              class: "border border-dashed"
            }
          },
          %Variation{
            id: :padding_extra_large,
            attributes: %{
              id: "card-title-pad-xl",
              title: "Extra Large",
              padding: "extra_large",
              class: "border border-dashed"
            }
          }
        ]
      },
      %VariationGroup{
        id: :use_cases,
        description: "Common use cases",
        note: "Real-world card title examples.",
        variations: [
          %Variation{
            id: :article_title,
            attributes: %{
              id: "card-title-article",
              title: "How to Build Modern UIs",
              icon: "hero-document-text",
              size: "large"
            }
          },
          %Variation{
            id: :settings_header,
            attributes: %{
              id: "card-title-settings",
              title: "Account Settings",
              icon: "hero-user-circle",
              position: "between"
            },
            slots: [
              ~s|<span class="text-xs bg-green-100 text-green-800 px-2 py-0.5 rounded">Active</span>|
            ]
          },
          %Variation{
            id: :notification_header,
            attributes: %{
              id: "card-title-notif",
              title: "Notifications",
              icon: "hero-bell",
              position: "between"
            },
            slots: [~s|<span class="text-xs opacity-70">3 new</span>|]
          },
          %Variation{
            id: :widget_title,
            attributes: %{
              id: "card-title-widget",
              title: "Recent Activity",
              icon: "hero-clock",
              size: "small",
              position: "between"
            },
            slots: [~s|<a href="#" class="text-xs text-blue-500 hover:underline">View All</a>|]
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
