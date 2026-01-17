defmodule MySqrftWeb.Test.CheckboxCardTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.CheckboxCard

  def mount(_params, _session, socket) do
    form = to_form(%{"plan" => "basic"}, as: "test")
    {:ok, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic checkbox_card -->
        <.checkbox_card name="plan">
          <:checkbox value="basic" title="Basic Plan"></:checkbox>
          <:checkbox value="pro" title="Pro Plan"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different sizes -->
        <.checkbox_card name="plan-xs" size="extra_small">
          <:checkbox value="basic" title="XS"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-sm" size="small">
          <:checkbox value="basic" title="Small"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-md" size="medium">
          <:checkbox value="basic" title="Medium"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-lg" size="large">
          <:checkbox value="basic" title="Large"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-xl" size="extra_large">
          <:checkbox value="basic" title="XL"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different colors and variants -->
        <%= for color <- ~w(natural primary secondary success warning danger info misc dawn silver white dark) do %>
          <.checkbox_card name={"plan-default-#{color}"} color={color}>
            <:checkbox value="basic" title={"Default #{color}"}></:checkbox>
          </.checkbox_card>
          <.checkbox_card name={"plan-outline-#{color}"} variant="outline" color={color}>
            <:checkbox value="basic" title={"Outline #{color}"}></:checkbox>
          </.checkbox_card>
          <.checkbox_card name={"plan-shadow-#{color}"} variant="shadow" color={color}>
            <:checkbox value="basic" title={"Shadow #{color}"}></:checkbox>
          </.checkbox_card>
          <.checkbox_card name={"plan-bordered-#{color}"} variant="bordered" color={color}>
            <:checkbox value="basic" title={"Bordered #{color}"}></:checkbox>
          </.checkbox_card>
        <% end %>

        <!-- CheckboxCard with different border sizes -->
        <.checkbox_card name="plan-border-xs" border="extra_small">
          <:checkbox value="basic" title="XS Border"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-border-sm" border="small">
          <:checkbox value="basic" title="Small Border"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-border-md" border="medium">
          <:checkbox value="basic" title="Medium Border"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-border-lg" border="large">
          <:checkbox value="basic" title="Large Border"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-border-xl" border="extra_large">
          <:checkbox value="basic" title="XL Border"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-border-none" border="none">
          <:checkbox value="basic" title="No Border"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different rounded styles -->
        <.checkbox_card name="plan-rounded-xs" rounded="extra_small">
          <:checkbox value="basic" title="XS Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-rounded-sm" rounded="small">
          <:checkbox value="basic" title="Small Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-rounded-md" rounded="medium">
          <:checkbox value="basic" title="Medium Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-rounded-lg" rounded="large">
          <:checkbox value="basic" title="Large Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-rounded-xl" rounded="extra_large">
          <:checkbox value="basic" title="XL Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-rounded-full" rounded="full">
          <:checkbox value="basic" title="Full Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-rounded-none" rounded="none">
          <:checkbox value="basic" title="No Rounded"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different padding sizes -->
        <.checkbox_card name="plan-padding-xs" padding="extra_small">
          <:checkbox value="basic" title="XS Padding"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-padding-sm" padding="small">
          <:checkbox value="basic" title="Small Padding"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-padding-md" padding="medium">
          <:checkbox value="basic" title="Medium Padding"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-padding-lg" padding="large">
          <:checkbox value="basic" title="Large Padding"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-padding-xl" padding="extra_large">
          <:checkbox value="basic" title="XL Padding"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-padding-none" padding="none">
          <:checkbox value="basic" title="No Padding"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different space sizes -->
        <.checkbox_card name="plan-space-xs" space="extra_small">
          <:checkbox value="basic" title="XS Space"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-space-sm" space="small">
          <:checkbox value="basic" title="Small Space"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-space-md" space="medium">
          <:checkbox value="basic" title="Medium Space"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-space-lg" space="large">
          <:checkbox value="basic" title="Large Space"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-space-xl" space="extra_large">
          <:checkbox value="basic" title="XL Space"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different cols -->
        <.checkbox_card name="plan-cols-one" cols="one">
          <:checkbox value="basic" title="One Col"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-cols-two" cols="two">
          <:checkbox value="basic" title="Two Cols"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-cols-three" cols="three">
          <:checkbox value="basic" title="Three Cols"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
          <:checkbox value="enterprise" title="Enterprise"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with different cols_gap -->
        <.checkbox_card name="plan-cols-gap-xs" cols_gap="extra_small">
          <:checkbox value="basic" title="XS Gap"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-cols-gap-sm" cols_gap="small">
          <:checkbox value="basic" title="Small Gap"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-cols-gap-md" cols_gap="medium">
          <:checkbox value="basic" title="Medium Gap"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-cols-gap-lg" cols_gap="large">
          <:checkbox value="basic" title="Large Gap"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-cols-gap-xl" cols_gap="extra_large">
          <:checkbox value="basic" title="XL Gap"></:checkbox>
          <:checkbox value="pro" title="Pro"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with reverse -->
        <.checkbox_card name="plan-reverse" reverse>
          <:checkbox value="basic" title="Reverse"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with show_checkbox -->
        <.checkbox_card name="plan-show-checkbox" show_checkbox>
          <:checkbox value="basic" title="Show Checkbox"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with label and description -->
        <.checkbox_card name="plan-with-label" label="Select Plan">
          <:checkbox value="basic" title="Basic"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-with-description" description="Choose your plan">
          <:checkbox value="basic" title="Basic"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with checkbox that has icon -->
        <.checkbox_card name="plan-checkbox-icon">
          <:checkbox value="basic" title="Checkbox Icon" icon="hero-check"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with checkbox that has description -->
        <.checkbox_card name="plan-checkbox-description">
          <:checkbox value="basic" title="Title" description="Description text"></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with checked checkbox -->
        <.checkbox_card name="plan-checked">
          <:checkbox value="basic" title="Checked" checked></:checkbox>
        </.checkbox_card>

        <!-- CheckboxCard with errors -->
        <.checkbox_card name="plan-errors" errors={["can't be blank"]}>
          <:checkbox value="basic" title="With Errors"></:checkbox>
        </.checkbox_card>

        <!-- Edge cases: custom binary values -->
        <.checkbox_card name="plan-custom-size" size="custom-size-value">
          <:checkbox value="basic" title="Custom Size"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-custom-rounded" rounded="custom-rounded-value">
          <:checkbox value="basic" title="Custom Rounded"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-custom-border" border="custom-border-value">
          <:checkbox value="basic" title="Custom Border"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-custom-padding" padding="custom-padding-value">
          <:checkbox value="basic" title="Custom Padding"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-custom-space" space="custom-space-value">
          <:checkbox value="basic" title="Custom Space"></:checkbox>
        </.checkbox_card>
        <.checkbox_card name="plan-custom-color-variant" color="custom-color" variant="custom-variant">
          <:checkbox value="basic" title="Custom Color/Variant"></:checkbox>
        </.checkbox_card>
      </div>
    </Layouts.app>
    """
  end
end
