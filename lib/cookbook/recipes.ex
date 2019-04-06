defmodule Cookbook.Recipes do
  import Ecto.Query, only: [from: 2]

  alias Cookbook.Recipes.Recipe
  alias Cookbook.Repo

  def get_recipes do
    query = from(recipe in Recipe, order_by: recipe.title)
    Repo.all(query)
  end

  def get_recipes(filter) do
    filter = "%#{String.downcase(filter)}%"
    query = from(recipe in Recipe, where: ilike(recipe.title, ^filter), order_by: recipe.title)
    Repo.all(query)
  end

  def get_recipe(id) do
    query = from(recipe in Recipe, where: recipe.id == ^id, preload: [:ingredients, :steps])

    case Repo.one(query) do
      nil -> {:error, :not_found}
      recipe -> {:ok, recipe}
    end
  end

  def create_recipe(attrs = %{"ingredients" => ingredients}) when is_map(ingredients) do
    ingredients = Map.values(ingredients)
    attrs |> Map.put("ingredients", ingredients) |> create_recipe()
  end

  def create_recipe(attrs = %{"steps" => steps}) when is_map(steps) do
    steps = Map.values(steps)
    attrs |> Map.put("steps", steps) |> create_recipe()
  end

  def create_recipe(attrs = %{"ingredients" => ingredients, "steps" => steps}) do
    ingredients = discard_empty_ingredients(ingredients)
    steps = discard_empty_steps(steps)

    attrs =
      attrs
      |> Map.put("ingredients", ingredients)
      |> Map.put("steps", steps)

    changeset = Recipe.changeset(%Recipe{}, attrs)
    Repo.insert(changeset)
  end

  def update_recipe(recipe, attrs = %{"ingredients" => ingredients}) when is_map(ingredients) do
    ingredients = Map.values(ingredients)
    attrs = Map.put(attrs, "ingredients", ingredients)
    update_recipe(recipe, attrs)
  end

  def update_recipe(recipe, attrs = %{"steps" => steps}) when is_map(steps) do
    steps = Map.values(steps)
    attrs = Map.put(attrs, "steps", steps)
    update_recipe(recipe, attrs)
  end

  def update_recipe(recipe, attrs = %{"ingredients" => ingredients, "steps" => steps}) do
    ingredients = discard_empty_ingredients(ingredients)
    steps = discard_empty_steps(steps)

    attrs =
      attrs
      |> Map.put("ingredients", ingredients)
      |> Map.put("steps", steps)

    changeset = Recipe.changeset(recipe, attrs)
    Repo.update(changeset)
  end

  def delete_recipe(recipe) do
    Repo.delete(recipe)
  end

  defp discard_empty_ingredients(ingredients) do
    ingredients
    |> Enum.reject(&empty_ingredient?/1)
    |> Enum.with_index()
    |> Enum.map(fn {ingredient, index} ->
      Map.put(ingredient, "index", index)
    end)
  end

  defp empty_ingredient?(ingredient) do
    quantity = Map.get(ingredient, "quantity")
    measurement = Map.get(ingredient, "measurement")
    description = Map.get(ingredient, "description")

    Enum.all?([quantity, measurement, description], fn value ->
      is_nil(value) || value == ""
    end)
  end

  defp discard_empty_steps(steps) do
    steps
    |> Enum.reject(&empty_step?/1)
    |> Enum.with_index()
    |> Enum.map(fn {step, index} ->
      Map.put(step, "index", index)
    end)
  end

  defp empty_step?(step) do
    description = Map.get(step, "description")
    is_nil(description) || description == ""
  end
end
