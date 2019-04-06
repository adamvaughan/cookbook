defmodule Cookbook.Lists.Item do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Lists.List
  alias Cookbook.Utils

  schema "items" do
    field :quantity, :float
    field :measurement, :string
    field :description, :string
    field :purchased, :boolean, default: false
    field :manually_added, :boolean, default: false

    belongs_to :list, List

    timestamps()
  end

  def changeset(item, attrs \\ %{}) do
    item
    |> cast(attrs, [:quantity, :measurement, :description, :purchased, :manually_added, :list_id])
    |> update_change(:measurement, &Utils.trim/1)
    |> update_change(:description, &Utils.trim/1)
    |> validate_required([:description])
    |> assoc_constraint(:list)
  end
end
