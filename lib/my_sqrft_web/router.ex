defmodule MySqrftWeb.Router do
  use MySqrftWeb, :router

  import MySqrftWeb.UserAuth
  import PhoenixStorybook.Router

  scope "/" do
    storybook_assets()
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MySqrftWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MySqrftWeb do
    pipe_through :browser
    live_storybook("/storybook", backend_module: MySqrftWeb.Storybook)
  end

  # Marketing pages with custom layout
  scope "/", MySqrftWeb do
    pipe_through :browser

    live_session :marketing,
      layout: {MySqrftWeb.Layouts, :marketing},
      on_mount: [{MySqrftWeb.UserAuth, :mount_current_scope}] do
      live "/", Marketing.LandingLive, :index
      live "/about", Marketing.AboutLive, :index
      live "/contact", Marketing.ContactLive, :index
      live "/terms", Marketing.TermsLive, :index
      live "/privacy", Marketing.PrivacyLive, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MySqrftWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:my_sqrft, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MySqrftWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", MySqrftWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{MySqrftWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", MySqrftWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{MySqrftWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  # Test-only routes for component integration testing
  if Application.compile_env(:my_sqrft, :test_routes) do
    scope "/test", MySqrftWeb.Test do
      pipe_through [:browser]

      live_session :test_components,
        on_mount: [{MySqrftWeb.UserAuth, :mount_current_scope}] do
        live "/components/modal", ModalTestLive, :index
        live "/components/navbar", NavbarTestLive, :index
        live "/components/button", ButtonTestLive, :index
        live "/components/alert", AlertTestLive, :index
        live "/components/input-field", InputFieldTestLive, :index
        live "/components/accordion", AccordionTestLive, :index
        live "/components/avatar", AvatarTestLive, :index
        live "/components/badge", BadgeTestLive, :index
        live "/components/banner", BannerTestLive, :index
        live "/components/blockquote", BlockquoteTestLive, :index
        live "/components/breadcrumb", BreadcrumbTestLive, :index
        live "/components/card", CardTestLive, :index
        live "/components/carousel", CarouselTestLive, :index
        live "/components/chat", ChatTestLive, :index
        live "/components/checkbox-card", CheckboxCardTestLive, :index
        live "/components/checkbox-field", CheckboxFieldTestLive, :index
      end
    end
  end
end
