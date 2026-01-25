defmodule MySqrftWeb.Marketing.ContactLive do
  @moduledoc """
  Contact page for MySqrft - form to submit contact inquiries.
  """
  use MySqrftWeb, :live_view

  import MySqrftWeb.Components.Button
  import MySqrftWeb.Components.Card
  import MySqrftWeb.Components.Icon
  alias MySqrft.Contact
  alias MySqrft.Contact.Submission

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Contact Us")
     |> assign(:form, to_form(Submission.changeset(%Submission{}, %{})))}
  end

  @impl true
  def handle_event("validate", %{"submission" => submission_params}, socket) do
    changeset =
      %Submission{}
      |> Submission.changeset(submission_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"submission" => submission_params}, socket) do
    case Contact.create_submission(submission_params) do
      {:ok, _submission} ->
        {:noreply,
         socket
         |> put_flash(
           :success,
           "Form submitted successfully! Someone from our team will contact you as soon as possible."
         )
         |> assign(:form, to_form(Submission.changeset(%Submission{}, %{})))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative overflow-hidden">
      <!-- Hero Section -->
      <section class="relative py-20 md:py-32 bg-gradient-to-br from-red-50 to-red-50 dark:from-gray-900 dark:to-gray-950">
        <div class="absolute inset-0 geo-pattern opacity-20"></div>
        <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="font-display text-4xl md:text-5xl lg:text-6xl font-bold text-gray-900 dark:text-white mb-6">
            Get in <span class="text-gradient">Touch</span>
          </h1>
          <p class="text-xl text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
            Have questions? We'd love to hear from you. Send us a message and we'll respond as soon as possible.
          </p>
        </div>
      </section>
      
    <!-- Contact Form Section -->
      <section class="py-20 md:py-32">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid md:grid-cols-2 gap-12">
            <!-- Contact Information -->
            <div>
              <h2 class="font-display text-3xl font-bold text-gray-900 dark:text-white mb-6">
                Contact Information
              </h2>
              <p class="text-gray-600 dark:text-gray-400 mb-8 leading-relaxed">
                Fill out the form or reach us directly using the information below. We're here to help you find your perfect space.
              </p>

              <div class="space-y-6">
                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center shrink-0">
                    <.icon name="hero-envelope" class="w-6 h-6 text-[#FF385C] dark:text-[#FF385C]" />
                  </div>
                  <div>
                    <h3 class="font-semibold text-gray-900 dark:text-white mb-1">Email</h3>
                    <a
                      href="mailto:contact@mysqrft.com"
                      class="text-[#FF385C] dark:text-[#FF385C] hover:text-[#FF5A5F] dark:hover:text-[#FF5A5F]"
                    >
                      contact@mysqrft.com
                    </a>
                  </div>
                </div>

                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center shrink-0">
                    <.icon name="hero-phone" class="w-6 h-6 text-[#FF385C] dark:text-[#FF385C]" />
                  </div>
                  <div>
                    <h3 class="font-semibold text-gray-900 dark:text-white mb-1">Phone</h3>
                    <a
                      href="tel:+911234567890"
                      class="text-[#FF385C] dark:text-[#FF385C] hover:text-[#FF5A5F] dark:hover:text-[#FF5A5F]"
                    >
                      +91-XXX-XXX-XXXX
                    </a>
                  </div>
                </div>

                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center shrink-0">
                    <.icon name="hero-map-pin" class="w-6 h-6 text-[#FF385C] dark:text-[#FF385C]" />
                  </div>
                  <div>
                    <h3 class="font-semibold text-gray-900 dark:text-white mb-1">Address</h3>
                    <p class="text-gray-600 dark:text-gray-400">
                      Bangalore, Karnataka<br /> India
                    </p>
                  </div>
                </div>
              </div>
            </div>
            
    <!-- Contact Form -->
            <div>
              <.card
                variant="default"
                color="white"
                rounded="extra_large"
                padding="extra_large"
              >
                <.form
                  for={@form}
                  id="contact-form"
                  phx-submit="save"
                  phx-change="validate"
                  phx-submit-loading
                  class="space-y-6"
                >
                  <.input
                    field={@form[:name]}
                    type="text"
                    label="Full Name"
                    placeholder="John Doe"
                    required
                  />

                  <.input
                    field={@form[:email]}
                    type="email"
                    label="Email Address"
                    placeholder="john@example.com"
                    required
                  />

                  <.input
                    field={@form[:phone]}
                    type="tel"
                    label="Phone Number (Optional)"
                    placeholder="+919876543210"
                  />

                  <.input
                    field={@form[:subject]}
                    type="text"
                    label="Subject"
                    placeholder="How can we help?"
                    required
                  />

                  <.input
                    field={@form[:message]}
                    type="textarea"
                    label="Message"
                    placeholder="Tell us more about your inquiry..."
                    required
                    rows={5}
                  />

                  <div>
                    <.button
                      type="submit"
                      variant="default"
                      color="primary"
                      size="extra_large"
                      rounded="large"
                      class="w-full"
                      phx-disable-with="Sending..."
                    >
                      Send Message <.icon name="hero-paper-airplane" class="w-5 h-5 ml-2" />
                    </.button>
                  </div>
                </.form>
              </.card>
            </div>
          </div>
        </div>
      </section>
      
    <!-- Additional CTA Section -->
      <section class="py-20 md:py-32 bg-gray-50 dark:bg-gray-900">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 class="font-display text-3xl md:text-4xl font-bold text-gray-900 dark:text-white mb-6">
            Looking for Properties?
          </h2>
          <p class="text-lg text-gray-600 dark:text-gray-300 mb-8 max-w-2xl mx-auto">
            Browse through thousands of verified listings and find your perfect home today.
          </p>
          <.button_link
            navigate="/"
            variant="default"
            color="primary"
            size="extra_large"
            rounded="large"
          >
            Browse Properties <.icon name="hero-arrow-right" class="w-5 h-5 ml-2" />
          </.button_link>
        </div>
      </section>
    </div>
    """
  end
end
