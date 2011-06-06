# encoding: UTF-8
require 'csv'

# The main model, an observation is a collection of activities.
class Observation < ActiveRecord::Base
  attr_protected :company_id unless Rails.env == 'test'

  attr :observation_date

  acts_as_state_machine :initial => :published

  state  :published
  state  :in_review

  event :review do
    transitions :from => :published, :to => :in_review
  end

  event :publish do
    transitions :from => :in_review, :to => :published
  end

  has_many :activities, :dependent => :destroy
  has_many :setups, :through => :activities
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :observation_types
  belongs_to :person
  belongs_to :company

  validates :obs_date,          :presence => true
  validates :observation_types, :presence => true
  validates :person_id,         :presence => true
  validate :no_invalid_areas

  scope :by_company, lambda {|company| where(:company_id => company)}
  scope :by_state, lambda {|state| where(:state=> state)}

  accepts_nested_attributes_for :activities, :allow_destroy => true

  def no_invalid_areas
    errors.add(:base, 'invalid areas') if @error_areas.present?
  end

  def company_name
    self.company.try(:name)
  end

  def observation_date=(date_string)
    logger.info date_string
    self.obs_date = Chronic.parse(date_string)
    logger.info obs_date
  end

  def observation_date
    self.obs_date
  end

  def Observation.by_state_and_page(state, page)
    by_state(state).ordered_by_date.includes_everything.paginate :page => page
  end

  def Observation.includes_everything
    includes({:areas => [:study, :treatment]}, :observation_types, {:activities => {:setups => {:material_transactions => :material}}})
  end

  def Observation.ordered_by_date
    order('obs_date desc')
  end

  def areas_as_text
    @error_areas || Area.unparse(areas)
  end

  def prepopulated_area_tokens
    Area.coalese(areas).map(&:attributes).to_json
  end

  def areas_as_text=(areas_as_text)
    @error_areas =  nil
    new_areas = Area.parse(areas_as_text)
    if String == new_areas.class
      @error_areas = new_areas
    else
      self.areas  = new_areas
    end
  end

  def collect_from_setups(method_to_collect)
    self.setups.collect { |setup| setup.send(method_to_collect) }.flatten.compact.uniq
  end

  def equipment_names
    setups.collect { |setup| setup.equipment_name }.flatten.join(', ')
  end

  def in_review
    'in_review' == self.state
  end

  def in_review=(state)
    return if new_record?
    case state
    when '0'
      self.publish!
    when '1'
      self.review!
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
    self.observation_types.first.name
  end

  def observation_type_names
    self.observation_types.collect { |type| type.name }.join(', ')
  end

  def person_name
    self.person.name
  end

  def rates
    collect_from_setups('rates')
  end

  def unit_names
    collect_from_setups('unit_names')
  end
end
