defmodule Cocontrol.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string, null: false
      add :bank, :string
      add :branch, :string
      add :number, :string

      add :org_id, references(:orgs, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:accounts, [:org_id])
    create index(:accounts, [:user_id])
  end
end
