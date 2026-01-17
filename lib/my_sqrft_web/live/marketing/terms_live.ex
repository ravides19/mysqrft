defmodule MySqrftWeb.Marketing.TermsLive do
  @moduledoc """
  Terms and Conditions page for MySqrft.
  """
  use MySqrftWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Terms of Service")
     |> assign(:last_updated, "January 15, 2026")
     |> assign(:sections, [
       %{
         id: "acceptance",
         title: "1. Acceptance of Terms",
         content: """
         By accessing or using MySqrft's services, website, or mobile application (collectively, the "Platform"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use our Platform.

         These Terms constitute a legally binding agreement between you and MySqrft Technologies Private Limited ("MySqrft," "we," "us," or "our"). We reserve the right to modify these Terms at any time, and such modifications will be effective immediately upon posting on the Platform.
         """
       },
       %{
         id: "eligibility",
         title: "2. Eligibility",
         content: """
         To use our Platform, you must:
         - Be at least 18 years of age
         - Have the legal capacity to enter into binding contracts
         - Not be prohibited from using our services under applicable laws
         - Provide accurate and complete registration information

         If you are using the Platform on behalf of an organization, you represent that you have the authority to bind that organization to these Terms.
         """
       },
       %{
         id: "services",
         title: "3. Description of Services",
         content: """
         MySqrft provides an online platform that connects property seekers (tenants and buyers) with property owners and landlords. Our services include:

         - Property listing and discovery
         - Direct communication between users
         - Rental agreement facilitation
         - Property verification services
         - Home services marketplace
         - Society management tools

         We act solely as an intermediary platform and are not a party to any transaction between users. We do not own, manage, or control any properties listed on our Platform.
         """
       },
       %{
         id: "user-accounts",
         title: "4. User Accounts",
         content: """
         **Account Creation**: You must create an account to access certain features of our Platform. You agree to provide accurate, current, and complete information during registration and to update such information as necessary.

         **Account Security**: You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must immediately notify us of any unauthorized use of your account.

         **Account Termination**: We reserve the right to suspend or terminate your account at any time for violation of these Terms or for any other reason at our sole discretion.
         """
       },
       %{
         id: "user-conduct",
         title: "5. User Conduct",
         content: """
         You agree not to:
         - Post false, misleading, or fraudulent content
         - Impersonate any person or entity
         - Harass, abuse, or harm other users
         - Use the Platform for any illegal purpose
         - Attempt to gain unauthorized access to our systems
         - Scrape, crawl, or use automated means to access our Platform without permission
         - Post content that infringes on intellectual property rights
         - Circumvent any security measures or access restrictions

         We reserve the right to remove any content that violates these Terms and to take appropriate action against violators.
         """
       },
       %{
         id: "listings",
         title: "6. Property Listings",
         content: """
         **For Property Owners/Landlords**:
         - You must have the legal right to list the property
         - All listing information must be accurate and up-to-date
         - You must promptly update or remove listings when properties are no longer available
         - You agree not to discriminate against potential tenants based on protected characteristics

         **For Property Seekers**:
         - You acknowledge that we do not guarantee the accuracy of listings
         - You are responsible for verifying property details before entering into any agreement
         - You must use the Platform in good faith and not submit false inquiries
         """
       },
       %{
         id: "payments",
         title: "7. Payments and Fees",
         content: """
         **Service Fees**: Certain services on our Platform may require payment. All fees are listed on our pricing page and are subject to change with notice.

         **Payment Processing**: Payments are processed through secure third-party payment processors. By making a payment, you agree to the terms and privacy policies of these processors.

         **Refunds**: Refund policies vary by service and are detailed on our Platform. Generally, subscription fees are non-refundable except as required by law.

         **Taxes**: You are responsible for any applicable taxes on transactions conducted through our Platform.
         """
       },
       %{
         id: "intellectual-property",
         title: "8. Intellectual Property",
         content: """
         **Our Content**: All content on the Platform, including text, graphics, logos, and software, is owned by MySqrft or its licensors and is protected by intellectual property laws. You may not use, reproduce, or distribute our content without permission.

         **User Content**: You retain ownership of content you post on the Platform but grant us a non-exclusive, worldwide, royalty-free license to use, display, and distribute such content in connection with our services.

         **Trademarks**: "MySqrft" and related logos are trademarks of MySqrft Technologies Private Limited. You may not use our trademarks without prior written consent.
         """
       },
       %{
         id: "disclaimers",
         title: "9. Disclaimers",
         content: """
         THE PLATFORM IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.

         We do not warrant that:
         - The Platform will be uninterrupted or error-free
         - Any information on the Platform is accurate or complete
         - Properties listed meet any particular standards
         - Transactions between users will be successful

         You use the Platform at your own risk.
         """
       },
       %{
         id: "limitation-liability",
         title: "10. Limitation of Liability",
         content: """
         TO THE MAXIMUM EXTENT PERMITTED BY LAW, MYSQRFT SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING BUT NOT LIMITED TO LOSS OF PROFITS, DATA, OR GOODWILL.

         Our total liability for any claims arising from these Terms or your use of the Platform shall not exceed the amount you paid to us in the twelve (12) months preceding the claim.

         Some jurisdictions do not allow limitations on implied warranties or liability, so these limitations may not apply to you.
         """
       },
       %{
         id: "indemnification",
         title: "11. Indemnification",
         content: """
         You agree to indemnify, defend, and hold harmless MySqrft and its officers, directors, employees, and agents from any claims, damages, losses, or expenses (including reasonable attorneys' fees) arising from:
         - Your use of the Platform
         - Your violation of these Terms
         - Your violation of any third-party rights
         - Any content you post on the Platform
         """
       },
       %{
         id: "governing-law",
         title: "12. Governing Law and Dispute Resolution",
         content: """
         These Terms are governed by the laws of India, without regard to conflict of law principles.

         Any disputes arising from these Terms shall be resolved through:
         1. Good faith negotiation between the parties
         2. Mediation by a mutually agreed mediator
         3. Binding arbitration in Bangalore, India, in accordance with the Arbitration and Conciliation Act, 1996

         You agree to waive any right to participate in class action lawsuits against MySqrft.
         """
       },
       %{
         id: "changes",
         title: "13. Changes to Terms",
         content: """
         We may modify these Terms at any time. We will notify you of material changes by posting a notice on our Platform or by email. Your continued use of the Platform after such notice constitutes acceptance of the modified Terms.

         We encourage you to review these Terms periodically for any updates.
         """
       },
       %{
         id: "contact",
         title: "14. Contact Information",
         content: """
         If you have questions about these Terms, please contact us:

         **MySqrft Technologies Private Limited**
         Email: legal@mysqrft.com
         Address: [Company Address], Bangalore, Karnataka, India

         For general support: support@mysqrft.com
         """
       }
     ])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative">
      <!-- Header -->
      <section class="py-16 md:py-24 bg-white dark:bg-gray-900 border-b border-red-100 dark:border-gray-800">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h1 class="font-display text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-4">
              Terms of Service
            </h1>
            <p class="text-gray-500 dark:text-gray-400">
              Last updated: {@last_updated}
            </p>
          </div>
        </div>
      </section>

      <!-- Table of Contents -->
      <section class="py-12 bg-gray-50 dark:bg-gray-900/50 border-b border-red-100 dark:border-gray-800">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 class="font-display text-xl font-bold text-gray-900 dark:text-white mb-6">Table of Contents</h2>
          <nav class="grid sm:grid-cols-2 gap-2">
            <a
              :for={section <- @sections}
              href={"##{section.id}"}
              class="text-gray-600 dark:text-gray-400 hover:text-[#FF385C] dark:hover:text-[#FF385C] transition-colors py-1"
            >
              {section.title}
            </a>
          </nav>
        </div>
      </section>

      <!-- Content -->
      <section class="py-16 md:py-24">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="prose prose-stone dark:prose-invert prose-lg max-w-none">
            <p class="text-gray-600 dark:text-gray-300 leading-relaxed mb-12">
              Welcome to MySqrft. These Terms of Service ("Terms") govern your access to and use of our platform, products, and services. Please read these Terms carefully before using MySqrft.
            </p>

            <div :for={section <- @sections} id={section.id} class="mb-12 scroll-mt-24">
              <h2 class="font-display text-2xl font-bold text-gray-900 dark:text-white mb-4 pb-2 border-b border-red-200 dark:border-gray-700">
                {section.title}
              </h2>
              <div class="text-gray-600 dark:text-gray-300 leading-relaxed whitespace-pre-line">
                {section.content}
              </div>
            </div>
          </div>

          <!-- Back to top -->
          <div class="mt-16 pt-8 border-t border-red-200 dark:border-gray-700">
            <a href="#" class="inline-flex items-center gap-2 text-[#FF385C] dark:text-[#FF385C] hover:text-[#FF5A5F] dark:hover:text-[#FF5A5F] font-medium">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
              </svg>
              Back to top
            </a>
          </div>
        </div>
      </section>
    </div>
    """
  end
end
