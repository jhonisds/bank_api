defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("account.json", %{account: account}) do
    IO.inspect(account, label: "[VIEW]")

    %{
      balance: account.balance,
      account_id: account.id,
      users: %{
        email: account.user.email,
        name: account.user.name,
        last_name: account.user.last_name,
        role: account.user.role,
        id: account.user.id
      }
    }
  end
end
