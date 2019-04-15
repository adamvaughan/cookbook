defmodule CookbookWeb.RecipeFormView do
  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML

  alias Cookbook.Recipes
  alias CookbookWeb.RecipeView
  alias CookbookWeb.Router.Helpers, as: Routes
  alias Recipes.{Ingredient, Recipe, Step}

  def render(assigns) do
    RecipeView.render("form.html", assigns)
  end

  def mount(%{recipe_id: recipe_id}, socket) do
    {:ok, recipe} = Recipes.get_recipe(recipe_id)
    changeset = recipe |> Recipes.change_recipe() |> ensure_ingredients |> ensure_steps
    back = Routes.recipe_path(socket, :show, recipe)
    {:ok, assign(socket, recipe: recipe, changeset: changeset, back: back)}
  end

  def mount(_session, socket) do
    changeset = %Recipe{} |> Recipes.change_recipe() |> ensure_ingredients |> ensure_steps
    back = Routes.recipe_path(socket, :index)
    {:ok, assign(socket, changeset: changeset, back: back)}
  end

  def handle_event("add-ingredient", _params, socket) do
    changeset = socket.assigns.changeset
    ingredients = Ecto.Changeset.get_field(changeset, :ingredients)
    ingredients = ingredients ++ [%Ingredient{}]
    changeset = Ecto.Changeset.put_change(changeset, :ingredients, ingredients)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-step", _params, socket) do
    changeset = socket.assigns.changeset
    steps = Ecto.Changeset.get_field(changeset, :steps)
    steps = steps ++ [%Step{}]
    changeset = Ecto.Changeset.put_change(changeset, :steps, steps)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("update-changeset", %{"recipe" => recipe_params}, socket) do
    changeset = socket.assigns.changeset
    changeset = Recipe.changeset(changeset, recipe_params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    if socket.assigns[:recipe] do
      update_recipe(socket, recipe_params)
    else
      create_recipe(socket, recipe_params)
    end
  end

  def handle_event("delete", _params, socket) do
    Logger.info("Deleting recipe #{socket.assigns.recipe.id}")
    Recipes.delete_recipe(socket.assigns.recipe)
    {:stop, redirect(socket, to: Routes.recipe_path(CookbookWeb.Endpoint, :index))}
  end

  defp create_recipe(socket, recipe_params) do
    Logger.info("Creating recipe with parameters: #{inspect(recipe_params)}")

    case Recipes.create_recipe(recipe_params) do
      {:ok, _recipe} ->
        {:stop, redirect(socket, to: Routes.recipe_path(CookbookWeb.Endpoint, :index))}

      {:error, changeset = %Ecto.Changeset{}} ->
        changeset = changeset |> ensure_ingredients |> ensure_steps
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp update_recipe(socket, recipe_params) do
    recipe = socket.assigns.recipe

    Logger.info("Updating recipe #{recipe.id} with parameters: #{inspect(recipe_params)}")

    case Recipes.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        {:stop, redirect(socket, to: Routes.recipe_path(CookbookWeb.Endpoint, :show, recipe))}

      {:error, changeset = %Ecto.Changeset{}} ->
        changeset = changeset |> ensure_ingredients |> ensure_steps
        {:noreply, assign(socket, changeset: changeset)}
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
