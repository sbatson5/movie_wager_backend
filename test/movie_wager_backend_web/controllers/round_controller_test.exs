defmodule MovieWagerBackendWeb.RoundControllerTest do
  use MovieWagerBackendWeb.ConnCase

  alias MovieWagerBackend.Movie
  alias MovieWagerBackend.Movie.Round

  @create_attrs %{box_office_amount: 42, code: "some code", end_date: ~D[2010-04-17], start_date: ~D[2010-04-17], title: "some title"}
  @update_attrs %{box_office_amount: 43, code: "some updated code", end_date: ~D[2011-05-18], start_date: ~D[2011-05-18], title: "some updated title"}
  @invalid_attrs %{box_office_amount: nil, code: nil, end_date: nil, start_date: nil, title: nil}

  def fixture(:round) do
    {:ok, round} = Movie.create_round(@create_attrs)
    round
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rounds", %{conn: conn} do
      conn = get conn, round_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create round" do
    test "renders round when data is valid", %{conn: conn} do
      conn = post conn, round_path(conn, :create), round: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, round_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "box_office_amount" => 42,
        "code" => "some code",
        "end_date" => ~D[2010-04-17],
        "start_date" => ~D[2010-04-17],
        "title" => "some title"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, round_path(conn, :create), round: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update round" do
    setup [:create_round]

    test "renders round when data is valid", %{conn: conn, round: %Round{id: id} = round} do
      conn = put conn, round_path(conn, :update, round), round: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, round_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "box_office_amount" => 43,
        "code" => "some updated code",
        "end_date" => ~D[2011-05-18],
        "start_date" => ~D[2011-05-18],
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, round: round} do
      conn = put conn, round_path(conn, :update, round), round: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete round" do
    setup [:create_round]

    test "deletes chosen round", %{conn: conn, round: round} do
      conn = delete conn, round_path(conn, :delete, round)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, round_path(conn, :show, round)
      end
    end
  end

  defp create_round(_) do
    round = fixture(:round)
    {:ok, round: round}
  end
end
