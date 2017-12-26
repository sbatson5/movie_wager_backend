defmodule MovieWagerBackend.Google.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias MovieWagerBackend.Google.User

  schema "users" do
    field :family_name, :string
    field :gender, :string
    field :given_name, :string
    field :google_id, :string
    field :locale, :string
    field :name, :string
    field :picture, :string
    field :verified_email, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:family_name, :gender, :given_name, :locale, :name, :picture, :verified_email, :google_id])
    |> validate_required([:google_id])
  end
end
