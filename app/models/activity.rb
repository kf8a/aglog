# Represents work done during an observation
class Activity < ActiveRecord::Base
  attr_accessible :person, :person_id, :observation_id, :operation_type_id,
                  :comment, :hours

  belongs_to :person
  belongs_to :observation
  has_many :setups, :dependent => :destroy
  
  validates :person, :presence => true
  validates_associated :person

  def equipment_names
    self.setups.collect { |setup| setup.equipment_name }
  end

  def person_name
    self.person.try(:name)
  end

  def materials_with_rates
    self.setups.collect { |setup| setup.materials_with_rates }
  end

  def material_names
    setups.collect { |setup| setup.material_names }
  end

  def n_contents
    setups.collect { |setup| setup.n_contents }
  end

  def rates
    setups.collect { |setup| setup.rates }
  end

  def unit_names
    setups.collect { |setup| setup.unit_names }
  end
end
