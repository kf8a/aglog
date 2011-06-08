# Deals with parsing Areas from a string or token_id
class AreaToken < String

  def AreaToken.tokens_to_areas(tokens, company = 1)
    tokens.collect.with_index do |token, index|
      area = new(token, company).to_area
      area.present? ? [area.expand, nil] : [nil, index]
    end.transpose
  end

  def initialize(contents = '', company = 1)
    @company = company.presence || 1
    super(contents)
  end

  def to_range
    first_part, dash_part, second_part = self.partition('-')
    base_part, first_number_part = first_part.dissect
    second_number_part = second_part.dissect.last

    (base_part + first_number_part)..(base_part + second_number_part)
  end

  def dissect
    number_part = ''
    until self[-1].to_i == 0
      number_part = self.slice!(-1) + number_part
    end

    [self, number_part]
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
