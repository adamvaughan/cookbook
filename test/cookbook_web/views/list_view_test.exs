defmodule CookbookWeb.ListViewTest do
  use CookbookWeb.ConnCase, async: true

  alias Cookbook.Lists.Item
  alias CookbookWeb.ListView

  describe "order_items/1" do
    test "sorting purchased items last" do
      items = [
        %Item{description: "Purchased", purchased: true},
        %Item{description: "Not Purchased", purchased: false}
      ]

      sorted_items = ListView.order_items(items)
      assert List.first(sorted_items).description == "Not Purchased"
      assert List.last(sorted_items).description == "Purchased"
    end
  end

  describe "round_quantity/1" do
    test "rounding quantities" do
      assert is_nil(ListView.round_quantity(nil))
      assert ListView.round_quantity(1.2) == 2
      assert ListView.round_quantity(2.8) == 3
    end
  end

  describe "pluralize_description/3" do
    test "pluralizing descriptions" do
      assert ListView.pluralize_description("apple", nil) == "apple"
      assert ListView.pluralize_description("apple", 1) == "apple"
      assert ListView.pluralize_description("apple", 2) == "apples"
    end
  end
end
