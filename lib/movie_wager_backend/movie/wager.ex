defmodule MovieWagerBackend.Movie.Wager do
  use Ecto.Schema
  import Ecto.Changeset
  alias MovieWagerBackend.Movie.Wager

  schema "wagers" do
    field :amount, :integer
    field :place, :integer

    belongs_to :round, MovieWagerBackend.Movie.Round
    belongs_to :user, MovieWagerBackend.Google.User

    timestamps()
  end

  @doc false
  def changeset(%Wager{} = wager, attrs) do
    wager
    |> cast(attrs, [:amount, :place, :round_id, :user_id])
    |> validate_required([:amount, :round_id, :user_id])
  end
end
