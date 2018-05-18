# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :movie_wager_backend,
  ecto_repos: [MovieWagerBackend.Repo]

# Configures the endpoint
config :movie_wager_backend, MovieWagerBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MEOjlJ6NIw4lBuG4K62+kn/kHdPDH5vyfWn9IqdddQb0edOx2EOvOLaACe88yBDq",
  render_errors: [view: MovieWagerBackendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MovieWagerBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :movie_wager_backend, :google,
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :movie_wager_backend, :omdbapi,
  api_key: System.get_env("OMDB_API_KEY")

config :phoenix, :format_encoders,
  "json-api": Poison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
