defmodule Cookbook.Plans.Meal do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Plans.Plan
  alias Cookbook.Recipes.Recipe

  schema "meals" do
    field :day, :integer

    belongs_to :plan, Plan
    belongs_to :recipe, Recipe

    timestamps()
  end

  def changeset(meal, attrs \\ %{}) do
    meal
    |> cast(attrs, [:day, :plan_id, :recipe_id])
    |> validate_required([:day, :plan_id, :recipe_id])
    |> assoc_constraint(:plan)
    |> assoc_constraint(:recipe)
  end
end
