defmodule Cookbook.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :quantity, :float
      add :measurement, :string
      add :description, :string, null: false
      add :purchased, :boolean, default: false
      add :manually_added, :boolean, default: false
      add :list_id, references(:lists), null: false
      timestamps()
    end

    create index(:items, :list_id)
  end
end
