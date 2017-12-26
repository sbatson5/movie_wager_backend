defmodule MovieWagerBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :family_name, :string
      add :gender, :string
      add :given_name, :string
      add :locale, :string
      add :name, :string
      add :picture, :string
      add :verified_email, :boolean, default: false, null: false
      add :google_id, :string

      timestamps()
    end

  end
end
