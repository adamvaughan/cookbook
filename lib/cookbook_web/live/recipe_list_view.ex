defmodule CookbookWeb.RecipeListView do
  use Phoenix.LiveView
  use Phoenix.HTML

  def render(assigns) do
    CookbookWeb.RecipeView.render("list.html", assigns)
  end

  def group_recipes(recipes) do
    Enum.group_by(recipes, fn recipe ->
      recipe.title |> String.downcase() |> String.first()
    end)
  end

  def mount(_session, socket) do
    recipes = Cookbook.Recipes.get_recipes() |> group_recipes()
    {:ok, assign(socket, recipes: recipes, query: nil)}
  end

  def handle_event("filter", %{"q" => ""}, socket) do
    recipes = Cookbook.Recipes.get_recipes() |> group_recipes()
    {:noreply, assign(socket, recipes: recipes)}
  end

  def handle_event("filter", %{"q" => query}, socket) do
    recipes = query |> Cookbook.Recipes.get_recipes() |> group_recipes()
    {:noreply, assign(socket, recipes: recipes)}
  end
end
