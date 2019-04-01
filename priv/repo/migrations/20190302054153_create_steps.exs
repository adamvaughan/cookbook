defmodule Cookbook.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :index, :integer, null: false
      add :description, :text, null: false
      add :recipe_id, references(:recipes), null: false
      timestamps()
    end

    create index(:steps, :recipe_id)
  end
end
