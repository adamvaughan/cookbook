defmodule CookbookWeb.ListController do
  use CookbookWeb, :controller

  alias Cookbook.{Lists, Plans}
  alias Lists.Item

  def show(conn, %{"plan_id" => plan_id}) do
    with {:ok, plan} <- Plans.get_plan(plan_id),
         {:ok, list} <- Lists.get_list(plan) do
      changeset = Lists.change_item(%Item{}, %{list_id: list.id})
      render(conn, "show.html", plan: plan, list: list, changeset: changeset)
    end
  end

  def delete(conn, %{"plan_id" => plan_id}) do
    with {:ok, plan} <- Plans.get_plan(plan_id),
         {:ok, list} <- Lists.get_list(plan) do
      Lists.regenerate(list)
      redirect(conn, to: Routes.plan_list_path(conn, :show, plan))
    end
  end
end
