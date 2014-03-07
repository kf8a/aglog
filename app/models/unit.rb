# Measurements have different units: kilograms, quarts, bushels, etc.
class Unit < ActiveRecord::Base

  has_many :material_transactions

  scope :ordered, -> { order('name')}
  validates :name, :uniqueness => { :case_sensitive => false }

  def si_unit_name
    if self.si_unit_id
      Unit.find(self.si_unit_id).name
    end
  end

  def self.si_units
    where('is_si_unit is true')
  end
end
