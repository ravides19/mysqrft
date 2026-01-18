defmodule MySqrftWeb.UserLive.Registration do
  use MySqrftWeb, :live_view

  alias MySqrft.Auth
  alias MySqrft.Auth.User

  import MySqrftWeb.Components.Card
  import MySqrftWeb.Components.Button
  import MySqrftWeb.Components.TextField
  import MySqrftWeb.Components.Typography
  import MySqrftWeb.Components.Icon

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.marketing flash={@flash} current_scope={@current_scope}>
      <div class="min-h-[calc(100vh-80px)] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-gray-50 via-white to-primary-bordered-bg-light/20 dark:from-gray-950 dark:via-gray-900 dark:to-primary-bordered-bg-dark/10 relative overflow-hidden">
        <!-- Decorative background elements -->
        <div class="absolute top-20 left-10 w-72 h-72 bg-primary-light/5 rounded-full blur-3xl"></div>
        <div class="absolute bottom-20 right-10 w-96 h-96 bg-secondary-light/5 rounded-full blur-3xl"></div>
        <div class="absolute top-1/2 left-1/4 w-64 h-64 bg-success-light/5 rounded-full blur-3xl"></div>

        <div class="relative z-10 w-full max-w-md">
          <!-- Registration Card -->
          <.card
            variant="bordered"
            color="natural"
            rounded="extra_large"
            padding="extra_large"
            class="!bg-white/95 dark:!bg-gray-900/95 backdrop-blur-xl shadow-[0_25px_60px_-15px_rgba(0,0,0,0.15)] dark:shadow-[0_25px_60px_-15px_rgba(0,0,0,0.4)] border-gray-100/80 dark:border-gray-700/50"
          >
            <!-- Header -->
            <div class="text-center mb-8">
              <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-primary-light to-primary-dark rounded-2xl mb-5 shadow-lg shadow-primary-light/30">
                <.icon name="hero-user-plus" class="w-8 h-8 text-white" />
              </div>
              <.h2 class="text-2xl md:text-3xl mb-2" color="base" font_weight="font-bold">
                Create your account
              </.h2>
              <.p class="opacity-70" color="base">
                Already have an account?
                <.link navigate={~p"/users/log-in"} class="font-semibold text-primary-light dark:text-primary-dark hover:underline ml-1">
                  Log in
                </.link>
              </.p>
            </div>

            <!-- Registration Form -->
            <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate" class="space-y-5">
              <!-- Name Fields Row -->
              <div class="grid grid-cols-2 gap-4">
                <.text_field
                  field={@form[:firstname]}
                  type="text"
                  label="First Name"
                  placeholder="John"
                  autocomplete="given-name"
                  size="large"
                  rounded="large"
                  color="primary"
                  variant="outline"
                  required
                  phx-mounted={JS.focus()}
                  class="!bg-gray-50/50 dark:!bg-gray-800/50"
                />

                <.text_field
                  field={@form[:lastname]}
                  type="text"
                  label="Last Name"
                  placeholder="Doe"
                  autocomplete="family-name"
                  size="large"
                  rounded="large"
                  color="primary"
                  variant="outline"
                  required
                  class="!bg-gray-50/50 dark:!bg-gray-800/50"
                />
              </div>

              <.text_field
                field={@form[:email]}
                type="email"
                label="Email Address"
                placeholder="john@example.com"
                autocomplete="username"
                size="large"
                rounded="large"
                color="primary"
                variant="outline"
                required
                class="!bg-gray-50/50 dark:!bg-gray-800/50"
              >
                <:start_section>
                  <.icon name="hero-envelope" class="w-5 h-5 text-gray-400" />
                </:start_section>
              </.text_field>

              <.text_field
                field={@form[:mobile_number]}
                type="tel"
                label="Mobile Number"
                placeholder="+91 98765 43210"
                autocomplete="tel"
                size="large"
                rounded="large"
                color="primary"
                variant="outline"
                required
                class="!bg-gray-50/50 dark:!bg-gray-800/50"
              >
                <:start_section>
                  <.icon name="hero-phone" class="w-5 h-5 text-gray-400" />
                </:start_section>
              </.text_field>

              <!-- Info Notice -->
              <div class="flex items-start gap-3 p-4 bg-info-bordered-bg-light/50 dark:bg-info-bordered-bg-dark/30 rounded-xl border border-info-light/20 dark:border-info-dark/20">
                <.icon name="hero-information-circle" class="w-5 h-5 text-info-light dark:text-info-dark mt-0.5 shrink-0" />
                <.p class="text-sm opacity-80" color="base">
                  We'll send you a magic link to log in. You can set up a password later in your account settings.
                </.p>
              </div>

              <!-- Submit Button -->
              <.button
                type="submit"
                variant="default"
                color="primary"
                size="extra_large"
                rounded="large"
                class="w-full !py-4 group"
                phx-disable-with="Creating account..."
              >
                <span class="flex items-center justify-center gap-2">
                  Create Account
                  <.icon name="hero-arrow-right" class="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </span>
              </.button>
            </.form>

            <!-- Terms Notice -->
            <.p class="text-xs text-center mt-6 opacity-60" color="base">
              By creating an account, you agree to our
              <.link navigate="/terms" class="underline hover:text-primary-light dark:hover:text-primary-dark">Terms of Service</.link>
              and
              <.link navigate="/privacy" class="underline hover:text-primary-light dark:hover:text-primary-dark">Privacy Policy</.link>
            </.p>
          </.card>

          <!-- Social Proof -->
          <div class="mt-8 text-center">
            <.p class="text-sm opacity-60 mb-3" color="base">Trusted by thousands of users across India</.p>
            <div class="flex items-center justify-center gap-6">
              <div class="flex items-center gap-1">
                <.icon name="hero-star-solid" class="w-4 h-4 text-warning-light" />
                <span class="text-sm font-medium text-base-text-light dark:text-base-text-dark">4.8 Rating</span>
              </div>
              <div class="w-px h-4 bg-gray-300 dark:bg-gray-600"></div>
              <div class="flex items-center gap-1">
                <.icon name="hero-users" class="w-4 h-4 text-primary-light dark:text-primary-dark" />
                <span class="text-sm font-medium text-base-text-light dark:text-base-text-dark">2M+ Users</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.marketing>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: MySqrftWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = User.registration_changeset(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Auth.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Auth.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> User.registration_changeset(user_params, validate_unique: false)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
