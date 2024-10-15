defmodule Cocontrol.Repo.Migrations.AddUserFkToOrgs do
  use Ecto.Migration

  def change do
    alter table(:orgs) do
      add :user_id, references(:users, on_delete: :nothing), null: false
    end

    create index(:orgs, [:user_id])
  end
end
