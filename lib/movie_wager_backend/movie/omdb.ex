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

  defp get_movie_information(%Round{} = round) do
    round
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
        nil
    end
  end

  defp build_omdb_url(%Round{} = round) do
    title = URI.encode_www_form(round.title)
    omdb_api_key = Application.get_env(:movie_wager_backend, :omdbapi)[:api_key]
    "http://www.omdbapi.com/?apikey#{omdb_api_key}=&t=#{title}"
  end
end
