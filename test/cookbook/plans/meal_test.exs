defmodule Cookbook.Plans.MealTest do
  use Cookbook.DataCase

  alias Cookbook.Plans.Meal

  describe "changeset/2" do
    test "building a changeset" do
      plan = insert(:plan)
      recipe = insert(:recipe)

      changeset =
        Meal.changeset(%Meal{}, %{
          day: 3,
          plan_id: plan.id,
          recipe_id: recipe.id
        })

      assert changeset.valid?
      assert {:ok, meal} = Repo.insert(changeset)
      assert meal.day == 3
      assert meal.plan_id == plan.id
      assert meal.recipe_id == recipe.id
    end

    test "requires a day" do
      plan = insert(:plan)
      recipe = insert(:recipe)

      changeset =
        Meal.changeset(%Meal{}, %{
          plan_id: plan.id,
          recipe_id: recipe.id
        })

      refute changeset.valid?
      assert %{day: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires a plan" do
      recipe = insert(:recipe)

      changeset =
        Meal.changeset(%Meal{}, %{
          day: 3,
          recipe_id: recipe.id
        })

      refute changeset.valid?
      assert %{plan_id: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires a recipe" do
      plan = insert(:plan)

      changeset =
        Meal.changeset(%Meal{}, %{
          day: 3,
          plan_id: plan.id
        })

      refute changeset.valid?
      assert %{recipe_id: ["can't be blank"]} == errors_on(changeset)
    end
  end
end
