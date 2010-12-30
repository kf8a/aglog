# encoding: UTF-8
if RUBY_VERSION > "1.9" then require 'csv' else require 'fastercsv' end

# The main model, an observation is a collection of activities.
class Observation < ActiveRecord::Base
  attr_accessible :person_id, :comment, :obs_date, :state, :observation_type_ids

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
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :observation_types
  belongs_to :person
  
  validates :obs_date,          :presence => true
  validates :observation_types, :presence => true
  validates :person_id,         :presence => true
  validate :no_invalid_areas
    
  def no_invalid_areas
    errors.add(:base, 'invalid areas') if  @error_areas
  end

  def equipment_names
    activities.collect { |activity| activity.equipment_names }.flatten.join(', ')
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

  def materials_with_rates
    self.activities.collect { |activity| activity.materials_with_rates }.flatten.join(', ')
  end

  def observation_type
    self.observation_types.first.name
  end

  def observation_type_names
    self.observation_types.collect { |type| type.name }.join(', ')
  end

  def areas_as_text
    @error_areas || Area.unparse(areas)
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

  def material_names
    activities.collect { |activity| activity.material_names }.flatten.compact.uniq
  end

  def n_contents
    activities.collect { |activity| activity.n_contents }.flatten.compact.uniq
  end

  def rates
    activities.collect { |activity| activity.rates }.flatten.compact.uniq
  end

  def unit_names
    activities.collect { |activity| activity.unit_names }.flatten.compact.uniq
  end
end
