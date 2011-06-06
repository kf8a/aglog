class AreaToken < String

  def to_range
    first_part, dash_part, second_part = self.partition('-')
    first_number_part = second_number_part = ''
    base_part, first_number_part = dissect_part(first_part)
    second_number_part = dissect_part(second_part).last
    first_part  = first_part + first_number_part
    second_part = base_part + second_number_part

    first_part..second_part
  end

  def dissect_part(part)
    number_part = ''
    until part[-1].to_i == 0
      number_part = part[-1] + number_part
      part.chop!
    end

    [part, number_part]
  end
end
