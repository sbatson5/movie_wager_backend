defmodule MovieWagerBackendWeb.Router do
  use MovieWagerBackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :json_api do
    plug :accepts, ["json-api"]
    plug :fetch_session
    plug JaSerializer.Deserializer
  end

  # Other scopes may use custom stacks.
  scope "/api", MovieWagerBackendWeb do
    pipe_through :json_api
    resources "/rounds", RoundController
    resources "/wagers", WagerController
    resources "/auth", UserController, only: [:create]
    get "/session", UserController, :show_session
    delete "/session", UserController, :delete_session
  end
end
