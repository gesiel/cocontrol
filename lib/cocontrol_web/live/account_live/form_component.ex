defmodule CocontrolWeb.AccountLive.FormComponent do
  use CocontrolWeb, :live_component

  alias Cocontrol.Accounts
  alias Cocontrol.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage account records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="account-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:org_id]}
          type="select"
          prompt="Select a organization"
          options={@orgs}
          label="Organization"
        />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:bank]} type="text" label="Bank" />
        <.input field={@form[:branch]} type="text" label="Branch" />
        <.input field={@form[:number]} type="text" label="Number" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{account: account, user: user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_account(account))
     end)
     |> assign_new(:orgs, fn ->
       Organizations.list_orgs(user.id) |> Enum.flat_map(fn org -> ["#{org.name}": org.id] end)
     end)}
  end

  @impl true
  def handle_event("validate", %{"account" => account_params}, socket) do
    user = socket.assigns.user

    changeset =
      Accounts.change_account(socket.assigns.account, Map.put(account_params, "user_id", user.id))

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"account" => account_params}, socket) do
    user = socket.assigns.user
    save_account(socket, socket.assigns.action, Map.put(account_params, "user_id", user.id))
  end

  defp save_account(socket, :edit, account_params) do
    case Accounts.update_account(socket.assigns.account, account_params) do
      {:ok, account} ->
        notify_parent({:saved, account})

        {:noreply,
         socket
         |> put_flash(:info, "Account updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_account(socket, :new, account_params) do
    case Accounts.create_account(account_params) do
      {:ok, account} ->
        notify_parent({:saved, account})

        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
