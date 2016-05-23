# Represents work done during an observation
class Activity < ActiveRecord::Base
  belongs_to :person
  belongs_to :observation
  has_many :setups, dependent: :destroy
  has_many :material_transactions, through: :setups

  validates :person, presence: true
  # validates_associated :person

  accepts_nested_attributes_for :setups, allow_destroy: true

  def person_name
    person.name
  end
end
