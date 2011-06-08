require 'date'
require 'set'

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

  acts_as_nested_set

  def Area.find_with_name_like(query)
    query = query.downcase + '%'
    Area.where('lower(name) like ?', query).all.sort
  end

  def expand
    leaf? ? self : leaves
  end

  def Area.coalese(areas = [])
    # need to check if one or more ancestors are complete

    areas_to_check = areas
    areas = areas.collect{ |area| area.expand }.flatten.to_set
    while areas_to_check.present?
      areas_to_check, areas = replace_full_family_with_parent(areas_to_check, areas)
    end

    areas.to_a
  end

  def Area.index_areas(observation_id)
    observation = Observation.find_by_id(observation_id)
    broad_scope = observation.try(:areas) || Area
    broad_scope.order('study_id, name').includes(:study).all
  end

  def Area.index_areas_by_company_and_observation(company, observation_id)
    observation = Observation.find_by_id(observation_id)
    broad_scope = observation.try(:areas) || Area
    broad_scope.by_company(company).order('study_id, name').includes(:study).all
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
    tokens = areas_as_text.split(/[ |,]+/)
    areas = []
    invalid_tokens = []
    tokens.each.with_index do |token, index|
      area_token = AreaToken.new(token, options[:company])
      area = area_token.to_area
      area.presence ? areas << area.expand : invalid_tokens << index
    end

    invalid_tokens.any? ? mark_tokens(invalid_tokens, tokens) : areas.flatten
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
    areas = coalese(areas)
    names = areas.collect { |area| area.name }.uniq

    names.sort.join(' ')
  end

  def study_name
    self.study.try(:name)
  end

  def <=>(other_area)
    comp = self.level <=> other_area.level
    if comp == 0
      comp = self.name <=> other_area.name
    end

    comp
  end


  private##########################################

  def Area.mark_tokens(invalid_tokens, tokens)
    invalid_tokens.each do |index|
      tokens[index] = '*' + tokens[index] + '*'
    end
    tokens.join(' ')
  end

  def Area.replace_full_family_with_parent(areas_to_check, areas)
    area = areas_to_check.pop
    if areas.superset?(area.siblings.to_set)
      father = area.parent
      kids = father.descendants
      areas          = areas + [father] - kids
      areas_to_check = areas_to_check + [father] - kids
    end

    [areas_to_check, areas]
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
