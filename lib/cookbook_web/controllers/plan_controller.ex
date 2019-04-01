defmodule CookbookWeb.PlanController do
  use CookbookWeb, :controller

  alias Cookbook.Plans

  def index(conn, _params) do
    plans = Plans.get_plans()
    render(conn, "index.html", plans: plans)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, plan} <- Plans.get_plan(id) do
      render(conn, "show.html", plan: plan)
    end
  end
end
