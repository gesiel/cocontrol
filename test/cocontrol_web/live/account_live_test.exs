defmodule CocontrolWeb.AccountLiveTest do
  use CocontrolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cocontrol.AuthFixtures
  import Cocontrol.OrganizationsFixtures
  import Cocontrol.AccountsFixtures

  @create_attrs %{
    name: "Account name",
    number: "1234-5",
    branch: "321-0",
    bank: "Bank name"
  }
  @update_attrs %{
    name: "Another account name",
    number: "5432-1",
    branch: "1012-3",
    bank: "Another bank name"
  }
  @invalid_attrs %{name: nil, number: nil, branch: nil, bank: nil}

  defp create_account(%{conn: conn}) do
    user = user_fixture()
    organization = organization_fixture(%{user_id: user.id})
    account = account_fixture(%{user_id: user.id, org_id: organization.id})
    %{conn: log_in_user(conn, user), account: account, user: user, org: organization}
  end

  describe "Index" do
    setup [:create_account]

    test "lists all accounts", %{conn: conn, account: account} do
      user = user_fixture()
      organization = organization_fixture(%{user_id: user.id})

      another_account =
        account_fixture(%{user_id: user.id, org_id: organization.id, name: "Another name"})

      {:ok, _index_live, html} = live(conn, ~p"/accounts")

      assert html =~ "Listing Accounts"
      assert html =~ account.name
      refute html =~ another_account.name
    end

    test "saves new account", %{conn: conn, org: org} do
      {:ok, index_live, _html} = live(conn, ~p"/accounts")

      assert index_live |> element("a", "New Account") |> render_click() =~
               "New Account"

      assert_patch(index_live, ~p"/accounts/new")

      assert index_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      create_attrs = @create_attrs |> Map.put("org_id", org.id)

      assert index_live
             |> form("#account-form", account: create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/accounts")

      html = render(index_live)
      assert html =~ "Account created successfully"
      assert html =~ create_attrs.name
    end

    test "updates account in listing", %{conn: conn, account: account, org: org} do
      {:ok, index_live, _html} = live(conn, ~p"/accounts")

      assert index_live |> element("#accounts-#{account.id} a", "Edit") |> render_click() =~
               "Edit Account"

      assert_patch(index_live, ~p"/accounts/#{account}/edit")

      assert index_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs = @update_attrs |> Map.put("org_id", org.id)

      assert index_live
             |> form("#account-form", account: update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/accounts")

      html = render(index_live)
      assert html =~ "Account updated successfully"
      assert html =~ update_attrs.name
    end

    test "deletes account in listing", %{conn: conn, account: account} do
      {:ok, index_live, _html} = live(conn, ~p"/accounts")

      assert index_live |> element("#accounts-#{account.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#accounts-#{account.id}")
    end
  end

  describe "Show" do
    setup [:create_account]

    test "displays account", %{conn: conn, account: account} do
      {:ok, _show_live, html} = live(conn, ~p"/accounts/#{account}")

      assert html =~ "Show Account"
      assert html =~ account.name
    end

    test "updates account within modal", %{conn: conn, account: account, org: org} do
      {:ok, show_live, _html} = live(conn, ~p"/accounts/#{account}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Account"

      assert_patch(show_live, ~p"/accounts/#{account}/show/edit")

      assert show_live
             |> form("#account-form", account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      update_attrs = @update_attrs |> Map.put("org_id", org.id)

      assert show_live
             |> form("#account-form", account: update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/accounts/#{account}")

      html = render(show_live)
      assert html =~ "Account updated successfully"
      assert html =~ update_attrs.name
    end
  end
end
