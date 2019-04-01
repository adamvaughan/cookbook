defmodule CookbookWeb.MealControllerTest do
  use CookbookWeb.ConnCase

  describe "index/2" do
    test "getting all meals for a day", %{conn: conn} do
      plan = insert(:plan)
      recipe = insert(:recipe, title: "My Recipe")
      insert(:meal, plan: plan, day: 1, recipe: recipe)
      recipe = insert(:recipe, title: "Another Recipe")
      insert(:meal, plan: plan, day: 2, recipe: recipe)

      conn = get(conn, Routes.plan_meal_path(conn, :index, plan, "1"))
      assert response = html_response(conn, 200)
      assert response =~ "My Recipe"
      refute response =~ "Another Recipe"
    end
  end

  describe "new/2" do
    test "preparing to create a new meal", %{conn: conn} do
      plan = insert(:plan, month: 2, year: 2019)

      conn = get(conn, Routes.plan_meal_path(conn, :new, plan, "2"))
      assert response = html_response(conn, 200)
      assert response =~ "February 2, 2019"
      assert response =~ Routes.plan_meal_path(conn, :create, plan)
    end
  end

  describe "create/2" do
    test "creating a new meal", %{conn: conn} do
      plan = insert(:plan)
      recipe = insert(:recipe)

      conn =
        post(conn, Routes.plan_meal_path(conn, :create, plan), %{
          "meal" => %{"day" => 2, "recipe_id" => recipe.id}
        })

      assert (redirect_path = redirected_to(conn)) == Routes.plan_meal_path(conn, :index, plan, 2)

      conn = get(conn, redirect_path)
      assert html_response(conn, 200) =~ "Test Recipe"
    end
  end

  describe "delete/2" do
    test "deleting a meal", %{conn: conn} do
      plan = insert(:plan)
      meal = insert(:meal, plan: plan, day: 2)

      conn = delete(conn, Routes.meal_path(conn, :delete, meal))

      assert (redirect_path = redirected_to(conn)) == Routes.plan_meal_path(conn, :index, plan, 2)

      conn = get(conn, redirect_path)
      refute html_response(conn, 200) =~ "Test Recipe"
    end
  end
end
