defmodule Cocontrol.OrganizationsTest do
  use Cocontrol.DataCase

  alias Cocontrol.Organizations

  describe "orgs" do
    alias Cocontrol.Organizations.Organization

    import Cocontrol.OrganizationsFixtures

    @invalid_attrs %{name: nil, document_number: nil}

    test "list_orgs/0 returns all orgs" do
      organization = organization_fixture()
      assert Organizations.list_orgs() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{
        document_number: "81.877.201/0001-73",
        name: "ACME Corporation"
      }

      assert {:ok, %Organization{} = organization} =
               Organizations.create_organization(valid_attrs)

      assert organization.name == valid_attrs.name
      assert organization.document_number == valid_attrs.document_number
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{name: "Organization Name", document_number: nil}

      assert {:ok, %Organization{} = organization} =
               Organizations.update_organization(organization, update_attrs)

      assert organization.name == update_attrs.name
      assert organization.document_number == update_attrs.document_number
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organizations.update_organization(organization, @invalid_attrs)

      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end
end
