defmodule Cookbook.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :title, :string, null: false
      add :notes, :text
      timestamps()
    end

    create unique_index(:recipes, :title)
  end
end
