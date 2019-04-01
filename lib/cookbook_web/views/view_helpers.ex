defmodule CookbookWeb.ViewHelpers do
  alias Cookbook.Measurements

  def month(1), do: "January"
  def month(2), do: "February"
  def month(3), do: "March"
  def month(4), do: "April"
  def month(5), do: "May"
  def month(6), do: "June"
  def month(7), do: "July"
  def month(8), do: "August"
  def month(9), do: "September"
  def month(10), do: "October"
  def month(11), do: "November"
  def month(12), do: "December"

  def replace_fractions(nil), do: nil

  def replace_fractions(text) do
    Regex.replace(~r/(\d+)\/(\d+)/, text, fn _, numerator, denominator ->
      "<sup>#{numerator}</sup>&frasl;<sub>#{denominator}</sub>"
    end)
  end

  def pluralize_measurement(nil, _), do: ""

  def pluralize_measurement(measurement, quantity) when is_binary(quantity) do
    quantity = Measurements.parse_quantity(quantity)
    pluralize_measurement(measurement, quantity)
  end

  def pluralize_measurement(measurement, quantity) do
    if quantity <= 1 do
      measurement
    else
      Measurements.pluralize(measurement)
    end
  end

  def abbreviate_measurement(measurement), do: Measurements.abbreviate(measurement)
end
