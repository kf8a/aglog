class AreaToken < String

  def initialize(contents = '', company = 1)
    @company = company.presence || 1
    super(contents)
  end

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
      number_part = part.slice!(-1) + number_part
    end

    [part, number_part]
  end

  def number_token?
    self.respond_to?(:to_i) && self.to_i != 0
  end

  def to_area
    if number_token?
      Area.find_by_id(self)
    elsif include?('-')
      Area.find_by_name_and_company_id(self.to_range, @company)
    else
      Area.find_by_name_and_company_id(self, @company)
    end
  end
end
