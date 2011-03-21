# A grouping of areas within a study.
class Treatment < ActiveRecord::Base
  attr_accessible :name, :study_id, :treatment_number

  has_many :areas
  belongs_to :study

  validates :name,  :uniqueness => { :case_sensitive => false }
  validates :study, :presence   => { :allow_nil => true }
end
