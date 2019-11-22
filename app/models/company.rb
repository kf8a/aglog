# Different groups have different equipment, people, etc.
# These groups are represented as companies.
class Company < ActiveRecord::Base
  has_many :memberships
  has_many :people, through: :memberships
  has_many :equipment
  has_many :materials
  has_many :observations
  has_many :areas

  validates_uniqueness_of :name
end
