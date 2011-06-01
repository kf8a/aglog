require 'date'

# Represents a location where observations are done.
class Area < ActiveRecord::Base
  attr_accessible :name, :replicate, :study_id,
                  :treatment_id, :description
  attr_accessible :company_id if Rails.env == 'test'

  has_and_belongs_to_many :observations, :order => 'obs_date desc'
  belongs_to :study
  belongs_to :treatment
  belongs_to :company

  scope :by_company, lambda {|company| where(:company_id => company)}

  validates :name, :uniqueness => { :case_sensitive => false,
                                    :scope => :company_id }
  validates :study, :presence => { :if => :study_id }

  validate :treatment_is_part_of_study
  validate :name_has_no_spaces

  def Area.index_areas(observation_id, current_user)
    observation = Observation.find_by_id(observation_id)
    broad_scope = observation.try(:areas) || Area
    if current_user
      broad_scope.by_company(current_user.company).order('study_id, name').includes(:study).all
    else
      broad_scope.order('study_id, name').includes(:study).all
    end
  end

  # Tries to find areas by their names.
  # @param [String] areas_as_text a string containing area names
  # @return [String or Array] the original string with errors highlighted or
  #   an array of areas
  # @example Parse a string of actual area names
  #   Area.parse('T1R1 T2') #=> [#<Area id: 1, name: "T1R1" ... >, ... ]
  # @example Parse a string which has no area with that name
  #   Area.parse('T1R1 R11') #=> "T1R1 *R11*"
  def Area.parse(areas_as_text, options={})
    return [] if areas_as_text.strip.empty?

    company = options[:company] || 1
    parser = AreaParser.new
    transformer = AreaParserTransform.new
    invalid_tokens = []

    begin
      area_tokens = transformer.apply(parser.parse(areas_as_text.upcase))
      areas = area_tokens.collect.with_index do |token, i|
        area = Area.joins(:treatment, :study)\
                   .where(:company_id => company)\
                   .send(:where, token[:where])\
                   .all
        invalid_tokens << i if area.empty?
        area
      end
      if invalid_tokens.empty?
        areas.flatten
      else
        mark_invalid_tokens(invalid_tokens, areas_as_text)
      end

    rescue Parslet::ParseFailed => error
      bad_ones_marked(areas_as_text)
    end
  end

  def Area.check_parse(areas_as_text)
    parsing_result = parse(areas_as_text)
    if parsing_result.class == String #failed parse
      'Parsing failed; invalid parts are marked: ' + parsing_result
    else
      parsing_result.collect { |area| area.name }.join(', ')
    end
  end

    # Transforms an array of areas into a list of area names and study names if a
  # whole study's areas are included.
  # @param [Array] areas an array of areas
  # @return [String] a list of area names and study names if a whole study's
  #   areas are included (and treatment names for the same reason)
  def Area.unparse(areas = [])
    names, areas = replace_class_areas_by_class([], areas, Study)
    names, areas = replace_class_areas_by_class(names, areas, Treatment)
    names += areas.uniq.collect { |area| area.name }
    names.sort.join(' ')
  end

  def study_name
    self.study.try(:name)
  end


  private##########################################

  def Area.bad_ones_marked(areas_as_text)
    area_parts = areas_as_text.sub(',', ' ').split
    if area_parts.count == 1
      '*' + area_parts[0] + '*'
    else
      parse_individual_pieces(area_parts)
    end
  end

  def Area.parse_individual_pieces(area_parts)
    area_parts.collect do |area_part|
      parsed_part = parse(area_part)
      if parsed_part.class == String
        parsed_part
      else
        area_part
      end
    end.join(' ')
  end

  def Area.mark_invalid_tokens(invalid_tokens, areas_as_text)
    tokens = areas_as_text.split(/[ |,]+/)
    invalid_tokens.each do |index|
      tokens[index] = '*' + tokens[index] + '*'
    end
    tokens.join(' ')
  end

  def Area.replace_class_areas_by_class(names, areas, klass)
    id_method = "#{klass.name.downcase}_id"
    member_ids = areas.collect { |area| area.send(id_method) }
    member_ids.compact.uniq.each do |member_id|
      member_areas = Area.where(id_method => member_id).all
      if areas.contains(member_areas)
        areas -= member_areas
        names << klass.find(member_id).name
      end
    end

    [names, areas]
  end

  def treatment_is_part_of_study
    # if treatment exists then it must belong to correct study
    if treatment && (treatment.study_id != study_id)
      errors.add(:base, 'inconsistent study and treatment combination')
    end
  end

  def name_has_no_spaces
    errors.add(:base, 'names should not contain spaces') if name.to_s.include?(' ')
  end

end

class Array
  def contains(other_array)
    [] == other_array - self
  end
end

class String
  def overlap(other_string)
    id = 0
    overlap = ''
    while self[id] && (self[id] == other_string[id])
      overlap += self[id..id].to_s #id..id gives letter in 1.8.7; just id gives char number
      id += 1
    end

    overlap
  end
end
