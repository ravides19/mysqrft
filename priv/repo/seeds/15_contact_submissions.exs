# Seeds for contact submissions - 50 submissions
alias MySqrft.Repo
alias MySqrft.Contact.Submission

subjects = ["Property Inquiry", "General Inquiry", "Complaint", "Feedback", "Support Request",
            "Partnership Opportunity", "Report Listing", "Bug Report", "Feature Request", "Job Application"]

messages = [
  "I am interested in this property.",
  "Please call me back regarding my inquiry.",
  "The website is very slow today.",
  "Great service, keep it up!",
  "How do I list my property?",
  "I found incorrect information on a listing.",
  "Is there a mobile app available?",
  "I haven't received my verification code.",
  "Do you offer services in Pune?",
  "I want to unsubscribe from emails."
]

sources = ["website", "mobile_app", "referral", "social_media"]
statuses = ["new", "read", "responded", "closed"]

# Generate 50 submissions
submissions_data = Enum.map(1..50, fn i ->
  status = Enum.at(statuses, rem(i, 4))

  %{
    name: "User #{i}",
    email: "user#{i}@example.com",
    phone: "+9198765#{String.pad_leading(Integer.to_string(i), 5, "0")}",
    subject: Enum.at(subjects, rem(i, length(subjects))),
    message: Enum.at(messages, rem(i, length(messages))),
    status: status
    # Removed source, responded_at (not in schema)
  }
end)

Enum.each(submissions_data, fn submission_data ->
  Repo.insert!(%Submission{
    name: submission_data.name,
    email: submission_data.email,
    phone: submission_data.phone,
    subject: submission_data.subject,
    message: submission_data.message,
    status: submission_data.status
  })
end)

IO.puts("✓ Seeded #{Repo.aggregate(Submission, :count, :id)} contact submissions")
