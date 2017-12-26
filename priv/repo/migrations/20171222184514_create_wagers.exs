defmodule MovieWagerBackend.Repo.Migrations.CreateWagers do
  use Ecto.Migration

  def change do
    create table(:wagers) do
      add :round_id, references(:rounds)
      add :user_id, references(:users)
      add :amount, :integer
      add :place, :integer

      timestamps()
    end

    create unique_index(:wagers, [:user_id, :round_id], name: :wagers_user_round_idx)
  end
end
