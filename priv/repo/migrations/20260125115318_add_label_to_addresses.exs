defmodule MySqrft.Repo.Migrations.AddLabelToAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :label, :string, size: 50
    end
  end
end
