defmodule MySqrft.UserManagement.Events do
  @moduledoc """
  Event publishing for UserManagement domain.

  This module publishes events for profile changes, role changes, etc.
  In production, this would integrate with an event bus (Kafka, RabbitMQ, etc.)
  For now, it uses Phoenix.PubSub for local event distribution.
  """
  alias Phoenix.PubSub

  @topic "user_management"

  @doc """
  Publishes a user profile created event.
  """
  def publish_profile_created(profile) do
    event = %{
      event: "user.profile.created",
      user_id: profile.user_id,
      profile_id: profile.id,
      roles: [],
      email: profile.email,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user profile updated event.
  """
  def publish_profile_updated(profile, changed_fields) do
    event = %{
      event: "user.profile.updated",
      user_id: profile.user_id,
      profile_id: profile.id,
      changed_fields: changed_fields,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user status changed event.
  """
  def publish_status_changed(profile, old_status, new_status, reason \\ nil) do
    event = %{
      event: "user.status.changed",
      user_id: profile.user_id,
      profile_id: profile.id,
      old_status: old_status,
      new_status: new_status,
      reason: reason,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user role added event.
  """
  def publish_role_added(user_role) do
    event = %{
      event: "user.role.added",
      user_id: user_role.user_profile.user_id,
      profile_id: user_role.user_profile_id,
      role_type: user_role.role.name,
      role_id: user_role.role_id,
      role_data: user_role.role_specific_data,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user role removed event.
  """
  def publish_role_removed(user_role) do
    event = %{
      event: "user.role.removed",
      user_id: user_role.user_profile.user_id,
      profile_id: user_role.user_profile_id,
      role_type: user_role.role.name,
      role_id: user_role.role_id,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user preferences updated event.
  """
  def publish_preferences_updated(profile, preference_type, values) do
    event = %{
      event: "user.preferences.updated",
      user_id: profile.user_id,
      profile_id: profile.id,
      preference_type: preference_type,
      values: values,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user consent changed event.
  """
  def publish_consent_changed(consent) do
    event = %{
      event: "user.consent.changed",
      user_id: consent.user_profile.user_id,
      profile_id: consent.user_profile_id,
      consent_type: consent.consent_type,
      granted: consent.granted,
      version: consent.version,
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end

  @doc """
  Publishes a user deleted event.
  """
  def publish_user_deleted(profile) do
    event = %{
      event: "user.deleted",
      user_id: profile.user_id,
      profile_id: profile.id,
      deletion_date: DateTime.utc_now(),
      timestamp: DateTime.utc_now()
    }

    PubSub.broadcast(MySqrft.PubSub, @topic, event)
    :ok
  end
end
