defmodule Cookbook.Recipes.Ingredient do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Recipes.Recipe
  alias Cookbook.Utils

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
    |> update_change(:quantity, &Utils.trim/1)
    |> update_change(:measurement, &Utils.trim/1)
    |> update_change(:measurement, &Utils.downcase/1)
    |> update_change(:description, &Utils.trim/1)
    |> validate_required([:index, :description])
    |> assoc_constraint(:recipe)
  end
end
