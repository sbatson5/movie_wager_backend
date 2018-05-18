defmodule MovieWagerBackend.Movie.OMDB do
  import Ecto.Query, warn: false

  alias MovieWagerBackend.Repo
  alias MovieWagerBackend.Movie
  alias MovieWagerBackend.Movie.Round

  def update_round_with_metadata(%Round{} = round) do
    case get_movie_information(round) do
      attrs = %{"plot" => _} ->
        Movie.update_round(round, attrs)
      _ ->
        nil
    end
  end

  def get_movie_information(%Round{} = round), do: get_movie_information(round.title)
  def get_movie_information(title) do
    title
    |> build_omdb_url()
    |> HTTPoison.get()
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        metadata = Poison.decode!(body)
        %{
          "plot" => Map.get(metadata, "Plot"),
          "poster" => Map.get(metadata, "Poster"),
          "website" => Map.get(metadata, "Website")
        }
      _ ->
        %{}
    end
  end

  defp build_omdb_url(title) do
    title =
      title
      |> String.replace("The ", "")
      |> URI.encode_www_form()
    omdb_api_key = Application.get_env(:movie_wager_backend, :omdbapi)[:api_key]
    year = DateTime.utc_now |> Map.fetch!(:year)
    "http://www.omdbapi.com/?apikey=#{omdb_api_key}&t=#{title}&y=#{year}"
  end
end
