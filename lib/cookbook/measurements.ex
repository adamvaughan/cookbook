defmodule Cookbook.Measurements do
  @measurements [
    %{
      value: "bag",
      aliases: ["bags"]
    },
    %{
      value: "bottle",
      aliases: ["bottles"]
    },
    %{
      value: "bunch",
      aliases: ["bunches"]
    },
    %{
      value: "can",
      aliases: ["cans"]
    },
    %{
      value: "clove",
      aliases: ["cloves"]
    },
    %{
      value: "cup",
      aliases: ["c", "cups"],
      conversions: %{
        "gallon" => 0.0625,
        "ounce" => 8,
        "pint" => 0.5,
        "quart" => 0.25,
        "tablespoon" => 16,
        "teaspoon" => 48
      }
    },
    %{
      value: "dozen",
      aliases: ["dozens"]
    },
    %{
      value: "gallon",
      aliases: ["g", "gallons"],
      conversions: %{
        "cup" => 16,
        "ounce" => 128,
        "pint" => 8,
        "quart" => 4,
        "tablespoon" => 256,
        "teaspoon" => 768
      }
    },
    %{
      value: "head",
      aliases: ["heads"]
    },
    %{
      value: "jar",
      aliases: ["jars"]
    },
    %{
      value: "large",
      aliases: ["lg"]
    },
    %{
      value: "leaf",
      aliases: ["leaves"]
    },
    %{
      value: "medium",
      aliases: ["med"]
    },
    %{
      value: "ounce",
      aliases: ["oz", "ozs", "ounces"],
      conversions: %{
        "cup" => 0.125,
        "pint" => 0.0625,
        "tablespoon" => 2,
        "teaspoon" => 6
      }
    },
    %{
      value: "package",
      aliases: ["packages"]
    },
    %{
      value: "packet",
      aliases: ["packets"]
    },
    %{
      value: "pint",
      aliases: ["pt", "pints"],
      conversions: %{
        "cup" => 2,
        "gallon" => 0.125,
        "ounce" => 16,
        "quart" => 0.5,
        "tablespoon" => 32,
        "teaspoon" => 96
      }
    },
    %{
      value: "pound",
      aliases: ["lb", "lbs", "pounds"]
    },
    %{
      value: "quart",
      aliases: ["qt", "quarts"],
      conversions: %{
        "cup" => 4,
        "gallon" => 0.25,
        "ounce" => 32,
        "pint" => 2,
        "tablespoon" => 64,
        "teaspoon" => 192
      }
    },
    %{
      value: "slice",
      aliases: ["slices"]
    },
    %{
      value: "small",
      aliases: ["sm"]
    },
    %{
      value: "stalk",
      aliases: ["stalks"]
    },
    %{
      value: "tablespoon",
      aliases: ["tbsp", "tbsps", "tablespoons"],
      conversions: %{
        "cup" => 0.0625,
        "ounce" => 0.5,
        "pint" => 0.03125,
        "teaspoon" => 3
      }
    },
    %{
      value: "teaspoon",
      aliases: ["tsp", "tsps", "teaspoons"],
      conversions: %{
        "cup" => 0.020833,
        "ounce" => 0.166,
        "pint" => 0.0104166,
        "tablespoon" => 0.33
      }
    },
    %{
      value: "whole"
    }
  ]

  def parse_quantity(quantity) do
    with nil <- Regex.run(~r/(\d+)\s+(\d+)\/(\d+)/, quantity),
         nil <- Regex.run(~r/(\d+)\/(\d+)/, quantity) do
      {quantity, _} = Float.parse(quantity)
      quantity
    else
      [_, whole, numerator, denominator] ->
        String.to_integer(whole) + String.to_integer(numerator) / String.to_integer(denominator)

      [_, numerator, denominator] ->
        String.to_integer(numerator) / String.to_integer(denominator)
    end
  end

  def normalize(measurement) do
    measurement = String.downcase(measurement)

    case lookup(measurement) do
      nil -> Inflex.singularize(measurement)
      measurement -> measurement.value
    end
  end

  def lookup(value) do
    @measurements
    |> Enum.find(fn measurement ->
      value == measurement.value || measurement |> Map.get(:aliases, []) |> Enum.member?(value)
    end)
  end

  def compatible?(nil, _), do: false
  def compatible?(_, nil), do: false
  def compatible?(m1, m2) when m1 == m2, do: true
  def compatible?(m1, m2) when is_bitstring(m1), do: compatible?(lookup(m1), m2)
  def compatible?(m1, m2) when is_bitstring(m2), do: compatible?(m1, lookup(m2))

  def compatible?(m1, m2) do
    m1
    |> Map.get(:conversions, %{})
    |> Map.keys()
    |> Enum.member?(m2.value)
  end

  def convert(value, m1, m2) when m1 == m2, do: value
  def convert(value, m1, m2) when is_bitstring(m1), do: convert(value, lookup(m1), m2)
  def convert(value, m1, m2) when is_bitstring(m2), do: convert(value, m1, lookup(m2))

  def convert(value, m1, m2) do
    conversions = Map.get(m1, :conversions, %{})
    factor = Map.get(conversions, m2.value)

    if factor do
      value * factor
    else
      raise(ArgumentError, "Can't convert #{m1.value} to #{m2.value}")
    end
  end

  def pluralize("large"), do: "large"
  def pluralize("medium"), do: "medium"
  def pluralize("small"), do: "small"
  def pluralize("whole"), do: "whole"

  def pluralize(measurement) do
    Inflex.pluralize(measurement)
  end

  def abbreviate("tablespoon"), do: "tbsp"
  def abbreviate("tablespoons"), do: "tbsps"
  def abbreviate("teaspoon"), do: "tsp"
  def abbreviate("teaspoons"), do: "tsps"
  def abbreviate("ounce"), do: "oz"
  def abbreviate("ounces"), do: "ozs"
  def abbreviate("pound"), do: "lb"
  def abbreviate("pounds"), do: "lbs"
  def abbreviate("small"), do: "sm"
  def abbreviate("medium"), do: "med"
  def abbreviate("large"), do: "lg"
  def abbreviate(measurement), do: measurement
end
