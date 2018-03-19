# Deals with parsing Areas from a string or token_id
class AreaToken
  attr_reader :token

  # Takes a list of strings and returns
  # a tuple with a list of valid areas and a list of invalid tokens
  def self.tokens_to_areas(tokens, company)
    # tokens.collect.with_index do |token, index|
    #   area = new(company).to_area(token)
    #   area.present? ? area.expand : tokens[index]
    # end

    valids = tokens.collect.each do |token|
      area = find_area(token, company)
      area.present?
    end

    areas = valids.collect.each_with_index do |valid, index|
      next unless valid
      find_area(tokens[index], company).expand
    end.compact.flatten

    invalid_strings = valids.collect.each_with_index do |valid, index|
      next if valid
      tokens[index]
    end.compact
    [areas, invalid_strings]
  end

  def self.find_area(token, company)
      new(company).to_area(token)
  end

  # NOTE that we are assuming a company id of 1
  def initialize(company)
    @company = company ||= 1
  end

  def to_area(token)
    if number_token?(token)
      Area.find(token.to_i)
    elsif token.include?('-')
      names = to_range(token).to_s
      Area.find_by(name: names, company: @company)
    else
      Area.find_by(name: token, company: @company)
    end
  end

  # TODO range does not work at this time
  def to_range(token)
    first_part, _dash_part, second_part = token.partition('-')
    return '' if second_part.empty?

    base_part, first_number_part = range_base(first_part)
    second_number_part = range_base(second_part).last

    (base_part + first_number_part)..(base_part + second_number_part)
  end

  def range_base(input)
    /(\w+)?(\d+)+/.match(input).captures
  end

  def number_token?(token)
    token.respond_to?(:to_i) && token.to_i != 0
  end
end
