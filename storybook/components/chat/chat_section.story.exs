defmodule Storybook.Components.Chat.ChatSection do
  use PhoenixStorybook.Story, :component

  alias PhoenixStorybook.Stories.{Variation, VariationGroup}

  def function, do: &MySqrftWeb.Components.Chat.chat_section/1
  def render_source, do: :function

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default",
        note: "Basic chat section with message content.",
        attributes: %{
          id: "chat-section-default"
        },
        slots: [
          """
          <div class="font-semibold">Bonnie Green</div>
          <p>That's awesome. I think our users will really appreciate the improvements.</p>
          """
        ]
      },
      %Variation{
        id: :with_status,
        description: "With status",
        note: "Chat section showing time and delivery status.",
        attributes: %{
          id: "chat-section-status"
        },
        slots: [
          """
          <div class="font-semibold">Bonnie Green</div>
          <p>That's awesome. I think our users will really appreciate the improvements.</p>
          <:status time="22:10" deliver="Delivered"/>
          """
        ]
      },
      %Variation{
        id: :with_meta,
        description: "With metadata",
        note: "Chat section with additional metadata slot.",
        attributes: %{
          id: "chat-section-meta"
        },
        slots: [
          """
          <div class="font-semibold">Bonnie Green</div>
          <p>That's awesome. I think our users will really appreciate the improvements.</p>
          <:status time="22:10" deliver="Delivered"/>
          <:meta><span class="text-xs opacity-60">Product Manager</span></:meta>
          """
        ]
      },
      %Variation{
        id: :time_only,
        description: "Time only status",
        note: "Status showing only the time without delivery status.",
        attributes: %{
          id: "chat-section-time-only"
        },
        slots: [
          """
          <div class="font-semibold">Alice Smith</div>
          <p>Can we schedule a meeting for tomorrow?</p>
          <:status time="14:35"/>
          """
        ]
      },
      %Variation{
        id: :deliver_only,
        description: "Delivery status only",
        note: "Status showing only the delivery status without time.",
        attributes: %{
          id: "chat-section-deliver-only"
        },
        slots: [
          """
          <div class="font-semibold">You</div>
          <p>Sure, let me check my calendar.</p>
          <:status deliver="Read"/>
          """
        ]
      },
      %VariationGroup{
        id: :font_weights,
        description: "Font weights",
        note: "Different font weight options for chat content.",
        variations: [
          %Variation{
            id: :font_light,
            attributes: %{
              id: "chat-section-font-light",
              font_weight: "font-light"
            },
            slots: [
              """
              <div class="font-semibold">Light Font</div>
              <p>This message uses light font weight.</p>
              <:status time="10:00" deliver="Sent"/>
              """
            ]
          },
          %Variation{
            id: :font_normal,
            attributes: %{
              id: "chat-section-font-normal",
              font_weight: "font-normal"
            },
            slots: [
              """
              <div class="font-semibold">Normal Font</div>
              <p>This message uses normal font weight.</p>
              <:status time="10:05" deliver="Sent"/>
              """
            ]
          },
          %Variation{
            id: :font_medium,
            attributes: %{
              id: "chat-section-font-medium",
              font_weight: "font-medium"
            },
            slots: [
              """
              <div class="font-semibold">Medium Font</div>
              <p>This message uses medium font weight.</p>
              <:status time="10:10" deliver="Sent"/>
              """
            ]
          },
          %Variation{
            id: :font_semibold,
            attributes: %{
              id: "chat-section-font-semibold",
              font_weight: "font-semibold"
            },
            slots: [
              """
              <div class="font-semibold">Semibold Font</div>
              <p>This message uses semibold font weight.</p>
              <:status time="10:15" deliver="Sent"/>
              """
            ]
          },
          %Variation{
            id: :font_bold,
            attributes: %{
              id: "chat-section-font-bold",
              font_weight: "font-bold"
            },
            slots: [
              """
              <div class="font-semibold">Bold Font</div>
              <p>This message uses bold font weight.</p>
              <:status time="10:20" deliver="Sent"/>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :status_styles,
        description: "Status with custom classes",
        note: "Status slots with custom styling for time and delivery.",
        variations: [
          %Variation{
            id: :styled_time,
            attributes: %{
              id: "chat-section-styled-time"
            },
            slots: [
              """
              <div class="font-semibold">Styled Time</div>
              <p>Message with styled time display.</p>
              <:status time="15:30" time_class="text-blue-500 font-medium"/>
              """
            ]
          },
          %Variation{
            id: :styled_deliver,
            attributes: %{
              id: "chat-section-styled-deliver"
            },
            slots: [
              """
              <div class="font-semibold">Styled Delivery</div>
              <p>Message with styled delivery status.</p>
              <:status time="15:35" deliver="Read" deliver_class="text-green-500"/>
              """
            ]
          },
          %Variation{
            id: :styled_both,
            attributes: %{
              id: "chat-section-styled-both"
            },
            slots: [
              """
              <div class="font-semibold">Fully Styled</div>
              <p>Message with both styled time and delivery.</p>
              <:status time="15:40" time_class="text-gray-400 italic" deliver="Delivered" deliver_class="text-emerald-600"/>
              """
            ]
          }
        ]
      },
      %Variation{
        id: :rich_content,
        description: "Rich content",
        note: "Chat section with more complex HTML content.",
        attributes: %{
          id: "chat-section-rich"
        },
        slots: [
          """
          <div class="flex items-center gap-2">
            <span class="font-semibold">Alex Johnson</span>
            <span class="text-xs bg-blue-100 text-blue-800 px-2 py-0.5 rounded">Admin</span>
          </div>
          <p>Here's the update you requested:</p>
          <ul class="list-disc list-inside text-sm mt-1">
            <li>Feature A - Complete</li>
            <li>Feature B - In Progress</li>
            <li>Feature C - Pending</li>
          </ul>
          <:status time="09:45" deliver="Seen by 3"/>
          <:meta><span class="text-xs opacity-60">Engineering Team Lead</span></:meta>
          """
        ]
      },
      MySqrftWeb.Storybook.ComponentDefaults.all_params_variation(function(),
        id: :all_params,
        description: "All params"
      )
    ]
  end
end
