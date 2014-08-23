module Measurements
  class Base
    def self.full_name
      name.split('::').last.downcase
    end

    def self.compatible_measurements
      []
    end

    def self.compatible_with?(other)
      return true if self == other

      compatible_measurements.map do |measurement|
        [measurement, measurement.subclasses]
      end.flatten.include?(other)
    end

    def self.convert(quantity, measurement)
      quantity.ceil if self == measurement
    end
  end
end
