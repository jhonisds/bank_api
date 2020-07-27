defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("account.json", %{user: user, account: account}) do
    # IO.inspect(account, label: "[VIEW]")

    %{
      balance: account.balance,
      account_id: account.id,
      user: %{
        email: user.email,
        name: user.name,
        last_name: user.last_name,
        role: user.role,
        id: user.id
      }
    }
  end
end
