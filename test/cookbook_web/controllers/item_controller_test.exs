defmodule CookbookWeb.ItemControllerTest do
  use CookbookWeb.ConnCase

  describe "create/2" do
    test "creating an item", %{conn: conn} do
      plan = insert(:plan)
      list = insert(:list, plan: plan)

      conn =
        post(conn, Routes.list_item_path(conn, :create, list), %{
          "item" => %{"description" => "Test item"}
        })

      assert (redirect_path = redirected_to(conn)) == Routes.plan_list_path(conn, :show, plan)

      conn = get(conn, redirect_path)
      assert html_response(conn, 200) =~ "Test item"
    end
  end

  describe "update/2" do
    test "updating an item", %{conn: conn} do
      plan = insert(:plan)
      list = insert(:list, plan: plan)
      item = insert(:item, list: list)

      conn =
        put(conn, Routes.item_path(conn, :update, item), %{
          "item" => %{"purchased" => "true"}
        })

      assert (redirect_path = redirected_to(conn)) == Routes.plan_list_path(conn, :show, plan)

      conn = get(conn, redirect_path)
      assert html_response(conn, 200) =~ "checked"
    end
  end
end
