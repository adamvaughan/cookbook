defmodule CookbookWeb.ItemController do
  use CookbookWeb, :controller

  alias Cookbook.Lists

  def create(conn, %{"list_id" => list_id, "item" => item_params}) do
    with {:ok, list} <- Lists.get_list(list_id) do
      create_item(conn, list, item_params)
    end
  end

  defp create_item(conn, list, item_params) do
    Lists.create_item(list, item_params)
    redirect(conn, to: Routes.plan_list_path(conn, :show, list.plan_id))
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    with {:ok, item} <- Lists.get_item(id) do
      update_item(conn, item, item_params)
    end
  end

  defp update_item(conn, item, item_params) do
    Lists.update_item(item, item_params)

    {:ok, list} = Lists.get_list(item.list_id)
    redirect(conn, to: Routes.plan_list_path(conn, :show, list.plan_id))
  end
end
