defmodule CocontrolWeb.OrganizationLive.FormComponent do
  use CocontrolWeb, :live_component

  alias Cocontrol.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage organization records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="organization-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:document_number]} type="text" label="Document number" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Organization</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{organization: organization} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Organizations.change_organization(organization))
     end)}
  end

  @impl true
  def handle_event("validate", %{"organization" => organization_params}, socket) do
    user = socket.assigns.user

    changeset =
      Organizations.change_organization(
        socket.assigns.organization,
        Map.put(organization_params, "user_id", user.id)
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"organization" => organization_params}, socket) do
    user = socket.assigns.user

    save_organization(
      socket,
      socket.assigns.action,
      Map.put(organization_params, "user_id", user.id)
    )
  end

  defp save_organization(socket, :edit, organization_params) do
    case Organizations.update_organization(socket.assigns.organization, organization_params) do
      {:ok, organization} ->
        notify_parent({:saved, organization})

        {:noreply,
         socket
         |> put_flash(:info, "Organization updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_organization(socket, :new, organization_params) do
    case Organizations.create_organization(organization_params) do
      {:ok, organization} ->
        notify_parent({:saved, organization})

        {:noreply,
         socket
         |> put_flash(:info, "Organization created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
