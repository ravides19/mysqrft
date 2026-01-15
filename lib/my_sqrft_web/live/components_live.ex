defmodule MySqrftWeb.ComponentsLive do
  @moduledoc """
  LiveView page showcasing all available components and their variations.
  """
  use MySqrftWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    config = Application.get_env(:mishka_chelekom, :component_colors, [])
    variants = Application.get_env(:mishka_chelekom, :component_variants, [])
    sizes = Application.get_env(:mishka_chelekom, :component_sizes, [])
    rounded = Application.get_env(:mishka_chelekom, :component_rounded, [])
    padding = Application.get_env(:mishka_chelekom, :component_padding, [])
    space = Application.get_env(:mishka_chelekom, :component_space, [])

    {:ok,
     assign(socket,
       colors: config,
       variants: variants,
       sizes: sizes,
       rounded: rounded,
       padding: padding,
       space: space
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-12">
        <div>
          <h1 class="text-4xl font-bold mb-2">Component Showcase</h1>
          <p class="text-lg text-gray-600 dark:text-gray-400">
            Browse all available components and their variations
          </p>
        </div>

    <!-- Buttons & Actions -->
        <.component_section title="Button" description="Button components with various styles">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="flex flex-wrap gap-3">
                <div :for={color <- @colors}>
                  <.button color={color}>{String.capitalize(color)}</.button>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Variants</h3>
              <div class="flex flex-wrap gap-3">
                <div :for={variant <- @variants}>
                  <.button variant={variant} color="primary">{String.capitalize(variant)}</.button>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-3">
                <div :for={size <- @sizes}>
                  <.button size={size} color="primary">
                    {String.replace(size, "_", " ") |> String.capitalize()}
                  </.button>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Badges -->
        <.component_section title="Badge" description="Badge components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="flex flex-wrap gap-3">
                <div :for={color <- @colors}>
                  <.badge color={color}>{String.capitalize(color)}</.badge>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Variants</h3>
              <div class="flex flex-wrap gap-3">
                <div :for={variant <- @variants}>
                  <.badge variant={variant} color="primary">{String.capitalize(variant)}</.badge>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-3">
                <div :for={size <- @sizes}>
                  <.badge size={size} color="primary">
                    {String.replace(size, "_", " ") |> String.capitalize()}
                  </.badge>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Alerts -->
        <.component_section title="Alert" description="Alert components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors (as kind)</h3>
              <div class="space-y-3">
                <div :for={color <- @colors}>
                  <.alert kind={String.to_atom(color)} variant="default">
                    This is a {color} alert
                  </.alert>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Variants</h3>
              <div class="space-y-3">
                <div :for={variant <- @variants}>
                  <.alert kind={:info} variant={variant}>This is a {variant} alert</.alert>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Banner -->
        <.component_section title="Banner" description="Banner components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3">
                <div :for={color <- @colors}>
                  <.banner id={"banner-#{color}"} color={color} variant="default">
                    This is a {color} banner
                  </.banner>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Cards -->
        <.component_section title="Card" description="Card components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div :for={color <- @colors}>
                  <.card color={color} class="h-full">
                    <.card_title>Card Title</.card_title>
                    <.card_content>
                      <p>This is a {color} card</p>
                    </.card_content>
                  </.card>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Variants</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div :for={variant <- @variants}>
                  <.card variant={variant} color="primary" class="h-full">
                    <.card_title>{String.capitalize(variant)} Card</.card_title>
                    <.card_content>
                      <p>This is a {variant} variant card</p>
                    </.card_content>
                  </.card>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Spinner -->
        <.component_section title="Spinner" description="Loading spinner components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="flex flex-wrap gap-6">
                <div :for={color <- @colors} class="flex flex-col items-center gap-2">
                  <.spinner color={color} />
                  <span class="text-sm">{String.capitalize(color)}</span>
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-6">
                <div :for={size <- @sizes} class="flex flex-col items-center gap-2">
                  <.spinner size={size} color="primary" />
                  <span class="text-sm">{String.replace(size, "_", " ") |> String.capitalize()}</span>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Progress -->
        <.component_section title="Progress" description="Progress bar components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-4">
                <div :for={color <- @colors}>
                  <.progress color={color} value={50} />
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Sizes</h3>
              <div class="space-y-4">
                <div :for={size <- @sizes}>
                  <.progress size={size} color="primary" value={50} />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Text Field -->
        <.component_section title="Text Field" description="Text input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.text_field
                    name={"field_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Input"}
                    color={color}
                    placeholder="Enter text..."
                  />
                </div>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Sizes</h3>
              <div class="space-y-3 max-w-md">
                <div :for={size <- @sizes}>
                  <.text_field
                    name={"field_#{size}"}
                    value=""
                    label={
                      String.replace(size, "_", " ") |> String.capitalize() |> Kernel.<>(" Input")
                    }
                    size={size}
                    placeholder="Enter text..."
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Email Field -->
        <.component_section title="Email Field" description="Email input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.email_field
                    name={"email_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Email"}
                    color={color}
                    placeholder="email@example.com"
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Password Field -->
        <.component_section title="Password Field" description="Password input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.password_field
                    name={"password_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Password"}
                    color={color}
                    placeholder="Enter password"
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Number Field -->
        <.component_section title="Number Field" description="Number input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.number_field
                    name={"number_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Number"}
                    color={color}
                    placeholder="Enter number"
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Textarea Field -->
        <.component_section title="Textarea Field" description="Textarea input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.textarea_field
                    name={"textarea_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Textarea"}
                    color={color}
                    placeholder="Enter text..."
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Checkbox Field -->
        <.component_section title="Checkbox Field" description="Checkbox input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.checkbox_field
                    name={"checkbox_#{color}"}
                    label={String.capitalize(color) <> " Checkbox"}
                    color={color}
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Radio Field -->
        <.component_section title="Radio Field" description="Radio input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.radio_field
                    name={"radio_#{color}"}
                    label={String.capitalize(color) <> " Radio"}
                    color={color}
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Select Field -->
        <.component_section title="Native Select" description="Select dropdown components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.native_select
                    name={"select_#{color}"}
                    label={String.capitalize(color) <> " Select"}
                    color={color}
                  >
                    <option value="1">Option 1</option>
                    <option value="2">Option 2</option>
                    <option value="3">Option 3</option>
                  </.native_select>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Range Field -->
        <.component_section title="Range Field" description="Range slider components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.range_field
                    name={"range_#{color}"}
                    label={String.capitalize(color) <> " Range"}
                    color={color}
                    value={50}
                    min={0}
                    max={100}
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Toggle Field -->
        <.component_section title="Toggle Field" description="Toggle switch components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.toggle_field
                    name={"toggle_#{color}"}
                    label={String.capitalize(color) <> " Toggle"}
                    color={color}
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Color Field -->
        <.component_section title="Color Field" description="Color picker components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.color_field
                    name={"color_#{color}"}
                    label={String.capitalize(color) <> " Color"}
                    color={color}
                    value="#000000"
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- File Field -->
        <.component_section title="File Field" description="File upload components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.file_field
                    name={"file_#{color}"}
                    label={String.capitalize(color) <> " File"}
                    color={color}
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Search Field -->
        <.component_section title="Search Field" description="Search input components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.search_field
                    name={"search_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Search"}
                    color={color}
                    placeholder="Search..."
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- URL Field -->
        <.component_section title="URL Field" description="URL input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.url_field
                    name={"url_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " URL"}
                    color={color}
                    placeholder="https://example.com"
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Tel Field -->
        <.component_section title="Tel Field" description="Telephone input field components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.tel_field
                    name={"tel_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " Phone"}
                    color={color}
                    placeholder="+1 (555) 123-4567"
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- DateTime Field -->
        <.component_section title="DateTime Field" description="Date and time input components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-md">
                <div :for={color <- @colors}>
                  <.date_time_field
                    name={"datetime_#{color}"}
                    value=""
                    label={String.capitalize(color) <> " DateTime"}
                    color={color}
                  />
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Accordion -->
        <div class="border-b border-gray-200 dark:border-gray-700 pb-8">
          <div class="mb-6">
            <h2 class="text-2xl font-bold mb-2">Accordion</h2>
            <p class="text-gray-600 dark:text-gray-400">Accordion components</p>
          </div>
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.accordion id="accordion-example">
                  <:item title="Item 1">
                    <p>Content for item 1</p>
                  </:item>
                  <:item title="Item 2">
                    <p>Content for item 2</p>
                  </:item>
                  <:item title="Item 3">
                    <p>Content for item 3</p>
                  </:item>
                </.accordion>
              </div>
            </div>
          </div>
        </div>

    <!-- Avatar -->
        <.component_section title="Avatar" description="Avatar components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-6">
                <div :for={size <- @sizes} class="flex flex-col items-center gap-2">
                  <.avatar size={size} color="primary" />
                  <span class="text-sm">{String.replace(size, "_", " ") |> String.capitalize()}</span>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Blockquote -->
        <.component_section title="Blockquote" description="Blockquote components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3 max-w-2xl">
                <div :for={color <- @colors}>
                  <.blockquote color={color}>
                    <p>This is a {color} blockquote example text.</p>
                  </.blockquote>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Breadcrumb -->
        <div class="border-b border-gray-200 dark:border-gray-700 pb-8">
          <div class="mb-6">
            <h2 class="text-2xl font-bold mb-2">Breadcrumb</h2>
            <p class="text-gray-600 dark:text-gray-400">Breadcrumb navigation components</p>
          </div>
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.breadcrumb>
                  <:item>Home</:item>
                  <:item>Components</:item>
                  <:item>Breadcrumb</:item>
                </.breadcrumb>
              </div>
            </div>
          </div>
        </div>

    <!-- Carousel -->
        <.component_section title="Carousel" description="Carousel components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.carousel id="carousel-example" indicator>
                  <:slide
                    title="Slide 1"
                    description="This is a description for slide 1"
                    content_position="start"
                    image={~p"/images/logo.svg"}
                  />
                  <:slide
                    title="Slide 2"
                    description="This is a description for slide 2"
                    content_position="center"
                    image={~p"/images/logo.svg"}
                  />
                  <:slide
                    title="Slide 3"
                    description="This is a description for slide 3"
                    content_position="end"
                    image={~p"/images/logo.svg"}
                  />
                </.carousel>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Chat -->
        <.component_section title="Chat" description="Chat message components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <div class="space-y-3">
                  <.chat color="primary">
                    <.chat_section>
                      <p>Hello! This is a chat message.</p>
                      <:status time="22:10" deliver="Delivered" />
                    </.chat_section>
                  </.chat>

                  <.chat color="secondary" position="flipped">
                    <.chat_section>
                      <p>Hi there! This is a reply.</p>
                      <:status time="22:11" deliver="Seen" />
                    </.chat_section>
                  </.chat>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Checkbox Card -->
        <.component_section title="Checkbox Card" description="Checkbox card components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div :for={color <- @colors}>
                  <.checkbox_card
                    id={"checkbox-card-#{color}"}
                    name={"checkbox_card_#{color}"}
                    color={color}
                  >
                    <:checkbox value="option_1" title="Option 1" description={"#{color} option 1"} />
                    <:checkbox value="option_2" title="Option 2" description={"#{color} option 2"} />
                  </.checkbox_card>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Radio Card -->
        <.component_section title="Radio Card" description="Radio card components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div :for={color <- @colors}>
                  <.radio_card id={"radio-card-#{color}"} name={"radio_card_#{color}"} color={color}>
                    <:radio value="option_1" title="Option 1" description={"#{color} option 1"} />
                    <:radio value="option_2" title="Option 2" description={"#{color} option 2"} />
                  </.radio_card>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Clipboard -->
        <.component_section title="Clipboard" description="Clipboard copy components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.clipboard text="Copy this text">
                  <:trigger>
                    <.button variant="default" color="primary" size="small">
                      <span class="clipboard-label">Copy</span>
                    </.button>
                  </:trigger>
                </.clipboard>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Collapse -->
        <.component_section title="Collapse" description="Collapsible content components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.collapse
                  id="collapse-example"
                  class="rounded border border-gray-200 dark:border-gray-700"
                >
                  <:trigger>
                    <div class="p-3 font-medium">Click to expand</div>
                  </:trigger>
                  <div class="p-3 text-sm text-gray-700 dark:text-gray-300">
                    <p>This is collapsible content that can be shown or hidden.</p>
                  </div>
                </.collapse>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Combobox -->
        <.component_section title="Combobox" description="Combobox dropdown components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.combobox name="combobox" label="Select an option" placeholder="Choose...">
                  <option value="1">Option 1</option>
                  <option value="2">Option 2</option>
                  <option value="3">Option 3</option>
                </.combobox>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Device Mockup -->
        <.component_section title="Device Mockup" description="Device mockup components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.device_mockup type="phone">
                  <div class="p-4 bg-white">Device content</div>
                </.device_mockup>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Divider -->
        <.component_section title="Divider" description="Divider components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl space-y-4">
                <p>Content above</p>
                <.divider />
                <p>Content below</p>
                <.hr />
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Dropdown -->
        <.component_section title="Dropdown" description="Dropdown menu components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.dropdown id="dropdown-example">
                  <:trigger>
                    <.button>Open Dropdown</.button>
                  </:trigger>
                  <:content>
                    <a href="#" class="block px-4 py-2 hover:bg-gray-100">Item 1</a>
                    <a href="#" class="block px-4 py-2 hover:bg-gray-100">Item 2</a>
                    <a href="#" class="block px-4 py-2 hover:bg-gray-100">Item 3</a>
                  </:content>
                </.dropdown>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Fieldset -->
        <.component_section title="Fieldset" description="Fieldset form grouping components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.fieldset legend="Form Group">
                  <.text_field name="field1" value="" label="Field 1" />
                  <.text_field name="field2" value="" label="Field 2" />
                </.fieldset>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Footer -->
        <.component_section title="Footer" description="Footer components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.footer border="extra_small" padding="medium" space="medium">
                  <.footer_section
                    class="border-b border-gray-200 dark:border-gray-700"
                    padding="small"
                  >
                    Section 1
                  </.footer_section>
                  <.footer_section padding="small">Section 2</.footer_section>
                  <.footer_section
                    class="border-t border-gray-200 dark:border-gray-700"
                    padding="small"
                  >
                    Section 3
                  </.footer_section>
                </.footer>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Gallery -->
        <.component_section title="Gallery" description="Gallery components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.gallery cols="three" gap="small">
                  <.gallery_media src={~p"/images/logo.svg"} alt="Gallery image 1" rounded="medium" />
                  <.gallery_media src={~p"/images/logo.svg"} alt="Gallery image 2" rounded="medium" />
                  <.gallery_media src={~p"/images/logo.svg"} alt="Gallery image 3" rounded="medium" />
                </.gallery>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Image -->
        <.component_section title="Image" description="Image components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Rounded</h3>
              <div class="flex flex-wrap gap-4">
                <div :for={round <- @rounded} class="flex flex-col items-center gap-2">
                  <.image src="/images/logo.svg" alt="Logo" rounded={round} class="w-24 h-24" />
                  <span class="text-sm">
                    {String.replace(round, "_", " ") |> String.capitalize()}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Indicator -->
        <.component_section title="Indicator" description="Indicator components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="flex flex-wrap gap-4">
                <div :for={color <- @colors} class="flex flex-col items-center gap-2">
                  <.indicator color={color} />
                  <span class="text-sm">{String.capitalize(color)}</span>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Jumbotron -->
        <.component_section title="Jumbotron" description="Jumbotron hero components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-4">
                <div :for={color <- @colors}>
                  <.jumbotron color={color}>
                    <h2 class="text-2xl font-bold mb-2">Jumbotron Title</h2>
                    <p>This is a {color} jumbotron example.</p>
                  </.jumbotron>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Keyboard -->
        <.component_section title="Keyboard" description="Keyboard key display components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <div class="flex items-center gap-2">
                  <.keyboard>Ctrl</.keyboard>
                  <span class="text-sm text-gray-500 dark:text-gray-400">+</span>
                  <.keyboard>C</.keyboard>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- List -->
        <.component_section title="List" description="List components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.list>
                  <:item>Item 1</:item>
                  <:item>Item 2</:item>
                  <:item>Item 3</:item>
                </.list>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Menu -->
        <.component_section title="Menu" description="Menu components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.menu>
                  <li><a href="#">Menu Item 1</a></li>
                  <li><a href="#">Menu Item 2</a></li>
                  <li><a href="#">Menu Item 3</a></li>
                </.menu>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Mega Menu -->
        <div class="border-b border-gray-200 dark:border-gray-700 pb-8">
          <div class="mb-6">
            <h2 class="text-2xl font-bold mb-2">Mega Menu</h2>
            <p class="text-gray-600 dark:text-gray-400">
              Mega menu components (complex slot structure - see component docs)
            </p>
          </div>
        </div>

    <!-- Modal -->
        <.component_section title="Modal" description="Modal dialog components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.button phx-click={JS.dispatch("phx:show-modal", to: "#example-modal")}>
                  Open Modal
                </.button>
                <.modal id="example-modal" title="Modal Title">
                  <p>This is modal content.</p>
                </.modal>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Navbar -->
        <div class="border-b border-gray-200 dark:border-gray-700 pb-8">
          <div class="mb-6">
            <h2 class="text-2xl font-bold mb-2">Navbar</h2>
            <p class="text-gray-600 dark:text-gray-400">Navigation bar components</p>
          </div>
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.navbar id="navbar-example" name="Brand" link="/">
                  <:list><.link navigate="/">Home</.link></:list>
                  <:list><.link navigate="/">About</.link></:list>
                  <:list><.link navigate="/">Contact</.link></:list>
                </.navbar>
              </div>
            </div>
          </div>
        </div>

    <!-- Overlay -->
        <.component_section title="Overlay" description="Overlay components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.overlay>
                  <div class="p-4 bg-white rounded">Overlay content</div>
                </.overlay>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Pagination -->
        <.component_section title="Pagination" description="Pagination components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.pagination id="pagination-example" total={10} active={1} />
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Popover -->
        <.component_section title="Popover" description="Popover components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.popover id="popover-example">
                  <:trigger>
                    <.button>Hover for Popover</.button>
                  </:trigger>
                  <:content>
                    <p>This is popover content.</p>
                  </:content>
                </.popover>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Rating -->
        <.component_section title="Rating" description="Rating components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.rating id="rating-example" select={4} count={5} color="primary" />
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Scroll Area -->
        <.component_section title="Scroll Area" description="Scrollable area components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md h-48">
                <.scroll_area id="scroll-area-example">
                  <div class="space-y-2">
                    <div :for={i <- 1..20} class="p-2 bg-gray-100 rounded">Item {i}</div>
                  </div>
                </.scroll_area>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Sidebar -->
        <.component_section title="Sidebar" description="Sidebar components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.sidebar id="sidebar-example" hide_position="left" color="dark" size="extra_small">
                  <:item link="#" label="Sidebar Item 1" icon="hero-home" />
                  <:item link="#" label="Sidebar Item 2" icon="hero-cog-6-tooth" />
                  <:item link="#" label="Sidebar Item 3" icon="hero-inbox" />
                </.sidebar>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Skeleton -->
        <.component_section title="Skeleton" description="Skeleton loading components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md space-y-2">
                <.skeleton class="h-4 w-full" />
                <.skeleton class="h-4 w-3/4" />
                <.skeleton class="h-4 w-1/2" />
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Speed Dial -->
        <.component_section title="Speed Dial" description="Speed dial floating action components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.speed_dial id="speed-dial-example" icon="hero-plus" clickable>
                  <:item icon="hero-pencil" href="#" color="primary">Edit</:item>
                  <:item icon="hero-trash" href="#" color="danger">Delete</:item>
                </.speed_dial>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Stepper -->
        <.component_section title="Stepper" description="Stepper progress components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.stepper>
                  <.stepper_section step="completed" title="Step 1" />
                  <.stepper_section step="current" title="Step 2" />
                  <.stepper_section title="Step 3" />
                </.stepper>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Table -->
        <.component_section title="Table" description="Table components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.table
                  id="table-example"
                  rows={[
                    %{name: "John Doe", email: "john@example.com", role: "Admin"},
                    %{name: "Jane Smith", email: "jane@example.com", role: "User"}
                  ]}
                >
                  <:col label="Name" />
                  <:col label="Email" />
                  <:col label="Role" />
                </.table>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Table Content -->
        <.component_section title="Table Content" description="Table content layout components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.table_content>
                  <:item title="Title 1">Content 1</:item>
                  <:item title="Title 2">Content 2</:item>
                  <:item title="Title 3">Content 3</:item>
                </.table_content>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Tabs -->
        <div class="border-b border-gray-200 dark:border-gray-700 pb-8">
          <div class="mb-6">
            <h2 class="text-2xl font-bold mb-2">Tabs</h2>
            <p class="text-gray-600 dark:text-gray-400">Tab components</p>
          </div>
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.tabs id="tabs-example">
                  <:tab>Tab 1</:tab>
                  <:tab>Tab 2</:tab>
                  <:tab>Tab 3</:tab>
                  <:panel>
                    <p>Content for Tab 1</p>
                  </:panel>
                  <:panel>
                    <p>Content for Tab 2</p>
                  </:panel>
                  <:panel>
                    <p>Content for Tab 3</p>
                  </:panel>
                </.tabs>
              </div>
            </div>
          </div>
        </div>

    <!-- Timeline -->
        <.component_section title="Timeline" description="Timeline components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.timeline>
                  <.timeline_section>
                    <p><strong>Event 1</strong> - 2024-01-01: Description of event 1</p>
                  </.timeline_section>
                  <.timeline_section>
                    <p><strong>Event 2</strong> - 2024-02-01: Description of event 2</p>
                  </.timeline_section>
                  <.timeline_section>
                    <p><strong>Event 3</strong> - 2024-03-01: Description of event 3</p>
                  </.timeline_section>
                </.timeline>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Toast -->
        <.component_section title="Toast" description="Toast notification components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Colors</h3>
              <div class="space-y-3">
                <div :for={{color, index} <- Enum.with_index(@colors)}>
                  <.toast id={"toast-#{color}-#{index}"} color={color} variant="default">
                    This is a {color} toast
                  </.toast>
                </div>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Tooltip -->
        <.component_section title="Tooltip" description="Tooltip components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.tooltip text="This is a tooltip">
                  <.button>Hover me</.button>
                </.tooltip>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Typography -->
        <.component_section title="Typography" description="Typography components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Headings</h3>
              <div class="space-y-2 max-w-2xl">
                <.h1>Heading 1</.h1>
                <.h2>Heading 2</.h2>
                <.h3>Heading 3</.h3>
                <.h4>Heading 4</.h4>
                <.h5>Heading 5</.h5>
                <.h6>Heading 6</.h6>
              </div>
            </div>
            <div>
              <h3 class="text-xl font-semibold mb-4">Text Elements</h3>
              <div class="space-y-2 max-w-2xl">
                <.p>This is a paragraph.</.p>
                <.strong>This is strong text.</.strong>
                <.em>This is emphasized text.</.em>
                <.small>This is small text.</.small>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Video -->
        <.component_section title="Video" description="Video components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-2xl">
                <.video controls>
                  <:source src="https://example.com/video.mp4" type="video/mp4" />
                </.video>
              </div>
            </div>
          </div>
        </.component_section>

    <!-- Drawer -->
        <.component_section title="Drawer" description="Drawer sidebar components">
          <div class="space-y-8">
            <div>
              <h3 class="text-xl font-semibold mb-4">Example</h3>
              <div class="max-w-md">
                <.button phx-click={JS.dispatch("phx:show-drawer", to: "#example-drawer")}>
                  Open Drawer
                </.button>
                <.drawer id="example-drawer" title="Drawer Title">
                  <p>This is drawer content.</p>
                </.drawer>
              </div>
            </div>
          </div>
        </.component_section>
      </div>
    </Layouts.app>
    """
  end

  defp component_section(assigns) do
    ~H"""
    <div class="border-b border-gray-200 dark:border-gray-700 pb-8">
      <div class="mb-6">
        <h2 class="text-2xl font-bold mb-2">{@title}</h2>
        <p class="text-gray-600 dark:text-gray-400">{@description}</p>
      </div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @impl true
  def handle_event("show_code", _params, socket) do
    {:noreply, socket}
  end
end
