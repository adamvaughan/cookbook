defmodule CookbookWeb.ListControllerTest do
  use CookbookWeb.ConnCase

  describe "show/2" do
    test "showing a list", %{conn: conn} do
      plan = insert(:plan, month: 2, year: 2019)
      list = insert(:list, plan: plan)
      insert(:item, description: "Test item", list: list)

      conn = get(conn, Routes.plan_list_path(conn, :show, plan))
      assert response = html_response(conn, 200)
      assert response =~ "February 2019"
      assert response =~ "Test item"
    end
  end

  describe "delete/2" do
    test "regenerating a list", %{conn: conn} do
      plan = insert(:plan, month: 2, year: 2019)
      list = insert(:list, plan: plan)
      insert(:item, description: "Test item", list: list)
      insert(:item, description: "Manual item", list: list, manually_added: true)

      conn =
        delete(conn, Routes.plan_list_path(conn, :delete, plan), %{
          "item" => %{"description" => "Test item"}
        })

      assert (redirect_path = redirected_to(conn)) == Routes.plan_list_path(conn, :show, plan)

      conn = get(conn, redirect_path)
      assert response = html_response(conn, 200)
      assert response =~ "February 2019"
      refute response =~ "Test item"
      assert response =~ "Manual item"
    end
  end
end
