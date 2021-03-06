defmodule BankApi.Operations do
  @moduledoc """
    Module operations
  """

  alias BankApi.{Accounts, Accounts.Account}
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

  def withdraw(f_id, value) do
    from = Accounts.get!(f_id)
    value = Decimal.new(value)

    case is_negative?(from.balance, value) do
      true ->
        {:error, "you can't have negative balance"}

      false ->
        {:ok, from} =
          perform_operation(from, value, :sub)
          |> Repo.update()

        {:ok, "withdraw with success! from: #{from.id}, value #{value}"}
    end
  end

  def is_negative?(from_balance, value) do
    Decimal.sub(from_balance, value)
    |> Decimal.negative?()
  end

  def perform_update(from, t_id, value) do
    to = Accounts.get!(t_id)

    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
      |> Ecto.Multi.update(:account_to, perform_operation(from, value, :sum))
      |> Repo.transaction()

    case transaction do
      {:ok, _} ->
        {:ok, "Transfer with success! from: #{from.id} to: #{to.id} value: #{value}"}

      {:error, :account_from, changeset, _} ->
        {:error, changeset}

      {:error, :account_to, changeset, _} ->
        {:error, changeset}
    end
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
  end
end
