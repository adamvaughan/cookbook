defmodule Cookbook.MeasurementsTest do
  use Cookbook.DataCase

  alias Cookbook.Measurements

  describe "parse_quantity/1" do
    test "with a whole number" do
      assert Measurements.parse_quantity("123") == 123.0
    end

    test "with a fraction" do
      assert Measurements.parse_quantity("1/2") == 0.5
    end

    test "with a whole number and a fraction" do
      assert Measurements.parse_quantity("1 1/2") == 1.5
    end
  end

  describe "normalize/1" do
    test "with a known measurement" do
      assert Measurements.normalize("cups") == "cup"
    end

    test "with an unknown measurement" do
      assert Measurements.normalize("chairs") == "chair"
    end
  end

  describe "lookup/1" do
    test "looking up by value" do
      assert Measurements.lookup("dozen") == %{value: "dozen", aliases: ["dozens"]}
    end

    test "lookup up by an alias" do
      assert Measurements.lookup("dozens") == %{value: "dozen", aliases: ["dozens"]}
    end
  end

  describe "compatible/2" do
    test "with unknown measurements" do
      refute Measurements.compatible?(nil, "cup")
      refute Measurements.compatible?("cup", nil)
      refute Measurements.compatible?(nil, nil)
    end

    test "with the same measurement" do
      assert Measurements.compatible?("cup", "cup")
    end

    test "with compatible measurements" do
      assert Measurements.compatible?("cup", "gallon")
      assert Measurements.compatible?("cup", "ounce")
      assert Measurements.compatible?("cup", "pint")
      assert Measurements.compatible?("cup", "quart")
      assert Measurements.compatible?("cup", "tablespoon")
      assert Measurements.compatible?("cup", "teaspoon")
      assert Measurements.compatible?("gallon", "cup")
      assert Measurements.compatible?("gallon", "ounce")
      assert Measurements.compatible?("gallon", "pint")
      assert Measurements.compatible?("gallon", "quart")
      assert Measurements.compatible?("gallon", "tablespoon")
      assert Measurements.compatible?("gallon", "teaspoon")
      assert Measurements.compatible?("ounce", "cup")
      assert Measurements.compatible?("ounce", "pint")
      assert Measurements.compatible?("ounce", "tablespoon")
      assert Measurements.compatible?("ounce", "teaspoon")
      assert Measurements.compatible?("pint", "cup")
      assert Measurements.compatible?("pint", "gallon")
      assert Measurements.compatible?("pint", "ounce")
      assert Measurements.compatible?("pint", "quart")
      assert Measurements.compatible?("pint", "tablespoon")
      assert Measurements.compatible?("pint", "teaspoon")
      assert Measurements.compatible?("quart", "cup")
      assert Measurements.compatible?("quart", "gallon")
      assert Measurements.compatible?("quart", "ounce")
      assert Measurements.compatible?("quart", "pint")
      assert Measurements.compatible?("quart", "tablespoon")
      assert Measurements.compatible?("quart", "teaspoon")
      assert Measurements.compatible?("tablespoon", "cup")
      assert Measurements.compatible?("tablespoon", "ounce")
      assert Measurements.compatible?("tablespoon", "pint")
      assert Measurements.compatible?("tablespoon", "teaspoon")
      assert Measurements.compatible?("teaspoon", "cup")
      assert Measurements.compatible?("teaspoon", "ounce")
      assert Measurements.compatible?("teaspoon", "pint")
      assert Measurements.compatible?("teaspoon", "tablespoon")
    end

    test "with incompatible measurements" do
      refute Measurements.compatible?("cup", "dozen")
    end
  end

  describe "convert/3" do
    test "with the same measurement" do
      assert Measurements.convert(1, "cup", "cup") == 1
    end

    test "with compatible measurements" do
      assert Measurements.convert(6, "cup", "gallon") == 0.375
      assert Measurements.convert(1, "cup", "ounce") == 8
      assert Measurements.convert(4, "cup", "pint") == 2
      assert Measurements.convert(4, "cup", "quart") == 1
      assert Measurements.convert(2, "cup", "tablespoon") == 32
      assert Measurements.convert(1, "cup", "teaspoon") == 48
      assert Measurements.convert(1, "gallon", "cup") == 16
      assert Measurements.convert(2, "gallon", "ounce") == 256
      assert Measurements.convert(2, "gallon", "pint") == 16
      assert Measurements.convert(1, "gallon", "quart") == 4
      assert Measurements.convert(2, "gallon", "tablespoon") == 512
      assert Measurements.convert(1, "gallon", "teaspoon") == 768
      assert Measurements.convert(6, "ounce", "cup") == 0.75
      assert Measurements.convert(1, "ounce", "pint") == 0.0625
      assert Measurements.convert(2, "ounce", "tablespoon") == 4
      assert Measurements.convert(1, "ounce", "teaspoon") == 6
      assert Measurements.convert(6, "pint", "cup") == 12
      assert Measurements.convert(1, "pint", "gallon") == 0.125
      assert Measurements.convert(1, "pint", "ounce") == 16
      assert Measurements.convert(3, "pint", "quart") == 1.5
      assert Measurements.convert(2, "pint", "tablespoon") == 64
      assert Measurements.convert(1, "pint", "teaspoon") == 96
      assert Measurements.convert(6, "quart", "cup") == 24
      assert Measurements.convert(6, "quart", "gallon") == 1.5
      assert Measurements.convert(1, "quart", "ounce") == 32
      assert Measurements.convert(4, "quart", "pint") == 8
      assert Measurements.convert(2, "quart", "tablespoon") == 128
      assert Measurements.convert(1, "quart", "teaspoon") == 192
      assert Measurements.convert(6, "tablespoon", "cup") == 0.375
      assert Measurements.convert(1, "tablespoon", "ounce") == 0.5
      assert Measurements.convert(4, "tablespoon", "pint") == 0.125
      assert Measurements.convert(1, "tablespoon", "teaspoon") == 3
      assert_in_delta Measurements.convert(96, "teaspoon", "cup"), 2, 0.1
      assert_in_delta Measurements.convert(3, "teaspoon", "ounce"), 0.5, 0.1
      assert_in_delta Measurements.convert(18, "teaspoon", "pint"), 0.1875, 0.1
      assert_in_delta Measurements.convert(3, "teaspoon", "tablespoon"), 1, 0.1
    end

    test "with incompatible measurements" do
      assert_raise(ArgumentError, fn -> Measurements.convert(1, "cup", "dozen") end)
    end
  end

  describe "pluralize/1" do
    test "pluralizing measurements" do
      assert Measurements.pluralize("bag") == "bags"
      assert Measurements.pluralize("bottle") == "bottles"
      assert Measurements.pluralize("bunch") == "bunches"
      assert Measurements.pluralize("can") == "cans"
      assert Measurements.pluralize("clove") == "cloves"
      assert Measurements.pluralize("cup") == "cups"
      assert Measurements.pluralize("dozen") == "dozens"
      assert Measurements.pluralize("gallon") == "gallons"
      assert Measurements.pluralize("head") == "heads"
      assert Measurements.pluralize("jar") == "jars"
      assert Measurements.pluralize("large") == "large"
      assert Measurements.pluralize("leaf") == "leaves"
      assert Measurements.pluralize("medium") == "medium"
      assert Measurements.pluralize("ounce") == "ounces"
      assert Measurements.pluralize("package") == "packages"
      assert Measurements.pluralize("packet") == "packets"
      assert Measurements.pluralize("pint") == "pints"
      assert Measurements.pluralize("pound") == "pounds"
      assert Measurements.pluralize("quart") == "quarts"
      assert Measurements.pluralize("slice") == "slices"
      assert Measurements.pluralize("small") == "small"
      assert Measurements.pluralize("stalk") == "stalks"
      assert Measurements.pluralize("tablespoon") == "tablespoons"
      assert Measurements.pluralize("teaspoon") == "teaspoons"
      assert Measurements.pluralize("whole") == "whole"
    end
  end

  describe "abbreviate/1" do
    test "abbreviating measurements" do
      assert Measurements.abbreviate("bag") == "bag"
      assert Measurements.abbreviate("bottle") == "bottle"
      assert Measurements.abbreviate("bunch") == "bunch"
      assert Measurements.abbreviate("can") == "can"
      assert Measurements.abbreviate("clove") == "clove"
      assert Measurements.abbreviate("cup") == "cup"
      assert Measurements.abbreviate("dozen") == "dozen"
      assert Measurements.abbreviate("gallon") == "gallon"
      assert Measurements.abbreviate("head") == "head"
      assert Measurements.abbreviate("jar") == "jar"
      assert Measurements.abbreviate("large") == "lg"
      assert Measurements.abbreviate("leaf") == "leaf"
      assert Measurements.abbreviate("medium") == "med"
      assert Measurements.abbreviate("ounce") == "oz"
      assert Measurements.abbreviate("ounces") == "ozs"
      assert Measurements.abbreviate("package") == "package"
      assert Measurements.abbreviate("packet") == "packet"
      assert Measurements.abbreviate("pint") == "pint"
      assert Measurements.abbreviate("pound") == "lb"
      assert Measurements.abbreviate("pounds") == "lbs"
      assert Measurements.abbreviate("quart") == "quart"
      assert Measurements.abbreviate("slice") == "slice"
      assert Measurements.abbreviate("small") == "sm"
      assert Measurements.abbreviate("stalk") == "stalk"
      assert Measurements.abbreviate("tablespoon") == "tbsp"
      assert Measurements.abbreviate("tablespoons") == "tbsps"
      assert Measurements.abbreviate("teaspoon") == "tsp"
      assert Measurements.abbreviate("teaspoons") == "tsps"
      assert Measurements.abbreviate("whole") == "whole"
    end
  end
end
