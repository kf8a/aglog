# Groups of areas belong to different studies.
class Study < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :areas
  has_many :treatments

  validates :name, :uniqueness => { :case_sensitive => false }
end
