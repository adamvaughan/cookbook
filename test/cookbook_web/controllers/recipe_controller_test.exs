defmodule CookbookWeb.RecipeControllerTest do
  use CookbookWeb.ConnCase

  alias Cookbook.Recipes.Recipe
  alias Cookbook.Repo

  describe "index/2" do
    test "getting all recipes", %{conn: conn} do
      insert(:recipe, title: "My Recipe")
      insert(:recipe, title: "Your Recipe")

      conn = get(conn, Routes.recipe_path(conn, :index))

      assert response = html_response(conn, 200)
      assert response =~ ~r/My Recipe/
      assert response =~ ~r/Your Recipe/
    end
  end

  describe "show/2" do
    test "getting a recipe", %{conn: conn} do
      recipe = insert(:recipe, title: "My Recipe")
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:step, recipe: recipe, description: "Cook it")

      conn = get(conn, Routes.recipe_path(conn, :show, recipe))

      assert response = html_response(conn, 200)
      assert response =~ ~r/My Recipe/
      assert response =~ ~r/1/
      assert response =~ ~r/cup/
      assert response =~ ~r/rice/
      assert response =~ ~r/Cook it/
    end
  end

  describe "new/2" do
    test "preparing to create a new recipe", %{conn: conn} do
      conn = get(conn, Routes.recipe_path(conn, :new))

      assert response = html_response(conn, 200)
      assert response =~ ~r/recipe_title/
      assert response =~ ~r/recipe_ingredients_0_quantity/
      assert response =~ ~r/recipe_steps_0_description/
    end
  end

  describe "add_ingredient/2" do
    test "adding an ingredient when creating a recipe", %{conn: conn} do
      conn =
        post(conn, Routes.recipe_path(conn, :add_ingredient), %{
          "recipe" => %{
            "ingredients" => %{"0" => %{}}
          }
        })

      assert response = html_response(conn, 200)
      assert response =~ ~r/recipe_title/
      assert response =~ ~r/recipe_ingredients_0_quantity/
      assert response =~ ~r/recipe_ingredients_1_quantity/
    end

    test "adding an ingredient when updating a recipe", %{conn: conn} do
      recipe = insert(:recipe)
      insert(:ingredient, recipe: recipe)

      conn =
        put(conn, Routes.recipe_path(conn, :add_ingredient, recipe.id), %{
          "recipe" => %{
            "ingredients" => %{"0" => %{}}
          }
        })

      assert response = html_response(conn, 200)
      assert response =~ ~r/recipe_title/
      assert response =~ ~r/recipe_ingredients_0_quantity/
      assert response =~ ~r/recipe_ingredients_1_quantity/
    end
  end

  describe "add_step/2" do
    test "adding an step when creating a recipe", %{conn: conn} do
      conn =
        post(conn, Routes.recipe_path(conn, :add_step), %{
          "recipe" => %{
            "steps" => %{"0" => %{}}
          }
        })

      assert response = html_response(conn, 200)
      assert response =~ ~r/recipe_title/
      assert response =~ ~r/recipe_steps_0_description/
      assert response =~ ~r/recipe_steps_1_description/
    end

    test "adding an step when updating a recipe", %{conn: conn} do
      recipe = insert(:recipe)
      insert(:step, recipe: recipe)

      conn =
        put(conn, Routes.recipe_path(conn, :add_step, recipe.id), %{
          "recipe" => %{
            "steps" => %{"0" => %{}}
          }
        })

      assert response = html_response(conn, 200)
      assert response =~ ~r/recipe_title/
      assert response =~ ~r/recipe_steps_0_description/
      assert response =~ ~r/recipe_steps_1_description/
    end
  end

  describe "create/2" do
    test "creating a recipe", %{conn: conn} do
      conn =
        post(conn, Routes.recipe_path(conn, :create), %{
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
        })

      assert (redirect_path = redirected_to(conn)) == Routes.recipe_path(conn, :index)

      conn = get(conn, redirect_path)
      assert html_response(conn, 200) =~ "My Recipe"

      recipe = Recipe |> Repo.all() |> List.first() |> Repo.preload([:ingredients, :steps])
      assert recipe.title == "My Recipe"

      ingredient = List.first(recipe.ingredients)
      assert ingredient.quantity == "1"
      assert ingredient.measurement == "cup"
      assert ingredient.description == "rice"

      step = List.first(recipe.steps)
      assert step.description == "Cook it."
    end

    test "with invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.recipe_path(conn, :create), %{
          "recipe" => %{
            "title" => "",
            "ingredients" => [],
            "steps" => []
          }
        })

      assert html_response(conn, 200) =~ ~r/can&#39;t be blank/
    end
  end

  describe "edit/2" do
    test "preparing to edit a recipe", %{conn: conn} do
      recipe = insert(:recipe, title: "My Recipe")
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:step, recipe: recipe, description: "Cook it.")

      conn = get(conn, Routes.recipe_path(conn, :edit, recipe))

      assert response = html_response(conn, 200)
      assert response =~ ~r/My Recipe/
      assert response =~ ~r/1/
      assert response =~ ~r/cup/
      assert response =~ ~r/rice/
      assert response =~ ~r/Cook it/
      assert response =~ ~r/recipe_ingredients_0_quantity/
      assert response =~ ~r/recipe_steps_0_description/
    end
  end

  describe "update/2" do
    test "updating a recipe", %{conn: conn} do
      recipe = insert(:recipe, title: "My Recipe")
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:step, recipe: recipe, description: "Cook it.")

      conn =
        put(conn, Routes.recipe_path(conn, :update, recipe), %{
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
        })

      assert (redirect_path = redirected_to(conn)) == Routes.recipe_path(conn, :show, recipe)

      conn = get(conn, redirect_path)
      assert response = html_response(conn, 200)
      assert response =~ "My Better Recipe"
      assert response =~ ~r/2/
      assert response =~ ~r/cups/
      assert response =~ ~r/rice/
      assert response =~ ~r/1/
      assert response =~ ~r/oz/
      assert response =~ ~r/milk/
      assert response =~ ~r/Cook it/
      assert response =~ ~r/Eat it/
    end

    test "with invalid data", %{conn: conn} do
      recipe = insert(:recipe, title: "My Recipe")

      conn =
        put(conn, Routes.recipe_path(conn, :update, recipe), %{
          "recipe" => %{
            "title" => "",
            "ingredients" => [],
            "steps" => []
          }
        })

      assert html_response(conn, 200) =~ ~r/can&#39;t be blank/
    end
  end

  describe "delete/2" do
    test "deleting a recipe", %{conn: conn} do
      recipe = insert(:recipe, title: "My Recipe")
      conn = delete(conn, Routes.recipe_path(conn, :delete, recipe))

      assert (redirect_path = redirected_to(conn)) == Routes.recipe_path(conn, :index)

      conn = get(conn, redirect_path)
      refute html_response(conn, 200) =~ ~r/My Recipe/
    end
  end
end
