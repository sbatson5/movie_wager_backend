defmodule MovieWagerBackendWeb.WagerControllerTest do
  use MovieWagerBackendWeb.ConnCase

  alias MovieWagerBackend.Movie
  alias MovieWagerBackend.Movie.Wager

  @create_attrs %{amount: 42, place: 42}
  @update_attrs %{amount: 43, place: 43}
  @invalid_attrs %{amount: nil, place: nil}

  def fixture(:wager) do
    {:ok, wager} = Movie.create_wager(@create_attrs)
    wager
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all wagers", %{conn: conn} do
      conn = get conn, wager_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create wager" do
    test "renders wager when data is valid", %{conn: conn} do
      conn = post conn, wager_path(conn, :create), wager: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, wager_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 42,
        "place" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, wager_path(conn, :create), wager: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update wager" do
    setup [:create_wager]

    test "renders wager when data is valid", %{conn: conn, wager: %Wager{id: id} = wager} do
      conn = put conn, wager_path(conn, :update, wager), wager: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, wager_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 43,
        "place" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, wager: wager} do
      conn = put conn, wager_path(conn, :update, wager), wager: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete wager" do
    setup [:create_wager]

    test "deletes chosen wager", %{conn: conn, wager: wager} do
      conn = delete conn, wager_path(conn, :delete, wager)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, wager_path(conn, :show, wager)
      end
    end
  end

  defp create_wager(_) do
    wager = fixture(:wager)
    {:ok, wager: wager}
  end
end
