# These are potentially hazardous chemicals.
class Hazard < ActiveRecord::Base
  # attr_accessible :name, :hazard_type, :chemical_name, :description,
  #                 :notification, :exclusion_time_days

  has_and_belongs_to_many :materials
#  has_and_belongs_to_many :people
end
