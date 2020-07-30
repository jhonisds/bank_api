defmodule BankApiWeb.OperationController do
  @moduledoc """
  This module controll transfers of value between accounts.
  """
  use BankApiWeb, :controller

  def transfer(conn, %{"from_account_id" => f_id, "to_account_id" => t_id, "value" => value}) do
    IO.inspect(t_id)
    IO.inspect(t_id)
    IO.inspect(value)

    conn
    |> render("success.json", message: "transfer executed")
  end
end
