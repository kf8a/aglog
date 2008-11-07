class Hazard < ActiveRecord::Base
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :people  
end
