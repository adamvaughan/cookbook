defmodule CookbookWeb.PlanControllerTest do
  use CookbookWeb.ConnCase

  describe "index/2" do
    test "getting all plans", %{conn: conn} do
      insert(:plan, month: 2, year: 2019)

      conn = get(conn, Routes.plan_path(conn, :index))

      assert response = html_response(conn, 200)
      assert response =~ "February"
      assert response =~ "2019"
    end
  end

  describe "show/2" do
    test "showing a plan", %{conn: conn} do
      plan = insert(:plan, month: 2, year: 2019)

      conn = get(conn, Routes.plan_path(conn, :show, plan))

      assert response = html_response(conn, 200)
      assert response =~ "February 2019"
    end
  end
end
