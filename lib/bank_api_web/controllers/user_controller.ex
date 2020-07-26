defmodule BankApiWeb.UserController do
  @moduledoc """
    This module defines the user access.
  """
  use BankApiWeb, :controller

  alias BankApi.Accounts

  def signup(conn, %{"user" => user}) do
    {:ok, account} = Accounts.create_user(user)

    conn
    |> put_status(:created)
    |> render("account.json", %{account: account})
  end
end
