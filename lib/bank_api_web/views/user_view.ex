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

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      account: %{id: user.accounts.id, balance: user.accounts.balance}
    }
  end
end
