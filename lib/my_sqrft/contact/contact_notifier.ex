defmodule MySqrft.Contact.ContactNotifier do
  @moduledoc """
  Email notifications for contact form submissions.
  """
  import Swoosh.Email

  alias MySqrft.Mailer
  alias MySqrft.Contact.Submission

  @doc """
  Deliver confirmation email to user after contact submission.
  """
  def deliver_submission_confirmation(%Submission{} = submission) do
    email =
      new()
      |> to(submission.email)
      |> from({"MySqrft", "noreply@mysqrft.com"})
      |> subject("Thank you for contacting MySqrft")
      |> html_body(confirmation_html_body(submission))
      |> text_body(confirmation_text_body(submission))

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  defp confirmation_html_body(submission) do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: linear-gradient(135deg, #f59e0b 0%, #f97316 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
          .content { background: #ffffff; padding: 30px; border: 1px solid #e5e7eb; border-top: none; }
          .footer { background: #f9fafb; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; font-size: 12px; color: #6b7280; }
          .button { display: inline-block; padding: 12px 24px; background: #f59e0b; color: white; text-decoration: none; border-radius: 6px; margin-top: 20px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>Thank You for Contacting MySqrft!</h1>
          </div>
          <div class="content">
            <p>Dear #{submission.name},</p>

            <p>Thank you for reaching out to us. We have received your message and our team will get back to you within 24-48 hours.</p>

            <p><strong>Your submission details:</strong></p>
            <ul>
              <li><strong>Subject:</strong> #{submission.subject}</li>
              <li><strong>Submitted on:</strong> #{format_datetime(submission.inserted_at)}</li>
            </ul>

            <p>Your message:</p>
            <blockquote style="background: #f9fafb; padding: 15px; border-left: 4px solid #f59e0b; margin: 20px 0;">
              #{submission.message}
            </blockquote>

            <p>If you have any urgent concerns, please feel free to call us at +91-XXX-XXX-XXXX.</p>

            <p>Best regards,<br>The MySqrft Team</p>
          </div>
          <div class="footer">
            <p>© 2026 MySqrft. All rights reserved.</p>
            <p>This is an automated email. Please do not reply to this message.</p>
          </div>
        </div>
      </body>
    </html>
    """
  end

  defp confirmation_text_body(submission) do
    """
    Thank You for Contacting MySqrft!

    Dear #{submission.name},

    Thank you for reaching out to us. We have received your message and our team will get back to you within 24-48 hours.

    Your submission details:
    - Subject: #{submission.subject}
    - Submitted on: #{format_datetime(submission.inserted_at)}

    Your message:
    #{submission.message}

    If you have any urgent concerns, please feel free to call us at +91-XXX-XXX-XXXX.

    Best regards,
    The MySqrft Team

    © 2026 MySqrft. All rights reserved.
    This is an automated email. Please do not reply to this message.
    """
  end

  defp format_datetime(datetime) do
    datetime
    |> DateTime.to_date()
    |> Date.to_string()
    |> String.replace("-", "/")
  end
end
