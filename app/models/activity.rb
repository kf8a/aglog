# frozen_string_literal: true

# Represents work done during an observation
class Activity < ActiveRecord
  belongs_to :person
  belongs_to :observation, optional: true
  has_many :setups, dependent: :destroy
  has_many :material_transactions, through: :setups

  validates :person, presence: true

  accepts_nested_attributes_for :setups, allow_destroy: true

  delegate :name, to: :person, prefix: true
end
