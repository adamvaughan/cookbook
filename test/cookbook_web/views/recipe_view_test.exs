defmodule CookbookWeb.RecipeViewTest do
  use CookbookWeb.ConnCase, async: true

  alias CookbookWeb.RecipeView
  alias Cookbook.Recipes.{Ingredient, Recipe, Step}

  describe "group_recipes/1" do
    test "grouping recipes" do
      recipes = [
        %Recipe{title: "Alphabet Soup"},
        %Recipe{title: "Chicken Noodle Soup"},
        %Recipe{title: "Chicken Pot Pie"},
        %Recipe{title: "Green Eggs and Ham"}
      ]

      grouped_recipes = RecipeView.group_recipes(recipes)

      assert grouped_recipes == %{
               "a" => [%Recipe{title: "Alphabet Soup"}],
               "c" => [%Recipe{title: "Chicken Noodle Soup"}, %Recipe{title: "Chicken Pot Pie"}],
               "g" => [%Recipe{title: "Green Eggs and Ham"}]
             }
    end
  end

  describe "order_ingredients/1" do
    test "ordering ingredients" do
      ingredients = [
        %Ingredient{index: 2, description: "second"},
        %Ingredient{index: 1, description: "first"}
      ]

      ordered_ingredients = RecipeView.order_ingredients(ingredients)
      assert List.first(ordered_ingredients).description == "first"
      assert List.last(ordered_ingredients).description == "second"
    end
  end

  describe "order_steps/1" do
    test "ordering steps" do
      steps = [
        %Step{index: 2, description: "second"},
        %Step{index: 1, description: "first"}
      ]

      ordered_steps = RecipeView.order_steps(steps)
      assert List.first(ordered_steps).description == "first"
      assert List.last(ordered_steps).description == "second"
    end
  end
end
