class Unit < ActiveRecord::Base
  has_many :material_transactions
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  
   
end
