defmodule CookbookWeb.RecipeView do
  use CookbookWeb, :view

  def group_recipes(recipes) do
    Enum.group_by(recipes, fn recipe ->
      recipe.title |> String.downcase() |> String.first()
    end)
  end

  def order_ingredients(ingredients) do
    Enum.sort_by(ingredients, fn ingredient -> ingredient.index end)
  end

  def order_steps(steps) do
    Enum.sort_by(steps, fn step -> step.index end)
  end
end
