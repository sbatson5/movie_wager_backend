defmodule MovieWagerBackend.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(MovieWagerBackend.Repo, []),
      supervisor(MovieWagerBackendWeb.Endpoint, []),
      worker(MovieWagerBackend.BoxOfficeCollector, [])
    ]

    opts = [strategy: :one_for_one, name: MovieWagerBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    MovieWagerBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
