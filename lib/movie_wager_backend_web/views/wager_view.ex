defmodule MovieWagerBackendWeb.WagerView do
  use MovieWagerBackendWeb, :view
  use JaSerializer.PhoenixView

  attributes [:amount, :place]

  has_one :user,
    include: true,
    serializer: MovieWagerBackendWeb.UserView

  has_one :round,
    include: true,
    serializer: MovieWagerBackendWeb.RoundView
end
