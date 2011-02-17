# Measurements have different units: kilograms, quarts, bushels, etc.
class Unit < ActiveRecord::Base
  attr_accessible :name, :si_unit_id, :conversion_factor

  has_many :material_transactions

  validates :name, :uniqueness => { :case_sensitive => false }
end
