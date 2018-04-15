defmodule MovieWagerBackend.Movie do
  @moduledoc """
  The Movie context.
  """

  import Ecto.Query, warn: false
  alias MovieWagerBackend.Repo

  alias MovieWagerBackend.Movie.Round

  def list_rounds do
    Repo.all(Round)
  end

  def get_round!(id), do: Repo.get!(Round, id)

  def create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
  end

  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  def change_round(%Round{} = round) do
    Round.changeset(round, %{})
  end

  alias MovieWagerBackend.Movie.Wager

  def list_wagers do
    Repo.all(Wager)
  end

  def list_wagers_by_place(place) do
    Wager
    |> Ecto.Query.preload([:user, :round])
    |> where(place: ^place)
    |> Repo.all
  end

  def list_wagers_by_round(round_id) do
    Wager
    |> Ecto.Query.preload([:user, :round])
    |> where(round_id: ^round_id)
    |> Repo.all
  end

  def list_wagers_by_user_and_round(google_id, round_id) do
    user_id = get_user_id(google_id)
    Wager
    |> Ecto.Query.preload([:user, :round])
    |> where(user_id: ^user_id)
    |> where(round_id: ^round_id)
    |> Repo.all
  end

  def get_wager!(id), do: Repo.get!(Wager, id)

  def create_wager(attrs \\ %{}, relationship_params) do
    attrs = get_wager_relationship_ids(relationship_params)
      |> Map.merge(attrs)

    %Wager{}
    |> Wager.changeset(attrs)
    |> Repo.insert()
  end

  def preload_wager_relationships(wager), do: Repo.preload(wager, [:user, :round])

  defp get_wager_relationship_ids(%{"round" => round_params, "user" => user_params}) do
    user_id =
      user_params
      |> get_id()
      |> get_user_id()
    %{
      "user_id" => user_id,
      "round_id" => get_id(round_params)
    }
  end

  def get_wager_relationships_with_local_id(%{"round" => round_params, "user" => user_params}) do
    user_id =
      user_params
      |> get_id()
    %{
      "user_id" => user_id,
      "round_id" => get_id(round_params)
    }
  end

  defp get_id(%{"data" => %{"id" => id}}), do: id
  defp get_id(_), do: nil

  defp get_user_id(google_id) do
    MovieWagerBackend.Google.User
    |> where(google_id: ^google_id)
    |> Repo.one
    |> case do
      user -> user.id
      nil -> {:error, "no record found"}
    end
  end

  def update_wager(%Wager{} = wager, attrs, relationship_params) do
    attrs = get_wager_relationships_with_local_id(relationship_params)
      |> Map.merge(attrs)

    wager
    |> Wager.changeset(attrs)
    |> Repo.update()
  end

  def update_wager(%Wager{} = wager, attrs) do
    wager
    |> Wager.changeset(attrs)
    |> Repo.update()
  end

  def delete_wager(%Wager{} = wager) do
    Repo.delete(wager)
  end

  def change_wager(%Wager{} = wager) do
    Wager.changeset(wager, %{})
  end

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
        {:ok, round} = update_round(round, %{"box_office_amount" => box_office_amount})
        set_wager_positions(round)
    end
  end

  defp set_wager_positions(%Round{box_office_amount: box_office_amount, id: round_id}) do
    list_wagers_by_round(round_id)
    |> Enum.sort(&(abs(box_office_amount - &1.amount) <= abs(box_office_amount - &2.amount)))
    |> Stream.with_index()
    |> Enum.each(fn({wager, index}) ->
      update_wager(wager, %{"place" => index + 1})
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
