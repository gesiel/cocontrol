defmodule CocontrolWeb.OrganizationLiveTest do
  use CocontrolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cocontrol.AuthFixtures
  import Cocontrol.OrganizationsFixtures

  @create_attrs %{name: "Organization", document_number: "08.116.330/0001-59"}
  @update_attrs %{name: "Updated Organization", document_number: "11.063.347/0001-08"}
  @invalid_attrs %{name: nil, document_number: nil}

  defp login_user(%{conn: conn}) do
    %{conn: log_in_user(conn, user_fixture())}
  end

  defp create_organization(%{conn: conn}) do
    organization = organization_fixture()
    %{conn: conn, organization: organization}
  end

  describe "Index" do
    setup [:login_user, :create_organization]

    test "lists all orgs", %{conn: conn, organization: organization} do
      {:ok, _index_live, html} = live(conn, ~p"/orgs")

      assert html =~ "Listing Orgs"
      assert html =~ organization.name
    end

    test "saves new organization", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/orgs")

      assert index_live |> element("a", "New Organization") |> render_click() =~
               "New Organization"

      assert_patch(index_live, ~p"/orgs/new")

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#organization-form", organization: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/orgs")

      html = render(index_live)
      assert html =~ "Organization created successfully"
      assert html =~ @create_attrs.name
    end

    test "updates organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, ~p"/orgs")

      assert index_live |> element("#orgs-#{organization.id} a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(index_live, ~p"/orgs/#{organization}/edit")

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#organization-form", organization: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/orgs")

      html = render(index_live)
      assert html =~ "Organization updated successfully"
      assert html =~ @update_attrs.name
    end

    test "deletes organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, ~p"/orgs")

      assert index_live |> element("#orgs-#{organization.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#orgs-#{organization.id}")
    end
  end

  describe "Show" do
    setup [:login_user, :create_organization]

    test "displays organization", %{conn: conn, organization: organization} do
      {:ok, _show_live, html} = live(conn, ~p"/orgs/#{organization}")

      assert html =~ "Show Organization"
      assert html =~ organization.name
    end

    test "updates organization within modal", %{conn: conn, organization: organization} do
      {:ok, show_live, _html} = live(conn, ~p"/orgs/#{organization}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(show_live, ~p"/orgs/#{organization}/show/edit")

      assert show_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#organization-form", organization: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/orgs/#{organization}")

      html = render(show_live)
      assert html =~ "Organization updated successfully"
      assert html =~ @update_attrs.name
    end
  end
end
