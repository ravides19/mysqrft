defmodule MySqrftWeb.Test.ButtonTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic button -->
        <.button>Click me</.button>

        <!-- All colors -->
        <.button color="base">Base</.button>
        <.button color="natural">Natural</.button>
        <.button color="primary">Primary</.button>
        <.button color="secondary">Secondary</.button>
        <.button color="success">Success</.button>
        <.button color="warning">Warning</.button>
        <.button color="danger">Danger</.button>
        <.button color="info">Info</.button>
        <.button color="misc">Misc</.button>
        <.button color="dawn">Dawn</.button>
        <.button color="silver">Silver</.button>
        <.button color="white">White</.button>
        <.button color="dark">Dark</.button>

        <!-- All variants -->
        <.button variant="base">Base</.button>
        <.button variant="outline">Outline</.button>
        <.button variant="transparent">Transparent</.button>
        <.button variant="bordered">Bordered</.button>
        <.button variant="shadow">Shadow</.button>
        <.button variant="default_gradient">Default Gradient</.button>
        <.button variant="outline_gradient">Outline Gradient</.button>
        <.button variant="inverted_gradient">Inverted Gradient</.button>
        <.button variant="subtle">Subtle</.button>

        <!-- All sizes -->
        <.button size="extra_small">XS</.button>
        <.button size="small">Small</.button>
        <.button size="medium">Medium</.button>
        <.button size="large">Large</.button>
        <.button size="extra_large">XL</.button>

        <!-- Button with icon -->
        <.button icon="hero-heart">With Icon</.button>
        <.button icon="hero-heart" right_icon>Right Icon</.button>
        <.button icon="hero-heart" left_icon>Left Icon</.button>

        <!-- Button with indicators -->
        <.button indicator>Indicator</.button>
        <.button right_indicator>Right Indicator</.button>
        <.button left_indicator>Left Indicator</.button>
        <.button top_left_indicator>Top Left</.button>
        <.button top_center_indicator>Top Center</.button>
        <.button top_right_indicator>Top Right</.button>
        <.button middle_left_indicator>Middle Left</.button>
        <.button middle_right_indicator>Middle Right</.button>
        <.button bottom_left_indicator>Bottom Left</.button>
        <.button bottom_center_indicator>Bottom Center</.button>
        <.button bottom_right_indicator>Bottom Right</.button>

        <!-- Button types -->
        <.button type="button">Button</.button>
        <.button type="submit">Submit</.button>
        <.button type="reset">Reset</.button>

        <!-- Button states -->
        <.button disabled>Disabled</.button>
        <.button full_width>Full Width</.button>
        <.button circle>Circle</.button>
        <.button pinging>Pinging</.button>

        <!-- Button group -->
        <.button_group>
          <.button>Button 1</.button>
          <.button>Button 2</.button>
          <.button>Button 3</.button>
        </.button_group>

        <.button_group variation="vertical">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>

        <.button_group color="success">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>

        <!-- Input button -->
        <.input_button value="Input Button" />
        <.input_button value="Submit" type="submit" />
        <.input_button value="Reset" type="reset" />
        <.input_button value="Warning" color="warning" />
        <.input_button value="Full Width" full_width />
        <.input_button value="Custom Size" size="custom-size" />
        <.input_button value="Custom Rounded" rounded="custom-rounded" />
        <.input_button value="Custom Border" border="custom-border" />
        <.input_button value="Custom Classes" class="custom-class" />
        <.input_button value="Custom Display" display="custom-display" />
        <.input_button value="Custom Font Weight" font_weight="custom-font-weight" />
        <.input_button value="Custom Line Height" line_height="custom-line-height" />
        <.input_button value="Custom Content Position" content_position="custom-position" />
        <.input_button value="Variant Outline" variant="outline" />
        <.input_button value="Variant Shadow" variant="shadow" />
        <.input_button value="Variant Bordered" variant="bordered" />
        <.input_button value="Variant Gradient" variant="gradient" />

        <!-- Button link with navigate -->
        <.button_link navigate="/">Navigate</.button_link>
        <.button_link navigate="/" icon="hero-heart">With Icon</.button_link>
        <.button_link navigate="/" icon="hero-heart" left_icon>Left Icon</.button_link>
        <.button_link navigate="/" icon="hero-heart" right_icon>Right Icon</.button_link>
        <.button_link navigate="/" title="Link Title" />
        <.button_link navigate="/" full_width>Full Width</.button_link>
        <.button_link navigate="/" pinging>Pinging</.button_link>
        <.button_link navigate="/" indicator>With Indicator</.button_link>
        <.button_link navigate="/" variant="outline" color="primary">Outline</.button_link>
        <.button_link navigate="/" variant="shadow" color="success">Shadow</.button_link>
        <.button_link navigate="/" variant="bordered" color="warning">Bordered</.button_link>
        <.button_link navigate="/" variant="gradient" color="danger">Gradient</.button_link>
        <.button_link navigate="/" variant="transparent" color="info">Transparent</.button_link>
        <.button_link navigate="/" variant="subtle" color="misc">Subtle</.button_link>
        <.button_link navigate="/">
          <:loading>Loading...</:loading>
          With Loading
        </.button_link>
        <.button_link navigate="/">
          <:loading position="start">Loading...</:loading>
          With Loading Start
        </.button_link>
        <.button_link navigate="/">
          <:loading position="end">Loading...</:loading>
          With Loading End
        </.button_link>

        <!-- Button link with patch -->
        <.button_link patch="/">Patch</.button_link>
        <.button_link patch="/" icon="hero-heart">Patch With Icon</.button_link>
        <.button_link patch="/" title="Patch Title" />
        <.button_link patch="/" full_width>Patch Full Width</.button_link>
        <.button_link patch="/" indicator>Patch With Indicator</.button_link>
        <.button_link patch="/">
          <:loading>Loading...</:loading>
          Patch With Loading
        </.button_link>

        <!-- Button link with href -->
        <.button_link href="https://example.com">Href</.button_link>
        <.button_link href="https://example.com" icon="hero-heart">Href With Icon</.button_link>
        <.button_link href="https://example.com" title="Href Title" />
        <.button_link href="https://example.com" full_width>Href Full Width</.button_link>
        <.button_link href="https://example.com" indicator>Href With Indicator</.button_link>
        <.button_link href="https://example.com">
          <:loading>Loading...</:loading>
          Href With Loading
        </.button_link>

        <!-- Button link with all indicator positions -->
        <.button_link navigate="/" indicator>Indicator</.button_link>
        <.button_link navigate="/" right_indicator>Right Indicator</.button_link>
        <.button_link navigate="/" left_indicator>Left Indicator</.button_link>
        <.button_link navigate="/" top_left_indicator>Top Left Indicator</.button_link>
        <.button_link navigate="/" top_center_indicator>Top Center Indicator</.button_link>
        <.button_link navigate="/" top_right_indicator>Top Right Indicator</.button_link>
        <.button_link navigate="/" middle_left_indicator>Middle Left Indicator</.button_link>
        <.button_link navigate="/" middle_right_indicator>Middle Right Indicator</.button_link>
        <.button_link navigate="/" bottom_left_indicator>Bottom Left Indicator</.button_link>
        <.button_link navigate="/" bottom_center_indicator>Bottom Center Indicator</.button_link>
        <.button_link navigate="/" bottom_right_indicator>Bottom Right Indicator</.button_link>

        <!-- Back button -->
        <.back navigate="/">Back to posts</.back>
        <.back navigate="/posts">Back to posts page</.back>

        <!-- Button with loading slot -->
        <.button>
          <:loading>Loading...</:loading>
          Submit
        </.button>
        <.button>
          <:loading position="end">Loading...</:loading>
          Submit
        </.button>
        <.button>
          <:loading position="start">Loading...</:loading>
          Submit
        </.button>

        <!-- Button with title instead of inner_block -->
        <.button title="Button Title">Content</.button>
        <.button title="Button Title" icon="hero-heart">Content</.button>
        <.button title="Button Title" icon="hero-heart" right_icon>Content</.button>
        <.button title="Button Title" icon="hero-heart" left_icon>Content</.button>

        <!-- Button without inner_block -->
        <.button icon="hero-heart" />
        <.button icon="hero-heart" right_icon />
        <.button icon="hero-heart" left_icon />


        <!-- Edge cases: all border sizes -->
        <.button border="none" variant="bordered">No border</.button>
        <.button border="extra_small" variant="bordered">Extra small border</.button>
        <.button border="small" variant="bordered">Small border</.button>
        <.button border="medium" variant="bordered">Medium border</.button>
        <.button border="large" variant="bordered">Large border</.button>
        <.button border="extra_large" variant="bordered">Extra large border</.button>
        <.button border="custom-border" variant="bordered">Custom border</.button>

        <!-- Edge cases: all rounded sizes -->
        <.button rounded="none">No rounded</.button>
        <.button rounded="extra_small">Extra small rounded</.button>
        <.button rounded="small">Small rounded</.button>
        <.button rounded="medium">Medium rounded</.button>
        <.button rounded="large">Large rounded</.button>
        <.button rounded="extra_large">Extra large rounded</.button>
        <.button rounded="full">Full rounded</.button>
        <.button rounded="custom-rounded">Custom rounded</.button>

        <!-- Edge cases: all color/variant combinations for outline -->
        <.button color="white" variant="outline">White outline</.button>
        <.button color="dark" variant="outline">Dark outline</.button>
        <.button color="natural" variant="outline">Natural outline</.button>
        <.button color="primary" variant="outline">Primary outline</.button>
        <.button color="secondary" variant="outline">Secondary outline</.button>
        <.button color="success" variant="outline">Success outline</.button>
        <.button color="warning" variant="outline">Warning outline</.button>
        <.button color="danger" variant="outline">Danger outline</.button>
        <.button color="info" variant="outline">Info outline</.button>
        <.button color="misc" variant="outline">Misc outline</.button>
        <.button color="dawn" variant="outline">Dawn outline</.button>
        <.button color="silver" variant="outline">Silver outline</.button>

        <!-- Edge cases: all color/variant combinations for transparent -->
        <.button color="white" variant="transparent">White transparent</.button>
        <.button color="dark" variant="transparent">Dark transparent</.button>
        <.button color="natural" variant="transparent">Natural transparent</.button>
        <.button color="primary" variant="transparent">Primary transparent</.button>
        <.button color="secondary" variant="transparent">Secondary transparent</.button>
        <.button color="success" variant="transparent">Success transparent</.button>
        <.button color="warning" variant="transparent">Warning transparent</.button>
        <.button color="danger" variant="transparent">Danger transparent</.button>
        <.button color="info" variant="transparent">Info transparent</.button>
        <.button color="misc" variant="transparent">Misc transparent</.button>
        <.button color="dawn" variant="transparent">Dawn transparent</.button>
        <.button color="silver" variant="transparent">Silver transparent</.button>

        <!-- Edge cases: all color/variant combinations for bordered -->
        <.button color="white" variant="bordered">White bordered</.button>
        <.button color="dark" variant="bordered">Dark bordered</.button>
        <.button color="natural" variant="bordered">Natural bordered</.button>
        <.button color="primary" variant="bordered">Primary bordered</.button>
        <.button color="secondary" variant="bordered">Secondary bordered</.button>
        <.button color="success" variant="bordered">Success bordered</.button>
        <.button color="warning" variant="bordered">Warning bordered</.button>
        <.button color="danger" variant="bordered">Danger bordered</.button>
        <.button color="info" variant="bordered">Info bordered</.button>
        <.button color="misc" variant="bordered">Misc bordered</.button>
        <.button color="dawn" variant="bordered">Dawn bordered</.button>
        <.button color="silver" variant="bordered">Silver bordered</.button>

        <!-- Edge cases: all color/variant combinations for shadow -->
        <.button color="white" variant="shadow">White shadow</.button>
        <.button color="dark" variant="shadow">Dark shadow</.button>
        <.button color="natural" variant="shadow">Natural shadow</.button>
        <.button color="primary" variant="shadow">Primary shadow</.button>
        <.button color="secondary" variant="shadow">Secondary shadow</.button>
        <.button color="success" variant="shadow">Success shadow</.button>
        <.button color="warning" variant="shadow">Warning shadow</.button>
        <.button color="danger" variant="shadow">Danger shadow</.button>
        <.button color="info" variant="shadow">Info shadow</.button>
        <.button color="misc" variant="shadow">Misc shadow</.button>
        <.button color="dawn" variant="shadow">Dawn shadow</.button>
        <.button color="silver" variant="shadow">Silver shadow</.button>

        <!-- Edge cases: all color/variant combinations for gradients -->
        <.button color="white" variant="default_gradient">White default gradient</.button>
        <.button color="dark" variant="default_gradient">Dark default gradient</.button>
        <.button color="natural" variant="default_gradient">Natural default gradient</.button>
        <.button color="primary" variant="default_gradient">Primary default gradient</.button>
        <.button color="secondary" variant="default_gradient">Secondary default gradient</.button>
        <.button color="success" variant="default_gradient">Success default gradient</.button>
        <.button color="warning" variant="default_gradient">Warning default gradient</.button>
        <.button color="danger" variant="default_gradient">Danger default gradient</.button>
        <.button color="info" variant="default_gradient">Info default gradient</.button>
        <.button color="misc" variant="default_gradient">Misc default gradient</.button>
        <.button color="dawn" variant="default_gradient">Dawn default gradient</.button>
        <.button color="silver" variant="default_gradient">Silver default gradient</.button>

        <.button color="white" variant="outline_gradient">White outline gradient</.button>
        <.button color="dark" variant="outline_gradient">Dark outline gradient</.button>
        <.button color="natural" variant="outline_gradient">Natural outline gradient</.button>
        <.button color="primary" variant="outline_gradient">Primary outline gradient</.button>
        <.button color="secondary" variant="outline_gradient">Secondary outline gradient</.button>
        <.button color="success" variant="outline_gradient">Success outline gradient</.button>
        <.button color="warning" variant="outline_gradient">Warning outline gradient</.button>
        <.button color="danger" variant="outline_gradient">Danger outline gradient</.button>
        <.button color="info" variant="outline_gradient">Info outline gradient</.button>
        <.button color="misc" variant="outline_gradient">Misc outline gradient</.button>
        <.button color="dawn" variant="outline_gradient">Dawn outline gradient</.button>
        <.button color="silver" variant="outline_gradient">Silver outline gradient</.button>

        <.button color="white" variant="inverted_gradient">White inverted gradient</.button>
        <.button color="dark" variant="inverted_gradient">Dark inverted gradient</.button>
        <.button color="natural" variant="inverted_gradient">Natural inverted gradient</.button>
        <.button color="primary" variant="inverted_gradient">Primary inverted gradient</.button>
        <.button color="secondary" variant="inverted_gradient">Secondary inverted gradient</.button>
        <.button color="success" variant="inverted_gradient">Success inverted gradient</.button>
        <.button color="warning" variant="inverted_gradient">Warning inverted gradient</.button>
        <.button color="danger" variant="inverted_gradient">Danger inverted gradient</.button>
        <.button color="info" variant="inverted_gradient">Info inverted gradient</.button>
        <.button color="misc" variant="inverted_gradient">Misc inverted gradient</.button>
        <.button color="dawn" variant="inverted_gradient">Dawn inverted gradient</.button>
        <.button color="silver" variant="inverted_gradient">Silver inverted gradient</.button>

        <!-- Edge cases: all color/variant combinations for subtle -->
        <.button color="white" variant="subtle">White subtle</.button>
        <.button color="dark" variant="subtle">Dark subtle</.button>
        <.button color="natural" variant="subtle">Natural subtle</.button>
        <.button color="primary" variant="subtle">Primary subtle</.button>
        <.button color="secondary" variant="subtle">Secondary subtle</.button>
        <.button color="success" variant="subtle">Success subtle</.button>
        <.button color="warning" variant="subtle">Warning subtle</.button>
        <.button color="danger" variant="subtle">Danger subtle</.button>
        <.button color="info" variant="subtle">Info subtle</.button>
        <.button color="misc" variant="subtle">Misc subtle</.button>
        <.button color="dawn" variant="subtle">Dawn subtle</.button>
        <.button color="silver" variant="subtle">Silver subtle</.button>

        <!-- Edge cases: button group with all rounded sizes -->
        <.button_group rounded="none">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="extra_small">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="small">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="medium">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="large">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="extra_large">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="full">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>
        <.button_group rounded="custom-rounded">
          <.button>Button 1</.button>
          <.button>Button 2</.button>
        </.button_group>

        <!-- Edge cases: buttons with indicators for shadow variant -->
        <.button color="natural" variant="shadow" indicator>Natural shadow with indicator</.button>
        <.button color="primary" variant="shadow" indicator>Primary shadow with indicator</.button>
        <.button color="secondary" variant="shadow" indicator>Secondary shadow with indicator</.button>
        <.button color="success" variant="shadow" indicator>Success shadow with indicator</.button>
        <.button color="warning" variant="shadow" indicator>Warning shadow with indicator</.button>
        <.button color="danger" variant="shadow" indicator>Danger shadow with indicator</.button>
        <.button color="info" variant="shadow" indicator>Info shadow with indicator</.button>
        <.button color="misc" variant="shadow" indicator>Misc shadow with indicator</.button>
        <.button color="dawn" variant="shadow" indicator>Dawn shadow with indicator</.button>
        <.button color="silver" variant="shadow" indicator>Silver shadow with indicator</.button>
        <.button color="white" variant="shadow" indicator>White shadow with indicator</.button>
        <.button color="dark" variant="shadow" indicator>Dark shadow with indicator</.button>

        <!-- Edge cases: buttons with indicators for bordered variant -->
        <.button color="natural" variant="bordered" indicator>Natural bordered with indicator</.button>
        <.button color="primary" variant="bordered" indicator>Primary bordered with indicator</.button>
        <.button color="secondary" variant="bordered" indicator>Secondary bordered with indicator</.button>
        <.button color="success" variant="bordered" indicator>Success bordered with indicator</.button>
        <.button color="warning" variant="bordered" indicator>Warning bordered with indicator</.button>
        <.button color="danger" variant="bordered" indicator>Danger bordered with indicator</.button>
        <.button color="info" variant="bordered" indicator>Info bordered with indicator</.button>
        <.button color="misc" variant="bordered" indicator>Misc bordered with indicator</.button>
        <.button color="dawn" variant="bordered" indicator>Dawn bordered with indicator</.button>
        <.button color="silver" variant="bordered" indicator>Silver bordered with indicator</.button>
        <.button color="white" variant="bordered" indicator>White bordered with indicator</.button>
        <.button color="dark" variant="bordered" indicator>Dark bordered with indicator</.button>

        <!-- Edge cases: buttons with indicators for outline variant -->
        <.button color="natural" variant="outline" indicator>Natural outline with indicator</.button>
        <.button color="primary" variant="outline" indicator>Primary outline with indicator</.button>
        <.button color="secondary" variant="outline" indicator>Secondary outline with indicator</.button>
        <.button color="success" variant="outline" indicator>Success outline with indicator</.button>
        <.button color="warning" variant="outline" indicator>Warning outline with indicator</.button>
        <.button color="danger" variant="outline" indicator>Danger outline with indicator</.button>
        <.button color="info" variant="outline" indicator>Info outline with indicator</.button>
        <.button color="misc" variant="outline" indicator>Misc outline with indicator</.button>
        <.button color="dawn" variant="outline" indicator>Dawn outline with indicator</.button>
        <.button color="silver" variant="outline" indicator>Silver outline with indicator</.button>

        <!-- Edge cases: buttons with indicators for default variant -->
        <.button color="natural" variant="base" indicator>Natural default with indicator</.button>
        <.button color="primary" variant="base" indicator>Primary default with indicator</.button>
        <.button color="secondary" variant="base" indicator>Secondary default with indicator</.button>
        <.button color="success" variant="base" indicator>Success default with indicator</.button>
        <.button color="warning" variant="base" indicator>Warning default with indicator</.button>
        <.button color="danger" variant="base" indicator>Danger default with indicator</.button>
        <.button color="info" variant="base" indicator>Info default with indicator</.button>
        <.button color="misc" variant="base" indicator>Misc default with indicator</.button>
        <.button color="dawn" variant="base" indicator>Dawn default with indicator</.button>
        <.button color="silver" variant="base" indicator>Silver default with indicator</.button>
        <.button color="white" variant="base" indicator>White default with indicator</.button>
        <.button color="dark" variant="base" indicator>Dark default with indicator</.button>

        <!-- Edge cases: transparent variants with indicators -->
        <.button color="natural" variant="transparent" indicator>Natural transparent with indicator</.button>
        <.button color="primary" variant="transparent" indicator>Primary transparent with indicator</.button>
        <.button color="secondary" variant="transparent" indicator>Secondary transparent with indicator</.button>
        <.button color="success" variant="transparent" indicator>Success transparent with indicator</.button>
        <.button color="warning" variant="transparent" indicator>Warning transparent with indicator</.button>
        <.button color="danger" variant="transparent" indicator>Danger transparent with indicator</.button>
        <.button color="info" variant="transparent" indicator>Info transparent with indicator</.button>
        <.button color="misc" variant="transparent" indicator>Misc transparent with indicator</.button>
        <.button color="dawn" variant="transparent" indicator>Dawn transparent with indicator</.button>
        <.button color="silver" variant="transparent" indicator>Silver transparent with indicator</.button>

        <!-- Edge cases: outline variants with indicators (all colors) -->
        <.button color="natural" variant="outline" indicator>Natural outline with indicator</.button>
        <.button color="primary" variant="outline" indicator>Primary outline with indicator</.button>
        <.button color="secondary" variant="outline" indicator>Secondary outline with indicator</.button>
        <.button color="success" variant="outline" indicator>Success outline with indicator</.button>
        <.button color="warning" variant="outline" indicator>Warning outline with indicator</.button>
        <.button color="danger" variant="outline" indicator>Danger outline with indicator</.button>
        <.button color="info" variant="outline" indicator>Info outline with indicator</.button>
        <.button color="misc" variant="outline" indicator>Misc outline with indicator</.button>
        <.button color="dawn" variant="outline" indicator>Dawn outline with indicator</.button>
        <.button color="silver" variant="outline" indicator>Silver outline with indicator</.button>

        <!-- Edge cases: buttons with circle and different sizes -->
        <.button size="extra_small" circle>XS Circle</.button>
        <.button size="small" circle>Small Circle</.button>
        <.button size="medium" circle>Medium Circle</.button>
        <.button size="large" circle>Large Circle</.button>
        <.button size="extra_large" circle>XL Circle</.button>
        <.button size="custom-size" circle>Custom Circle</.button>

        <!-- Edge cases: buttons with indicators and different sizes -->
        <.button size="extra_small" indicator>XS with indicator</.button>
        <.button size="small" indicator>Small with indicator</.button>
        <.button size="medium" indicator>Medium with indicator</.button>
        <.button size="large" indicator>Large with indicator</.button>
        <.button size="extra_large" indicator>XL with indicator</.button>
        <.button size="custom-size" indicator>Custom with indicator</.button>

        <!-- Edge cases: buttons with left_icon and right_icon -->
        <.button icon="hero-heart" left_icon>Left icon</.button>
        <.button icon="hero-heart" right_icon>Right icon</.button>
        <.button icon="hero-heart" left_icon indicator>Left icon with indicator</.button>
        <.button icon="hero-heart" right_icon indicator>Right icon with indicator</.button>

        <!-- Edge cases: buttons with all border_class colors for bordered variant -->
        <.button color="base" variant="bordered">Base bordered</.button>
        <.button color="natural" variant="bordered">Natural bordered</.button>
        <.button color="primary" variant="bordered">Primary bordered</.button>
        <.button color="secondary" variant="bordered">Secondary bordered</.button>
        <.button color="success" variant="bordered">Success bordered</.button>
        <.button color="warning" variant="bordered">Warning bordered</.button>
        <.button color="danger" variant="bordered">Danger bordered</.button>
        <.button color="info" variant="bordered">Info bordered</.button>
        <.button color="misc" variant="bordered">Misc bordered</.button>
        <.button color="dawn" variant="bordered">Dawn bordered</.button>
        <.button color="silver" variant="bordered">Silver bordered</.button>

        <!-- Edge cases: buttons with rounded="full" and rounded="none" -->
        <.button rounded="full">Full rounded</.button>
        <.button rounded="none">No rounded</.button>
        <.button rounded="full" circle>Full rounded circle</.button>
        <.button rounded="none" circle>No rounded circle</.button>

        <!-- Edge cases: buttons with custom binary rounded and size -->
        <.button rounded="custom-rounded-value">Custom rounded</.button>
        <.button size="custom-size-value">Custom size</.button>
        <.button border="custom-border-value" variant="bordered">Custom border</.button>

        <!-- Edge cases: buttons with content_position values -->
        <.button content_position="start">Content Start</.button>
        <.button content_position="end">Content End</.button>
        <.button content_position="center">Content Center</.button>
        <.button content_position="between">Content Between</.button>
        <.button content_position="around">Content Around</.button>
        <.button content_position="custom-position-value">Custom Content Position</.button>

        <!-- Edge cases: buttons with indicator_size values -->
        <.button indicator_size="extra_small" indicator>Extra Small Indicator</.button>
        <.button indicator_size="small" indicator>Small Indicator</.button>
        <.button indicator_size="medium" indicator>Medium Indicator</.button>
        <.button indicator_size="large" indicator>Large Indicator</.button>
        <.button indicator_size="extra_large" indicator>Extra Large Indicator</.button>
        <.button indicator_size="custom-indicator-size-value" indicator>Custom Indicator Size</.button>

        <!-- Edge cases: buttons with pinging and indicator combinations -->
        <.button pinging indicator>Pinging With Indicator</.button>
        <.button pinging>Pinging Without Indicator</.button>
        <.button indicator>Indicator Without Pinging</.button>

        <!-- Edge cases: buttons with all indicator positions -->
        <.button indicator>Indicator</.button>
        <.button right_indicator>Right Indicator</.button>
        <.button left_indicator>Left Indicator</.button>
        <.button top_left_indicator>Top Left Indicator</.button>
        <.button top_center_indicator>Top Center Indicator</.button>
        <.button top_right_indicator>Top Right Indicator</.button>
        <.button middle_left_indicator>Middle Left Indicator</.button>
        <.button middle_right_indicator>Middle Right Indicator</.button>
        <.button bottom_left_indicator>Bottom Left Indicator</.button>
        <.button bottom_center_indicator>Bottom Center Indicator</.button>
        <.button bottom_right_indicator>Bottom Right Indicator</.button>
      </div>
    </Layouts.app>
    """
  end
end
