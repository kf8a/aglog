class Unit < ActiveRecord::Base
  has_many :material_transactions
  
  validates :name, :uniqueness => { :case_sensitive => false }
end
