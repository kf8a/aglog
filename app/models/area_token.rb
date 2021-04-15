# frozen_string_literal: true

# Deals with parsing Areas from a string or token_id
class AreaToken
  attr_reader :token

  # Takes a list of strings and returns
  # a tuple with a list of valid areas and a list of invalid tokens
  def self.tokens_to_areas(tokens, company)
    valids = valid_areas(tokens, company)

    areas =
      valids.collect.each_with_index do |valid, index|
        next unless valid

        find_area(tokens[index], company).expand
      end.compact.flatten

    invalid_strings =
      valids.collect.each_with_index do |valid, index|
        next if valid

        tokens[index]
      end.compact
    [areas, invalid_strings]
  end

  def self.valid_areas(tokens, company)
    tokens.collect.each do |token|
      area = find_area(token, company)
      area.present?
    end
  end

  def self.find_area(token, company)
    new(company).to_area(token)
  end

  # NOTE that we are assuming a company id of 1
  def initialize(company)
    @company = company || 1
  end

  def to_area(token)
    # number_token?(token) ? Area.find(token.to_i) : Area.find_by(name: token, company: @company)
    Area.find_by(name: token, company: @company)
  end

  def number_token?(token)
    token.respond_to?(:to_i) && token.to_i != 0
  end
end
