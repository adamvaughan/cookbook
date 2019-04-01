defmodule Cookbook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :index, :integer, null: false
      add :quantity, :string
      add :measurement, :string
      add :description, :string, null: false
      add :recipe_id, references(:recipes), null: false
      timestamps()
    end

    create index(:ingredients, :recipe_id)
  end
end
