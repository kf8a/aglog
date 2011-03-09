# A setup is the equipment and material used for an activity.
class Setup < ActiveRecord::Base
  #attr_accessible :activity_id, :equipment_id, :settings

  belongs_to :activity
  belongs_to :equipment
  has_one :observation, :through => :activity
  has_many :material_transactions, :dependent => :destroy
  has_many :materials, :through => :material_transactions
  has_many :units, :through => :material_transactions

  validates_associated :equipment
  validates :equipment, :presence => true

  validates_associated :material_transactions

  accepts_nested_attributes_for :material_transactions, :allow_destroy => true

  def equipment_name
    self.equipment.try(:name)
  end

  def materials_with_rates
    self.material_transactions.collect { |trans| trans.material_with_rate }
  end

  def material_names
    materials.collect { |material| material.name }
  end

  def n_contents
    material_transactions.collect { |transaction| transaction.n_content }
  end

  def rates
    material_transactions.collect { |transaction| transaction.rate }
  end

  def unit_names
    units.collect { |unit| unit.name }
  end
end
