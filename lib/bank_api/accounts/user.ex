defmodule BankApi.Accounts.User do
  @moduledoc """
    Module user
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string

    timestamps()
  end

  def changeset() do
  end
end
