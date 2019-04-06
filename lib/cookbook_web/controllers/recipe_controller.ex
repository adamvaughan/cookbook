defmodule CookbookWeb.RecipeController do
  use CookbookWeb, :controller

  alias Cookbook.Recipes
  alias Recipes.Recipe

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      render(conn, "show.html", recipe: recipe)
    end
  end

  def new(conn, _params) do
    changeset = Recipe.changeset(%Recipe{}, %{"ingredients" => [%{}], "steps" => [%{}]})
    render(conn, "new.html", changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      changeset = recipe |> Recipe.changeset() |> ensure_ingredients |> ensure_steps
      render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  defp ensure_ingredients(changeset) do
    changeset
    |> Ecto.Changeset.get_field(:ingredients, [%{}])
    |> ensure_ingredients(changeset)
  end

  defp ensure_ingredients(ingredients, changeset) when length(ingredients) > 0, do: changeset

  defp ensure_ingredients(_ingredients, changeset) do
    Ecto.Changeset.put_change(changeset, :ingredients, [%{}])
  end

  defp ensure_steps(changeset) do
    changeset
    |> Ecto.Changeset.get_field(:steps, [%{}])
    |> ensure_steps(changeset)
  end

  defp ensure_steps(steps, changeset) when length(steps) > 0, do: changeset

  defp ensure_steps(_steps, changeset) do
    Ecto.Changeset.put_change(changeset, :steps, [%{}])
  end
end
