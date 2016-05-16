# Represents what is being worked on and measured: alfalfa, wheat, corn, etc.
class Material < ActiveRecord::Base

  has_and_belongs_to_many :equipment
  has_many :material_transactions
  has_many :setups, through: :material_transactions
  belongs_to :material_type
  belongs_to :company

  scope :current, -> { where(archived: false) }
  scope :ordered, -> { order('name') }
  scope :by_company, lambda { |company| where(company_id: company) }

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :company_id }

  def self.find_with_children(id)
    where(id: id).includes(:material_transactions,
                           setups: { observation: :observation_types }).first
  end

  # Converts liquids from millileter to grams.
  def to_mass(amount)
    if liquid
      (amount * specific_weight)
    else
      amount
    end
  end

  def observations
    setups.collect(&:observation).compact
  end

  def material_type_name
    material_type.try(:name)
  end
end
