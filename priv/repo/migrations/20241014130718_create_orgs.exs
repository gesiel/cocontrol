defmodule Cocontrol.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs) do
      add :name, :string, null: false
      add :document_number, :string, size: 18

      timestamps(type: :utc_datetime)
    end
  end
end
