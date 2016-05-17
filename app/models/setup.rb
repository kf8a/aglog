# A setup is the equipment and material used for an activity.
class Setup < ActiveRecord::Base
  belongs_to :activity
  belongs_to :equipment
  has_one :observation, through: :activity
  has_many :material_transactions, dependent: :destroy
  has_many :materials, through: :material_transactions
  has_many :units, through: :material_transactions

  validates_associated :equipment
  validates :equipment, presence: true

  validates_associated :material_transactions

  accepts_nested_attributes_for :material_transactions, allow_destroy: true

  def equipment_name
    equipment.try(:name)
  end

  def materials_with_rates
    material_transactions.collect(&:materials_with_rate)
  end

  def material_names
    materials.collect(&:name)
  end

  def n_contents
    material_transactions.collect(&:n_content)
  end

  def rates
    material_transactions.collect(&rate)
  end

  def unit_names
    units.collect(&:name)
  end
end
