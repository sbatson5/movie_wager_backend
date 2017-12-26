defmodule MovieWagerBackend.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :code, :string
      add :start_date, :date
      add :end_date, :date
      add :box_office_amount, :integer
      add :title, :string

      timestamps()
    end

  end
end
