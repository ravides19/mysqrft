defmodule MySqrftWeb.Marketing.AboutLive do
  @moduledoc """
  About page for MySqrft - company story, mission, and team.
  """
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Card

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "About Us")
     |> assign(:values, [
       %{
         title: "Trust First",
         description: "We verify every listing and user because trust is the foundation of every successful rental.",
         icon: "hero-shield-check"
       },
       %{
         title: "User Obsessed",
         description: "Every feature we build starts with understanding and solving real user problems.",
         icon: "hero-heart"
       },
       %{
         title: "Transparent Always",
         description: "No hidden fees, no surprises. What you see is what you get.",
         icon: "hero-eye"
       },
       %{
         title: "Innovation Driven",
         description: "We use cutting-edge technology to make finding homes simpler and faster.",
         icon: "hero-light-bulb"
       }
     ])
     |> assign(:milestones, [
       %{year: "2024", title: "The Beginning", description: "Founded with a mission to transform India's rental experience."},
       %{year: "2025", title: "Rapid Growth", description: "Expanded to 50+ cities with 25,000+ verified listings."},
       %{year: "2026", title: "Market Leader", description: "Serving 2M+ users across 100+ Indian cities."}
     ])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative overflow-hidden">
      <!-- Hero Section -->
      <section class="relative py-20 md:py-32 grain-overlay">
        <div class="absolute inset-0 geo-pattern opacity-30"></div>
        <div class="absolute top-0 right-0 w-1/2 h-full bg-gradient-to-l from-red-100/50 to-transparent dark:from-red-900/10"></div>

        <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="max-w-3xl">
            <span class="inline-flex items-center gap-2 px-4 py-2 bg-red-100 dark:bg-red-900/30 text-[#FF385C] dark:text-red-300 rounded-full text-sm font-medium mb-6">
              Our Story
            </span>

            <h1 class="font-display text-5xl md:text-6xl font-bold text-gray-900 dark:text-white leading-tight mb-6">
              Making Home Finding
              <span class="text-gradient">Personal Again</span>
            </h1>

            <p class="text-xl text-gray-600 dark:text-gray-300 leading-relaxed">
              We believe everyone deserves a place they can call home. MySqrft was born from the frustration of endless broker calls, fake listings, and opaque pricing. We're here to change that.
            </p>
          </div>
        </div>
      </section>

      <!-- Mission Section -->
      <section class="py-20 md:py-32 bg-white dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid lg:grid-cols-2 gap-16 items-center">
            <div>
              <h2 class="font-display text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
                Our Mission
              </h2>
              <p class="text-lg text-gray-600 dark:text-gray-300 leading-relaxed mb-6">
                To create India's most trusted and transparent rental marketplace where finding a home is as simple as booking a cab.
              </p>
              <p class="text-lg text-gray-600 dark:text-gray-300 leading-relaxed">
                We envision a world where every Indian can find their perfect living space without the hassle of middlemen, fake listings, or hidden costs. Through technology and trust, we're making this vision a reality.
              </p>
            </div>

            <div class="relative">
              <div class="aspect-square bg-gradient-to-br from-red-100 to-red-100 dark:from-gray-800 dark:to-gray-700 rounded-3xl overflow-hidden">
                <div class="absolute inset-0 flex items-center justify-center">
                  <div class="text-center">
                    <div class="w-32 h-32 mx-auto mb-6 bg-gradient-to-br from-[#FF385C] to-[#FF5A5F] rounded-3xl flex items-center justify-center shadow-xl shadow-red-500/30">
                      <svg class="w-16 h-16 text-white" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 3L4 9v12h16V9l-8-6zm0 2.5L18 10v9H6v-9l6-4.5z"/>
                        <rect x="10" y="14" width="4" height="5" rx="0.5"/>
                      </svg>
                    </div>
                    <div class="font-display text-2xl font-bold text-gray-900 dark:text-white">MySqrft</div>
                    <div class="text-gray-500 dark:text-gray-400">Est. 2024</div>
                  </div>
                </div>
              </div>

              <!-- Decorative elements -->
              <div class="absolute -top-4 -right-4 w-24 h-24 bg-red-200 dark:bg-red-800/30 rounded-2xl -z-10"></div>
              <div class="absolute -bottom-4 -left-4 w-32 h-32 bg-red-200 dark:bg-red-800/30 rounded-3xl -z-10"></div>
            </div>
          </div>
        </div>
      </section>

      <!-- Values Section -->
      <section class="py-20 md:py-32">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-3xl mx-auto mb-16">
            <h2 class="font-display text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
              Our Values
            </h2>
            <p class="text-lg text-gray-600 dark:text-gray-300">
              The principles that guide everything we do at MySqrft.
            </p>
          </div>

          <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            <.card
              :for={value <- @values}
              variant="bordered"
              color="natural"
              rounded="extra_large"
              padding="extra_large"
              class="text-center group hover:border-red-300 dark:hover:border-red-600 transition-all duration-300 !bg-white dark:!bg-gray-800/50"
            >
              <div class="w-16 h-16 mx-auto mb-6 bg-gradient-to-br from-red-100 to-red-100 dark:from-red-900/30 dark:to-red-900/30 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                <.icon name={value.icon} class="w-8 h-8 text-[#FF385C] dark:text-[#FF385C]" />
              </div>
              <h3 class="font-display text-xl font-bold text-gray-900 dark:text-white mb-3">{value.title}</h3>
              <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">{value.description}</p>
            </.card>
          </div>
        </div>
      </section>

      <!-- Timeline Section -->
      <section class="py-20 md:py-32 bg-gray-50 dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-3xl mx-auto mb-16">
            <h2 class="font-display text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
              Our Journey
            </h2>
            <p class="text-lg text-gray-600 dark:text-gray-300">
              From a small idea to India's trusted rental marketplace.
            </p>
          </div>

          <div class="relative">
            <!-- Timeline line -->
            <div class="hidden md:block absolute left-1/2 transform -translate-x-1/2 h-full w-0.5 bg-red-200 dark:bg-red-800"></div>

            <div class="space-y-12">
              <div
                :for={{milestone, index} <- Enum.with_index(@milestones)}
                class={[
                  "relative grid md:grid-cols-2 gap-8 items-center",
                  rem(index, 2) == 1 && "md:[direction:rtl]"
                ]}
              >
                <!-- Timeline dot -->
                <div class="hidden md:block absolute left-1/2 transform -translate-x-1/2 w-4 h-4 bg-[#FF385C] rounded-full border-4 border-red-50 dark:border-gray-900"></div>

                <div class={["md:[direction:ltr]", rem(index, 2) == 0 && "md:text-right"]}>
                  <span class="inline-block px-4 py-1 bg-red-100 dark:bg-red-900/30 text-[#FF385C] dark:text-red-400 rounded-full text-sm font-semibold mb-3">
                    {milestone.year}
                  </span>
                  <h3 class="font-display text-2xl font-bold text-gray-900 dark:text-white mb-2">{milestone.title}</h3>
                  <p class="text-gray-600 dark:text-gray-400">{milestone.description}</p>
                </div>

                <div class="md:[direction:ltr]"></div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Team Section -->
      <section class="py-20 md:py-32">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-3xl mx-auto mb-16">
            <h2 class="font-display text-4xl md:text-5xl font-bold text-stone-800 dark:text-white mb-6">
              Built by People Who Care
            </h2>
            <p class="text-lg text-stone-600 dark:text-stone-300">
              Our team is united by a shared passion: making home finding better for everyone.
            </p>
          </div>

          <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
            <div :for={member <- [
              %{name: "Amit Patel", role: "Founder & CEO", initials: "AP", color: "from-[#FF385C] to-[#FF5A5F]"},
              %{name: "Sneha Reddy", role: "Head of Product", initials: "SR", color: "from-blue-400 to-indigo-500"},
              %{name: "Vikram Singh", role: "Head of Engineering", initials: "VS", color: "from-green-400 to-emerald-500"},
              %{name: "Meera Kapoor", role: "Head of Operations", initials: "MK", color: "from-purple-400 to-pink-500"}
            ]} class="text-center group">
              <div class={"w-24 h-24 mx-auto mb-4 bg-gradient-to-br #{member.color} rounded-2xl flex items-center justify-center shadow-lg group-hover:scale-105 transition-transform duration-300"}>
                <span class="text-2xl font-bold text-white">{member.initials}</span>
              </div>
              <h3 class="font-display text-lg font-bold text-gray-900 dark:text-white">{member.name}</h3>
              <p class="text-sm text-gray-500 dark:text-gray-400">{member.role}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- CTA Section -->
      <section class="py-20 md:py-32 bg-gradient-to-br from-[#FF385C] to-[#FF5A5F] relative overflow-hidden">
        <div class="absolute inset-0 geo-pattern opacity-20"></div>

        <div class="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 class="font-display text-4xl md:text-5xl font-bold text-white mb-6">
            Join Us in Building the Future of Rentals
          </h2>
          <p class="text-xl text-red-100 mb-10 max-w-2xl mx-auto">
            Whether you're looking for a home or want to join our team, we'd love to hear from you.
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a href="/users/register" class="inline-flex items-center justify-center px-8 py-4 text-lg font-semibold text-[#FF385C] bg-white rounded-xl hover:bg-red-50 shadow-xl shadow-red-900/20 transition-all">
              Start Your Search
            </a>
            <a href="#" class="inline-flex items-center justify-center px-8 py-4 text-lg font-semibold text-white border-2 border-white/50 rounded-xl hover:bg-white/10 transition-all">
              View Careers
            </a>
          </div>
        </div>
      </section>
    </div>
    """
  end
end
