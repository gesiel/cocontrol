defmodule Cocontrol.OrganizationsTest do
  use Cocontrol.DataCase

  alias Cocontrol.Organizations

  describe "orgs" do
    alias Cocontrol.Organizations.Organization

    import Cocontrol.AuthFixtures
    import Cocontrol.OrganizationsFixtures

    @invalid_attrs %{name: nil, document_number: nil}

    test "list_orgs/1 returns all orgs for the given user_id" do
      user = user_fixture()
      other_user = user_fixture()

      organization = organization_fixture(%{user_id: user.id})
      organization_fixture(%{user_id: other_user.id})

      assert Organizations.list_orgs(user.id) == [organization]
    end

    test "list_orgs/1 returns empty orgs when given user_id has no orgs" do
      user = user_fixture()
      assert Organizations.list_orgs(user.id) == []
    end

    test "get_organization!/1 returns the organization with given id" do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "get_organization!/2 returns the organization with given id for the given user id" do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})
      assert Organizations.get_organization!(organization.id, user.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      user = user_fixture()

      valid_attrs = %{
        user_id: user.id,
        document_number: "81.877.201/0001-73",
        name: "ACME Corporation"
      }

      assert {:ok, %Organization{} = organization} =
               Organizations.create_organization(valid_attrs)

      assert organization.user_id == valid_attrs.user_id
      assert organization.name == valid_attrs.name
      assert organization.document_number == valid_attrs.document_number
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})
      update_attrs = %{name: "Organization Name", document_number: nil}

      assert {:ok, %Organization{} = organization} =
               Organizations.update_organization(organization, update_attrs)

      assert organization.name == update_attrs.name
      assert organization.document_number == update_attrs.document_number
    end

    test "update_organization/2 with invalid data returns error changeset" do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               Organizations.update_organization(organization, @invalid_attrs)

      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end
end
