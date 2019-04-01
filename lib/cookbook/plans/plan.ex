defmodule Cookbook.Plans.Plan do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Plans.Meal

  schema "plans" do
    field :month, :integer
    field :year, :integer

    has_many :meals, Meal

    timestamps()
  end

  def changeset(plan, attrs \\ %{}) do
    plan
    |> cast(attrs, [:month, :year])
    |> validate_required([:month, :year])
    |> unique_constraint(:month, name: "plans_month_year_index")
  end
end
