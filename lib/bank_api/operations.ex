defmodule BankApi.Operations do
  @moduledoc """
    Module operations
  """

  alias BankApi.{Accounts, Accounts.Account}
  alias BankApi.Repo

  def transfer(f_id, t_id, value) do
    from = Accounts.get!(f_id)
  end
end
