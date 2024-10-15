defmodule Cocontrol.Accounts.Account do
  use Cocontrol.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    field :number, :string
    field :branch, :string
    field :bank, :string

    belongs_to :user, Cocontrol.Auth.User
    belongs_to :org, Cocontrol.Organizations.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :bank, :branch, :number, :user_id, :org_id])
    |> validate_required([:name, :user_id, :org_id])
  end
end
