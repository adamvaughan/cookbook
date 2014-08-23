module Measurements
  class Teaspoon < Base
    def self.compatible_measurements
      [Tablespoon, Ounce, Cup]
    end

    def self.convert(quantity, measurement)
      case
      when measurement == Teaspoon then quantity
      when measurement == Tablespoon then quantity / 3.0
      when measurement == Ounce then quantity / 6.0
      when measurement == Cup then quantity / 48.0
      end.ceil
    end
  end
end
