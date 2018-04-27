defmodule MovieWagerBackendWeb.ErrorView do
  use MovieWagerBackendWeb, :view

  alias JaSerializer.ErrorSerializer

  def render("404.json-api", _assigns) do
    %{title: "Not Found", code: 404}
    |> ErrorSerializer.format()
  end

  def render("500.json-api", _assigns) do
    %{title: "Internal Server Error", code: 500}
    |> ErrorSerializer.format()
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_, assigns) do
    render "500.json-api", assigns
  end
end
