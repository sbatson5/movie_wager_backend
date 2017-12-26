defmodule MovieWagerBackend.Movie.Round do
  use Ecto.Schema
  import Ecto.Changeset
  alias MovieWagerBackend.Movie.Round

  schema "rounds" do
    field :box_office_amount, :integer
    field :code, :string
    field :end_date, :date
    field :start_date, :date
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Round{} = round, attrs) do
    round
    |> cast(attrs, [:code, :start_date, :end_date, :box_office_amount, :title])
    |> validate_required([:code, :start_date, :end_date, :title])
  end
end
