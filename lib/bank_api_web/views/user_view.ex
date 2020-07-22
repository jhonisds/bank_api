defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("user.json", %{user: user}) do
    IO.inspect(user)
    user
  end
end
