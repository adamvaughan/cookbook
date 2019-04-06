defmodule Cookbook.RecipesTest do
  use Cookbook.DataCase

  alias Cookbook.Recipes

  describe "get_recipes/0" do
    test "getting all recipes" do
      recipe_1 = insert(:recipe, title: "My Recipe")
      recipe_2 = insert(:recipe, title: "Your Recipe")

      recipes = Recipes.get_recipes()
      assert length(recipes) == 2
      assert List.first(recipes).id == recipe_1.id
      assert List.last(recipes).id == recipe_2.id
    end
  end

  describe "get_recipes/1" do
    test "getting recipes that match a query" do
      recipe_1 = insert(:recipe, title: "My Recipe")
      recipe_2 = insert(:recipe, title: "Your Recipe")
      insert(:recipe, title: "Something Good")

      recipes = Recipes.get_recipes("recipe")
      assert length(recipes) == 2
      assert List.first(recipes).id == recipe_1.id
      assert List.last(recipes).id == recipe_2.id
    end
  end

  describe "get_recipe/1" do
    test "getting a recipe" do
      recipe = insert(:recipe)

      assert {:ok, found} = Recipes.get_recipe(recipe.id)
      assert found.id == recipe.id
    end
  end

  describe "create_recipe/1" do
    test "creating a recipe" do
      attrs = %{
        "title" => "My Recipe",
        "notes" => "So good.",
        "ingredients" => %{
          0 => %{
            "quantity" => "1",
            "measurement" => "cup",
            "description" => "rice"
          }
        },
        "steps" => %{
          0 => %{
            "description" => "Cook it."
          }
        }
      }

      assert {:ok, recipe} = Recipes.create_recipe(attrs)
      assert recipe.title == "My Recipe"
      assert recipe.notes == "So good."
      assert length(recipe.ingredients) == 1
      assert List.first(recipe.ingredients).quantity == "1"
      assert List.first(recipe.ingredients).measurement == "cup"
      assert List.first(recipe.ingredients).description == "rice"
      assert length(recipe.steps) == 1
      assert List.first(recipe.steps).description == "Cook it."
    end
  end

  describe "update_recipe/2" do
    test "updating a recipe" do
      recipe = insert(:recipe)

      attrs = %{
        "title" => "My Recipe",
        "notes" => "So good.",
        "ingredients" => %{
          0 => %{
            "quantity" => "1",
            "measurement" => "cup",
            "description" => "rice"
          }
        },
        "steps" => %{
          0 => %{
            "description" => "Cook it."
          }
        }
      }

      assert {:ok, recipe} = Recipes.update_recipe(recipe, attrs)
      assert recipe.title == "My Recipe"
      assert recipe.notes == "So good."
      assert length(recipe.ingredients) == 1
      assert List.first(recipe.ingredients).quantity == "1"
      assert List.first(recipe.ingredients).measurement == "cup"
      assert List.first(recipe.ingredients).description == "rice"
      assert length(recipe.steps) == 1
      assert List.first(recipe.steps).description == "Cook it."
    end
  end

  describe "delete_recipe/1" do
    test "deleting a recipe" do
      recipe = insert(:recipe)
      Recipes.delete_recipe(recipe)
      assert {:error, :not_found} = Recipes.get_recipe(recipe.id)
    end
  end
end
