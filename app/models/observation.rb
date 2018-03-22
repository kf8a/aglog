# frozen_string_literal: true

require 'csv'

# The main model, an observation is a collection of activities.
class Observation < ActiveRecord::Base
  attr_reader :observation_date

  has_many :activities, dependent: :destroy
  has_many :setups, through: :activities
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :observation_types
  belongs_to :person, inverse_of: :observations
  belongs_to :company

  mount_uploader :note, NoteUploader
  mount_uploaders :notes, NoteUploader

  validates :obs_date,          presence: true
  validates :observation_types, presence: true
  validates :person,            presence: true
  validate :no_invalid_areas

  scope :by_company, ->(company) { where(company_id: company) }

  accepts_nested_attributes_for :activities, allow_destroy: true

  def no_invalid_areas
    errors.add(:base, 'invalid areas') if @error_areas.present?
  end

  def company_name
    company.try(:name)
  end

  def editable?(user)
    Set.new(user.projects).intersect?(Set.new(person.projects))
  end

  def observation_date=(date_string)
    self.obs_date = Chronic.parse(date_string)
  end

  def self.by_year(year)
    where("date_part('year',obs_date) = ?", year)
  end

  def self.by_page(page)
    ordered_by_date.includes_everything.paginate page: page
  end

  def self.includes_everything
    includes({ areas: %i[study treatment] }, :observation_types,
             activities: { setups: { material_transactions: :material } })
  end

  def self.ordered_by_date
    order('obs_date desc')
  end

  def areas_as_text
    @error_areas || Area.unparse(areas)
  end

  def prepopulated_area_tokens
    Area.coalese(areas).map(&:attributes).to_json
  end

  def areas_as_text=(areas_as_text)
    @error_areas = nil
    new_areas = Area.parse(areas_as_text)
    if String == new_areas.class
      @error_areas = new_areas
    else
      self.areas = new_areas
    end
  end

  def collect_from_setups(method_to_collect)
    setups.map { |setup| setup.send(method_to_collect) }
          .flatten.compact.uniq
  end

  def equipment_names
    setups.map(&:equipment_name).flatten.join(', ')
  end

  def in_review=(state)
    return if new_record?
    case state
    when '0'
      publish!
    when '1'
      review!
    end
  end

  def material_names
    collect_from_setups('material_names')
  end

  def materials_with_rates
    collect_from_setups('materials_with_rates').join(', ')
  end

  def n_contents
    collect_from_setups('n_contents')
  end

  def observation_type
    observation_types.first.name
  end

  def observation_type_names
    observation_types.map(&:name).join(', ')
  end

  delegate :name, to: :person, prefix: true

  def rates
    collect_from_setups('rates')
  end

  def unit_names
    collect_from_setups('unit_names')
  end
end
