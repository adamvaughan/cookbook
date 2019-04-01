defmodule Cookbook.Recipes.IngredientTest do
  use Cookbook.DataCase

  alias Cookbook.Recipes.Ingredient

  describe "changeset/2" do
    test "building a changeset" do
      recipe = insert(:recipe)

      changeset =
        Ingredient.changeset(%Ingredient{}, %{
          index: 0,
          quantity: "3",
          measurement: "cup",
          description: "rice",
          recipe_id: recipe.id
        })

      assert changeset.valid?
      assert {:ok, ingredient} = Repo.insert(changeset)
      assert ingredient.index == 0
      assert ingredient.quantity == "3"
      assert ingredient.measurement == "cup"
      assert ingredient.description == "rice"
      assert ingredient.recipe_id == recipe.id
    end

    test "requires an index" do
      recipe = insert(:recipe)

      changeset =
        Ingredient.changeset(%Ingredient{}, %{
          quantity: "3",
          measurement: "cup",
          description: "rice",
          recipe_id: recipe.id
        })

      refute changeset.valid?
      assert %{index: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires an description" do
      recipe = insert(:recipe)

      changeset =
        Ingredient.changeset(%Ingredient{}, %{
          index: 0,
          quantity: "3",
          measurement: "cup",
          recipe_id: recipe.id
        })

      refute changeset.valid?
      assert %{description: ["can't be blank"]} == errors_on(changeset)
    end
  end
end
