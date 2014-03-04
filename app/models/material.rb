# Represents what is being worked on and measured: alfalfa, wheat, corn, etc.
class Material < ActiveRecord::Base

  has_and_belongs_to_many :equipment
  has_many :material_transactions
  has_many :setups, :through => :material_transactions
  belongs_to :material_type
  belongs_to :company

  scope :current, -> { where(archived: false)}
  scope :ordered, -> { order('name') }
  scope :by_company, lambda {|company| where(:company_id => company)}

  validates_presence_of :name
  validates :name, :uniqueness => { :case_sensitive => false }

  def self.find_with_children(id)
    where(:id => id).includes(:material_transactions, :setups => {:observation => :observation_types}).first
  end

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

  def material_type_name
    self.material_type.try(:name)
  end

end
