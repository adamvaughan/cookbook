module Measurements
  class Quart < Base
    def self.compatible_measurements
      [Teaspoon, Tablespoon, Ounce, Cup, Pint, Gallon]
    end

    def self.convert(quantity, measurement)
      case
      when measurement == Teaspoon then quantity * 192.0
      when measurement == Tablespoon then quantity * 64.0
      when measurement == Ounce then quantity * 32.0
      when measurement == Cup then quantity * 4.0
      when measurement == Pint then quantity * 2.0
      when measurement == Quart then quantity
      when measurement == Gallon then quantity / 4.0
      end.ceil
    end
  end
end
