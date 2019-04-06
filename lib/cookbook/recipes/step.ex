defmodule Cookbook.Recipes.Step do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Recipes.Recipe
  alias Cookbook.Utils

  schema "steps" do
    field :index, :integer
    field :description, :string

    belongs_to :recipe, Recipe

    timestamps()
  end

  def changeset(step, attrs \\ %{}) do
    step
    |> cast(attrs, [:index, :description, :recipe_id])
    |> update_change(:description, &Utils.trim/1)
    |> validate_required([:index, :description])
    |> assoc_constraint(:recipe)
  end
end
