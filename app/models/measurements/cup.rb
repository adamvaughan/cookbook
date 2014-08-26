module Measurements
  class Cup < Base
    def self.compatible_measurements
      [Teaspoon, Tablespoon, Ounce, Pint, Quart, Gallon]
    end

    def self.convert(quantity, measurement)
      case
      when measurement == Teaspoon then quantity * 48.0
      when measurement == Tablespoon then quantity * 16.0
      when measurement == Ounce then quantity * 8.0
      when measurement == Cup then quantity
      when measurement == Pint then quantity / 2.0
      when measurement == Quart then quantity / 4.0
      when measurement == Gallon then quantity / 16.0
      end
    end
  end
end
