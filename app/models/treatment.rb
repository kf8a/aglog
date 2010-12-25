class Treatment < ActiveRecord::Base
  has_many :areas
  belongs_to :study
  
  validates :name,  :uniqueness => { :case_sensitive => false }
  validates :study, :presence   => { :allow_nil => true }
end
