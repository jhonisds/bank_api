defmodule BankApiWeb.OperationController do
  @moduledoc """
  This module controll transfers of value between accounts.
  """
  use BankApiWeb, :controller

  alias BankApiWeb.Operation

  action_fallback BankApiWeb.FallbackController

  def transfer(conn, %{"from_account_id" => f_id, "to_account_id" => t_id, "value" => value}) do
    with {:ok, message} <- Operation.transfer(f_id, t_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
