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

  def mount(%{recipe: recipe, changeset: changeset, back: back}, socket) do
    {:ok, assign(socket, recipe: recipe, changeset: changeset, back: back)}
  end

  def mount(%{changeset: changeset, back: back}, socket) do
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
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
