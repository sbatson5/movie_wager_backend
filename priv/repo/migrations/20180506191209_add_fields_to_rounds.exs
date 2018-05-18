defmodule MovieWagerBackend.Repo.Migrations.AddFieldsToRounds do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :plot, :text
      add :poster, :string
      add :website, :string
      remove :start_date
    end
  end
end
