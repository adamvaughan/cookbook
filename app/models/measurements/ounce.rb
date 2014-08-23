module Measurements
  class Ounce < Base
    def self.compatible_measurements
      [Teaspoon, Tablespoon, Cup, Pint]
    end

    def self.convert(quantity, measurement)
      case
      when measurement == Teaspoon then quantity * 6.0
      when measurement == Tablespoon then quantity * 2.0
      when measurement == Ounce then quantity
      when measurement == Cup then quantity / 8.0
      when measurement == Pint then quantity / 16.0
      end.ceil
    end
  end
end
