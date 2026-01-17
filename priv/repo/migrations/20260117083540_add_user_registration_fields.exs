defmodule MySqrft.Repo.Migrations.AddUserRegistrationFields do
  use Ecto.Migration

  def up do
    # First, add columns as nullable
    alter table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :mobile_number, :string
    end

    # Update existing rows with default values if any exist
    # Using email prefix as firstname and generating unique mobile_number
    execute """
    UPDATE users
    SET firstname = COALESCE(SPLIT_PART(email, '@', 1), 'User'),
        lastname = 'User',
        mobile_number = '+1000000000' || SUBSTRING(REPLACE(id::text, '-', ''), 1, 10)
    WHERE firstname IS NULL OR lastname IS NULL OR mobile_number IS NULL
    """, """
    -- Rollback handled by down()
    """

    # Now add NOT NULL constraints
    alter table(:users) do
      modify :firstname, :string, null: false
      modify :lastname, :string, null: false
      modify :mobile_number, :string, null: false
    end

    create unique_index(:users, [:mobile_number])
  end

  def down do
    drop unique_index(:users, [:mobile_number])

    alter table(:users) do
      remove :firstname
      remove :lastname
      remove :mobile_number
    end
  end
end
