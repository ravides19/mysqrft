defmodule MySqrftWeb.Marketing.LandingLive do
  @moduledoc """
  Landing page for MySqrft - the main marketing homepage.
  Inspired by Airbnb and 99acres design.
  """
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Button
  import MySqrftWeb.Components.Card
  import MySqrftWeb.Components.Carousel
  import MySqrftWeb.Components.Badge
  import MySqrftWeb.Components.Icon
  import MySqrftWeb.Components.SearchField
  import MySqrftWeb.Components.Typography
  import MySqrftWeb.Components.Rating
  import MySqrftWeb.Components.Avatar
  import MySqrftWeb.Components.CheckboxField

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Home")
     |> assign(:search_query, "")
     |> assign(:selected_tab, "buy")
     |> assign(:selected_property_types, MapSet.new())
     |> assign(:show_property_type_menu, false)
     |> assign(:budget, "any")
     |> assign(:bedroom, "any")
     |> assign(:construction_status, "any")
     |> assign(:posted_by, "any")
     |> assign(:stats, [
       %{value: "50K+", label: "Active Listings", icon: "hero-home"},
       %{value: "2M+", label: "Happy Users", icon: "hero-users"},
       %{value: "100+", label: "Cities Covered", icon: "hero-map-pin"},
       %{value: "4.8", label: "User Rating", icon: "hero-star"}
     ])
     |> assign(:hero_slides, [
       %{
         image:
           "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1920&h=1080&fit=crop&crop=center",
         title: "Lakescape by Candeur",
         rera: "Rera No. - P02400005724",
         rera_url: "http://rerait.telangana.gov.in",
         headline: "EXPAND YOUR VIEW FOR ULTIMATE LUXURY",
         details: "3 & 3.5 BHK | ₹1.7 Cr* Onwards | Kondapur, Hyderabad",
         area: "1,909 - 2416 sq.ft. (177.35 - 224.45 sq.m.)"
       },
       %{
         image:
           "https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1920&h=1080&fit=crop&crop=center",
         title: "Skyline Residency",
         rera: "Rera No. - P01234567890",
         rera_url: "http://rerait.telangana.gov.in",
         headline: "MODERN LIVING IN THE HEART OF THE CITY",
         details: "2 & 3 BHK | ₹1.2 Cr* Onwards | Hitech City, Hyderabad",
         area: "1,200 - 1,800 sq.ft. (111.48 - 167.22 sq.m.)"
       },
       %{
         image:
           "https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1920&h=1080&fit=crop&crop=center",
         title: "Garden Estates",
         rera: "Rera No. - P09876543210",
         rera_url: "http://rerait.telangana.gov.in",
         headline: "LUXURY SURROUNDED BY NATURE",
         details: "4 & 5 BHK | ₹2.5 Cr* Onwards | Jubilee Hills, Hyderabad",
         area: "2,500 - 3,200 sq.ft. (232.26 - 297.29 sq.m.)"
       },
       %{
         image:
           "https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=1920&h=1080&fit=crop&crop=center",
         title: "Ocean View Towers",
         rera: "Rera No. - P04567890123",
         rera_url: "http://rerait.telangana.gov.in",
         headline: "PREMIUM LIFESTYLE WITH PANORAMIC VIEWS",
         details: "3 & 4 BHK | ₹2.0 Cr* Onwards | Gachibowli, Hyderabad",
         area: "2,000 - 2,800 sq.ft. (185.81 - 259.93 sq.m.)"
       },
       %{
         image:
           "https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1920&h=1080&fit=crop&crop=center",
         title: "Green Valley Residency",
         rera: "Rera No. - P05678901234",
         rera_url: "http://rerait.telangana.gov.in",
         headline: "SERENE LIVING IN URBAN PARADISE",
         details: "2 & 3 BHK | ₹1.5 Cr* Onwards | Banjara Hills, Hyderabad",
         area: "1,500 - 2,200 sq.ft. (139.35 - 204.39 sq.m.)"
       }
     ])
     |> assign(:recommended_properties, [
       %{
         id: 1,
         image: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=400",
         verified: true,
         price: "₹ 58 L",
         title: "2 BHK Independent House for Rent",
         location: "Dammaiguda, Secunderabad",
         posted_by: "Owner",
         posted_at: "2 months ago",
         rating: 4.8,
         sqft: "1,200 sq.ft"
       },
       %{
         id: 2,
         image: "https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=400",
         verified: true,
         price: "₹ 60 L",
         title: "2 BHK Apartment for Sale",
         location: "Koramangala, Bangalore",
         posted_by: "Dealer",
         posted_at: "1 month ago",
         rating: 4.9,
         sqft: "1,350 sq.ft"
       },
       %{
         id: 3,
         image: "https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=400",
         verified: false,
         price: "₹ 65 L",
         title: "3 BHK Villa for Sale",
         location: "Whitefield, Bangalore",
         posted_by: "Owner",
         posted_at: "3 weeks ago",
         rating: 4.7,
         sqft: "1,800 sq.ft"
       },
       %{
         id: 4,
         image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400",
         verified: true,
         price: "₹ 45 L",
         title: "2 BHK Flat for Rent",
         location: "Rampally, Secunderabad",
         posted_by: "Owner",
         posted_at: "1 week ago",
         rating: 4.9,
         sqft: "1,100 sq.ft"
       }
     ])
     |> assign(:recommended_projects, [
       %{
         id: 1,
         image: "https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=400",
         title: "Ocean View Towers",
         location: "Mumbai",
         price: "₹ 2.5 Cr* Onwards",
         rera: "P12345678901"
       },
       %{
         id: 2,
         image: "https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=400",
         title: "Green Valley Residency",
         location: "Pune",
         price: "₹ 1.8 Cr* Onwards",
         rera: "P23456789012"
       },
       %{
         id: 3,
         image: "https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=400",
         title: "Sunrise Apartments",
         location: "Hyderabad",
         price: "₹ 1.5 Cr* Onwards",
         rera: "P34567890123"
       }
     ])
     |> assign(:features, [
       %{
         title: "Verified Listings",
         description:
           "Every property undergoes rigorous verification. Photos, ownership documents, and amenities - all verified by our team.",
         icon: "hero-shield-check"
       },
       %{
         title: "Direct Owner Connect",
         description:
           "No middlemen, no hidden fees. Connect directly with property owners and negotiate on your terms.",
         icon: "hero-phone"
       },
       %{
         title: "Smart Matching",
         description:
           "Our AI-powered matching algorithm finds properties that fit your lifestyle, budget, and preferences perfectly.",
         icon: "hero-sparkles"
       },
       %{
         title: "Legal Assistance",
         description:
           "From rental agreements to police verification, we handle all the paperwork so you can focus on moving in.",
         icon: "hero-document-check"
       }
     ])
     |> assign(:explore_options, [
       %{
         image: "https://images.unsplash.com/photo-1582407947304-fd86f028f716?w=400",
         title: "Buying a home",
         navigate: "/search?type=buy"
       },
       %{
         image: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400",
         title: "Renting a home",
         navigate: "/search?type=rent"
       },
       %{
         image: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400",
         title: "Invest in Real Estate",
         navigate: "/invest",
         badge: "NEW"
       },
       %{
         image: "https://images.unsplash.com/photo-1556761175-b413da4baf72?w=400",
         title: "Sell/Rent your property",
         navigate: "/users/register"
       },
       %{
         image: "https://images.unsplash.com/photo-1589476993333-f55b84301219?w=400",
         title: "Plots/Land",
         navigate: "/search?type=plot"
       },
       %{
         image: "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400",
         title: "Explore Insights",
         navigate: "/insights",
         badge: "NEW"
       },
       %{
         image: "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400",
         title: "PG / Co-living",
         navigate: "/search?type=pg"
       }
     ])}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, assign(socket, :search_query, query)}
  end

  @impl true
  def handle_event("toggle_property_type", %{"value" => value}, socket) do
    IO.inspect(value, label: "value")

    IO.inspect(socket.assigns.selected_property_types,
      label: "socket.assigns.selected_property_types"
    )

    selected =
      if MapSet.member?(socket.assigns.selected_property_types, value) do
        MapSet.delete(socket.assigns.selected_property_types, value)
      else
        MapSet.put(socket.assigns.selected_property_types, value)
      end

    {:noreply,
     socket
     |> assign(:selected_property_types, selected)
     |> IO.inspect(label: "selected_property_types")
     |> IO.inspect(label: "socket")}
  end

  @impl true
  def handle_event("toggle_property_type_menu", _params, socket) do
    {:noreply, assign(socket, :show_property_type_menu, !socket.assigns.show_property_type_menu)}
  end

  @impl true
  def handle_event("close_property_type_menu", _params, socket) do
    {:noreply, assign(socket, :show_property_type_menu, false)}
  end

  @impl true
  def handle_event("clear_all_filters", _params, socket) do
    IO.inspect(socket.assigns.selected_property_types,
      label: "socket.assigns.selected_property_types"
    )

    {:noreply,
     socket
     |> assign(:selected_property_types, MapSet.new())
     |> assign(:budget, "any")
     |> assign(:bedroom, "any")
     |> assign(:construction_status, "any")
     |> assign(:posted_by, "any")}
  end

  @impl true
  def handle_event("filter_changed", %{"budget" => budget}, socket) do
    {:noreply, assign(socket, :budget, budget)}
  end

  @impl true
  def handle_event("filter_changed", %{"bedroom" => bedroom}, socket) do
    {:noreply, assign(socket, :bedroom, bedroom)}
  end

  @impl true
  def handle_event("filter_changed", %{"construction_status" => construction_status}, socket) do
    {:noreply, assign(socket, :construction_status, construction_status)}
  end

  @impl true
  def handle_event("filter_changed", %{"posted_by" => posted_by}, socket) do
    {:noreply, assign(socket, :posted_by, posted_by)}
  end

  @impl true
  def handle_event("select_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :selected_tab, tab)}
  end

  @impl true
  def handle_event("scroll-explore-right", _params, socket) do
    {:noreply, socket}
  end

  def count_applied_filters(assigns) do
    property_types_count =
      MapSet.size(assigns.selected_property_types)
      |> IO.inspect(label: "property_types_count")

    additional_filters_count =
      [
        assigns.budget != "any",
        assigns.bedroom != "any",
        assigns.construction_status != "any",
        assigns.posted_by != "any"
      ]
      |> Enum.count(& &1)

    property_types_count + additional_filters_count
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative overflow-hidden">
      <!-- Hero Carousel Section (inspired by 99acres) -->
      <section class="relative h-[29vh] md:h-[34.5vh] lg:h-[40vh]">
        <.carousel
          id="hero-carousel"
          indicator={true}
          control={true}
          autoplay={true}
          autoplay_interval={5000}
          size="extra_large"
          padding="extra_large"
          overlay="transparent"
          text_position="center"
          class="h-full"
        >
          <:slide
            :for={slide <- @hero_slides}
            image={slide.image}
            image_class="w-full h-full object-cover"
            title={slide.headline}
            description={slide.details}
            content_position="end"
            wrapper_class="flex flex-col justify-center items-end pr-8 md:pr-16"
            title_class="text-3xl md:text-5xl lg:text-6xl font-display font-bold text-white mb-4 drop-shadow-lg"
            description_class="text-lg md:text-xl text-white/90 mb-6 drop-shadow-md"
          >
            <div class="bg-white/95 dark:bg-stone-900/95 backdrop-blur-md rounded-2xl p-6 md:p-8 max-w-md shadow-2xl">
              <div class="flex items-center gap-2 mb-3">
                <div class="w-12 h-12 bg-gradient-to-br from-primary-light to-primary-dark rounded-lg flex items-center justify-center">
                  <.icon name="hero-home" class="w-6 h-6 text-white" />
                </div>
                <div>
                  <.h3 class="text-xl md:text-2xl" color="base">
                    {slide.title}
                  </.h3>
                  <.p class="text-xs" color="base">
                    {slide.rera}
                  </.p>
                </div>
              </div>
              <.p class="mb-4 text-sm md:text-base" color="base">
                {slide.area}
              </.p>
              <.button_link
                navigate="/users/register"
                variant="gradient"
                color="primary"
                size="large"
                class="w-full"
              >
                Explore Now <.icon name="hero-arrow-right" class="w-5 h-5 ml-2" />
              </.button_link>
            </div>
          </:slide>
        </.carousel>
      </section>
      
    <!-- Search Bar Section (inspired by Airbnb) -->
      <section
        class="relative -mt-16 md:-mt-20 z-20"
        id="search-bar-section"
        data-test-id="search-bar-section"
      >
        <div
          class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8"
          id="search-section-container"
          data-test-id="search-section-container"
        >
          <div
            class="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl border border-gray-200 dark:border-gray-700 p-2"
            id="search-bar-card"
            data-test-id="search-bar-card"
          >
            <!-- Navigation Tabs -->
            <div
              class="flex flex-wrap items-center gap-2 mb-4 px-2"
              id="navigation-tabs-container"
              data-test-id="navigation-tabs-container"
            >
              <.button
                variant="transparent"
                color={if @selected_tab == "buy", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="buy"
                class={
                  if(@selected_tab == "buy",
                    do:
                      "cursor-pointer transition-colors !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold",
                    else:
                      "cursor-pointer transition-colors hover:!text-primary-light dark:hover:!text-primary-dark"
                  )
                }
              >
                Buy
              </.button>
              <.button
                variant="transparent"
                color={if @selected_tab == "rent", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="rent"
                class={
                  if(@selected_tab == "rent",
                    do:
                      "cursor-pointer transition-colors !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold",
                    else:
                      "cursor-pointer transition-colors hover:!text-primary-light dark:hover:!text-primary-dark"
                  )
                }
              >
                Rent
              </.button>
              <.button
                variant="transparent"
                color={if @selected_tab == "new_launch", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="new_launch"
                class={
                  if(@selected_tab == "new_launch",
                    do:
                      "cursor-pointer transition-colors relative !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold pr-6",
                    else:
                      "cursor-pointer transition-colors relative hover:!text-primary-light dark:hover:!text-primary-dark pr-6"
                  )
                }
              >
                New Launch
                <.icon
                  name="hero-sparkles"
                  class="w-4 h-4 text-secondary-light dark:text-secondary-dark"
                />
              </.button>
              <.button
                variant="transparent"
                color={if @selected_tab == "pg_coliving", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="pg_coliving"
                class={
                  if(@selected_tab == "pg_coliving",
                    do:
                      "cursor-pointer transition-colors !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold",
                    else:
                      "cursor-pointer transition-colors hover:!text-primary-light dark:hover:!text-primary-dark"
                  )
                }
              >
                PG / Co-living
              </.button>
              <.button
                variant="transparent"
                color={if @selected_tab == "commercial", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="commercial"
                class={
                  if(@selected_tab == "commercial",
                    do:
                      "cursor-pointer transition-colors !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold",
                    else:
                      "cursor-pointer transition-colors hover:!text-primary-light dark:hover:!text-primary-dark"
                  )
                }
              >
                Commercial
              </.button>
              <.button
                variant="transparent"
                color={if @selected_tab == "plots_land", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="plots_land"
                class={
                  if(@selected_tab == "plots_land",
                    do:
                      "cursor-pointer transition-colors !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold",
                    else:
                      "cursor-pointer transition-colors hover:!text-primary-light dark:hover:!text-primary-dark"
                  )
                }
              >
                Plots/Land
              </.button>
              <.button
                variant="transparent"
                color={if @selected_tab == "projects", do: "primary", else: "base"}
                size="small"
                phx-click="select_tab"
                phx-value-tab="projects"
                class={
                  if(@selected_tab == "projects",
                    do:
                      "cursor-pointer transition-colors !border-b-2 !border-primary-light dark:!border-primary-dark !text-primary-light dark:!text-primary-dark font-semibold",
                    else:
                      "cursor-pointer transition-colors hover:!text-primary-light dark:hover:!text-primary-dark"
                  )
                }
              >
                Projects
              </.button>
              <.button_link
                navigate="/users/register"
                variant="default"
                color="success"
                size="medium"
                class="ml-auto"
              >
                Post Property FREE
              </.button_link>
            </div>
            
    <!-- Search Input -->
            <form
              phx-submit="search"
              class="flex flex-col md:flex-row gap-2"
              id="search-form"
              data-test-id="search-form"
            >
              <div
                class="relative w-auto md:w-48"
                id="property-type-selector-container"
                data-test-id="property-type-selector-container"
              >
                <div class="relative">
                  <div
                    class="flex items-center justify-between w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg cursor-pointer hover:border-primary-light dark:hover:border-primary-dark transition-colors"
                    id="property-type-trigger"
                    data-test-id="property-type-trigger"
                    phx-click="toggle_property_type_menu"
                  >
                    <span
                      class="text-base-text-light dark:text-base-text-dark font-medium"
                      data-test-id="property-type-trigger-text"
                    >
                      {if count_applied_filters(assigns) == 0,
                        do: "All Residential",
                        else:
                          "#{count_applied_filters(assigns)} Filter#{if count_applied_filters(assigns) == 1, do: "", else: "s"} Applied"}
                    </span>
                    <.icon
                      name="hero-chevron-down"
                      class={[
                        "w-5 h-5 text-base-text-light dark:text-base-text-dark transition-transform",
                        if(@show_property_type_menu, do: "rotate-180", else: "")
                      ]}
                      data-test-id="property-type-trigger-icon"
                    />
                  </div>

                  <div
                    :if={@show_property_type_menu}
                    phx-click-away="close_property_type_menu"
                    class="absolute top-full left-0 mt-2 w-[55vw] bg-white dark:bg-gray-900 shadow-2xl p-6 max-h-[600px] overflow-y-auto border border-gray-100 dark:border-gray-800 backdrop-blur-sm bg-opacity-98 dark:bg-opacity-98 rounded-lg z-50"
                    id="property-type-menu-content"
                    data-test-id="property-type-menu-content"
                  >
                    <div
                      id="property-type-menu-inner"
                      data-test-id="property-type-menu-inner"
                      class="w-full"
                    >
                      <div
                        class="flex items-center justify-between mb-5"
                        id="property-type-header"
                        data-test-id="property-type-header"
                      >
                        <h3
                          class="text-lg font-semibold text-gray-900 dark:text-white"
                          id="property-type-title"
                          data-test-id="property-type-title"
                        >
                          Property Type
                        </h3>
                        <button
                          type="button"
                          phx-click="clear_all_filters"
                          class="cursor-pointer text-primary-light dark:text-primary-dark hover:text-primary-hover-light dark:hover:text-primary-hover-dark font-medium text-sm transition-colors"
                          id="property-type-clear-button"
                          data-test-id="property-type-clear-button"
                        >
                          Clear All
                        </button>
                      </div>

                      <div
                        class="grid grid-cols-1 md:grid-cols-3 gap-x-6 gap-y-4 mb-6"
                        id="property-type-checkboxes-grid"
                        data-test-id="property-type-checkboxes-grid"
                      >
                        <div
                          class="space-y-4"
                          id="property-type-column-1"
                          data-test-id="property-type-column-1"
                        >
                          <.checkbox_field
                            name="property_type"
                            value="flat_apartment"
                            checked={MapSet.member?(@selected_property_types, "flat_apartment")}
                            label="Flat/Apartment"
                            id="property-type-flat-apartment-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="flat_apartment"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-flat-apartment-checkbox"
                          />
                          <.checkbox_field
                            name="property_type"
                            value="residential_land"
                            checked={MapSet.member?(@selected_property_types, "residential_land")}
                            label="Residential Land"
                            id="property-type-residential-land-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="residential_land"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-residential-land-checkbox"
                          />
                          <.checkbox_field
                            name="property_type"
                            value="serviced_apartments"
                            checked={MapSet.member?(@selected_property_types, "serviced_apartments")}
                            label="Serviced Apartments"
                            id="property-type-serviced-apartments-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="serviced_apartments"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-serviced-apartments-checkbox"
                          />
                        </div>

                        <div
                          class="space-y-4"
                          id="property-type-column-2"
                          data-test-id="property-type-column-2"
                        >
                          <.checkbox_field
                            name="property_type"
                            value="independent_builder_floor"
                            checked={
                              MapSet.member?(@selected_property_types, "independent_builder_floor")
                            }
                            label="Independent/Builder Floor"
                            id="property-type-independent-builder-floor-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="independent_builder_floor"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-independent-builder-floor-checkbox"
                          />
                          <.checkbox_field
                            name="property_type"
                            value="rk_studio"
                            checked={MapSet.member?(@selected_property_types, "rk_studio")}
                            label="1 RK/Studio Apartment"
                            id="property-type-rk-studio-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="rk_studio"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-rk-studio-checkbox"
                          />
                          <.checkbox_field
                            name="property_type"
                            value="other"
                            checked={MapSet.member?(@selected_property_types, "other")}
                            label="Other"
                            id="property-type-other-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="other"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-other-checkbox"
                          />
                        </div>

                        <div
                          class="space-y-4"
                          id="property-type-column-3"
                          data-test-id="property-type-column-3"
                        >
                          <.checkbox_field
                            name="property_type"
                            value="independent_house_villa"
                            checked={
                              MapSet.member?(@selected_property_types, "independent_house_villa")
                            }
                            label="Independent House/Villa"
                            id="property-type-independent-house-villa-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="independent_house_villa"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-independent-house-villa-checkbox"
                          />
                          <.checkbox_field
                            name="property_type"
                            value="farm_house"
                            checked={MapSet.member?(@selected_property_types, "farm_house")}
                            label="Farm House"
                            id="property-type-farm-house-checkbox"
                            color="primary"
                            size="small"
                            space="small"
                            phx-click="toggle_property_type"
                            phx-value-value="farm_house"
                            class="cursor-pointer group"
                            label_class="ml-3 text-sm text-gray-700 dark:text-gray-300 group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                            data-test-id="property-type-farm-house-checkbox"
                          />
                        </div>
                      </div>

                      <div
                        class="pt-5 border-t border-gray-200 dark:border-gray-700 mb-5"
                        id="property-type-commercial-link-section"
                        data-test-id="property-type-commercial-link-section"
                      >
                        <a
                          href="/search?type=commercial"
                          class="text-primary-light dark:text-primary-dark hover:text-primary-hover-light dark:hover:text-primary-hover-dark text-sm font-medium transition-colors inline-flex items-center"
                          id="property-type-commercial-link"
                          data-test-id="property-type-commercial-link"
                        >
                          Looking for commercial properties?
                          <span
                            class="underline ml-1"
                            data-test-id="property-type-commercial-link-text"
                          >
                            Click here
                          </span>
                        </a>
                      </div>

                      <div
                        class="grid grid-cols-2 md:grid-cols-4 gap-4 pt-5 border-t border-gray-200 dark:border-gray-700"
                        id="property-type-additional-filters"
                        data-test-id="property-type-additional-filters"
                      >
                        <div
                          class="flex flex-col"
                          id="filter-budget-container"
                          data-test-id="filter-budget-container"
                        >
                          <label
                            class="text-xs font-semibold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide"
                            id="filter-budget-label"
                            data-test-id="filter-budget-label"
                            for="filter-budget-select"
                          >
                            Budget
                          </label>
                          <select
                            id="filter-budget-select"
                            name="budget"
                            phx-change="filter_changed"
                            data-test-id="filter-budget-select"
                            class="px-3 py-2.5 text-sm border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-light focus:border-primary-light dark:focus:border-primary-dark transition-colors cursor-pointer"
                          >
                            <option value="any" selected={@budget == "any"}>Any</option>
                            <option value="0-50" selected={@budget == "0-50"}>0 - 50 L</option>
                            <option value="50-100" selected={@budget == "50-100"}>50 L - 1 Cr</option>
                            <option value="100-200" selected={@budget == "100-200"}>
                              1 Cr - 2 Cr
                            </option>
                            <option value="200+" selected={@budget == "200+"}>2 Cr+</option>
                          </select>
                        </div>
                        <div
                          class="flex flex-col"
                          id="filter-bedroom-container"
                          data-test-id="filter-bedroom-container"
                        >
                          <label
                            class="text-xs font-semibold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide"
                            id="filter-bedroom-label"
                            data-test-id="filter-bedroom-label"
                            for="filter-bedroom-select"
                          >
                            Bedroom
                          </label>
                          <select
                            id="filter-bedroom-select"
                            name="bedroom"
                            phx-change="filter_changed"
                            data-test-id="filter-bedroom-select"
                            class="px-3 py-2.5 text-sm border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-light focus:border-primary-light dark:focus:border-primary-dark transition-colors cursor-pointer"
                          >
                            <option value="any" selected={@bedroom == "any"}>Any</option>
                            <option value="1" selected={@bedroom == "1"}>1 BHK</option>
                            <option value="2" selected={@bedroom == "2"}>2 BHK</option>
                            <option value="3" selected={@bedroom == "3"}>3 BHK</option>
                            <option value="4+" selected={@bedroom == "4+"}>4+ BHK</option>
                          </select>
                        </div>
                        <div
                          class="flex flex-col"
                          id="filter-construction-status-container"
                          data-test-id="filter-construction-status-container"
                        >
                          <label
                            class="text-xs font-semibold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide"
                            id="filter-construction-status-label"
                            data-test-id="filter-construction-status-label"
                            for="filter-construction-status-select"
                          >
                            Construction Status
                          </label>
                          <select
                            id="filter-construction-status-select"
                            name="construction_status"
                            phx-change="filter_changed"
                            data-test-id="filter-construction-status-select"
                            class="px-3 py-2.5 text-sm border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-light focus:border-primary-light dark:focus:border-primary-dark transition-colors cursor-pointer"
                          >
                            <option value="any" selected={@construction_status == "any"}>Any</option>
                            <option value="ready" selected={@construction_status == "ready"}>
                              Ready to Move
                            </option>
                            <option
                              value="under-construction"
                              selected={@construction_status == "under-construction"}
                            >
                              Under Construction
                            </option>
                          </select>
                        </div>
                        <div
                          class="flex flex-col"
                          id="filter-posted-by-container"
                          data-test-id="filter-posted-by-container"
                        >
                          <label
                            class="text-xs font-semibold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide"
                            id="filter-posted-by-label"
                            data-test-id="filter-posted-by-label"
                            for="filter-posted-by-select"
                          >
                            Posted By
                          </label>
                          <select
                            id="filter-posted-by-select"
                            name="posted_by"
                            phx-change="filter_changed"
                            data-test-id="filter-posted-by-select"
                            class="px-3 py-2.5 text-sm border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-light focus:border-primary-light dark:focus:border-primary-dark transition-colors cursor-pointer"
                          >
                            <option value="any" selected={@posted_by == "any"}>Any</option>
                            <option value="owner" selected={@posted_by == "owner"}>Owner</option>
                            <option value="dealer" selected={@posted_by == "dealer"}>Dealer</option>
                          </select>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="flex-[2]" id="search-box-container" data-test-id="search-box-container">
                <.search_field
                  name="query"
                  value={@search_query}
                  placeholder="Search 'Farm house in Punjab below 1 cr'"
                  color="primary"
                  size="large"
                  search_button={true}
                  class="w-full"
                  id="search-query-field"
                  data-test-id="search-query-field"
                >
                  <:end_section>
                    <.icon
                      name="hero-map-pin"
                      class="w-5 h-5 cursor-pointer hover:text-primary-light"
                    />
                    <.icon
                      name="hero-microphone"
                      class="w-5 h-5 cursor-pointer hover:text-primary-light"
                    />
                  </:end_section>
                </.search_field>
              </div>
            </form>
            
    <!-- Recent Searches -->
            <div class="mt-3 px-2 flex items-center gap-3 text-sm">
              <.p class="text-sm" color="base">Recent searches:</.p>
              <button class="cursor-pointer flex items-center gap-1 hover:text-primary-light dark:hover:text-primary-dark">
                <.icon name="hero-clock" class="w-4 h-4" />
                <span>Buy in Neopolis + 3 localities, Hyderab...</span>
              </button>
              <button class="cursor-pointer flex items-center gap-1 hover:text-primary-light dark:hover:text-primary-dark">
                <.icon name="hero-clock" class="w-4 h-4" />
                <span>View all searches</span>
              </button>
            </div>
          </div>
        </div>
      </section>
      
    <!-- Get Started With Exploring Real Estate Options Section -->
      <section class="py-8 md:py-12 bg-white dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <.h2
            class="text-lg md:text-xl uppercase tracking-wide mb-6"
            color="base"
            font_weight="font-bold"
          >
            GET STARTED WITH EXPLORING REAL ESTATE OPTIONS
          </.h2>
          
    <!-- Horizontal Scrollable Cards -->
          <div class="relative">
            <div
              class="overflow-x-auto pb-4 -mx-4 px-4 scrollbar-hide scroll-smooth"
              id="explore-options-scroll"
            >
              <div class="flex gap-4 md:gap-6 min-w-max">
                <.card
                  :for={option <- @explore_options}
                  variant="bordered"
                  color="natural"
                  rounded="large"
                  class="min-w-[200px] md:min-w-[240px] !bg-white dark:!bg-gray-800 hover:shadow-xl transition-all duration-300 group cursor-pointer overflow-hidden"
                >
                  <.link navigate={option.navigate} class="block">
                    <div class="relative">
                      <img
                        src={option.image}
                        alt={option.title}
                        class="w-full h-40 md:h-48 object-cover rounded-t-lg group-hover:scale-105 transition-transform duration-300"
                      />
                      <.badge
                        :if={option[:badge]}
                        variant="default"
                        color="danger"
                        size="small"
                        class="absolute top-2 left-2"
                      >
                        {option.badge}
                      </.badge>
                    </div>
                    <div class="p-4">
                      <.h3
                        class="font-semibold text-center group-hover:text-primary-light dark:group-hover:text-primary-dark transition-colors"
                        color="base"
                      >
                        {option.title}
                      </.h3>
                    </div>
                  </.link>
                </.card>
              </div>
            </div>
            
    <!-- Scroll Arrow -->
            <button
              phx-hook=".ScrollExplore"
              id="scroll-explore-btn"
              data-target="explore-options-scroll"
              class="cursor-pointer absolute right-0 top-1/2 -translate-y-1/2 -translate-x-4 w-10 h-10 bg-white dark:bg-gray-800 rounded-full shadow-lg flex items-center justify-center hover:bg-primary-bordered-bg-light dark:hover:bg-primary-bordered-bg-dark transition-colors z-10"
              aria-label="Scroll right"
            >
              <.icon
                name="hero-chevron-right"
                class="w-6 h-6 text-base-text-light dark:text-base-text-dark"
              />
            </button>
            <script :type={Phoenix.LiveView.ColocatedHook} name=".ScrollExplore">
              export default {
                mounted() {
                  this.el.addEventListener("click", () => {
                    const targetId = this.el.dataset.target;
                    const scrollContainer = document.getElementById(targetId);
                    if (scrollContainer) {
                      scrollContainer.scrollBy({ left: 300, behavior: "smooth" });
                    }
                  });
                }
              }
            </script>
          </div>
        </div>
      </section>
      
    <!-- Recommended Properties Section (inspired by Airbnb & 99acres) -->
      <section class="py-12 md:py-16 bg-white dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between mb-6">
            <div>
              <.h2 class="mb-2" color="base" font_weight="font-bold">
                Recommended Properties
              </.h2>
              <.p color="base">Curated especially for you.</.p>
            </div>
            <button class="cursor-pointer text-primary-light dark:text-primary-dark font-semibold hover:text-primary-hover-light dark:hover:text-primary-hover-dark flex items-center gap-1">
              See all <.icon name="hero-arrow-right" class="w-5 h-5" />
            </button>
          </div>
          
    <!-- Property Cards (Horizontal Scroll) -->
          <div class="overflow-x-auto pb-4 -mx-4 px-4 scrollbar-hide">
            <div class="flex gap-6 min-w-max">
              <.card
                :for={property <- @recommended_properties}
                variant="bordered"
                color="natural"
                rounded="extra_large"
                class="min-w-[320px] md:min-w-[380px] !bg-white dark:!bg-gray-800 hover:shadow-xl transition-all duration-300 group"
              >
                <div class="relative">
                  <img
                    src={property.image}
                    alt={property.title}
                    class="w-full h-64 object-cover rounded-t-xl"
                  />
                  <.badge
                    :if={property.verified}
                    variant="default"
                    color="success"
                    size="small"
                    class="absolute top-3 left-3"
                  >
                    ✓ Verified
                  </.badge>
                  <button class="cursor-pointer absolute top-3 right-3 w-10 h-10 bg-white/90 dark:bg-gray-800/90 rounded-full flex items-center justify-center hover:bg-white dark:hover:bg-gray-700 transition-colors">
                    <.icon name="hero-heart" class="w-5 h-5 text-gray-600 dark:text-gray-400" />
                  </button>
                </div>
                <div class="p-5">
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex-1">
                      <.h3 class="mb-1 line-clamp-1" color="base" font_weight="font-bold">
                        {property.price}
                      </.h3>
                      <.p class="text-sm line-clamp-2" color="base">
                        {property.title}
                      </.p>
                    </div>
                  </div>
                  <div class="flex items-center gap-4 text-xs mb-3">
                    <span
                      class="flex items-center gap-1"
                      class="text-base-text-light dark:text-base-text-dark"
                    >
                      <.icon name="hero-map-pin" class="w-3 h-3" />
                      {property.location}
                    </span>
                    <span
                      class="flex items-center gap-1"
                      class="text-base-text-light dark:text-base-text-dark"
                    >
                      <.icon name="hero-square-3-stack-3d" class="w-3 h-3" />
                      {property.sqft}
                    </span>
                  </div>
                  <div class="flex items-center justify-between pt-3 border-t border-gray-100 dark:border-gray-700">
                    <div class="flex items-center gap-1">
                      <.rating
                        id={"property-rating-#{property.id}"}
                        color="primary"
                        size="small"
                        select={property.rating}
                        count={5}
                      />
                      <span class="text-sm font-semibold text-base-text-light dark:text-base-text-dark">
                        {property.rating}
                      </span>
                    </div>
                    <div class="text-xs text-base-text-light dark:text-base-text-dark">
                      {property.posted_by} · {property.posted_at}
                    </div>
                  </div>
                </div>
              </.card>
            </div>
          </div>
        </div>
      </section>
      
    <!-- Recommended Projects Section -->
      <section class="py-12 md:py-16 bg-gray-50 dark:bg-gray-950">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between mb-6">
            <.h2 color="base" font_weight="font-bold">
              Recommended Projects
            </.h2>
            <button class="cursor-pointer text-primary-light dark:text-primary-dark font-semibold hover:text-primary-hover-light dark:hover:text-primary-hover-dark flex items-center gap-1">
              See all <.icon name="hero-arrow-right" class="w-5 h-5" />
            </button>
          </div>

          <div class="grid md:grid-cols-3 gap-6">
            <.card
              :for={project <- @recommended_projects}
              variant="bordered"
              color="natural"
              rounded="extra_large"
              class="!bg-white dark:!bg-gray-800 hover:shadow-xl transition-all duration-300 group overflow-hidden"
            >
              <div class="relative">
                <img
                  src={project.image}
                  alt={project.title}
                  class="w-full h-64 object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <.badge
                  variant="default"
                  color="primary"
                  size="small"
                  class="absolute top-3 left-3"
                >
                  RERA
                </.badge>
                <button class="cursor-pointer absolute top-3 right-3 w-10 h-10 bg-white/90 dark:bg-gray-800/90 rounded-full flex items-center justify-center hover:bg-white dark:hover:bg-gray-700 transition-colors">
                  <.icon name="hero-heart" class="w-5 h-5 text-gray-600 dark:text-gray-400" />
                </button>
              </div>
              <div class="p-5">
                <.h3 class="mb-2" color="base" font_weight="font-bold">
                  {project.title}
                </.h3>
                <.p class="text-sm mb-3" color="base">
                  {project.location}
                </.p>
                <.p class="text-lg font-semibold text-primary-light dark:text-primary-dark mb-4">
                  {project.price}
                </.p>
                <.button_link
                  navigate="/users/register"
                  variant="outline"
                  color="primary"
                  size="medium"
                  class="w-full"
                >
                  View Details
                </.button_link>
              </div>
            </.card>
          </div>
        </div>
      </section>
      
    <!-- Stats Section -->
      <section class="py-16 md:py-24 bg-white dark:bg-gray-900 border-y border-red-100 dark:border-gray-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8 md:gap-12">
            <div :for={stat <- @stats} class="text-center">
              <div class="inline-flex items-center justify-center w-14 h-14 bg-primary-bordered-bg-light dark:bg-primary-bordered-bg-dark rounded-2xl mb-4">
                <.icon name={stat.icon} class="w-7 h-7 text-primary-light dark:text-primary-dark" />
              </div>
              <div class="text-3xl md:text-4xl font-display font-bold text-base-text-light dark:text-base-text-dark">
                {stat.value}
              </div>
              <div class="text-sm text-base-text-light dark:text-base-text-dark mt-1 opacity-70">
                {stat.label}
              </div>
            </div>
          </div>
        </div>
      </section>
      
    <!-- Features Section -->
      <section class="py-20 md:py-32">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-3xl mx-auto mb-16 md:mb-20">
            <.h2 class="mb-6" color="base" font_weight="font-bold">
              Why Choose <span class="text-primary-light dark:text-primary-dark">MySqrft</span>?
            </.h2>
            <.p class="text-lg" color="base">
              We've reimagined the rental experience to make finding your perfect home simple, transparent, and trustworthy.
            </.p>
          </div>

          <div class="grid md:grid-cols-2 gap-6 md:gap-8">
            <.card
              :for={feature <- @features}
              variant="bordered"
              color="natural"
              rounded="extra_large"
              padding="extra_large"
              class="group hover:border-red-300 dark:hover:border-red-600 hover:shadow-lg hover:shadow-red-500/5 transition-all duration-300 !bg-white dark:!bg-gray-800/50"
            >
              <div class="flex gap-5">
                <div class="shrink-0 w-14 h-14 bg-gradient-to-br from-primary-bordered-bg-light to-primary-bordered-bg-light dark:from-primary-bordered-bg-dark dark:to-primary-bordered-bg-dark rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                  <.icon
                    name={feature.icon}
                    class="w-7 h-7 text-primary-light dark:text-primary-dark"
                  />
                </div>
                <div>
                  <.h3 class="mb-2" color="base" font_weight="font-bold">{feature.title}</.h3>
                  <.p class="leading-relaxed" color="base">{feature.description}</.p>
                </div>
              </div>
            </.card>
          </div>
        </div>
      </section>
      
    <!-- CTA Section -->
      <section class="py-20 md:py-32 relative overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-br from-primary-light to-primary-dark"></div>
        <div class="absolute inset-0 geo-pattern opacity-20"></div>

        <div class="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <.h2 class="mb-6" color="white" font_weight="font-bold">
            Ready to Find Your Dream Home?
          </.h2>
          <.p class="text-xl mb-10 max-w-2xl mx-auto" color="white" style="opacity: 0.9;">
            Join millions of Indians who found their perfect space through MySqrft. Start your journey today.
          </.p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <.button_link
              navigate="/users/register"
              variant="default"
              color="white"
              size="extra_large"
              rounded="large"
              class="!bg-white !text-primary-light hover:!bg-primary-bordered-bg-light !shadow-xl"
            >
              Create Free Account
            </.button_link>
            <.button_link
              navigate="/about"
              variant="outline"
              color="white"
              size="extra_large"
              rounded="large"
            >
              Learn More
            </.button_link>
          </div>
        </div>
      </section>
      
    <!-- Testimonials Preview -->
      <section class="py-20 md:py-32 bg-gray-50 dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-3xl mx-auto mb-16">
            <.h2 class="mb-6" color="base" font_weight="font-bold">
              Loved by Thousands
            </.h2>
            <.p class="text-lg" color="base">
              Don't just take our word for it. Here's what our users have to say.
            </.p>
          </div>

          <div class="grid md:grid-cols-3 gap-8">
            <.card
              variant="bordered"
              color="natural"
              rounded="extra_large"
              padding="extra_large"
              class="!bg-white dark:!bg-gray-800"
            >
              <div class="flex mb-4">
                <.rating id="testimonial-rating-1" color="primary" size="small" select={5} count={5} />
              </div>
              <.p class="mb-6 leading-relaxed" color="base">
                "Found my perfect 2BHK in Indiranagar within a week! The verified listings saved me so much time. Highly recommend MySqrft."
              </.p>
              <div class="flex items-center gap-3">
                <.avatar size="medium" color="primary" class="w-10 h-10">
                  P
                </.avatar>
                <div>
                  <.p class="font-semibold" color="base">Priya Sharma</.p>
                  <.p class="text-sm" color="base" style="opacity: 0.7;">Bangalore</.p>
                </div>
              </div>
            </.card>

            <.card
              variant="bordered"
              color="natural"
              rounded="extra_large"
              padding="extra_large"
              class="!bg-white dark:!bg-gray-800"
            >
              <div class="flex mb-4">
                <.rating id="testimonial-rating-2" color="primary" size="small" select={5} count={5} />
              </div>
              <.p class="mb-6 leading-relaxed" color="base">
                "As a property owner, listing on MySqrft was seamless. Got genuine tenants within days, and the agreement process was hassle-free."
              </.p>
              <div class="flex items-center gap-3">
                <.avatar size="medium" color="info" class="w-10 h-10">
                  R
                </.avatar>
                <div>
                  <.p class="font-semibold" color="base">Rahul Mehta</.p>
                  <.p class="text-sm" color="base" style="opacity: 0.7;">Mumbai</.p>
                </div>
              </div>
            </.card>

            <.card
              variant="bordered"
              color="natural"
              rounded="extra_large"
              padding="extra_large"
              class="!bg-white dark:!bg-gray-800"
            >
              <div class="flex mb-4">
                <.rating id="testimonial-rating-3" color="primary" size="small" select={5} count={5} />
              </div>
              <.p class="mb-6 leading-relaxed" color="base">
                "The rental agreement service was a lifesaver! Everything was handled professionally, and I could focus on settling into my new home."
              </.p>
              <div class="flex items-center gap-3">
                <.avatar size="medium" color="success" class="w-10 h-10">
                  A
                </.avatar>
                <div>
                  <.p class="font-semibold" color="base">Ananya Gupta</.p>
                  <.p class="text-sm" color="base" style="opacity: 0.7;">Delhi NCR</.p>
                </div>
              </div>
            </.card>
          </div>
        </div>
      </section>
    </div>

    <style>
      .scrollbar-hide {
        -ms-overflow-style: none;
        scrollbar-width: none;
      }
      .scrollbar-hide::-webkit-scrollbar {
        display: none;
      }
      .line-clamp-1 {
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
      .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
    </style>
    """
  end
end
