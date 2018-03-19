require 'date'
require 'set'

# Represents a location where observations are done.
class Area < ActiveRecord::Base
  has_and_belongs_to_many :observations, -> { order('obs_date desc') }
  belongs_to :study
  belongs_to :treatment
  belongs_to :company

  scope :by_company, ->(company) { where(company_id: company) }

  validates :name, uniqueness: { case_sensitive: false,
                                 scope: :company_id }
  validates :study, presence: { if: :study_id }

  # validate :treatment_is_part_of_study
  validate :name_has_no_spaces

  acts_as_nested_set

  def self.find_with_name_like(query)
    query = query.downcase + '%'
    Area.where('lower(name) like ?', query)
  end

  def self.to_jquery_tokens
    all.sort.map { |area| { id: area.id, name: area.name } }
  end

  def expand
    leaf? ? [self] : leaves.to_a.keep_if { |area| area.company_id == company_id }
  end

  def self.coalese(areas = [])
    areas_to_check = areas.to_a # make sure we have an array to work with
    areas = areas.map(&:expand).flatten.to_set
    while areas_to_check.present?
      areas_to_check, areas = replace_full_family_with_parent(areas_to_check, areas)
    end

    areas.to_a
  end

  # Tries to find areas by their names
  # @param [String] areas_as_text a string containing area names and tokens
  # @return [String or Array] the original string with errors highlighted or
  #   an array of areas
  # @example Parse a string of actual area names
  #   Area.parse('T1R1 T2') #=> [#<Area id: 1, name: "T1R1" ... >, ... ]
  # @example Parse a string which has no area with that name
  #   Area.parse('T1R1 R11') #=> "T1R1 *R11*"
  def self.parse(areas_as_text, options = {})
    tokens = areas_as_text.split(/[ |,]+/)
    return [] unless tokens.present?
    areas, invalid_tokens = AreaToken.tokens_to_areas(tokens, options[:company])

    if invalid_tokens.present?
      areas = unparse(areas)
      [areas, mark_tokens(invalid_tokens)].join(' ').strip
    else
      areas
    end
  end

  # Transforms an array of areas into a list of area names,
  # contracted if possible.
  # @param [Array] areas an array of areas
  # @return [String] a list of area names, as close as possible to roots.
  def self.unparse(areas = [])
    areas = coalese(areas)
    names = areas.map(&:name).uniq

    names.sort.join(' ')
  end

  def study_name
    study.try(:name)
  end

  def <=>(other)
    comp = level <=> other.level
    if comp == 0
      comp = name <=> other.name
    end

    comp
  end

  def leaf_observations
    if leaf?
      observations
    else
      leaves.map(&:observations)
            .flatten.compact.uniq
    end
  end

  def self.mark_tokens(invalid_tokens)
    return mark_token(invalid_tokens) unless invalid_tokens.respond_to?(:compact)
    invalid_tokens.compact.collect do |token|
      mark_token(token)
    end
  end

  def self.mark_token(invalid_token)
    '*' + invalid_token+ '*'
  end

  def self.replace_full_family_with_parent(areas_to_check, areas)
    area = areas_to_check.pop
    if areas.superset?(area.siblings.to_set)
      areas          = adjust_collection(areas, area)
      areas_to_check = adjust_collection(areas_to_check, area)
    elsif area.root?
      areas << area
    end

    [areas_to_check, areas]
  end

  def self.adjust_collection(collection, area)
    father = area.parent
    kids = father.descendants
    collection + [father] - kids
  end

  private

  def treatment_is_part_of_study
    # if treatment exists then it must belong to correct study
    if treatment_id && (treatment.try(:study_id) != study_id)
      errors.add(:base, 'inconsistent study and treatment combination')
    end
  end

  def name_has_no_spaces
    errors.add(:base, 'names should not contain spaces') if name.to_s.include?(' ')
  end
end
