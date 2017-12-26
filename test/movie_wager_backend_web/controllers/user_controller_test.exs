defmodule MovieWagerBackendWeb.UserControllerTest do
  use MovieWagerBackendWeb.ConnCase

  alias MovieWagerBackend.Google
  alias MovieWagerBackend.Google.User

  @create_attrs %{family_name: "some family_name", gender: "some gender", given_name: "some given_name", google_id: "some google_id", locale: "some locale", name: "some name", picture: "some picture", verified_email: true}
  @update_attrs %{family_name: "some updated family_name", gender: "some updated gender", given_name: "some updated given_name", google_id: "some updated google_id", locale: "some updated locale", name: "some updated name", picture: "some updated picture", verified_email: false}
  @invalid_attrs %{family_name: nil, gender: nil, given_name: nil, google_id: nil, locale: nil, name: nil, picture: nil, verified_email: nil}

  def fixture(:user) do
    {:ok, user} = Google.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "family_name" => "some family_name",
        "gender" => "some gender",
        "given_name" => "some given_name",
        "google_id" => "some google_id",
        "locale" => "some locale",
        "name" => "some name",
        "picture" => "some picture",
        "verified_email" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "family_name" => "some updated family_name",
        "gender" => "some updated gender",
        "given_name" => "some updated given_name",
        "google_id" => "some updated google_id",
        "locale" => "some updated locale",
        "name" => "some updated name",
        "picture" => "some updated picture",
        "verified_email" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
