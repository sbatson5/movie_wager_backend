defmodule MovieWagerBackendWeb.UserController do
  use MovieWagerBackendWeb, :controller

  alias MovieWagerBackend.Google
  alias MovieWagerBackend.Google.User

  action_fallback MovieWagerBackendWeb.FallbackController

  def index(conn, _params) do
    users = Google.list_users()
    render(conn, "index.json-api", data: users)
  end

  def create(conn, google_credentials = %{"code" => _, "redirect_uri" => _}) do
    case Google.fetch_google_credentials(google_credentials) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded_body = Poison.decode!(body)
        conn
        |> json(decoded_body)
      {:error, error} -> IO.inspect(error)
    end
  end

  def create(conn, %{"id" => google_id, "user" => google_user_info}) do
    conn = Plug.Conn.put_session(conn, :google_id, google_id)
    case Google.create_user_from_google(google_id, google_user_info) do
      {:ok, _} ->
        send_resp(conn, 200, "{}")
      {:error, error} ->
        send_resp(conn, :unprocessable_entity, error)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Google.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def show_session(conn, _) do
    google_id = Plug.Conn.get_session(conn, :google_id)
    user = Google.get_user_by_google_id(google_id)
    case Google.get_user_by_google_id(google_id) do
      user = %User{} ->
        render(conn, "show.json-api", data: user)
      _ ->
        conn
        |> put_status(:not_found)
        |> render(MovieWagerBackendWeb.ErrorView, :"404")
    end
  end

  def delete_session(conn, _) do
    conn = Plug.Conn.delete_session(conn, :google_id)
    send_resp(conn, 200, "{}")
  end
end
