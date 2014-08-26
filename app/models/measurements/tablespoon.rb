module Measurements
  class Tablespoon < Base
    def self.compatible_measurements
      [Teaspoon, Ounce, Cup, Pint]
    end

    def self.convert(quantity, measurement)
      case
      when measurement == Teaspoon then quantity * 3.0
      when measurement == Tablespoon then quantity
      when measurement == Ounce then quantity / 2.0
      when measurement == Cup then quantity / 16.0
      when measurement == Pint then quantity / 32.0
      end
    end
  end
end
