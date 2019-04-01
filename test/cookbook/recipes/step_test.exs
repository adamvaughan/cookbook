defmodule Cookbook.Recipes.StepTest do
  use Cookbook.DataCase

  alias Cookbook.Recipes.Step

  describe "changeset/2" do
    test "building a changeset" do
      recipe = insert(:recipe)

      changeset =
        Step.changeset(%Step{}, %{
          index: 0,
          description: "Testing.",
          recipe_id: recipe.id
        })

      assert changeset.valid?
      {:ok, step} = Repo.insert(changeset)
      assert step.index == 0
      assert step.description == "Testing."
      assert step.recipe_id == recipe.id
    end

    test "requires an index" do
      recipe = insert(:recipe)

      changeset =
        Step.changeset(%Step{}, %{
          description: "Testing.",
          recipe_id: recipe.id
        })

      refute changeset.valid?
      assert %{index: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires a description" do
      recipe = insert(:recipe)

      changeset =
        Step.changeset(%Step{}, %{
          index: 0,
          recipe_id: recipe.id
        })

      refute changeset.valid?
      assert %{description: ["can't be blank"]} == errors_on(changeset)
    end
  end
end
