defmodule Cookbook.ListsTest do
  use Cookbook.DataCase

  alias Cookbook.Lists

  describe "get_list/1" do
    test "getting a list by id" do
      list = insert(:list)
      {:ok, found} = Lists.get_list(list.id)
      assert found.id == list.id
    end

    test "getting an existing list by plan" do
      plan = insert(:plan)
      list = insert(:list, plan: plan)
      {:ok, found} = Lists.get_list(plan)
      assert found.id == list.id
    end

    test "generating a list for a plan" do
      today = Date.utc_today()
      plan = insert(:plan, month: today.month + 1, year: today.year)

      recipe_1 = insert(:recipe, title: "Recipe 1")
      recipe_2 = insert(:recipe, title: "Recipe 2")

      insert(:ingredient, recipe: recipe_1, quantity: "1", measurement: "cup", description: "rice")

      insert(:ingredient,
        recipe: recipe_1,
        quantity: "1/2",
        measurement: "teaspoon",
        description: "salt"
      )

      insert(:ingredient, recipe: recipe_2, quantity: "3", measurement: "cup", description: "rice")

      insert(:ingredient,
        recipe: recipe_2,
        quantity: "1",
        measurement: "tablespoon",
        description: "salt"
      )

      insert(:ingredient,
        recipe: recipe_2,
        quantity: "1",
        measurement: "gallon",
        description: "milk"
      )

      insert(:meal, plan: plan, recipe: recipe_1, day: 1)
      insert(:meal, plan: plan, recipe: recipe_2, day: 2)

      {:ok, list} = plan |> Repo.preload(meals: [recipe: :ingredients]) |> Lists.get_list()
      assert list.plan_id == plan.id
      assert length(list.items) == 3

      item = Enum.find(list.items, fn item -> item.description == "rice" end)
      assert item.quantity == 4
      assert item.measurement == "cup"

      item = Enum.find(list.items, fn item -> item.description == "salt" end)
      assert item.quantity == 1.165
      assert item.measurement == "tablespoon"

      item = Enum.find(list.items, fn item -> item.description == "milk" end)
      assert item.quantity == 1
      assert item.measurement == "gallon"
    end

    test "skipping past days for current month" do
      today = Date.utc_today()
      plan = insert(:plan, month: today.month, year: today.year)
      recipe = insert(:recipe)
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:meal, plan: plan, recipe: recipe, day: today.day - 1)

      {:ok, list} = plan |> Repo.preload(meals: [recipe: :ingredients]) |> Lists.get_list()
      assert list.plan_id == plan.id
      assert Enum.empty?(list.items)
    end
  end

  describe "regenerate/1" do
    test "regenerating a list" do
      today = Date.utc_today()
      plan = insert(:plan, month: today.month + 1, year: today.year)
      list = insert(:list, plan: plan)
      old_item = insert(:item, list: list)

      recipe = insert(:recipe)
      insert(:ingredient, recipe: recipe, quantity: "1", measurement: "cup", description: "rice")
      insert(:meal, plan: plan, recipe: recipe, day: 1)

      {:ok, list} = list |> Repo.preload(:items) |> Lists.regenerate()
      assert length(list.items) == 1
      assert List.first(list.items).id != old_item.id
    end

    test "keeping manually added items" do
      list = insert(:list)
      item = insert(:item, list: list, manually_added: true)
      insert(:item, list: list, manually_added: true, purchased: true)

      {:ok, list} = list |> Repo.preload(:items) |> Lists.regenerate()
      assert length(list.items) == 1
      assert List.first(list.items).id == item.id
    end
  end

  describe "get_item/1" do
    test "getting an item by id" do
      item = insert(:item)
      {:ok, found} = Lists.get_item(item.id)
      assert found.id == item.id
    end
  end

  describe "create_item/1" do
    test "creating an item" do
      list = insert(:list)

      attrs = %{
        "description" => "test"
      }

      {:ok, item} = Lists.create_item(list, attrs)
      assert item.description == "test"
      assert item.list_id == list.id
    end
  end

  describe "update_item/2" do
    test "updating an item" do
      item = insert(:item)

      attrs = %{
        purchased: true
      }

      {:ok, item} = Lists.update_item(item, attrs)
      assert item.purchased
    end
  end
end
