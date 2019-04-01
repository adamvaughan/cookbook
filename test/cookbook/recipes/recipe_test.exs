defmodule Cookbook.Recipes.RecipeTest do
  use Cookbook.DataCase

  alias Cookbook.Recipes.Recipe

  describe "changeset/2" do
    test "building a changeset" do
      changeset =
        Recipe.changeset(%Recipe{}, %{
          title: "Test Recipe",
          notes: "Be careful.",
          ingredients: [
            %{
              index: 0,
              quantity: "3",
              measurement: "cup",
              description: "rice"
            }
          ],
          steps: [
            %{
              index: 0,
              description: "Cook it."
            }
          ]
        })

      assert changeset.valid?
      {:ok, recipe} = Repo.insert(changeset)
      assert recipe.title == "Test Recipe"
      assert recipe.notes == "Be careful."
      assert length(recipe.ingredients) == 1
      assert length(recipe.steps) == 1
    end

    test "requires a title" do
      changeset =
        Recipe.changeset(%Recipe{}, %{
          ingredients: [],
          steps: []
        })

      refute changeset.valid?
      assert %{title: ["can't be blank"]} == errors_on(changeset)
    end

    test "requires a unique title" do
      insert(:recipe, title: "Test Recipe")

      changeset =
        Recipe.changeset(%Recipe{}, %{
          title: "Test Recipe"
        })

      assert changeset.valid?
      assert {:error, changeset} = Repo.insert(changeset)
      assert %{title: ["has already been taken"]} == errors_on(changeset)
    end
  end
end
