defmodule BankApi.Accounts.Account do
  @moduledoc """
  Provides schema from `accounts`.
    * balance
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BankApi.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type Ecto.UUID
  schema "accounts" do
    field :balance, :decimal, precision: 10, scale: 2, default: 1000
    belongs_to :user, User

    timestamps()
  end

  @doc """
    Validate Changesets for Accounts.

  ## Examples
      iex(1)> BankApi.Accounts.Account.changeset(%Account{})
      #Ecto.Changeset<action: nil, changes: %{}, errors: [],
      data: #BankApi.Accounts.Account<>, valid?: true>
  """
  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end
