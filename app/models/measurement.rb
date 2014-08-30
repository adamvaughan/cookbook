class Measurement
  def self.lookup(text)
    return Measurements::Blank if text.nil?
    text = text.strip.downcase.singularize.titleize
    measurement = if text.blank?
                    Measurements::Blank
                  else
                    "Measurements::#{text}".constantize
                  end

    while measurement.superclass != Measurements::Base
      measurement = measurement.superclass
    end

    measurement
  rescue NameError
    Measurements.const_set text, Class.new(Measurements::Base)
  end

  def self.compatible?(first, second)
    first = lookup(first)
    second = lookup(second)
    first.compatible_with?(second)
  end
end
