defmodule CookbookWeb.RecipeController do
  use CookbookWeb, :controller

  alias Cookbook.Recipes
  alias Recipes.Recipe

  def index(conn, _params) do
    recipes = Recipes.get_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      render(conn, "show.html", recipe: recipe)
    end
  end

  def new(conn, _params) do
    changeset = Recipe.changeset(%Recipe{}, %{"ingredients" => [%{}], "steps" => [%{}]})
    render(conn, "new.html", changeset: changeset, focus: "recipe")
  end

  def add_ingredient(conn, %{
        "id" => id,
        "recipe" => recipe_params = %{"ingredients" => ingredients}
      }) do
    ingredients = Map.values(ingredients) ++ [%{}]
    recipe_params = Map.put(recipe_params, "ingredients", ingredients)

    with {:ok, recipe} <- Recipes.get_recipe(id),
         changeset <- Recipe.changeset(recipe, recipe_params) do
      render(conn, "edit.html", recipe: recipe, changeset: changeset, focus: "ingredients")
    end
  end

  def add_ingredient(conn, %{"recipe" => recipe_params = %{"ingredients" => ingredients}}) do
    ingredients = Map.values(ingredients) ++ [%{}]
    recipe_params = Map.put(recipe_params, "ingredients", ingredients)

    changeset = Recipe.changeset(%Recipe{}, recipe_params)
    render(conn, "new.html", changeset: changeset, focus: "ingredients")
  end

  def add_step(conn, %{"id" => id, "recipe" => recipe_params = %{"steps" => steps}}) do
    steps = Map.values(steps) ++ [%{}]
    recipe_params = Map.put(recipe_params, "steps", steps)

    with {:ok, recipe} <- Recipes.get_recipe(id),
         changeset <- Recipe.changeset(recipe, recipe_params) do
      render(conn, "edit.html", recipe: recipe, changeset: changeset, focus: "steps")
    end
  end

  def add_step(conn, %{"recipe" => recipe_params = %{"steps" => steps}}) do
    steps = Map.values(steps) ++ [%{}]
    recipe_params = Map.put(recipe_params, "steps", steps)

    changeset = Recipe.changeset(%Recipe{}, recipe_params)
    render(conn, "new.html", changeset: changeset, focus: "steps")
  end

  def create(conn, %{"recipe" => recipe_params}) do
    case Recipes.create_recipe(recipe_params) do
      {:ok, _recipe} ->
        redirect(conn, to: Routes.recipe_path(conn, :index))

      {:error, changeset = %Ecto.Changeset{}} ->
        changeset = changeset |> ensure_ingredients |> ensure_steps
        render(conn, "new.html", changeset: changeset, focus: "recipe")
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      changeset = recipe |> Recipe.changeset() |> ensure_ingredients |> ensure_steps
      render(conn, "edit.html", recipe: recipe, changeset: changeset, focus: "recipe")
    end
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      update_recipe(conn, recipe, recipe_params)
    end
  end

  defp update_recipe(conn, recipe, recipe_params) do
    case Recipes.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        redirect(conn, to: Routes.recipe_path(conn, :show, recipe))

      {:error, changeset = %Ecto.Changeset{}} ->
        changeset = changeset |> ensure_ingredients |> ensure_steps
        render(conn, "edit.html", recipe: recipe, changeset: changeset, focus: "recipe")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, recipe} <- Recipes.get_recipe(id) do
      Recipes.delete_recipe(recipe)
      redirect(conn, to: Routes.recipe_path(conn, :index))
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
