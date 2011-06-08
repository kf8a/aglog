class AreaToken

  def initialize(contents = '', company = 1)
    @contents = contents
    @company = company.presence || 1
    self.to_range if @contents.include?('-')
  end

  def to_range
    first_part, dash_part, second_part = @contents.partition('-')
    first_number_part = second_number_part = ''
    base_part, first_number_part = dissect_part(first_part)
    second_number_part = dissect_part(second_part).last
    first_part  = first_part + first_number_part
    second_part = base_part + second_number_part

    @contents = first_part..second_part
  end

  def dissect_part(part)
    number_part = ''
    until part[-1].to_i == 0
      number_part = part[-1] + number_part
      part.chop!
    end

    [part, number_part]
  end

  def number_token?
    @contents.respond_to?(:to_i) && @contents.to_i != 0
  end

  def to_area
    if number_token?
      Area.find_by_id(@contents)
    else
      Area.find_by_name_and_company_id(@contents, @company)
    end
  end
end
