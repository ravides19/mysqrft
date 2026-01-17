defmodule MySqrft.Contact do
  @moduledoc """
  The Contact context for managing contact form submissions.
  """

  import Ecto.Query, warn: false
  alias MySqrft.Repo
  alias MySqrft.Contact.Submission
  alias MySqrft.Contact.ContactNotifier

  @doc """
  Creates a contact submission.

  ## Examples

      iex> create_submission(%{field: value})
      {:ok, %Submission{}}

      iex> create_submission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_submission(attrs \\ %{}) do
    %Submission{}
    |> Submission.changeset(attrs)
    |> Repo.insert()
    |> maybe_send_email()
  end

  defp maybe_send_email({:ok, submission}) do
    # Send email to user confirming submission
    ContactNotifier.deliver_submission_confirmation(submission)

    # Optionally, send notification to admin
    # ContactNotifier.deliver_admin_notification(submission)

    {:ok, submission}
  end

  defp maybe_send_email(error), do: error

  @doc """
  Returns the list of contact submissions.

  ## Examples

      iex> list_submissions()
      [%Submission{}, ...]

  """
  def list_submissions(opts \\ []) do
    status = Keyword.get(opts, :status, nil)
    limit = Keyword.get(opts, :limit, 100)

    Submission
    |> maybe_filter_by_status(status)
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  defp maybe_filter_by_status(query, nil), do: query
  defp maybe_filter_by_status(query, status), do: where(query, [s], s.status == ^status)

  @doc """
  Gets a single submission.

  Raises `Ecto.NoResultsError` if the Submission does not exist.

  ## Examples

      iex> get_submission!(123)
      %Submission{}

      iex> get_submission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_submission!(id), do: Repo.get!(Submission, id)

  @doc """
  Updates a submission.

  ## Examples

      iex> update_submission(submission, %{field: new_value})
      {:ok, %Submission{}}

      iex> update_submission(submission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_submission(%Submission{} = submission, attrs) do
    submission
    |> Submission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a submission.

  ## Examples

      iex> delete_submission(submission)
      {:ok, %Submission{}}

      iex> delete_submission(submission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_submission(%Submission{} = submission) do
    Repo.delete(submission)
  end
end
