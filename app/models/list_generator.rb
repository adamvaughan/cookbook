class ListGenerator
  def self.generate!(plan)
    new.generate!(plan)
  end

  def generate!(plan)
    list_items = list_items_for_plan_ingredients(plan)
    descriptions = list_items.map(&:description).uniq

    list_items = descriptions.map do |description|
      list_items_for_description = list_items.select { |list_item| list_item.description == description }
      groups = group_by_compatible_measurements(list_items_for_description)
      groups.map { |group| combine_list_items(group) }
    end.flatten

    List.create!(plan: plan, list_items: list_items)
  end

  private

  def list_items_for_plan_ingredients(plan)
    meals = filter_meals(plan)
    recipes = meals.map(&:recipe)
    ingredients = recipes.map(&:ingredients).flatten

    ingredients.map do |ingredient|
      quantity = Quantity.parse(ingredient.quantity)
      description = ingredient.description.strip.downcase.singularize
      measurement = Measurement.lookup(ingredient.measurement)
      ListItem.new(quantity: quantity, measurement: measurement.full_name, description: description)
    end
  end

  # Only use meals on or after the current day if generating a list for the current month.
  def filter_meals(plan)
    today = Date.today
    year = today.year
    month = today.month - 1 # we're using 0-11 for month but ruby uses 1-12
    day = today.day

    if plan.year == year && plan.month == month
      plan.meals.select { |meal| meal.day >= day }
    else
      plan.meals
    end
  end

  def group_by_compatible_measurements(list_items)
    groups = []

    while list_items.count > 0
      list_item = list_items.shift

      compatible_list_items, incompatible_list_items = list_items.partition do |other_list_item|
        Measurement.compatible?(list_item.measurement, other_list_item.measurement)
      end

      list_items = incompatible_list_items
      compatible_list_items << list_item
      groups << compatible_list_items
    end

    groups
  end

  def combine_list_items(list_items)
    measurements = list_items.map { |list_item| Measurement.lookup(list_item.measurement) }.uniq
    selection = nil

    measurements.each do |measurement|
      list_item_for_measurement = ListItem.new(quantity: 0, measurement: measurement.full_name, description: list_items.first.description)

      list_items.each do |list_item|
        list_item_measurement = Measurement.lookup(list_item.measurement)
        list_item_for_measurement.quantity += list_item_measurement.convert(list_item.quantity, measurement)
      end

      # pick the list item whose measurement produces the smallest quantity
      if selection.nil? || selection.quantity > list_item_for_measurement.quantity
        selection = list_item_for_measurement
      end
    end

    selection.quantity = selection.quantity.ceil
    selection.description = selection.description.pluralize(selection.quantity)

    if selection.measurement.present?
      measurement = Measurement.lookup(selection.measurement)

      if measurement.always_pluralize_description
        selection.measurement = selection.measurement.pluralize
      else
        selection.measurement = selection.measurement.pluralize(selection.quantity)
      end
    end

    selection
  end
end
