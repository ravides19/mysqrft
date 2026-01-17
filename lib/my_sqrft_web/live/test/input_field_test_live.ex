defmodule MySqrftWeb.Test.InputFieldTestLive do
  @moduledoc false
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.InputField

  def mount(_params, _session, socket) do
    # Create a simple changeset for form testing
    form = to_form(%{}, as: "test")
    {:ok, assign(socket, form: form)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="p-8 space-y-8">
        <!-- Basic input -->
        <.input name="email" type="text" value="" />
        <.input name="email" type="text" label="Email" value="" />
        <.input name="email" type="text" value="test@example.com" />

        <!-- All input types -->
        <.input name="email" type="email" value="" />
        <.input name="password" type="password" value="" />
        <.input name="number" type="number" value="" />
        <.input name="date" type="date" value="" />
        <.input name="datetime-local" type="datetime-local" value="" />
        <.input name="url" type="url" value="" />
        <.input name="tel" type="tel" value="" />
        <.input name="search" type="search" value="" />
        <.input name="time" type="time" value="" />
        <.input name="week" type="week" value="" />
        <.input name="month" type="month" value="" />
        <.input name="color" type="color" value="" />
        <.input name="range" type="range" value="" />
        <.input name="file" type="file" value="" />

        <!-- Input with errors -->
        <.input name="email" type="text" value="" errors={["can't be blank"]} />
        <.input name="email" type="text" value="" errors={["can't be blank", "is invalid"]} />

        <!-- Checkbox input -->
        <.input name="terms" type="checkbox" label="Accept terms" />
        <.input name="terms" type="checkbox" value={true} label="Checked" />
        <.input name="terms" type="checkbox" value={false} label="Unchecked" />
        <.input name="terms" type="checkbox" checked={true} label="Checked attr" />
        <.input name="terms" type="checkbox" checked={false} label="Unchecked attr" />

        <!-- Select input -->
        <.input
          name="country"
          type="select"
          label="Country"
          value="us"
          options={[{"USA", "us"}, {"Canada", "ca"}, {"Mexico", "mx"}]}
        />
        <.input
          name="country"
          type="select"
          prompt="Select a country"
          value=""
          options={[{"USA", "us"}]}
        />
        <.input
          name="countries"
          type="select"
          multiple={true}
          value={[]}
          options={[{"USA", "us"}, {"Canada", "ca"}]}
        />

        <!-- Textarea input -->
        <.input name="description" type="textarea" label="Description" value="" />
        <.input name="description" type="textarea" value="Test content" />
        <.input name="description" type="textarea" value="" errors={["can't be blank"]} />

        <!-- Input with name only -->
        <.input name="email" type="email" value="" />
        <.input name="name" type="text" value="" />

        <!-- Label component -->
        <.label for="email">Email Address</.label>

        <!-- Error component -->
        <.error>This field is required</.error>
        <.error>Another error message</.error>
      </div>
    </Layouts.app>
    """
  end
end
