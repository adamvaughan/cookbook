defmodule Cookbook.Recipes.Recipe do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.Recipes.{Ingredient, Step}

  schema "recipes" do
    field :title, :string
    field :notes, :string

    has_many :ingredients, Ingredient, on_replace: :delete, on_delete: :delete_all
    has_many :steps, Step, on_replace: :delete, on_delete: :delete_all

    timestamps()
  end

  def changeset(recipe, attrs \\ %{}) do
    recipe
    |> cast(attrs, [:title, :notes])
    |> cast_assoc(:ingredients)
    |> cast_assoc(:steps)
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
