defmodule MovieWagerBackendWeb.PageController do
  use MovieWagerBackendWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
