defmodule Cocontrol.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cocontrol.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        name: "Account name",
        bank: "Bank name",
        branch: "123-0",
        number: "456-7"
      })
      |> Cocontrol.Accounts.create_account()

    account
  end
end
