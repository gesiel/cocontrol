defmodule Cocontrol.Organizations.Organization do
  use Cocontrol.Schema
  import Ecto.Changeset

  schema "orgs" do
    field :name, :string
    field :document_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :document_number])
    |> validate_required([:name])
  end
end
