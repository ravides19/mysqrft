defmodule Storybook.MyPage do
  # See https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Story.html for full story
  # documentation.
  use PhoenixStorybook.Story, :page

  def doc, do: "Your very first steps into using Phoenix Storybook"

  # Declare an optional tab-based navigation in your page:
  def navigation do
    [
      {:welcome, "Welcome", {:fa, "hand-wave", :thin}},
      {:mysqrft, "MySqrft UI", {:fa, "layer-group", :thin}},
      {:reference, "Storybook Reference", {:fa, "book", :thin}},
      {:components, "Components", {:fa, "toolbox", :thin}},
      {:sandboxing, "Sandboxing", {:fa, "box-check", :thin}},
      {:icons, "Icons", {:fa, "icons", :thin}}
    ]
  end

  # This is a dummy function that you should replace with your own HEEx content.
  def render(assigns = %{tab: :welcome}) do
    ~H"""
    <div class="psb-welcome-page">
      <p>
        We generated your storybook with an example of a page and a component.
        Explore the generated <code class="psb:inline">*.story.exs</code>
        files in your <code class="inline">/storybook</code>
        directory. When you're ready to add your own, just drop your new story & index files into the same directory and refresh your storybook.
      </p>

      <p>
        Here are a few docs you might be interested in:
      </p>

      <.description_list items={[
        {"Create a new Story", doc_link("Story")},
        {"Display components using Variations", doc_link("Stories.Variation")},
        {"Group components using VariationGroups", doc_link("Stories.VariationGroup")},
        {"Organize the sidebar with Index files", doc_link("Index")}
      ]} />

      <p>
        This should be enough to get you started, but you can use the tabs in the upper-right corner of this page to <strong>check out advanced usage guides</strong>.
      </p>
    </div>
    """
  end

  def render(assigns = %{tab: :mysqrft}) do
    ~H"""
    <div class="psb:welcome-page psb:w-full psb:text-left">
      <div class="psb:space-y-3">
        <h2 class="psb:text-2xl psb:font-semibold psb:text-slate-200">MySqrft UI Components</h2>
        <p class="psb:text-slate-400 psb:leading-relaxed">
          This project ships a large set of function components under <code class="psb:inline">lib/my_sqrft_web/components/</code>, built around the
          Mishka Chelekom design system.
        </p>

        <p class="psb:text-slate-400 psb:leading-relaxed">
          Stories for these components are generated from Phoenix declarative
          <code class="psb:inline">attr/slot</code>
          metadata, so the Storybook Playground can expose
          all params automatically.
        </p>
      </div>

      <div class="psb:mt-6 psb:border-t psb:border-slate-700 psb:pt-4">
        <h3 class="psb:text-xl psb:font-semibold psb:text-slate-200 psb:mb-2">Using components</h3>
        <p class="psb:text-slate-400 psb:leading-relaxed psb:mb-3">
          Most apps import them via <code class="psb:inline">MySqrftWeb.Components.MishkaComponents</code>.
        </p>

        <pre class="psb highlight psb:p-3 psb:border psb:border-slate-800 psb:text-xs psb:rounded-md psb:bg-slate-800! psb:whitespace-pre-wrap psb:break-normal">
          <code phx-no-curly-interpolation>
            use MySqrftWeb.Components.MishkaComponents

            &lt;.button color="success"&gt;Save&lt;/.button&gt;
            &lt;.badge color="warning"&gt;Beta&lt;/.badge&gt;
          </code>
        </pre>

        <p class="psb:text-slate-400 psb:leading-relaxed psb:mt-3">
          Chelekom docs:
          <a class="hover:text-indigo-400" href="https://mishka.tools/chelekom/docs" target="_blank">
            mishka.tools/chelekom/docs
          </a>
        </p>
      </div>
    </div>
    """
  end

  def render(assigns = %{tab: :reference}) do
    ~H"""
    <div class="psb:welcome-page psb:w-full psb:text-left">
      <h2 class="psb:text-2xl psb:font-semibold psb:text-slate-200 psb:mb-2">
        Phoenix Storybook Reference
      </h2>
      <p class="psb:text-slate-400 psb:leading-relaxed psb:mb-6">
        This section keeps the key reference content handy (mirroring the HexDocs pages) so the team can copy/paste patterns while building stories.
      </p>

      <div class="psb:space-y-10">
        <section>
          <h3 class="psb:text-xl psb:font-semibold psb:text-slate-200 psb:mb-2">
            PhoenixStorybook.Story
          </h3>
          <p class="psb:text-slate-400 psb:leading-relaxed psb:mb-3">
            A story designates any kind of content in your storybook. For now only following kinds of stories are supported <code class="psb:inline">:component</code>, <code class="psb:inline">:live_component</code>, and <code class="psb:inline">:page</code>.
          </p>

          <pre class="psb highlight psb:p-3 psb:border psb:border-slate-800 psb:text-xs psb:rounded-md psb:bg-slate-800! psb:whitespace-pre-wrap psb:break-normal">
            <code phx-no-curly-interpolation>
              # storybook/my_component.exs
              defmodule MyAppWeb.Storybook.MyComponent do
                use PhoenixStorybook.Story, :component

                # required
                def function, do: &amp;MyAppWeb.MyComponent.my_component/1

                def render_source, do: :function

                def attributes, do: []
                def slots, do: []
                def variations, do: []
              end
            </code>
          </pre>

          <p class="psb:text-slate-400 psb:leading-relaxed psb:mt-2">
            Docs:
            <a
              class="hover:text-indigo-400"
              href="https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Story.html"
              target="_blank"
            >
              PhoenixStorybook.Story
            </a>
          </p>
        </section>

        <section>
          <h3 class="psb:text-xl psb:font-semibold psb:text-slate-200 psb:mb-2">
            PhoenixStorybook.Stories.Variation
          </h3>
          <p class="psb:text-slate-400 psb:leading-relaxed psb:mb-3">
            A variation captures the rendered state of a UI component. Developers write multiple variations per component that describe all the “interesting” states a component can support.
          </p>

          <pre class="psb highlight psb:p-3 psb:border psb:border-slate-800 psb:text-xs psb:rounded-md psb:bg-slate-800! psb:whitespace-pre-wrap psb:break-normal">
            <code phx-no-curly-interpolation>
              def variations do
                [
                  %Variation{
                    id: :default,
                    description: "Default dropdown",
                    note: "This variation shows the most common use case.",
                    attributes: %{
                      label: "A dropdown"
                    },
                    slots: [
                      ~s|&lt;:entry path="#" label="Account settings"/&gt;|,
                      ~s|&lt;:entry path="#" label="Support"/&gt;|,
                      ~s|&lt;:entry path="#" label="License"/&gt;|
                    ]
                  }
                ]
              end
            </code>
          </pre>

          <p class="psb:text-slate-400 psb:leading-relaxed psb:mt-2">
            Docs:
            <a
              class="hover:text-indigo-400"
              href="https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Stories.Variation.html"
              target="_blank"
            >
              PhoenixStorybook.Stories.Variation
            </a>
          </p>
        </section>

        <section>
          <h3 class="psb:text-xl psb:font-semibold psb:text-slate-200 psb:mb-2">
            PhoenixStorybook.Stories.VariationGroup
          </h3>
          <p class="psb:text-slate-400 psb:leading-relaxed psb:mb-3">
            A variation group is a set of similar variations that will be rendered together in a single preview
            <code class="psb:inline">&lt;pre&gt;</code>
            block.
          </p>

          <pre class="psb highlight psb:p-3 psb:border psb:border-slate-800 psb:text-xs psb:rounded-md psb:bg-slate-800! psb:whitespace-pre-wrap psb:break-normal">
            <code phx-no-curly-interpolation>
    def variations do
    [
    %VariationGroup{
      id: :colors,
      description: "Different color buttons",
      note: "Note that every button has a different color.",
      variations: [
        %Variation{
          id: :blue_button,
          attributes: %{label: "A button", color: :blue }
        },
        %Variation{
          id: :red_button,
          attributes: %{label: "A button", color: :red }
        },
        %Variation{
          id: :green_button,
          attributes: %{label: "A button", color: :green }
        }
      ]
    }
    ]
    end
            </code>
          </pre>

          <p class="psb:text-slate-400 psb:leading-relaxed psb:mt-2">
            Docs:
            <a
              class="hover:text-indigo-400"
              href="https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Stories.VariationGroup.html"
              target="_blank"
            >
              PhoenixStorybook.Stories.VariationGroup
            </a>
          </p>
        </section>

        <section>
          <h3 class="psb:text-xl psb:font-semibold psb:text-slate-200 psb:mb-2">
            PhoenixStorybook.Index
          </h3>
          <p class="psb:text-slate-400 psb:leading-relaxed psb:mb-3">
            An index is an optional file you can create in every folder of your storybook content tree to improve rendering of the storybook sidebar.
          </p>

          <pre class="psb highlight psb:p-3 psb:border psb:border-slate-800 psb:text-xs psb:rounded-md psb:bg-slate-800! psb:whitespace-pre-wrap psb:break-normal">
            <code phx-no-curly-interpolation>
    # storybook/_components.index.exs
    defmodule MyAppWeb.Storybook.Components do
    use PhoenixStorybook.Index

    def folder_name, do: "My Components"
    def folder_icon, do: {:fa, "icon"}
    def folder_open?, do: true
    def folder_index, do: 0

    def entry("a_component"), do: [name: "My Component", index: 1]
    def entry("other_component"), do: [name: "Another Component", icon: {:fa, "icon", :thin}, index: 0]
    end
            </code>
          </pre>

          <p class="psb:text-slate-400 psb:leading-relaxed psb:mt-2">
            Docs:
            <a
              class="hover:text-indigo-400"
              href="https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Index.html"
              target="_blank"
            >
              PhoenixStorybook.Index
            </a>
          </p>
        </section>
      </div>
    </div>
    """
  end

  def render(assigns = %{tab: guide}) when guide in ~w(components sandboxing icons)a do
    assigns =
      assign(assigns,
        guide: guide,
        guide_content: PhoenixStorybook.Guides.markup("#{guide}.md")
      )

    ~H"""
    <p class="psb:md:text-lg psb:leading-relaxed psb:text-slate-400 psb:w-full psb:text-left psb:mb-4 psb:mt-2 psb:italic">
      <a
        class="hover:text-indigo-700"
        href={"https://hexdocs.pm/phoenix_storybook/#{@guide}.html"}
        target="_blank"
      >
        This and other guides are also available on HexDocs.
      </a>
    </p>
    <div class="psb:welcome-page psb:border-t psb:border-gray-200 psb:pt-4">
      {Phoenix.HTML.raw(@guide_content)}
    </div>
    """
  end

  defp description_list(assigns) do
    ~H"""
    <div class="psb:w-full psb:md:px-8">
      <div class="psb:md:border-t psb:border-gray-200 psb:px-4 psb:py-5 psb:sm:p-0 psb:md:my-6 psb:w-full">
        <dl class="psb:sm:divide-y psb:sm:divide-gray-200">
          <%= for {dt, link} <- @items do %>
            <div class="psb:py-4 psb:sm:grid psb:sm:grid-cols-3 psb:sm:gap-4 psb:sm:py-5 psb:sm:px-6 psb:max-w-full">
              <dt class="psb:text-base psb:font-medium psb:text-indigo-700">
                {dt}
              </dt>
              <dd class="psb:mt-1 psb:text-base psb:text-slate-400 psb:sm:col-span-2 psb:sm:mt-0 psb:group psb:cursor-pointer psb:max-w-full">
                <a
                  class="psb:group-hover:text-indigo-700 psb:max-w-full psb:inline-block psb:truncate"
                  href={link}
                  target="_blank"
                >
                  {link}
                </a>
              </dd>
            </div>
          <% end %>
        </dl>
      </div>
    </div>
    """
  end

  defp doc_link(page) do
    "https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.#{page}.html"
  end
end
