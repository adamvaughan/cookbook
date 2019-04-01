defmodule Cookbook.PlansTest do
  use Cookbook.DataCase

  alias Cookbook.Plans

  describe "get_plans/0" do
    test "when a plan already exists for the current month" do
      today = Date.utc_today()
      plan = insert(:plan, month: today.month, year: today.year)
      plans = Plans.get_plans()

      assert length(plans) == 1
      assert List.first(plans).id == plan.id
    end

    test "when a plan already exists for a previous month" do
      today = Date.utc_today()
      plan = insert(:plan, month: today.month - 1, year: today.year)
      plans = Plans.get_plans()

      assert length(plans) == 2
      assert List.first(plans) != plan.id
      assert List.first(plans).month == today.month
      assert List.last(plans).id == plan.id
    end

    test "when a plan already exists for a previous year" do
      today = Date.utc_today()
      plan = insert(:plan, month: today.month, year: today.year - 1)
      plans = Plans.get_plans()

      assert List.last(plans).id == plan.id
    end

    test "when no plans already exist" do
      today = Date.utc_today()
      assert plans = Plans.get_plans()
      assert List.first(plans).month == today.month
      assert List.first(plans).year == today.year
    end
  end

  describe "get_meal/1" do
    test "getting a meal" do
      meal = insert(:meal)

      assert {:ok, found} = Plans.get_meal(meal.id)
      assert found.id == meal.id
    end
  end

  describe "create_meal/2" do
    test "creating a meal" do
      plan = insert(:plan)
      recipe = insert(:recipe)

      attrs = %{
        "day" => 4,
        "recipe_id" => recipe.id
      }

      assert {:ok, meal} = Plans.create_meal(plan, attrs)
      assert meal.plan_id == plan.id
      assert meal.recipe_id == recipe.id
      assert meal.day == 4
    end
  end

  describe "delete_meal/1" do
    test "deleting a meal" do
      meal = insert(:meal)
      Plans.delete_meal(meal)
      assert {:error, :not_found} = Plans.get_meal(meal.id)
    end
  end
end
