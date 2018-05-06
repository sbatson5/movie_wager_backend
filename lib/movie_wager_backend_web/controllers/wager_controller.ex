defmodule MovieWagerBackendWeb.WagerController do
  use MovieWagerBackendWeb, :controller

  alias MovieWagerBackend.Movie
  alias MovieWagerBackend.Movie.Wager

  action_fallback MovieWagerBackendWeb.FallbackController

  def index(conn, %{"user_id" => google_id, "round_id" => round_id}) do
    wagers = Movie.list_wagers_by_user_and_round(google_id, round_id)
    render(conn, "index.json-api", data: wagers)
  end

  def index(conn, %{"round_id" => round_id}) do
    wagers = Movie.list_wagers_by_round(round_id)
    render(conn, "index.json-api", data: wagers)
  end

  def index(conn, %{"place" => place}) do
    wagers = Movie.list_wagers_by_place(place)
    render(conn, "index.json-api", data: wagers)
  end

  def create(conn, %{"data" => %{"attributes" => wager_params, "relationships" => relationship_params}}) do
    case Movie.create_wager(wager_params, relationship_params) do
      {:ok, %Wager{} = wager} ->
        wager = Movie.preload_wager_relationships(wager)
        conn
        |> put_status(:created)
        |> put_resp_header("location", wager_path(conn, :show, wager))
        |> render("show.json-api", data: wager)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wager = Movie.get_wager!(id)
    render(conn, "show.json-api", data: wager)
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => wager_params, "relationships" => relationship_params}}) do
    wager = Movie.get_wager!(id)

    case Movie.update_wager(wager, wager_params, relationship_params) do
      {:ok, %Wager{} = wager} ->
        wager = Movie.preload_wager_relationships(wager)
        render(conn, "show.json-api", data: wager)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wager = Movie.get_wager!(id)
    with {:ok, %Wager{}} <- Movie.delete_wager(wager) do
      send_resp(conn, :no_content, "")
    end
  end
end
