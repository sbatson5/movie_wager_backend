defmodule MovieWagerBackendWeb.RoundView do
  use MovieWagerBackendWeb, :view
  use JaSerializer.PhoenixView

  import MovieWagerBackend.Movie

  attributes [
    :code,
    :start_date,
    :end_date,
    :box_office_amount,
    :title,
    :poster,
    :plot,
    :website,
    :highest_wager,
    :lowest_wager,
    :number_of_wagers
  ]

  def highest_wager(%{id: round_id}, _conn) do
    case MovieWagerBackend.Movie.get_highest_wager_by_round(round_id) do
      nil -> nil
      wager -> wager.amount
    end
  end

  def lowest_wager(%{id: round_id}, _conn) do
    case MovieWagerBackend.Movie.get_lowest_wager_by_round(round_id) do
      nil -> nil
      wager -> wager.amount
    end
  end

  def number_of_wagers(%{id: round_id}, _conn) do
    get_number_of_wagers_by_round(round_id)
  end
end
