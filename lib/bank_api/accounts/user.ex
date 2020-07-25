defmodule BankApi.Accounts.User do
  @moduledoc """
  Schema User.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string
    field :name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "user"

    timestamps()
  end

  @doc """
  Use changest to validate `BankApi.Accounts.User` as: User.

  ## Examples

    iex> User.changeset(%User{}, %{email: "JHoni@sousa", name: "jhoni", last_name: "sousa", password: "123", password_confirmation: "123"})

  Insert value into users tables.

  ## Examples
    user = User.changeset(%User{}, %{email: "JHoni@sousa", name: "jhoni", last_name: "sousa", password: "123", password_confirmation: "123"})
    iexs> BankApi.Repo.insert!(user)

  Returns data from table.

  ## Example
    iex> BankApi.Repo.all(User)

  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> validate_required([
      :email,
      :name,
      :last_name,
      :password,
      :password_confirmation,
      :role
    ])
    |> validate_format(:email, ~r/@/, message: "Email format invalid.")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 3, max: 6, message: "Password lenght between 3 and 6.")
    |> validate_confirmation(:password, message: "Password should be the same.")
    |> unique_constraint(:email, message: "Email aready exist.")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
