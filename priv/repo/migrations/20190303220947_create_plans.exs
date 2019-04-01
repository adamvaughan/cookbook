defmodule Cookbook.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :month, :integer, null: false
      add :year, :integer, null: false
      timestamps()
    end

    create unique_index(:plans, [:month, :year])
  end
end
