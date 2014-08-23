module Measurements
  class Gallon < Base
    def self.compatible_measurements
      [Teaspoon, Tablespoon, Ounce, Cup, Pint, Quart]
    end

    def self.conver(quantity, measurement)
      case
      when measurement == Teaspoon then quantity * 768.0
      when measurement == Tablespoon then quantity * 256.0
      when measurement == Ounce then quantity * 128.0
      when measurement == Cup then quantity * 16.0
      when measurement == Pint then quantity * 8.0
      when measurement == Quart then quantity * 4.0
      when measurement == Gallon then quantity
      end.ceil
    end
  end
end
