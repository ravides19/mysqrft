defmodule MySqrft.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :mobile_number, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime
    field :authenticated_at, :utc_datetime, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration with magic link authentication.

  Password is optional and can be set later in user settings.

  ## Options

    * `:validate_unique` - Set to false if you don't want to validate the
      uniqueness of the email and mobile_number, useful when displaying live validations.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :mobile_number, :password])
    |> validate_required([:firstname, :lastname, :email, :mobile_number])
    |> validate_firstname()
    |> validate_lastname()
    |> validate_email(opts)
    |> validate_mobile_number(opts)
    |> validate_password_if_present(opts)
  end

  @doc """
  A user changeset for updating profile information (firstname, lastname, mobile_number).

  ## Options

    * `:validate_unique` - Set to false if you don't want to validate the
      uniqueness of the mobile_number, useful when displaying live validations.
      Defaults to `true`.
  """
  def profile_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:firstname, :lastname, :mobile_number])
    |> validate_required([:firstname, :lastname, :mobile_number])
    |> validate_firstname()
    |> validate_lastname()
    |> validate_mobile_number(opts)
  end

  @doc """
  A user changeset for registering or changing the email.

  It requires the email to change otherwise an error is added.

  ## Options

    * `:validate_unique` - Set to false if you don't want to validate the
      uniqueness of the email, useful when displaying live validations.
      Defaults to `true`.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_email(opts)
  end

  defp validate_firstname(changeset) do
    changeset
    |> validate_length(:firstname, min: 1, max: 100)
  end

  defp validate_lastname(changeset) do
    changeset
    |> validate_length(:lastname, min: 1, max: 100)
  end

  defp validate_email(changeset, opts) do
    changeset =
      changeset
      |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+\.[^@,;\s]+$/,
        message: "must be a valid email address"
      )
      |> validate_length(:email, max: 160)

    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:email, MySqrft.Repo)
      |> unique_constraint(:email)
      |> maybe_validate_email_changed()
    else
      changeset
    end
  end

  defp validate_mobile_number(changeset, opts) do
    # Basic phone validation - supports international format with country code
    # Format: +[country code][number] (e.g., +1234567890, +919876543210)
    changeset =
      changeset
      |> validate_format(:mobile_number, ~r/^\+[1-9]\d{1,14}$/,
        message: "must be in international format with country code (e.g., +1234567890)"
      )
      |> validate_length(:mobile_number, min: 10, max: 16)

    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:mobile_number, MySqrft.Repo)
      |> unique_constraint(:mobile_number)
    else
      changeset
    end
  end

  defp maybe_validate_email_changed(changeset) do
    # Only validate email changed if this is an update (user already exists)
    if Ecto.Changeset.get_field(changeset, :id) && get_change(changeset, :email) == nil do
      add_error(changeset, :email, "did not change")
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the password.

  It is important to validate the length of the password, as long passwords may
  be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  defp validate_password_if_present(changeset, opts) do
    password = get_change(changeset, :password)

    if password && password != "" do
      validate_password(changeset, opts)
    else
      changeset
    end
  end

  defp validate_password(changeset, opts) do
    changeset =
      changeset
      |> validate_length(:password, min: 8, max: 72)
      |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
      |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
      |> validate_format(:password, ~r/[0-9]/, message: "at least one number")
      |> validate_format(:password, ~r/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/,
        message: "at least one special character"
      )

    maybe_hash_password(changeset, opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing with cost factor 12 (configured in config.exs)
      # Uses Application.get_env(:bcrypt_elixir, :log_rounds, 12) for cost factor
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%MySqrft.Auth.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end
