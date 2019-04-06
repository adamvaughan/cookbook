defmodule CookbookWeb.RecipeControllerTest do
  use CookbookWeb.ConnCase

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

    test "preparing to edit a recipe with no ingredients or steps", %{conn: conn} do
      recipe = insert(:recipe, title: "My Recipe")

      conn = get(conn, Routes.recipe_path(conn, :edit, recipe))

      assert response = html_response(conn, 200)
      assert response =~ ~r/My Recipe/
      assert response =~ ~r/recipe_ingredients_0_quantity/
      assert response =~ ~r/recipe_steps_0_description/
    end
  end
end
