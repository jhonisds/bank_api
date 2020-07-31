defmodule BankApi.Operations do
  @moduledoc """
    Module operations
  """

  alias BankApi.{Accounts, Accounts.Account}
  # alias BankApi.Accounts.Account
  alias BankApi.Repo

  def transfer(f_id, t_id, value) do
    from = Accounts.get!(f_id)
    value = Decimal.new(value)

    case is_negative?(from.balance, value) do
      true ->
        {:error, "you can't have negative balance"}

      false ->
        perform_update(from, t_id, value)
    end
  end

  def is_negative?(from_balance, value) do
    Decimal.sub(from_balance, value)
    |> Decimal.negative?()
  end

  def perform_update(from, t_id, value) do
    {:ok, from} = perform_operation(from, value, :sub)

    {:ok, to} =
      Accounts.get!(t_id)
      |> perform_operation(value, :sum)

    {:ok, "Transfer with success! from: #{from.id} to: #{to.id} value: #{value}"}
  end

  def perform_operation(account, value, :sum) do
    account
    |> update_account(%{balance: Decimal.add(account.balance, value)})
  end

  def perform_operation(account, value, :sub) do
    account
    |> update_account(%{balance: Decimal.sub(account.balance, value)})
  end

  def update_account(%Account{} = account, attrs) do
    Account.changeset(account, attrs)
    |> Repo.update()
  end
end
