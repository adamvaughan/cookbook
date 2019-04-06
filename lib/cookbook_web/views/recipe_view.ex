defmodule CookbookWeb.RecipeView do
  use CookbookWeb, :view

  def order_ingredients(ingredients) do
    Enum.sort_by(ingredients, fn ingredient -> ingredient.index end)
  end

  def order_steps(steps) do
    Enum.sort_by(steps, fn step -> step.index end)
  end
end
