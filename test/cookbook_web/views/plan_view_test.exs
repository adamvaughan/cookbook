defmodule CookbookWeb.PlanViewTest do
  use CookbookWeb.ConnCase, async: true

  alias CookbookWeb.PlanView
  alias Cookbook.Plans.{Meal, Plan}
  alias Cookbook.Repo

  describe "group_plans/1" do
    test "grouping plans" do
      plans = [
        %Plan{month: 3, year: 2018},
        %Plan{month: 1, year: 2019},
        %Plan{month: 3, year: 2019}
      ]

      grouped_plans = PlanView.group_plans(plans)

      assert grouped_plans == [
               {2019, [%Plan{month: 3, year: 2019}, %Plan{month: 1, year: 2019}]},
               {2018, [%Plan{month: 3, year: 2018}]}
             ]
    end
  end

  describe "group_plan_meals/1" do
    test "grouping plan meals" do
      plan = %Plan{
        month: 2,
        year: 2019,
        meals: [%Meal{day: 3}, %Meal{day: 7}, %Meal{day: 7}, %Meal{day: 20}]
      }

      grouped_meals =
        plan
        |> Repo.preload(:meals)
        |> PlanView.group_plan_meals()

      assert grouped_meals == [
               [
                 {"", []},
                 {"", []},
                 {"", []},
                 {"", []},
                 {"", []},
                 {1, []},
                 {2, []}
               ],
               [
                 {3, [%Meal{day: 3}]},
                 {4, []},
                 {5, []},
                 {6, []},
                 {7, [%Meal{day: 7}, %Meal{day: 7}]},
                 {8, []},
                 {9, []}
               ],
               [
                 {10, []},
                 {11, []},
                 {12, []},
                 {13, []},
                 {14, []},
                 {15, []},
                 {16, []}
               ],
               [
                 {17, []},
                 {18, []},
                 {19, []},
                 {20, [%Meal{day: 20}]},
                 {21, []},
                 {22, []},
                 {23, []}
               ],
               [
                 {24, []},
                 {25, []},
                 {26, []},
                 {27, []},
                 {28, []},
                 {"", []},
                 {"", []}
               ]
             ]
    end
  end
end
