defmodule MovieWagerBackend.Movie.BoxofficeMojo do
  import Ecto.Query, warn: false

  alias MovieWagerBackend.Repo
  alias MovieWagerBackend.Movie
  alias MovieWagerBackend.Movie.Round

  def update_rounds_without_amounts() do
    unfinished_rounds = Repo.all(from r in Round,
      where: is_nil(r.box_office_amount))

    rounds = Enum.filter(unfinished_rounds, fn(round) ->
      today = DateTime.utc_now()
      end_of_weekend = Date.add(round.end_date, 3)
      Date.compare(end_of_weekend, today) == :lt
    end)

    Enum.each(rounds, fn(round) ->
      update_round_with_boxoffice(round)
    end)
  end

  defp update_round_with_boxoffice(%Round{} = round) do
    case get_boxoffice_dom(round) do
      nil ->
        nil
      box_office_amount ->
        {:ok, round} = Movie.update_round(round, %{"box_office_amount" => box_office_amount})
        set_wager_positions(round)
    end
  end

  defp set_wager_positions(%Round{box_office_amount: box_office_amount, id: round_id}) do
    Movie.list_wagers_by_round(round_id)
    |> Enum.sort(&(abs(box_office_amount - &1.amount) <= abs(box_office_amount - &2.amount)))
    |> Stream.with_index()
    |> Enum.each(fn({wager, index}) ->
      Movie.update_wager(wager, %{"place" => index + 1})
    end)
  end

  defp get_boxoffice_dom(%Round{} = round) do
    round
    |> get_movie_url()
    |> HTTPoison.get()
    |> case do
      {:ok, response} ->
        find_weekend_amount_node(response.body)
      _ ->
        nil
    end
  end

  defp get_movie_url(%Round{code: code}) do
    box_office_domain = "http://www.boxofficemojo.com/movies/"
    "#{box_office_domain}?page=weekend&id=#{code}.htm&sort=weeknum&order=ASC&p=.htm"
  end

  defp find_weekend_amount_node(body) do
    Floki.find(body, ".chart-wide td[align='right']")
    |> Enum.at(0)
    |> case do
      nil ->
        nil
      node ->
        Floki.text(node)
        |> cleanup_amount()
    end
  end

  defp cleanup_amount(amount) do
    amount
    |> String.replace("$", "")
    |> String.replace(",", "")
  end
end
