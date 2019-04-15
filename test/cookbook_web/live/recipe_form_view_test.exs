defmodule CookbookWeb.RecipeFormViewTest do
  use Cookbook.DataCase

  import Phoenix.LiveViewTest

  alias Cookbook.Recipes
  alias CookbookWeb.RecipeFormView
  alias Recipes.Recipe

  describe "mount/2" do
    test "creating a recipe" do
      {:ok, _view, _html} = mount(CookbookWeb.Endpoint, RecipeFormView)
    end

    test "updating a recipe" do
      recipe = insert(:recipe)

      {:ok, _view, html} =
        mount(CookbookWeb.Endpoint, RecipeFormView, session: %{recipe_id: recipe.id})

      assert html =~ "Delete"
    end
  end

  describe "handle_event/3" do
    test "adding an ingredient" do
      {:ok, view, html} = mount(CookbookWeb.Endpoint, RecipeFormView)

      assert html =~ ~r/recipe_title/
      assert html =~ ~r/recipe_ingredients_0_quantity/
      refute html =~ ~r/recipe_ingredients_1_quantity/

      html = render_click(view, "add-ingredient")

      assert html =~ ~r/recipe_title/
      assert html =~ ~r/recipe_ingredients_0_quantity/
      assert html =~ ~r/recipe_ingredients_1_quantity/
    end

    test "adding a step" do
      {:ok, view, html} = mount(CookbookWeb.Endpoint, RecipeFormView)

      assert html =~ ~r/recipe_title/
      assert html =~ ~r/recipe_steps_0_description/
      refute html =~ ~r/recipe_steps_1_description/

      html = render_click(view, "add-step")

      assert html =~ ~r/recipe_title/
      assert html =~ ~r/recipe_steps_0_description/
      assert html =~ ~r/recipe_steps_1_description/
    end

    test "updating the changeset" do
      {:ok, view, _html} = mount(CookbookWeb.Endpoint, RecipeFormView)

      html =
        render_change(view, "update-changeset", %{"recipe" => %{"title" => "My Test Recipe"}})

      assert html =~ "My Test Recipe"
    end

    test "creating a recipe" do
      attrs = %{
        "recipe" => %{
          "title" => "My Recipe",
          "ingredients" => %{
            "0" => %{
              "quantity" => "1",
              "measurement" => "cup",
              "description" => "rice"
            }
          },
          "steps" => %{
            "0" => %{
              "description" => "Cook it."
            }
          }
        }
      }

      {:ok, view, _html} = mount(CookbookWeb.Endpoint, RecipeFormView)

      assert {:error, :redirect} = render_submit(view, "save", attrs)

      recipe = Recipe |> Repo.all() |> List.first() |> Repo.preload([:ingredients, :steps])
      assert recipe.title == "My Recipe"

      ingredient = List.first(recipe.ingredients)
      assert ingredient.quantity == "1"
      assert ingredient.measurement == "cup"
      assert ingredient.description == "rice"

      step = List.first(recipe.steps)
      assert step.description == "Cook it."
    end

    test "creating a recipe with invalid data" do
      attrs = %{
        "recipe" => %{
          "title" => "",
          "ingredients" => [%{"quantity" => ""}],
          "steps" => [%{"description" => ""}]
        }
      }

      {:ok, view, _html} = mount(CookbookWeb.Endpoint, RecipeFormView)

      html = render_submit(view, "save", attrs)
      assert html =~ "can&#39;t be blank"
    end

    test "updating a recipe" do
      recipe = insert(:recipe, title: "My Recipe")
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:step, recipe: recipe, description: "Cook it.")
      {:ok, recipe} = Recipes.get_recipe(recipe.id)

      attrs = %{
        "recipe" => %{
          "title" => "My Better Recipe",
          "ingredients" => %{
            "0" => %{
              "quantity" => "2",
              "measurement" => "cups",
              "description" => "rice"
            },
            "1" => %{
              "quantity" => "1",
              "measurement" => "ounce",
              "description" => "milk"
            }
          },
          "steps" => %{
            "0" => %{
              "description" => "Cook it."
            },
            "1" => %{
              "description" => "Eat it."
            }
          }
        }
      }

      {:ok, view, _html} =
        mount(CookbookWeb.Endpoint, RecipeFormView, session: %{recipe_id: recipe.id})

      assert {:error, :redirect} = render_submit(view, "save", attrs)

      recipe = Recipe |> Repo.get(recipe.id) |> Repo.preload([:ingredients, :steps])
      assert recipe.title == "My Better Recipe"

      ingredient = Enum.find(recipe.ingredients, &(&1.index == 0))
      assert ingredient.quantity == "2"
      assert ingredient.measurement == "cups"
      assert ingredient.description == "rice"

      ingredient = Enum.find(recipe.ingredients, &(&1.index == 1))
      assert ingredient.quantity == "1"
      assert ingredient.measurement == "ounce"
      assert ingredient.description == "milk"

      step = List.first(recipe.steps)
      assert step.description == "Cook it."

      step = List.last(recipe.steps)
      assert step.description == "Eat it."
    end

    test "updating a recipe with invalid data" do
      recipe = insert(:recipe, title: "My Recipe")
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:step, recipe: recipe, description: "Cook it.")

      attrs = %{
        "recipe" => %{
          "title" => "",
          "ingredients" => [%{"quantity" => ""}],
          "steps" => [%{"description" => ""}]
        }
      }

      {:ok, view, _html} =
        mount(CookbookWeb.Endpoint, RecipeFormView, session: %{recipe_id: recipe.id})

      html = render_submit(view, "save", attrs)
      assert html =~ "can&#39;t be blank"
    end

    test "deleting a recipe" do
      recipe = insert(:recipe)

      {:ok, view, _html} =
        mount(CookbookWeb.Endpoint, RecipeFormView, session: %{recipe_id: recipe.id})

      assert {:error, :redirect} = render_click(view, "delete")
      assert is_nil(Repo.get(Recipe, recipe.id))
    end
  end
end
