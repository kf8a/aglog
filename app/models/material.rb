# Represents what is being worked on and measured: alfalfa, wheat, corn, etc.
class Material < ActiveRecord::Base
  attr_accessible :name, :operation_type_id, :material_type_id, :n_content,
                  :p_content, :k_content, :specific_weight, :liquid

  has_and_belongs_to_many :equipment 
  has_and_belongs_to_many :hazards
  has_many :material_transactions
  has_many :setups, :through => :material_transactions
  belongs_to :material_type
  
  validates :name, :uniqueness => { :case_sensitive => false }

  # Converts liquids from liters to grams.
  def to_mass(amount)
    if liquid
      (amount * specific_weight) * 1000.0
    else
      amount
    end
  end

  def observations
    self.setups.collect {|setup| setup.observation}.compact
  end
  
end
