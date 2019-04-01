defmodule CookbookWeb.ViewHelpersTest do
  use CookbookWeb.ConnCase, async: true

  alias CookbookWeb.ViewHelpers

  describe "month/1" do
    test "converting month number to month name" do
      assert ViewHelpers.month(1) == "January"
      assert ViewHelpers.month(2) == "February"
      assert ViewHelpers.month(3) == "March"
      assert ViewHelpers.month(4) == "April"
      assert ViewHelpers.month(5) == "May"
      assert ViewHelpers.month(6) == "June"
      assert ViewHelpers.month(7) == "July"
      assert ViewHelpers.month(8) == "August"
      assert ViewHelpers.month(9) == "September"
      assert ViewHelpers.month(10) == "October"
      assert ViewHelpers.month(11) == "November"
      assert ViewHelpers.month(12) == "December"
    end
  end

  describe "replace_fractions/1" do
    test "replacing fractions" do
      assert is_nil(ViewHelpers.replace_fractions(nil))
      assert ViewHelpers.replace_fractions("1 1/4") == "1 <sup>1</sup>&frasl;<sub>4</sub>"
    end
  end

  describe "pluralize_measurement/2" do
    test "pluralizing measurements" do
      assert ViewHelpers.pluralize_measurement(nil, 5) == ""
      assert ViewHelpers.pluralize_measurement("cup", 1) == "cup"
      assert ViewHelpers.pluralize_measurement("cup", 5) == "cups"
    end
  end

  describe "abbreviate_measurement/1" do
    test "abbreviating measurements" do
      assert ViewHelpers.abbreviate_measurement("cup") == "cup"
      assert ViewHelpers.abbreviate_measurement("ounce") == "oz"
    end
  end
end
