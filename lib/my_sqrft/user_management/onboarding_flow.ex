defmodule MySqrft.UserManagement.OnboardingFlow do
  @moduledoc """
  OnboardingFlow schema - tracks user progress through onboarding.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "onboarding_flows" do
    field :flow_type, :string
    field :current_step, :integer, default: 1
    field :total_steps, :integer
    field :completed_steps, {:array, :string}, default: []
    field :status, :string, default: "in_progress"
    field :started_at, :utc_datetime
    field :completed_at, :utc_datetime

    belongs_to :user_profile, MySqrft.UserManagement.Profile, foreign_key: :user_profile_id
    belongs_to :role, MySqrft.UserManagement.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(onboarding_flow, attrs) do
    onboarding_flow
    |> cast(attrs, [
      :user_profile_id,
      :role_id,
      :flow_type,
      :current_step,
      :total_steps,
      :completed_steps,
      :status,
      :started_at,
      :completed_at
    ])
    |> validate_required([:user_profile_id, :role_id, :flow_type, :total_steps, :started_at])
    |> validate_inclusion(:status, ["in_progress", "completed", "abandoned"])
    |> validate_number(:current_step, greater_than_or_equal_to: 1)
    |> validate_number(:total_steps, greater_than: 0)
    |> unique_constraint([:user_profile_id, :role_id, :flow_type])
  end

  def complete_changeset(onboarding_flow) do
    now = DateTime.utc_now()
    change(onboarding_flow, status: "completed", completed_at: now)
  end
end
