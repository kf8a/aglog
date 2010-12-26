class ObservationType < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :observations
  
  validates :name, :uniqueness => { :case_sensitive => false, :message => "must be unique" }
  
end
