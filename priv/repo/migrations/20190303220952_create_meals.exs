defmodule Cookbook.Repo.Migrations.CreateMeals do
  use Ecto.Migration

  def change do
    create table(:meals) do
      add :day, :integer, null: false
      add :plan_id, references(:plans)
      add :recipe_id, references(:recipes), null: false
      timestamps()
    end

    create index(:meals, :plan_id)
    create index(:meals, :recipe_id)
  end
end
