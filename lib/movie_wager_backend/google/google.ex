defmodule MovieWagerBackend.Google do
  @moduledoc """
  The Google context.
  """

  import Ecto.Query, warn: false
  alias MovieWagerBackend.Repo

  alias MovieWagerBackend.Google.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def fetch_google_credentials(%{"code" => code, "redirect_uri" => redirect_uri, "client_id" => client_id}) do
    google = Application.get_env(:movie_wager_backend, :google)

    request_body = %{
      "code" => code,
      "redirect_uri" => redirect_uri,
      "client_id" => client_id,
      "client_secret" => google[:client_secret],
      "scope" => "",
      "grant_type" => "authorization_code"
    } |> Plug.Conn.Query.encode

    headers = %{
      "Content-Type" => "application/x-www-form-urlencoded",
      "X-Requested-With": "XMLHttpRequest"
    }

    HTTPoison.post("https://accounts.google.com/o/oauth2/token", request_body, headers)
  end

  def fetch_google_credentials(_) do
    {:error, "Missing required parameters"}
  end

  def create_user_from_google(google_id, google_user_info) do
    params = %{
      "family_name" => google_user_info["familyName"],
      "gender" => google_user_info["gender"],
      "given_name" => google_user_info["givenName"],
      "locale" => google_user_info["locale"],
      "name" => google_user_info["name"],
      "picture" => google_user_info["picture"],
      "verified_email" => google_user_info["verifiedEmail"]
    }

    User
    |> where(google_id: ^google_id)
    |> Repo.one()
    |> case do
      nil -> create_new_user(google_id, params)
      user -> update_user(user, params)
    end
  end

  defp create_new_user(google_id, params) do
    params = params |> Map.put("google_id", google_id)

    changeset = User.changeset(%User{}, params)
    Repo.insert(changeset)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
