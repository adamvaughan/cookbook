defmodule Cookbook.Lists do
  alias Cookbook.Lists.Item
  alias Cookbook.{Measurements, Plans, Repo}

  def get_list(id) when is_integer(id) or is_binary(id) do
    case Repo.get(Cookbook.Lists.List, id) do
      nil -> {:error, :not_found}
      list -> {:ok, Repo.preload(list, :items)}
    end
  end

  def get_list(plan) do
    case Repo.get_by(Cookbook.Lists.List, plan_id: plan.id) do
      nil ->
        items = generate_list_items(plan)
        create_list(plan, items)

      list ->
        {:ok, Repo.preload(list, :items)}
    end
  end

  def regenerate(list) do
    {:ok, plan} = Plans.get_plan(list.plan_id)

    Enum.each(list.items, fn item ->
      unless item.manually_added do
        Repo.delete(item)
      end
    end)

    items = generate_list_items(plan)

    Enum.each(items, fn attrs ->
      attrs = Map.put(attrs, :list_id, list.id)
      changeset = Item.changeset(%Item{}, attrs)
      Repo.insert!(changeset)
    end)

    get_list(list.id)
  end

  defp generate_list_items(plan) do
    plan
    |> get_meals()
    |> Enum.map(fn meal -> meal.recipe end)
    |> Enum.flat_map(fn recipe -> recipe.ingredients end)
    |> Enum.map(fn ingredient -> build_item(ingredient) end)
    |> Enum.reduce(%{}, fn item, acc -> group_compatible_items(item, acc) end)
    |> Enum.reduce([], fn {_ingredient, measurement_items}, acc ->
      measurement_items
      |> Map.values()
      |> Enum.map(fn items -> combine_items(items) end)
      |> Enum.concat(acc)
    end)
  end

  defp get_meals(plan) do
    today = Date.utc_today()

    if plan.month == today.month && plan.year == today.year do
      Enum.filter(plan.meals, fn meal -> meal.day >= today.day end)
    else
      plan.meals
    end
  end

  defp build_item(ingredient) do
    description =
      ingredient.description
      |> String.split(",")
      |> List.first()

    %{
      quantity: Measurements.parse_quantity(ingredient.quantity),
      description: description,
      measurement: ingredient.measurement
    }
  end

  defp group_compatible_items(item, items) do
    # group items by compatible ingredients and compatible measurements
    ingredient_items = Map.get(items, item.description, %{})
    measurements = Map.keys(ingredient_items)

    measurement =
      Enum.find(measurements, fn m ->
        m == item.measurement || Measurements.compatible?(m, item.measurement)
      end) || item.measurement

    measurement_items = Map.get(ingredient_items, measurement, [])
    measurement_items = [item | measurement_items]

    ingredient_items = Map.put(ingredient_items, measurement, measurement_items)
    Map.put(items, item.description, ingredient_items)
  end

  defp combine_items(items) do
    measurement = find_minimal_measurement(items)

    # convert all measurements to the minimal measurement and sum the quantities
    quantity =
      Enum.reduce(items, 0, fn item, sum ->
        sum + Measurements.convert(item.quantity, item.measurement, measurement)
      end)

    item = List.first(items)
    %{item | quantity: quantity, measurement: measurement}
  end

  defp find_minimal_measurement(items) do
    # find the measurement that results in the smallest quantity
    measurements =
      items
      |> Enum.map(fn item -> item.measurement end)
      |> Enum.uniq()

    Enum.min_by(measurements, fn measurement ->
      Enum.reduce(items, 0, fn item, sum ->
        sum + Measurements.convert(item.quantity, item.measurement, measurement)
      end)
    end)
  end

  defp create_list(plan, items) do
    attrs = %{plan_id: plan.id, items: items}
    changeset = Cookbook.Lists.List.changeset(%Cookbook.Lists.List{}, attrs)
    Repo.insert(changeset)
  end

  def get_item(id) do
    case Repo.get(Item, id) do
      nil -> {:error, :not_found}
      item -> {:ok, item}
    end
  end

  def create_item(list, attrs) do
    attrs = Map.put(attrs, "list_id", list.id)
    changeset = Item.changeset(%Item{}, attrs)
    Repo.insert(changeset)
  end

  def update_item(item, attrs) do
    changeset = Item.changeset(item, attrs)
    Repo.update(changeset)
  end
end
