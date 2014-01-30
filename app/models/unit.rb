# Measurements have different units: kilograms, quarts, bushels, etc.
class Unit < ActiveRecord::Base

  has_many :material_transactions

  scope :ordered, -> { order('name')}
  validates :name, :uniqueness => { :case_sensitive => false }

  def si_unit_name
    Unit.find(si_unit_id).first.name
  end
end
