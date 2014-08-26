class Quantity
  def self.parse(value)
    regex = /^(\d)(\s+(\d)\/(\d)|\/(\d))?$/
    matches = regex.match(value.strip)

    if matches
      matches = matches[1..-1].compact

      case matches.length
      when 1
        # whole quantity, ie: '1'
        matches[0].to_i
      when 3
        # fractional quantity, ie: '1/4'
        matches[0].to_f / matches[2].to_f
      when 4
        # whole and fractional quantity, id: '1 1/4'
        matches[0].to_i + (matches[2].to_f / matches[3].to_f)
      end
    else
      value.to_f
    end
  end
end
