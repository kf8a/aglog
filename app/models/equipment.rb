class Equipment < ActiveRecord::Base
  has_many :setups
  has_and_belongs_to_many :materials
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  
# self referential join which stuff can get pulled by what.
#  has_many :equipment, :through => EquipmentConnection 
end
