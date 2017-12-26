defmodule MovieWagerBackend.MovieTest do
  use MovieWagerBackend.DataCase

  alias MovieWagerBackend.Movie

  describe "rounds" do
    alias MovieWagerBackend.Movie.Round

    @valid_attrs %{box_office_amount: 42, code: "some code", end_date: ~D[2010-04-17], start_date: ~D[2010-04-17], title: "some title"}
    @update_attrs %{box_office_amount: 43, code: "some updated code", end_date: ~D[2011-05-18], start_date: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{box_office_amount: nil, code: nil, end_date: nil, start_date: nil, title: nil}

    def round_fixture(attrs \\ %{}) do
      {:ok, round} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Movie.create_round()

      round
    end

    test "list_rounds/0 returns all rounds" do
      round = round_fixture()
      assert Movie.list_rounds() == [round]
    end

    test "get_round!/1 returns the round with given id" do
      round = round_fixture()
      assert Movie.get_round!(round.id) == round
    end

    test "create_round/1 with valid data creates a round" do
      assert {:ok, %Round{} = round} = Movie.create_round(@valid_attrs)
      assert round.box_office_amount == 42
      assert round.code == "some code"
      assert round.end_date == ~D[2010-04-17]
      assert round.start_date == ~D[2010-04-17]
      assert round.title == "some title"
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movie.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      round = round_fixture()
      assert {:ok, round} = Movie.update_round(round, @update_attrs)
      assert %Round{} = round
      assert round.box_office_amount == 43
      assert round.code == "some updated code"
      assert round.end_date == ~D[2011-05-18]
      assert round.start_date == ~D[2011-05-18]
      assert round.title == "some updated title"
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = round_fixture()
      assert {:error, %Ecto.Changeset{}} = Movie.update_round(round, @invalid_attrs)
      assert round == Movie.get_round!(round.id)
    end

    test "delete_round/1 deletes the round" do
      round = round_fixture()
      assert {:ok, %Round{}} = Movie.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Movie.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = round_fixture()
      assert %Ecto.Changeset{} = Movie.change_round(round)
    end
  end

  describe "wagers" do
    alias MovieWagerBackend.Movie.Wager

    @valid_attrs %{amount: 42, place: 42}
    @update_attrs %{amount: 43, place: 43}
    @invalid_attrs %{amount: nil, place: nil}

    def wager_fixture(attrs \\ %{}) do
      {:ok, wager} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Movie.create_wager()

      wager
    end

    test "list_wagers/0 returns all wagers" do
      wager = wager_fixture()
      assert Movie.list_wagers() == [wager]
    end

    test "get_wager!/1 returns the wager with given id" do
      wager = wager_fixture()
      assert Movie.get_wager!(wager.id) == wager
    end

    test "create_wager/1 with valid data creates a wager" do
      assert {:ok, %Wager{} = wager} = Movie.create_wager(@valid_attrs)
      assert wager.amount == 42
      assert wager.place == 42
    end

    test "create_wager/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movie.create_wager(@invalid_attrs)
    end

    test "update_wager/2 with valid data updates the wager" do
      wager = wager_fixture()
      assert {:ok, wager} = Movie.update_wager(wager, @update_attrs)
      assert %Wager{} = wager
      assert wager.amount == 43
      assert wager.place == 43
    end

    test "update_wager/2 with invalid data returns error changeset" do
      wager = wager_fixture()
      assert {:error, %Ecto.Changeset{}} = Movie.update_wager(wager, @invalid_attrs)
      assert wager == Movie.get_wager!(wager.id)
    end

    test "delete_wager/1 deletes the wager" do
      wager = wager_fixture()
      assert {:ok, %Wager{}} = Movie.delete_wager(wager)
      assert_raise Ecto.NoResultsError, fn -> Movie.get_wager!(wager.id) end
    end

    test "change_wager/1 returns a wager changeset" do
      wager = wager_fixture()
      assert %Ecto.Changeset{} = Movie.change_wager(wager)
    end
  end
end
