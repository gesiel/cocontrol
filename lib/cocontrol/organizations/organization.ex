defmodule Cocontrol.Organizations.Organization do
  use Cocontrol.Schema
  import Ecto.Changeset

  alias Cocontrol.Auth.User

  schema "orgs" do
    field :name, :string
    field :document_number, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:user_id, :name, :document_number])
    |> validate_required([:user_id, :name])
  end
end
