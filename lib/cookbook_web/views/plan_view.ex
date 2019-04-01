defmodule CookbookWeb.PlanView do
  use CookbookWeb, :view

  def group_plans(plans) do
    plans
    |> Enum.group_by(fn plan -> plan.year end)
    |> Enum.into([], fn {year, plans} ->
      {year, plans |> Enum.sort_by(fn plan -> plan.month end) |> Enum.reverse()}
    end)
    |> Enum.reverse()
  end

  def group_plan_meals(plan) do
    {:ok, date} = Date.new(plan.year, plan.month, 1)
    first_day_of_month = Date.day_of_week(date)
    days_in_month = Date.days_in_month(date)
    week_count = Float.ceil((first_day_of_month + days_in_month) / 7)
    week_range = 0..(round(week_count) - 1)
    meals = Enum.group_by(plan.meals, fn meal -> meal.day end)

    Enum.map(week_range, fn week ->
      days = (week * 7 + 1)..(week * 7 + 7)
      meals_for_week(days, first_day_of_month, days_in_month, meals)
    end)
  end

  defp meals_for_week(days, first_day_of_month, days_in_month, meals) do
    Enum.map(days, fn day ->
      day_of_month = day - first_day_of_month
      meals_for_day(day_of_month, days_in_month, meals)
    end)
  end

  defp meals_for_day(day, days_in_month, meals) do
    if day < 1 || day > days_in_month do
      {"", []}
    else
      {day, Map.get(meals, day, [])}
    end
  end
end
