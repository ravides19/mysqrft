defmodule MySqrftWeb.UserLive.Login do
  use MySqrftWeb, :live_view

  alias MySqrft.Auth

  import MySqrftWeb.Components.Card
  import MySqrftWeb.Components.Button
  import MySqrftWeb.Components.TextField
  import MySqrftWeb.Components.PasswordField
  import MySqrftWeb.Components.Typography
  import MySqrftWeb.Components.Divider
  import MySqrftWeb.Components.Icon

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.marketing flash={@flash} current_scope={@current_scope}>
      <div class="min-h-[calc(100vh-80px)] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-gray-50 via-white to-primary-bordered-bg-light/20 dark:from-gray-950 dark:via-gray-900 dark:to-primary-bordered-bg-dark/10 relative overflow-hidden">
        <!-- Decorative background elements -->
        <div class="absolute top-20 right-10 w-72 h-72 bg-primary-light/5 rounded-full blur-3xl"></div>
        <div class="absolute bottom-20 left-10 w-96 h-96 bg-secondary-light/5 rounded-full blur-3xl"></div>
        <div class="absolute top-1/3 right-1/4 w-64 h-64 bg-info-light/5 rounded-full blur-3xl"></div>

        <div class="relative z-10 w-full max-w-md">
          <!-- Login Card -->
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
                <.icon name="hero-arrow-right-on-rectangle" class="w-8 h-8 text-white" />
              </div>
              <.h2 class="text-2xl md:text-3xl mb-2" color="base" font_weight="font-bold">
                Welcome back
              </.h2>
              <.p class="opacity-70" color="base">
                <%= if @current_scope do %>
                  Please reauthenticate to continue
                <% else %>
                  Don't have an account?
                  <.link navigate={~p"/users/register"} class="font-semibold text-primary-light dark:text-primary-dark hover:underline ml-1">
                    Sign up
                  </.link>
                <% end %>
              </.p>
            </div>

            <!-- Dev Mode Notice -->
            <div :if={local_mail_adapter?()} class="flex items-start gap-3 p-4 mb-6 bg-info-bordered-bg-light/50 dark:bg-info-bordered-bg-dark/30 rounded-xl border border-info-light/20 dark:border-info-dark/20">
              <.icon name="hero-information-circle" class="w-5 h-5 text-info-light dark:text-info-dark mt-0.5 shrink-0" />
              <div>
                <.p class="text-sm font-medium" color="base">Development Mode</.p>
                <.p class="text-xs opacity-70" color="base">
                  Visit <.link href="/dev/mailbox" class="underline hover:text-primary-light">the mailbox</.link> to see sent emails.
                </.p>
              </div>
            </div>

            <!-- Magic Link Login Form -->
            <.form
              :let={f}
              for={@form}
              id="login_form_magic"
              action={~p"/users/log-in"}
              phx-submit="submit_magic"
              class="space-y-5"
            >
              <.text_field
                readonly={!!@current_scope}
                field={f[:email]}
                type="email"
                label="Email Address"
                placeholder="john@example.com"
                autocomplete="email"
                size="large"
                rounded="large"
                color="primary"
                variant="outline"
                required
                phx-mounted={JS.focus()}
                class="!bg-gray-50/50 dark:!bg-gray-800/50"
              >
                <:start_section>
                  <.icon name="hero-envelope" class="w-5 h-5 text-gray-400" />
                </:start_section>
              </.text_field>

              <.button
                type="submit"
                variant="default"
                color="primary"
                size="extra_large"
                rounded="large"
                class="w-full !py-4 group"
              >
                <span class="flex items-center justify-center gap-2">
                  <.icon name="hero-sparkles" class="w-5 h-5" />
                  Send Magic Link
                  <.icon name="hero-arrow-right" class="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </span>
              </.button>
            </.form>

            <!-- Divider -->
            <.divider color="natural" class="my-6">
              <span class="px-3 text-sm opacity-60 bg-white dark:bg-gray-900">or continue with password</span>
            </.divider>

            <!-- Password Login Form -->
            <.form
              :let={f}
              for={@form}
              id="login_form_password"
              action={~p"/users/log-in"}
              phx-submit="submit_password"
              phx-trigger-action={@trigger_submit}
              class="space-y-5"
            >
              <.text_field
                readonly={!!@current_scope}
                field={f[:email]}
                type="email"
                label="Email Address"
                placeholder="john@example.com"
                autocomplete="email"
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

              <.password_field
                field={@form[:password]}
                label="Password"
                placeholder="Enter your password"
                autocomplete="current-password"
                size="large"
                rounded="large"
                color="primary"
                variant="outline"
                class="!bg-gray-50/50 dark:!bg-gray-800/50"
              />

              <div class="flex flex-col gap-3">
                <.button
                  type="submit"
                  variant="default"
                  color="primary"
                  size="extra_large"
                  rounded="large"
                  class="w-full !py-4 group"
                  name={@form[:remember_me].name}
                  value="true"
                >
                  <span class="flex items-center justify-center gap-2">
                    Log in & Remember me
                    <.icon name="hero-arrow-right" class="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </span>
                </.button>

                <.button
                  type="submit"
                  variant="outline"
                  color="primary"
                  size="large"
                  rounded="large"
                  class="w-full"
                >
                  Log in this session only
                </.button>
              </div>
            </.form>

            <!-- Forgot Password Link -->
            <div class="mt-6 text-center">
              <span class="text-sm text-primary-light dark:text-primary-dark opacity-60 cursor-not-allowed">
                Forgot your password? Use Magic Link above
              </span>
            </div>
          </.card>

          <!-- Social Proof -->
          <div class="mt-8 text-center">
            <.p class="text-sm opacity-60 mb-3" color="base">Secure login with 256-bit encryption</.p>
            <div class="flex items-center justify-center gap-2">
              <.icon name="hero-shield-check" class="w-5 h-5 text-success-light dark:text-success-dark" />
              <span class="text-sm font-medium text-base-text-light dark:text-base-text-dark">Your data is safe with us</span>
            </div>
          </div>
        </div>
      </div>
    </Layouts.marketing>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Auth.get_user_by_email(email) do
      Auth.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:my_sqrft, MySqrft.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
