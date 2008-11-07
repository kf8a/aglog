class Treatment < ActiveRecord::Base
  has_many :areas
  belongs_to :study
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  
  validates_presence_of :study, :allow_nil => true, :message => "must exist"
end
