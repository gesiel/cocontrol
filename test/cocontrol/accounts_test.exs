defmodule Cocontrol.AccountsTest do
  use Cocontrol.DataCase

  alias Cocontrol.Accounts

  describe "accounts" do
    alias Cocontrol.Accounts.Account

    import Cocontrol.AccountsFixtures
    import Cocontrol.AuthFixtures
    import Cocontrol.OrganizationsFixtures

    @invalid_attrs %{name: nil, number: nil, branch: nil, bank: nil}

    setup _ do
      user = user_fixture()
      org = organization_fixture(%{user_id: user.id})
      %{user: user, org: org}
    end

    test "list_accounts/0 returns all accounts", %{user: user, org: org} do
      account = account_fixture(%{user_id: user.id, org_id: org.id})
      assert Accounts.list_accounts(user.id) == [account]
    end

    test "get_account!/1 returns the account with given id", %{user: user, org: org} do
      account = account_fixture(%{user_id: user.id, org_id: org.id})
      assert Accounts.get_account!(account.id) == account
    end

    test "get_account!/2 returns the account with given id for the given user id", %{
      user: user,
      org: org
    } do
      account = account_fixture(%{user_id: user.id, org_id: org.id})
      assert Accounts.get_account!(account.id, user.id) == account
    end

    test "create_account/1 with valid data creates a account", %{user: user, org: org} do
      valid_attrs = %{
        name: "Account name",
        user_id: user.id,
        org_id: org.id
      }

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.name == valid_attrs.name
      assert account.number == nil
      assert account.branch == nil
      assert account.bank == nil
      assert account.user_id == user.id
      assert account.org_id == org.id
    end

    test "create_account/1 with valid data and all fields creates a account", %{
      user: user,
      org: org
    } do
      valid_attrs = %{
        name: "Account name",
        user_id: user.id,
        org_id: org.id,
        bank: "Bank name",
        branch: "123-0",
        number: "321-1"
      }

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.name == valid_attrs.name
      assert account.number == valid_attrs.number
      assert account.branch == valid_attrs.branch
      assert account.bank == valid_attrs.bank
      assert account.user_id == user.id
      assert account.org_id == org.id
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account", %{user: user, org: org} do
      account = account_fixture(%{user_id: user.id, org_id: org.id})

      update_attrs = %{
        name: "Another account name",
        bank: "Another bank name",
        branch: "321-0",
        number: "567-8"
      }

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.name == update_attrs.name
      assert account.number == update_attrs.number
      assert account.branch == update_attrs.branch
      assert account.bank == update_attrs.bank
    end

    test "update_account/2 with invalid data returns error changeset", %{user: user, org: org} do
      account = account_fixture(%{user_id: user.id, org_id: org.id})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account", %{user: user, org: org} do
      account = account_fixture(%{user_id: user.id, org_id: org.id})
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset", %{user: user, org: org} do
      account = account_fixture(%{user_id: user.id, org_id: org.id})
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
