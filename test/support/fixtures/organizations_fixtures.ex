defmodule Cocontrol.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cocontrol.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        document_number: "81.877.201/0001-73",
        name: "ACME Corporation"
      })
      |> Cocontrol.Organizations.create_organization()

    organization
  end
end
