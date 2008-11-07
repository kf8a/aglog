class Material < ActiveRecord::Base
  has_and_belongs_to_many :equipment 
  has_and_belongs_to_many :hazards
  has_many :material_transactions
  has_many :setups, :through => :material_transactions
  belongs_to :material_type
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
 
  def to_mass(amount)
    if liquid
      (amount * specific_weight) * 1000.0
    else
      amount
    end
  end
  
  
end
