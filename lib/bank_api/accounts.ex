defmodule BankApi.Accounts do
  @moduledoc """
  This module provides context for accounts.
  """
  alias BankApi.Repo
  alias BankApi.Accounts.{Account, User}

  @doc """
  This function is responsible to create a new user.

  ## Examples
      iex(3)> Accounts.create_user %{email: "JHONI@sds.com", name: "jhoni", last_name: "Santos", password: "123", password_confirmation: "123"}
      {:ok,
      %BankApi.Accounts.Account{
        __meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
        balance: 1000,
        id: "2a96e0ea-5a8c-4531-a4f0-1b78d0d0fe85",
        inserted_at: ~N[2020-07-26 17:24:40],
        updated_at: ~N[2020-07-26 17:24:40],
        user: #Ecto.Association.NotLoaded<association :user is not loaded>,
        user_id: "6ffd3288-5261-4486-a161-5184d1f3ecbf"
      }}
  """
  def create_user(attrs \\ %{}) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, insert_user(attrs))
      |> Ecto.Multi.insert(:account, fn %{user: user} ->
        user
        |> Ecto.build_assoc(:accounts)
        |> Account.changeset()
      end)
      |> Repo.transaction()

    case transaction do
      {:ok, operations} ->
        {:ok, operations.user, operations.account}

      {:error, :user, changeset, _} ->
        {:error, changeset}
    end
  end

  @doc """
  Insert new user.

  ## Use Ecto to drop database

  * mix `ecto.drop`
  * mix `ecto.setup`
  """
  def insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
  end
end
