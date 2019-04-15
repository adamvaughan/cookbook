defmodule CookbookWeb.RecipeController do
  use CookbookWeb, :controller

  alias Cookbook.Recipes

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      render(conn, "show.html", recipe: recipe)
    end
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      render(conn, "edit.html", recipe: recipe)
    end
  end
end
