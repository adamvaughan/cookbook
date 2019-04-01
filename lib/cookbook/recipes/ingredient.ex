defmodule Cookbook.Recipes.Ingredient do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Recipes.Recipe

  schema "ingredients" do
    field :index, :integer
    field :quantity, :string
    field :measurement, :string
    field :description, :string

    belongs_to :recipe, Recipe

    timestamps()
  end

  def changeset(ingredient, attrs \\ %{}) do
    ingredient
    |> cast(attrs, [:index, :quantity, :measurement, :description, :recipe_id])
    |> validate_required([:index, :description])
    |> assoc_constraint(:recipe)
  end
end
