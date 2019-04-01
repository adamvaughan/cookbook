defmodule Cookbook.Lists.List do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Lists.Item
  alias Cookbook.Plans.Plan

  schema "lists" do
    has_many :items, Item

    belongs_to :plan, Plan

    timestamps()
  end

  def changeset(list, attrs \\ %{}) do
    list
    |> cast(attrs, [:plan_id])
    |> cast_assoc(:items)
    |> validate_required([:plan_id])
    |> assoc_constraint(:plan)
    |> unique_constraint(:plan_id)
  end
end
