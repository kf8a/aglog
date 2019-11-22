# frozen_string_literal: true

# Measurements have different units: kilograms, quarts, bushels, etc.
class Unit < ActiveRecord::Base
  has_many :material_transactions

  scope :ordered, -> { order('name') }
  validates :name, uniqueness: { case_sensitive: false }

  def si_unit_name
    return if si_unit_id.nil?

    Unit.find(si_unit_id).name
  end

  def self.si_units
    where('is_si_unit is true')
  end
end
