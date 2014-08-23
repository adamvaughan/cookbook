module Measurements
  class Pint < Base
    def self.compatible_measurements
      [Teaspoon, Tablespoon, Ounce, Cup, Quart, Gallon]
    end

    def self.convert(quantity, measurement)
      case
      when measurement == Teaspoon then quantity * 98.0
      when measurement == Tablespoon then quantity * 32.0
      when measurement == Ounce then quantity * 16.0
      when measurement == Cup then quantity * 2.0
      when measurement == Pint then quantity
      when measurement == Quart then quantity / 2.0
      when measurement == Gallon then quantity / 8.0
      end.ceil
    end
  end
end
