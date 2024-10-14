defmodule CocontrolWeb.OrganizationLive.Index do
  use CocontrolWeb, :live_view

  alias Cocontrol.Organizations
  alias Cocontrol.Organizations.Organization

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :orgs, Organizations.list_orgs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Organization")
    |> assign(:organization, Organizations.get_organization!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Organization")
    |> assign(:organization, %Organization{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orgs")
    |> assign(:organization, nil)
  end

  @impl true
  def handle_info({CocontrolWeb.OrganizationLive.FormComponent, {:saved, organization}}, socket) do
    {:noreply, stream_insert(socket, :orgs, organization)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = Organizations.get_organization!(id)
    {:ok, _} = Organizations.delete_organization(organization)

    {:noreply, stream_delete(socket, :orgs, organization)}
  end
end
