# frozen_string_literal: true

# A setup is the equipment and material used for an activity.
class Setup < ActiveRecord::Base
  belongs_to :activity, optional: true
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
    material_transactions.map(&:material_with_rate)
  end

  def material_names
    materials.map(&:name)
  end

  def n_contents
    material_transactions.map(&:n_content)
  end

  def rates
    material_transactions.map(&:rate)
  end

  def unit_names
    units.map(&:name)
  end
end
