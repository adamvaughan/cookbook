defmodule Cookbook.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :plan_id, references(:plans), null: false
      timestamps()
    end

    create unique_index(:lists, :plan_id)
  end
end
