defmodule BankApi.Accounts.User do
  @moduledoc """
  Provides schema from `user`.
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
  Changesets allow filtering, casting, validation and definition of constraints when manipulating structs.

  ## Examples

      iex> User.changeset(%User{}, %{email: "JHoni@sousa", name: "jhoni",
      last_name: "sousa", password: "123", password_confirmation: "123"})
      #Ecto.Changeset<
      action: nil,
      changes: %{
        email: "jhoni@sousa",
        last_name: "sousa",
        name: "jhoni",
        password: "123",
        password_confirmation: "123",
        password_hash: "$argon2id$v=19$m=131072,t=8,p=4$hjFlb9SKys+UhCuDePppIA$KskjM3MbTC5Q/s/ZwotujYCYwVz6oMfBc4qOHeqpMTM"
      },
      errors: [],
      data: #BankApi.Accounts.User<>,
      valid?: true
      >

  ## Examples
    Insert value into `users` tables.
      iex> user = User.changeset(%User{}, %{email: "JHoni@sousa", name: "jhoni",
      last_name: "sousa", password: "123", password_confirmation: "123"})

      iex> BankApi.Repo.insert!(user)
      %BankApi.Accounts.User{
      __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
      email: "jhoni@sousa",
      id: "e0c4ba79-6a02-4ab9-97f6-c09f903091d1",
      inserted_at: ~N[2020-07-25 20:58:01],
      last_name: "sousa",
      name: "jhoni",
      password: "123",
      password_confirmation: "123",
      password_hash: "$argon2id$v=19$m=131072,t=8,p=4$hjFlb9SKys+UhCuDePppIA$KskjM3MbTC5Q/s/ZwotujYCYwVz6oMfBc4qOHeqpMTM",
      role: "user",
      updated_at: ~N[2020-07-25 20:58:01]}

  ## Example
    Return data from database.
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
