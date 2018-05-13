defmodule MovieWagerBackend.Movie.Round do
  use Ecto.Schema
  import Ecto.Changeset
  alias MovieWagerBackend.Movie.{BoxofficeMojo,Round,OMDB}

  schema "rounds" do
    field :box_office_amount, :integer
    field :code, :string
    field :end_date, :date
    field :title, :string
    field :plot, :string
    field :poster, :string
    field :website, :string

    timestamps()
  end

  @doc false
  def changeset(%Round{} = round, attrs) do
    title = Map.get(attrs, "title") || round.title
    code = Map.get(attrs, "code") || round.code
    attrs =
      attrs
      |> Map.merge(OMDB.get_movie_information(title))
      |> Map.merge(BoxofficeMojo.fetch_release_date(code))

    round
    |> cast(attrs, [:code, :end_date, :box_office_amount, :title, :plot, :poster, :website])
    |> validate_required([:code, :end_date, :title])
  end
end
