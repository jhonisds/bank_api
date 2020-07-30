defmodule BankApiWeb.OperationView do
  use BankApiWeb, :view

  def render("success.json", %{message: message}) do
    IO.inspect(message)

    %{
      message: message
    }
  end
end
