defmodule MySqrftWeb.Test.CheckboxFieldTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.CheckboxField

  def mount(_params, _session, socket) do
    form = to_form(%{"terms" => false, "newsletter" => true}, as: "test")
    {:ok, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic checkbox_field -->
        <.checkbox_field name="terms" value="accept" />

        <!-- CheckboxField with different sizes -->
        <.checkbox_field name="terms-xs" value="accept" size="extra_small" />
        <.checkbox_field name="terms-sm" value="accept" size="small" />
        <.checkbox_field name="terms-md" value="accept" size="medium" />
        <.checkbox_field name="terms-lg" value="accept" size="large" />
        <.checkbox_field name="terms-xl" value="accept" size="extra_large" />

        <!-- CheckboxField with different colors -->
        <%= for color <- ~w(primary secondary success warning danger info misc dawn silver white dark natural) do %>
          <.checkbox_field name={"terms-#{color}"} value="accept" color={color} />
        <% end %>

        <!-- CheckboxField with value "true" and "false" -->
        <.checkbox_field name="terms-true" value="true" />
        <.checkbox_field name="terms-false" value="false" />

        <!-- CheckboxField with field and multiple -->
        <.checkbox_field field={@form[:terms]} value="accept" multiple />
        <.checkbox_field field={@form[:newsletter]} value="subscribe" multiple />

        <!-- CheckboxField with different border sizes -->
        <.checkbox_field name="terms-border-xs" value="accept" border="extra_small" />
        <.checkbox_field name="terms-border-sm" value="accept" border="small" />
        <.checkbox_field name="terms-border-md" value="accept" border="medium" />
        <.checkbox_field name="terms-border-lg" value="accept" border="large" />
        <.checkbox_field name="terms-border-xl" value="accept" border="extra_large" />
        <.checkbox_field name="terms-border-none" value="accept" border="none" />

        <!-- CheckboxField with different rounded styles -->
        <.checkbox_field name="terms-rounded-xs" value="accept" rounded="extra_small" />
        <.checkbox_field name="terms-rounded-sm" value="accept" rounded="small" />
        <.checkbox_field name="terms-rounded-md" value="accept" rounded="medium" />
        <.checkbox_field name="terms-rounded-lg" value="accept" rounded="large" />
        <.checkbox_field name="terms-rounded-xl" value="accept" rounded="extra_large" />
        <.checkbox_field name="terms-rounded-full" value="accept" rounded="full" />
        <.checkbox_field name="terms-rounded-none" value="accept" rounded="none" />

        <!-- CheckboxField with different space sizes -->
        <.checkbox_field name="terms-space-xs" value="accept" space="extra_small" label="XS Space" />
        <.checkbox_field name="terms-space-sm" value="accept" space="small" label="Small Space" />
        <.checkbox_field name="terms-space-md" value="accept" space="medium" label="Medium Space" />
        <.checkbox_field name="terms-space-lg" value="accept" space="large" label="Large Space" />
        <.checkbox_field name="terms-space-xl" value="accept" space="extra_large" label="XL Space" />

        <!-- CheckboxField with label -->
        <.checkbox_field name="terms-label" value="accept" label="Accept Terms" />

        <!-- CheckboxField with checked -->
        <.checkbox_field name="terms-checked" value="accept" checked />

        <!-- CheckboxField with reverse -->
        <.checkbox_field name="terms-reverse" value="accept" label="Reverse" reverse />

        <!-- CheckboxField with ring -->
        <.checkbox_field name="terms-ring" value="accept" ring />
        <.checkbox_field name="terms-no-ring" value="accept" ring={false} />

        <!-- CheckboxField with field -->
        <.checkbox_field field={@form["terms"]} value="accept" />
        <.checkbox_field field={@form["newsletter"]} value="subscribe" />

        <!-- CheckboxField with errors -->
        <.checkbox_field name="terms-errors" value="accept" errors={["can't be blank"]} />

        <!-- CheckboxField with multiple -->
        <.checkbox_field name="interests" value="sports" multiple label="Sports" />
        <.checkbox_field name="interests" value="music" multiple label="Music" />

        <!-- CheckboxField with custom classes -->
        <.checkbox_field name="terms-custom" value="accept" class="custom-class" label_class="custom-label" wrapper_class="custom-wrapper" checkbox_class="custom-checkbox" />

        <!-- Edge cases: custom binary values -->
        <.checkbox_field name="terms-custom-size" value="accept" size="custom-size-value" />
        <.checkbox_field name="terms-custom-rounded" value="accept" rounded="custom-rounded-value" />
        <.checkbox_field name="terms-custom-border" value="accept" border="custom-border-value" />
        <.checkbox_field name="terms-custom-space" value="accept" space="custom-space-value" />
        <.checkbox_field name="terms-custom-color" value="accept" color="custom-color-value" />
      </div>
    </Layouts.app>
    """
  end
end
