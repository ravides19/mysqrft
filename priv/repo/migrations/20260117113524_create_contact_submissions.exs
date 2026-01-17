defmodule MySqrft.Repo.Migrations.CreateContactSubmissions do
  use Ecto.Migration

  def change do
    create table(:contact_submissions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :subject, :string, null: false
      add :message, :text, null: false
      add :status, :string, default: "new", null: false

      timestamps(type: :utc_datetime)
    end

    create index(:contact_submissions, [:email])
    create index(:contact_submissions, [:status])
    create index(:contact_submissions, [:inserted_at])
  end
end
