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

  def get_highest_wager_by_round(round_id) do
    case list_wagers_by_round(round_id) do
      nil -> nil
      wagers ->
        Enum.sort(wagers, &(&1.amount > &2.amount))
        |> List.first()
    end
  end

  def get_lowest_wager_by_round(round_id) do
    case list_wagers_by_round(round_id) do
      nil -> nil
      wagers ->
        Enum.sort(wagers, &(&1.amount < &2.amount))
        |> List.first()
    end
  end

  def get_number_of_wagers_by_round(round_id) do
    round_id
    |> list_wagers_by_round
    |> length()
  end

  def list_wagers_by_user_and_round(user_id, round_id) do
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

  def has_round_expired?(round_id) do
    round = get_round!(round_id)
    now = DateTime.utc_now()
    Date.compare(round.end_date, now) == :lt
  end

  def preload_wager_relationships(wager), do: Repo.preload(wager, [:user, :round])

  defp get_wager_relationship_ids(%{"round" => round_params, "user" => user_params}) do
    %{
      "user_id" => get_id(user_params),
      "round_id" => get_id(round_params)
    }
  end

  defp get_id(%{"data" => %{"id" => id}}), do: id
  defp get_id(_), do: nil

  def update_wager(%Wager{} = wager, attrs, relationship_params) do
    attrs = get_wager_relationship_ids(relationship_params)
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
end
