defmodule MovieWagerBackendWeb.UserView do
  use MovieWagerBackendWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :family_name,
    :gender,
    :given_name,
    :locale,
    :name,
    :picture,
    :verified_email,
    :google_id
  ]
end
