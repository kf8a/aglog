class ObservationType < ActiveRecord::Base
  has_and_belongs_to_many :observations
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  
end
