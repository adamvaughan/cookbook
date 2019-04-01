defmodule Cookbook.Plans do
  import Ecto.Query, only: [from: 2]

  alias Cookbook.Repo
  alias Cookbook.Plans.{Meal, Plan}

  def get_plans do
    ensure_plans_exist()
    query = from(plan in Plan, order_by: [desc: plan.year, desc: plan.month])
    Repo.all(query)
  end

  def get_plan(id) do
    query = from(plan in Plan, where: plan.id == ^id, preload: [meals: [recipe: :ingredients]])

    case Repo.one(query) do
      nil -> {:error, :not_found}
      plan -> {:ok, plan}
    end
  end

  defp ensure_plans_exist do
    today = Date.utc_today()
    month = today.month
    year = today.year

    query =
      from(
        plan in Plan,
        where: plan.year < ^year or (plan.year == ^year and plan.month < ^month),
        select: count(plan.id)
      )

    count = Repo.one(query)

    if count == 0 do
      ensure_plan_exists(month, year)
    else
      ensure_plans_exist(month, year)
    end
  end

  defp ensure_plans_exist(0, year), do: ensure_plans_exist(12, year - 1)

  defp ensure_plans_exist(month, year) do
    case ensure_plan_exists(month, year) do
      :ok -> :ok
      _ -> ensure_plans_exist(month - 1, year)
    end
  end

  defp ensure_plan_exists(month, year) do
    case Repo.get_by(Plan, month: month, year: year) do
      nil -> create_plan!(month, year)
      _plan -> :ok
    end
  end

  defp create_plan!(month, year) do
    attrs = %{
      month: month,
      year: year
    }

    changeset = Plan.changeset(%Plan{}, attrs)
    Repo.insert!(changeset)
  end

  def get_meal(id) do
    query = from(meal in Meal, where: meal.id == ^id, preload: [:plan, :recipe])

    case Repo.one(query) do
      nil -> {:error, :not_found}
      meal -> {:ok, meal}
    end
  end

  def create_meal(plan, attrs) do
    attrs = Map.put(attrs, "plan_id", plan.id)
    changeset = Meal.changeset(%Meal{}, attrs)
    Repo.insert(changeset)
  end

  def delete_meal(meal) do
    Repo.delete(meal)
  end
end
