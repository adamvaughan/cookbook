defmodule CookbookWeb.MealController do
  use CookbookWeb, :controller

  alias Cookbook.{Plans, Recipes}
  alias Plans.Meal

  def index(conn, %{"plan_id" => plan_id, "day" => day}) do
    day = String.to_integer(day)

    with {:ok, plan} <- Plans.get_plan(plan_id),
         meals <- Enum.filter(plan.meals, fn meal -> meal.day == day end) do
      render(conn, "index.html", plan: plan, day: day, meals: meals)
    end
  end

  def new(conn, %{"plan_id" => plan_id, "day" => day}) do
    with {:ok, plan} <- Plans.get_plan(plan_id),
         recipes <- Recipes.get_recipes() do
      changeset = Meal.changeset(%Meal{}, %{day: day})
      render(conn, "new.html", plan: plan, day: day, recipes: recipes, changeset: changeset)
    end
  end

  def create(conn, %{"plan_id" => plan_id, "meal" => meal_params}) do
    with {:ok, plan} <- Plans.get_plan(plan_id),
         {:ok, meal} <- Plans.create_meal(plan, meal_params) do
      redirect(conn, to: Routes.plan_meal_path(conn, :index, plan, meal.day))
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, meal} <- Plans.get_meal(id) do
      Plans.delete_meal(meal)
      redirect(conn, to: Routes.plan_meal_path(conn, :index, meal.plan, meal.day))
    end
  end
end
