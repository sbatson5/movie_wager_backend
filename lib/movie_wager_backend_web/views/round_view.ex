defmodule MovieWagerBackendWeb.RoundView do
  use MovieWagerBackendWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :code,
    :start_date,
    :end_date,
    :box_office_amount,
    :title,
    :poster,
    :plot,
    :website
  ]
end
