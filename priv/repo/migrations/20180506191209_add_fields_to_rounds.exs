defmodule MovieWagerBackend.Repo.Migrations.AddFieldsToRounds do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :plot, :string
      add :poster, :string
      add :website, :string
    end
  end
end
