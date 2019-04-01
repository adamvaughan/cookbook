defmodule Cookbook.Lists.Item do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Lists.List

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
    |> validate_required([:description])
    |> assoc_constraint(:list)
  end
end
