defmodule CookbookWeb.RecipeListViewTest do
  use Cookbook.DataCase

  import Phoenix.LiveViewTest

  alias CookbookWeb.RecipeListView
  alias Cookbook.Recipes.Recipe

  describe "group_recipes/1" do
    test "grouping recipes" do
      recipes = [
        %Recipe{title: "Alphabet Soup"},
        %Recipe{title: "Chicken Noodle Soup"},
        %Recipe{title: "Chicken Pot Pie"},
        %Recipe{title: "Green Eggs and Ham"}
      ]

      grouped_recipes = RecipeListView.group_recipes(recipes)

      assert grouped_recipes == %{
               "a" => [%Recipe{title: "Alphabet Soup"}],
               "c" => [%Recipe{title: "Chicken Noodle Soup"}, %Recipe{title: "Chicken Pot Pie"}],
               "g" => [%Recipe{title: "Green Eggs and Ham"}]
             }
    end
  end

  describe "handle_event/3" do
    test "filtering recipes" do
      insert(:recipe, title: "My Recipe")
      insert(:recipe, title: "Your Recipe")
      insert(:recipe, title: "Good Stuff")

      {:ok, view, html} = mount(CookbookWeb.Endpoint, RecipeListView)
      assert html =~ "My Recipe"
      assert html =~ "Your Recipe"
      assert html =~ "Good Stuff"

      html = render_change(view, "filter", %{"q" => "recipe"})
      assert html =~ "My Recipe"
      assert html =~ "Your Recipe"
      refute html =~ "Good Stuff"

      html = render_change(view, "filter", %{"q" => ""})
      assert html =~ "My Recipe"
      assert html =~ "Your Recipe"
      assert html =~ "Good Stuff"
    end
  end
end
