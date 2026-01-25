defmodule MySqrftWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use MySqrftWeb, :html

  # Define marketing layout function before embed_templates to avoid attribute definition errors
  @doc """
  Renders the marketing layout for marketing pages.
  This layout includes the marketing navbar, footer, and flash messages.
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_scope, :map, default: nil, doc: "the current scope"
  slot :inner_block, doc: "the content to render inside the layout"

  def marketing(assigns) do
    ~H"""
    <!-- Floating Navigation -->
    <header
      id="navbar-header"
      phx-hook=".NavbarScroll"
      phx-update="ignore"
      class="sticky top-0 z-50 transition-all duration-300"
    >
      <.navbar
        id="main-navbar"
        variant="default"
        color="white"
        rounded="none"
        padding="small"
        max_width=""
        content_position="between"
        nav_wrapper_class="md:grid md:grid-cols-3 md:items-center md:gap-4"
        list_wrapper_class="md:flex md:justify-center md:col-start-2 md:col-end-3"
        class="bg-white/95 dark:bg-base-bg-dark/95 backdrop-blur-md border-b border-base-border-light/50 dark:border-base-border-dark/50 shadow-none transition-all duration-300 navbar-scroll-state"
      >
        <:start_content class="flex items-center gap-3 md:justify-start md:col-start-1 md:col-end-2">
          <.link navigate="/" class="flex items-center gap-3 group">
            <div class="w-10 h-10 md:w-12 md:h-12 bg-gradient-to-br from-primary-light to-primary-dark rounded-xl flex items-center justify-center shadow-lg shadow-primary-light/20 group-hover:shadow-primary-light/40 transition-shadow duration-300">
              <.icon name="hero-home" class="w-6 h-6 md:w-7 md:h-7 text-white" />
            </div>
            <span class="font-display text-xl md:text-2xl font-bold text-primary-light dark:text-primary-dark">
              MySqrft
            </span>
          </.link>
        </:start_content>

        <:list
          icon="hero-home-solid"
          icon_class="w-4 h-4"
          class="gap-2 group"
        >
          <.link
            navigate="/"
            class="text-base-text-light dark:text-base-text-dark group-hover:text-primary-light dark:group-hover:text-primary-dark font-medium transition-colors"
          >
            Home
          </.link>
        </:list>
        <:list
          icon="hero-information-circle-solid"
          icon_class="w-4 h-4"
          class="gap-2 group"
        >
          <.link
            navigate="/about"
            class="text-base-text-light dark:text-base-text-dark group-hover:text-primary-light dark:group-hover:text-primary-dark font-medium transition-colors"
          >
            About
          </.link>
        </:list>
        <:list
          icon="hero-envelope-solid"
          icon_class="w-4 h-4"
          class="gap-2 group"
        >
          <.link
            navigate="/contact"
            class="text-base-text-light dark:text-base-text-dark group-hover:text-primary-light dark:group-hover:text-primary-dark font-medium transition-colors"
          >
            Contact
          </.link>
        </:list>

        <:end_content class="flex items-center gap-4 md:justify-end md:col-start-3 md:col-end-4">
          <div class="flex flex-row items-center gap-4">
            <.theme_toggle />
            <%= if @current_scope do %>
              <.dropdown
                id="user-menu"
                position="bottom"
                relative="relative"
                width="w-fit"
                rounded="large"
                padding="small"
                variant="default"
                color="white"
              >
                <:trigger>
                  <button class="flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-base-border-light/10 dark:hover:bg-base-border-dark/10 transition-colors">
                    <.avatar size="small" color="primary" rounded="full">
                      {String.first(@current_scope.user.firstname || @current_scope.user.email)
                      |> String.upcase()}
                    </.avatar>
                    <span class="hidden sm:block text-sm font-medium text-base-text-light dark:text-base-text-dark">
                      {@current_scope.user.firstname || "User"}
                    </span>
                    <.icon
                      name="hero-chevron-down"
                      class="w-4 h-4 text-base-text-light dark:text-base-text-dark"
                    />
                  </button>
                </:trigger>
                <:content class="w-48">
                  <ul class="space-y-1">
                    <li>
                      <.link
                        href={~p"/profile"}
                        class="flex items-center gap-2 px-3 py-2 rounded-md text-sm text-base-text-light dark:text-base-text-dark hover:bg-primary-bordered-bg-light dark:hover:bg-primary-bordered-bg-dark hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                      >
                        <.icon name="hero-user" class="w-4 h-4" /> Profile
                      </.link>
                    </li>
                    <li>
                      <.link
                        href={~p"/users/settings"}
                        class="flex items-center gap-2 px-3 py-2 rounded-md text-sm text-base-text-light dark:text-base-text-dark hover:bg-primary-bordered-bg-light dark:hover:bg-primary-bordered-bg-dark hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                      >
                        <.icon name="hero-cog-6-tooth" class="w-4 h-4" /> Settings
                      </.link>
                    </li>
                    <li class="border-t border-base-border-light dark:border-base-border-dark my-1">
                    </li>
                    <li>
                      <.link
                        href={~p"/users/log-out"}
                        method="delete"
                        class="flex items-center gap-2 px-3 py-2 rounded-md text-sm text-danger-light dark:text-danger-dark hover:bg-danger-bordered-bg-light dark:hover:bg-danger-bordered-bg-dark transition-colors"
                      >
                        <.icon name="hero-arrow-right-on-rectangle" class="w-4 h-4" /> Log out
                      </.link>
                    </li>
                  </ul>
                </:content>
              </.dropdown>
            <% else %>
              <div class="flex items-center gap-3">
                <.button_link
                  href={~p"/users/log-in"}
                  variant="default"
                  color="natural"
                  size="medium"
                  rounded="large"
                >
                  Log in
                </.button_link>
                <.button_link
                  href={~p"/users/register"}
                  variant="default"
                  color="primary"
                  size="medium"
                  rounded="large"
                >
                  Register
                </.button_link>
              </div>
            <% end %>
          </div>
        </:end_content>
      </.navbar>
      <script :type={Phoenix.LiveView.ColocatedHook} name=".NavbarScroll">
        export default {
          mounted() {
            this.initScrollHandler();
          },
          updated() {
            // Immediately re-apply scroll state synchronously to prevent flickering
            const header = this.el;
            const navbar = header.querySelector("#main-navbar");

            // Update references
            this.header = header;
            this.navbar = navbar;

            // Get current scroll state before update
            const currentScrollState = window.scrollY > 50;
            const wasScrolled = header.classList.contains("navbar-scrolled");

            // Only disable transitions if state is actually changing to prevent unnecessary flicker
            if (currentScrollState !== wasScrolled) {
              // Temporarily disable transitions to prevent flicker during update
              header.style.transition = "none";
              if (navbar) {
                navbar.style.transition = "none";
                navbar.style.animation = "none";
              }
            }

            // Re-check and apply scroll state synchronously
            const scrolled = window.scrollY > 50;

            if (scrolled) {
              header.classList.add("navbar-scrolled");
              header.classList.remove("navbar-top");
              if (navbar) {
                navbar.classList.add("navbar-floating");
                navbar.classList.remove("navbar-full-width");
              }
            } else {
              header.classList.remove("navbar-scrolled");
              header.classList.add("navbar-top");
              if (navbar) {
                navbar.classList.remove("navbar-floating");
                navbar.classList.add("navbar-full-width");
              }
            }

            // Re-enable transitions after DOM settles, allowing smooth morphing
            if (currentScrollState !== wasScrolled) {
              requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                  header.style.transition = "";
                  if (navbar) {
                    navbar.style.transition = "";
                    navbar.style.animation = "";
                  }
                });
              });
            }

            // Ensure scroll listener is still attached
            if (!this.handleScroll) {
              this.initScrollHandler();
            }
          },
          destroyed() {
            this.cleanup();
          },
          initScrollHandler() {
            const header = this.el;
            const navbar = header.querySelector("#main-navbar");

            // Store references
            this.header = header;
            this.navbar = navbar;

            // Use requestAnimationFrame to debounce and prevent flickering
            let ticking = false;
            let lastScrollState = null;

            const checkScroll = () => {
              if (!ticking) {
                window.requestAnimationFrame(() => {
                  const scrolled = window.scrollY > 50;

                  // Only update if state actually changed to prevent unnecessary DOM manipulation
                  if (lastScrollState !== scrolled) {
                    // Ensure transitions are enabled for smooth morphing during scroll
                    if (header.style.transition === "none") {
                      header.style.transition = "";
                    }
                    if (navbar && navbar.style.transition === "none") {
                      navbar.style.transition = "";
                      navbar.style.animation = "";
                    }

                    if (scrolled) {
                      header.classList.add("navbar-scrolled");
                      header.classList.remove("navbar-top");
                      if (navbar) {
                        navbar.classList.add("navbar-floating");
                        navbar.classList.remove("navbar-full-width");
                      }
                    } else {
                      header.classList.remove("navbar-scrolled");
                      header.classList.add("navbar-top");
                      if (navbar) {
                        navbar.classList.remove("navbar-floating");
                        navbar.classList.add("navbar-full-width");
                      }
                    }
                    lastScrollState = scrolled;
                  }

                  ticking = false;
                });
                ticking = true;
              }
            };

            // Store the last scroll state
            this.lastScrollState = () => lastScrollState;

            // Initial check
            checkScroll();

            // Add scroll listener only if not already added
            if (!this.handleScroll) {
              window.addEventListener("scroll", checkScroll, { passive: true });
              this.handleScroll = checkScroll;
            }
          },
          cleanup() {
            if (this.handleScroll) {
              window.removeEventListener("scroll", this.handleScroll);
              this.handleScroll = null;
            }
          }
        }
      </script>
      <style>
        /* Base transitions for seamless morphing */
        #navbar-header {
          transition: top 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      padding-left 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      padding-right 0.4s cubic-bezier(0.4, 0, 0.2, 1);
          will-change: top, padding;
        }

        #navbar-header #main-navbar {
          transition: border-radius 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      max-width 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      margin-left 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      margin-right 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      box-shadow 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      border-width 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      transform 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      opacity 0.4s cubic-bezier(0.4, 0, 0.2, 1);
          will-change: border-radius, max-width, margin, box-shadow, transform;
        }

        /* Navbar at top - full width */
        #navbar-header.navbar-top {
          top: 0;
          padding-left: 0;
          padding-right: 0;
        }

        #navbar-header.navbar-top #main-navbar {
          border-radius: 0 !important;
          max-width: 100% !important;
          margin-left: 0 !important;
          margin-right: 0 !important;
          box-shadow: none !important;
          border-bottom-width: 1px;
          border-left-width: 0;
          border-right-width: 0;
          border-top-width: 0;
          transform: scale(1);
          opacity: 1;
        }

        /* Navbar when scrolled - floating with rounded borders */
        #navbar-header.navbar-scrolled {
          top: 1rem;
          padding-left: 1rem;
          padding-right: 1rem;
        }

        @media (min-width: 640px) {
          #navbar-header.navbar-scrolled {
            padding-left: 1.5rem;
            padding-right: 1.5rem;
          }
        }

        @media (min-width: 1024px) {
          #navbar-header.navbar-scrolled {
            padding-left: 2rem;
            padding-right: 2rem;
          }
        }

        #navbar-header.navbar-scrolled #main-navbar {
          border-radius: 1rem !important;
          max-width: 72rem !important;
          margin-left: auto !important;
          margin-right: auto !important;
          box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important;
          border-width: 1px !important;
          transform: scale(1);
          opacity: 1;
        }

        /* Smooth morphing effect on state transition */
        @keyframes navbar-morph-in {
          0% {
            transform: scale(0.98) translateY(-2px);
            opacity: 0.96;
          }
          100% {
            transform: scale(1) translateY(0);
            opacity: 1;
          }
        }

        @keyframes navbar-morph-out {
          0% {
            transform: scale(1) translateY(0);
            opacity: 1;
          }
          100% {
            transform: scale(0.98) translateY(-2px);
            opacity: 0.96;
          }
        }

        /* Apply morph animation when transitioning to scrolled state */
        #navbar-header.navbar-scrolled #main-navbar {
          animation: navbar-morph-in 0.4s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }

        /* Apply morph animation when transitioning to top state */
        #navbar-header.navbar-top #main-navbar {
          animation: navbar-morph-out 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }

        /* Enhanced backdrop blur transition for smoother morphing */
        #navbar-header #main-navbar {
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          transition: backdrop-filter 0.4s cubic-bezier(0.4, 0, 0.2, 1),
                      -webkit-backdrop-filter 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Three-section navbar layout on desktop */
        @media (min-width: 768px) {
          #main-navbar .nav-wrapper {
            display: grid !important;
            grid-template-columns: 1fr 1fr 1fr;
            align-items: center;
            gap: 1rem;
          }

          /* Left section - logo (start_content) */
          #main-navbar .nav-wrapper > div:first-child {
            grid-column: 1;
            justify-self: start;
          }

          /* Center section - navigation links (list wrapper with w-auto class) */
          #main-navbar .nav-wrapper > div.w-auto {
            grid-column: 2;
            justify-self: center;
          }

          /* Right section - end content */
          #main-navbar .nav-wrapper > div:last-child {
            grid-column: 3;
            justify-self: end;
          }
        }
      </style>
    </header>

    <!-- Main Content -->
    <main class="flex-1">
      <%= if assigns[:inner_block] && @inner_block != [] do %>
        {render_slot(@inner_block)}
      <% else %>
        {@inner_content}
      <% end %>
    </main>

    <!-- Footer -->
    <footer class="bg-base-bg-dark dark:bg-gray-950 text-gray-300 border-t border-base-border-dark">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 md:gap-12">
          <!-- Brand Column -->
          <div class="col-span-2 md:col-span-1">
            <div class="flex items-center gap-3 mb-4">
              <div class="w-10 h-10 bg-gradient-to-br from-[#FF385C] to-[#FF5A5F] rounded-xl flex items-center justify-center">
                <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 3L4 9v12h16V9l-8-6zm0 2.5L18 10v9H6v-9l6-4.5z" />
                  <rect x="10" y="14" width="4" height="5" rx="0.5" />
                </svg>
              </div>
              <span class="font-display text-xl font-bold text-white">MySqrft</span>
            </div>
            <p class="text-sm text-stone-400 leading-relaxed">
              India&#39;s trusted rental and real estate marketplace. Connecting seekers with their perfect spaces since 2026.
            </p>
          </div>

          <div>
            <h4 class="font-semibold text-white mb-4">Platform</h4>
            <ul class="space-y-3 text-sm">
              <li>
                <.link
                  navigate="/"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Home
                </.link>
              </li>
              <li>
                <.link
                  navigate="/about"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  About Us
                </.link>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  How it Works
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Pricing
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="font-semibold text-white mb-4">Resources</h4>
            <ul class="space-y-3 text-sm">
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Help Center
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Blog
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Guides
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  API
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="font-semibold text-white mb-4">Legal</h4>
            <ul class="space-y-3 text-sm">
              <li>
                <.link
                  navigate="/privacy"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Privacy Policy
                </.link>
              </li>
              <li>
                <.link
                  navigate="/terms"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Terms of Service
                </.link>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Cookie Policy
                </a>
              </li>
              <li>
                <a
                  href="#"
                  class="hover:text-primary-light dark:hover:text-primary-dark transition-colors"
                >
                  Refund Policy
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div class="mt-12 pt-8 border-t border-base-border-dark flex flex-col md:flex-row items-center justify-between gap-4">
          <p class="text-sm text-gray-500">
            2026 MySqrft. All rights reserved.
          </p>
          <div class="flex items-center gap-6">
            <a
              href="#"
              class="text-gray-400 hover:text-primary-light dark:hover:text-primary-dark transition-colors"
              aria-label="Twitter"
            >
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
              </svg>
            </a>
            <a
              href="#"
              class="text-gray-400 hover:text-primary-light dark:hover:text-primary-dark transition-colors"
              aria-label="LinkedIn"
            >
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
              </svg>
            </a>
            <a
              href="#"
              class="text-gray-400 hover:text-primary-light dark:hover:text-primary-dark transition-colors"
              aria-label="Instagram"
            >
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
              </svg>
            </a>
          </div>
        </div>
      </div>
    </footer>

    <div id="flash-group" class="fixed top-4 right-4 z-50 space-y-3" aria-live="polite">
      <.flash kind={:success} flash={@flash} variant="bordered" width="medium" rounded="large" />
      <.flash kind={:error} flash={@flash} variant="bordered" width="medium" rounded="large" />
      <.flash kind={:info} flash={@flash} variant="bordered" width="medium" rounded="large" />
    </div>
    """
  end

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="sticky top-0 z-50 bg-white/95 dark:bg-gray-900/95 backdrop-blur-md border-b border-gray-100 dark:border-gray-800 px-4 sm:px-6 lg:px-8">
      <div class="max-w-7xl mx-auto flex items-center justify-between h-16">
        <div class="flex items-center gap-3">
          <.link navigate="/" class="flex items-center gap-3 group">
            <div class="w-10 h-10 bg-gradient-to-br from-primary-light to-primary-dark rounded-xl flex items-center justify-center shadow-lg shadow-primary-light/20 group-hover:shadow-primary-light/40 transition-shadow duration-300">
              <.icon name="hero-home" class="w-6 h-6 text-white" />
            </div>
            <span class="font-display text-xl font-bold text-primary-light dark:text-primary-dark">
              MySqrft
            </span>
          </.link>
        </div>
        <nav class="flex items-center gap-6">
          <.link
            navigate="/"
            class="text-base-text-light dark:text-base-text-dark hover:text-primary-light dark:hover:text-primary-dark font-medium transition-colors"
          >
            Home
          </.link>
          <.link
            navigate="/about"
            class="text-base-text-light dark:text-base-text-dark hover:text-primary-light dark:hover:text-primary-dark font-medium transition-colors"
          >
            About
          </.link>
          <.theme_toggle />
          <%= if @current_scope do %>
            <.link
              href={~p"/users/settings"}
              class="text-base-text-light dark:text-base-text-dark hover:text-primary-light dark:hover:text-primary-dark font-medium transition-colors"
            >
              Settings
            </.link>
          <% else %>
            <.button_link
              href={~p"/users/log-in"}
              variant="outline"
              color="primary"
              size="small"
              rounded="large"
            >
              Log in
            </.button_link>
          <% end %>
        </nav>
      </div>
    </header>

    <main class="px-4 py-12 sm:px-6 lg:px-8 min-h-[calc(100vh-200px)] bg-gradient-to-b from-gray-50 to-white dark:from-gray-950 dark:to-gray-900">
      <div class="mx-auto max-w-4xl">
        {render_slot(@inner_block)}
      </div>
    </main>

    <!-- Simple Footer -->
    <footer class="bg-gray-900 dark:bg-gray-950 text-gray-400 py-8 px-4 sm:px-6 lg:px-8">
      <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 bg-gradient-to-br from-primary-light to-primary-dark rounded-lg flex items-center justify-center">
            <.icon name="hero-home" class="w-4 h-4 text-white" />
          </div>
          <span class="font-display text-lg font-bold text-white">MySqrft</span>
        </div>
        <p class="text-sm">2026 MySqrft. All rights reserved.</p>
      </div>
    </footer>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end
