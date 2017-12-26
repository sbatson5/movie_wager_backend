defmodule MovieWagerBackendWeb.UserController do
  use MovieWagerBackendWeb, :controller

  alias MovieWagerBackend.Google
  alias MovieWagerBackend.Google.User

  action_fallback MovieWagerBackendWeb.FallbackController

  def index(conn, _params) do
    users = Google.list_users()
    render(conn, "index.json-api", users: users)
  end

  def create(conn, google_credentials = %{"code" => code, "redirect_uri" => redirect_uri}) do
    case Google.fetch_google_credentials(google_credentials) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded_body = Poison.decode!(body)
        conn
        |> json(decoded_body)
      {:error, error} -> IO.inspect(error)
    end
  end

  def create(conn, %{"id" => google_id, "user" => google_user_info}) do
    case Google.create_user_from_google(google_id, google_user_info) do
      {:ok, _} ->
        send_resp(conn, 200, "")
      {:error, error} ->
        send_resp(conn, :unprocessable_entity, "")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Google.get_user!(id)
    render(conn, "show.json-api", user: user)
  end
end
