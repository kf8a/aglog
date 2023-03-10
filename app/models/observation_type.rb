# A broad class of activities being done: harvesting, controlling weeds, etc.
class ObservationType < ApplicationRecord
  has_and_belongs_to_many :observations

  validates :name, uniqueness: { case_sensitive: false, message: 'must be unique' }
end
