defmodule CookbookWeb.ListView do
  use CookbookWeb, :view

  def order_items(items) do
    Enum.sort_by(items, fn item -> item.purchased end)
  end

  def round_quantity(nil), do: nil
  def round_quantity(value), do: value |> Float.ceil() |> round

  def pluralize_description(description, nil) do
    description
  end

  def pluralize_description(description, quantity) do
    Inflex.inflect(description, quantity)
  end
end
