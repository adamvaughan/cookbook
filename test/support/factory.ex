defmodule Cookbook.Factory do
  use ExMachina.Ecto, repo: Cookbook.Repo

  def plan_factory do
    %Cookbook.Plans.Plan{
      month: 3,
      year: 2019
    }
  end

  def meal_factory do
    %Cookbook.Plans.Meal{
      day: 1,
      plan: build(:plan),
      recipe: build(:recipe)
    }
  end

  def list_factory do
    %Cookbook.Lists.List{
      plan: build(:plan)
    }
  end

  def item_factory do
    %Cookbook.Lists.Item{
      quantity: 1.5,
      measurement: "cup",
      description: "rice",
      list: build(:list)
    }
  end

  def recipe_factory do
    %Cookbook.Recipes.Recipe{
      title: "Test Recipe",
      notes: "This is really good!",
      ingredients: [],
      steps: []
    }
  end

  def ingredient_factory do
    %Cookbook.Recipes.Ingredient{
      index: 1,
      quantity: "2",
      measurement: "cup",
      description: "rice"
    }
  end

  def step_factory do
    %Cookbook.Recipes.Step{
      index: 1,
      description: "Cook it."
    }
  end
end
