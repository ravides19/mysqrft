defmodule MySqrftWeb.Marketing.PrivacyLive do
  @moduledoc """
  Privacy Policy page for MySqrft.
  """
  use MySqrftWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Privacy Policy")
     |> assign(:last_updated, "January 15, 2026")
     |> assign(:sections, [
       %{
         id: "introduction",
         title: "1. Introduction",
         content: """
         MySqrft Technologies Private Limited ("MySqrft," "we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our website, mobile application, and services (collectively, the "Platform").

         By using our Platform, you consent to the collection and use of your information as described in this Privacy Policy. If you do not agree with this policy, please do not use our Platform.
         """
       },
       %{
         id: "information-collected",
         title: "2. Information We Collect",
         content: """
         **Personal Information You Provide**:
         - Account information: name, email address, phone number, password
         - Profile information: photograph, address, ID documents (for verification)
         - Property information: property details, photos, pricing (for listings)
         - Communication data: messages between users, support inquiries
         - Payment information: billing details, transaction history

         **Information Collected Automatically**:
         - Device information: device type, operating system, unique device identifiers
         - Usage data: pages visited, features used, search queries, time spent
         - Location data: approximate location based on IP address, precise location (if permitted)
         - Cookies and tracking technologies: session data, preferences, analytics

         **Information from Third Parties**:
         - Social media profiles (if you sign in using social accounts)
         - Identity verification services
         - Marketing partners and analytics providers
         """
       },
       %{
         id: "use-of-information",
         title: "3. How We Use Your Information",
         content: """
         We use your information to:

         **Provide Our Services**:
         - Create and manage your account
         - Connect you with properties and property owners
         - Facilitate communications between users
         - Process transactions and payments
         - Verify user and property information

         **Improve Our Platform**:
         - Analyze usage patterns and trends
         - Develop new features and services
         - Personalize your experience
         - Conduct research and analytics

         **Communicate With You**:
         - Send service-related notifications
         - Provide customer support
         - Send marketing communications (with your consent)
         - Notify you of policy changes

         **Ensure Safety and Security**:
         - Detect and prevent fraud
         - Verify user identities
         - Enforce our terms and policies
         - Comply with legal obligations
         """
       },
       %{
         id: "information-sharing",
         title: "4. Information Sharing",
         content: """
         We may share your information with:

         **Other Users**: When you list a property or express interest, relevant information is shared with other users to facilitate connections.

         **Service Providers**: We work with third-party companies to provide services such as:
         - Payment processing
         - Identity verification
         - Cloud hosting
         - Analytics
         - Customer support

         **Legal Requirements**: We may disclose information if required by law, legal process, or government request.

         **Business Transfers**: In case of merger, acquisition, or sale of assets, your information may be transferred as part of the transaction.

         **With Your Consent**: We may share information for other purposes with your explicit consent.

         We do not sell your personal information to third parties for their marketing purposes.
         """
       },
       %{
         id: "data-security",
         title: "5. Data Security",
         content: """
         We implement appropriate technical and organizational measures to protect your information, including:

         - Encryption of data in transit and at rest
         - Regular security assessments and audits
         - Access controls and authentication measures
         - Employee training on data protection
         - Incident response procedures

         However, no method of transmission over the Internet or electronic storage is 100% secure. While we strive to protect your information, we cannot guarantee absolute security.
         """
       },
       %{
         id: "data-retention",
         title: "6. Data Retention",
         content: """
         We retain your information for as long as necessary to:
         - Provide our services
         - Comply with legal obligations
         - Resolve disputes
         - Enforce our agreements

         When you delete your account, we will delete or anonymize your personal information within 30 days, except where we are required to retain it for legal purposes.

         Some information may be retained in backup systems for a limited period.
         """
       },
       %{
         id: "your-rights",
         title: "7. Your Rights",
         content: """
         You have the following rights regarding your personal information:

         **Access**: Request a copy of the information we hold about you.

         **Correction**: Request correction of inaccurate or incomplete information.

         **Deletion**: Request deletion of your personal information (subject to certain exceptions).

         **Portability**: Request a copy of your data in a structured, machine-readable format.

         **Objection**: Object to certain processing of your information.

         **Withdraw Consent**: Withdraw consent for processing based on consent.

         To exercise these rights, please contact us at privacy@mysqrft.com. We will respond to your request within 30 days.
         """
       },
       %{
         id: "cookies",
         title: "8. Cookies and Tracking Technologies",
         content: """
         We use cookies and similar technologies to:
         - Keep you logged in
         - Remember your preferences
         - Understand how you use our Platform
         - Deliver relevant advertisements

         **Types of Cookies We Use**:
         - Essential cookies: Required for basic functionality
         - Functional cookies: Remember your preferences
         - Analytics cookies: Help us understand usage patterns
         - Marketing cookies: Deliver personalized ads

         You can control cookies through your browser settings. Note that disabling certain cookies may affect Platform functionality.
         """
       },
       %{
         id: "children",
         title: "9. Children's Privacy",
         content: """
         Our Platform is not intended for children under 18 years of age. We do not knowingly collect personal information from children.

         If you believe we have collected information from a child, please contact us immediately at privacy@mysqrft.com, and we will take steps to delete such information.
         """
       },
       %{
         id: "international-transfers",
         title: "10. International Data Transfers",
         content: """
         Your information may be transferred to and processed in countries other than India. When we transfer data internationally, we ensure appropriate safeguards are in place, including:

         - Standard contractual clauses
         - Adequacy decisions
         - Certification mechanisms

         By using our Platform, you consent to such transfers.
         """
       },
       %{
         id: "third-party-links",
         title: "11. Third-Party Links",
         content: """
         Our Platform may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties.

         We encourage you to read the privacy policies of any third-party sites you visit.
         """
       },
       %{
         id: "changes",
         title: "12. Changes to This Policy",
         content: """
         We may update this Privacy Policy from time to time. We will notify you of material changes by:
         - Posting a notice on our Platform
         - Sending you an email
         - Updating the "Last Updated" date

         We encourage you to review this Privacy Policy periodically.
         """
       },
       %{
         id: "contact",
         title: "13. Contact Us",
         content: """
         If you have questions, concerns, or complaints about this Privacy Policy or our data practices, please contact our Data Protection Officer:

         **MySqrft Technologies Private Limited**
         Email: privacy@mysqrft.com
         Address: [Company Address], Bangalore, Karnataka, India

         **Grievance Officer**:
         Name: [Grievance Officer Name]
         Email: grievance@mysqrft.com

         We will respond to your inquiry within 30 days.
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
              Privacy Policy
            </h1>
            <p class="text-gray-500 dark:text-gray-400">
              Last updated: {@last_updated}
            </p>
          </div>
        </div>
      </section>

      <!-- Quick Summary -->
      <section class="py-12 bg-red-50 dark:bg-red-900/10 border-b border-red-100 dark:border-gray-800">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-start gap-4">
            <div class="shrink-0 w-12 h-12 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center">
              <svg class="w-6 h-6 text-[#FF385C] dark:text-[#FF385C]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
            <div>
              <h2 class="font-display text-lg font-bold text-gray-900 dark:text-white mb-2">Privacy at a Glance</h2>
              <p class="text-gray-600 dark:text-gray-300 text-sm leading-relaxed">
                We collect information to provide our rental marketplace services. We protect your data with industry-standard security measures. You have rights over your data including access, correction, and deletion. We never sell your personal information.
              </p>
            </div>
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
            <div :for={section <- @sections} id={section.id} class="mb-12 scroll-mt-24">
              <h2 class="font-display text-2xl font-bold text-gray-900 dark:text-white mb-4 pb-2 border-b border-red-200 dark:border-gray-700">
                {section.title}
              </h2>
              <div class="text-gray-600 dark:text-gray-300 leading-relaxed whitespace-pre-line">
                {section.content}
              </div>
            </div>
          </div>

          <!-- Your Privacy Choices -->
          <div class="mt-16 p-8 bg-gray-50 dark:bg-gray-800/50 rounded-2xl border border-gray-200 dark:border-gray-700">
            <h3 class="font-display text-xl font-bold text-gray-900 dark:text-white mb-4">Your Privacy Choices</h3>
            <div class="grid sm:grid-cols-2 gap-4">
              <a href="#" class="flex items-center gap-3 p-4 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 hover:border-red-400 dark:hover:border-red-600 transition-colors">
                <div class="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-[#FF385C] dark:text-[#FF385C]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                  </svg>
                </div>
                <div>
                  <div class="font-semibold text-gray-900 dark:text-white">Privacy Settings</div>
                  <div class="text-sm text-gray-500 dark:text-gray-400">Manage your preferences</div>
                </div>
              </a>
              <a href="#" class="flex items-center gap-3 p-4 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 hover:border-red-400 dark:hover:border-red-600 transition-colors">
                <div class="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-[#FF385C] dark:text-[#FF385C]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                  </svg>
                </div>
                <div>
                  <div class="font-semibold text-gray-900 dark:text-white">Download Your Data</div>
                  <div class="text-sm text-gray-500 dark:text-gray-400">Request a copy</div>
                </div>
              </a>
              <a href="#" class="flex items-center gap-3 p-4 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 hover:border-red-400 dark:hover:border-red-600 transition-colors">
                <div class="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-[#FF385C] dark:text-[#FF385C]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                  </svg>
                </div>
                <div>
                  <div class="font-semibold text-gray-900 dark:text-white">Delete Account</div>
                  <div class="text-sm text-gray-500 dark:text-gray-400">Remove your data</div>
                </div>
              </a>
              <a href="mailto:privacy@mysqrft.com" class="flex items-center gap-3 p-4 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 hover:border-red-400 dark:hover:border-red-600 transition-colors">
                <div class="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-lg flex items-center justify-center">
                  <svg class="w-5 h-5 text-[#FF385C] dark:text-[#FF385C]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                  </svg>
                </div>
                <div>
                  <div class="font-semibold text-gray-900 dark:text-white">Contact Privacy Team</div>
                  <div class="text-sm text-gray-500 dark:text-gray-400">privacy@mysqrft.com</div>
                </div>
              </a>
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
