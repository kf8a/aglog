class Study < ActiveRecord::Base
	has_many :areas
	has_many :treatments
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
end
