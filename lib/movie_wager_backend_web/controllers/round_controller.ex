defmodule MovieWagerBackendWeb.RoundController do
  use MovieWagerBackendWeb, :controller

  alias MovieWagerBackend.Movie
  alias MovieWagerBackend.Movie.Round

  action_fallback MovieWagerBackendWeb.FallbackController

  def index(conn, _params) do
    rounds = Movie.list_rounds()
    render(conn, "index.json-api", data: rounds)
  end

  def create(conn, %{"data" =>  %{"attributes" => round_params}}) do
    with {:ok, %Round{} = round} <- Movie.create_round(round_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", round_path(conn, :show, round))
      |> render("show.json-api", data: round)
    end
  end

  def show(conn, %{"id" => id}) do
    round = Movie.get_round!(id)
    render(conn, "show.json-api", data: round)
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Movie.get_round!(id)

    with {:ok, %Round{} = round} <- Movie.update_round(round, round_params) do
      render(conn, "show.json-api", data: round)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Movie.get_round!(id)
    with {:ok, %Round{}} <- Movie.delete_round(round) do
      send_resp(conn, :no_content, "")
    end
  end
end
