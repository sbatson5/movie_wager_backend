defmodule MovieWagerBackend.GoogleTest do
  use MovieWagerBackend.DataCase

  alias MovieWagerBackend.Google

  describe "users" do
    alias MovieWagerBackend.Google.User

    @valid_attrs %{family_name: "some family_name", gender: "some gender", given_name: "some given_name", google_id: "some google_id", locale: "some locale", name: "some name", picture: "some picture", verified_email: true}
    @update_attrs %{family_name: "some updated family_name", gender: "some updated gender", given_name: "some updated given_name", google_id: "some updated google_id", locale: "some updated locale", name: "some updated name", picture: "some updated picture", verified_email: false}
    @invalid_attrs %{family_name: nil, gender: nil, given_name: nil, google_id: nil, locale: nil, name: nil, picture: nil, verified_email: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Google.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Google.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Google.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Google.create_user(@valid_attrs)
      assert user.family_name == "some family_name"
      assert user.gender == "some gender"
      assert user.given_name == "some given_name"
      assert user.google_id == "some google_id"
      assert user.locale == "some locale"
      assert user.name == "some name"
      assert user.picture == "some picture"
      assert user.verified_email == true
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Google.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Google.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.family_name == "some updated family_name"
      assert user.gender == "some updated gender"
      assert user.given_name == "some updated given_name"
      assert user.google_id == "some updated google_id"
      assert user.locale == "some updated locale"
      assert user.name == "some updated name"
      assert user.picture == "some updated picture"
      assert user.verified_email == false
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Google.update_user(user, @invalid_attrs)
      assert user == Google.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Google.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Google.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Google.change_user(user)
    end
  end
end
