# Represents equipment used during an activity, like a plow or tractor.
class Equipment < ActiveRecord::Base
  has_many                :setups
  has_many                :equipment_pictures
  has_and_belongs_to_many :materials
  belongs_to :company
  belongs_to :equipment_type

  accepts_nested_attributes_for :equipment_pictures

  validates :company, presence: true

  validates :name, uniqueness: { case_sensitive: false, scope: :company_id }

  scope :current, -> { where(archived: false) }
  scope :ordered, -> { order('name') }
  scope :by_company, lambda { |company| where(company_id: company) }

  def observations
    setups.collect(&:observation).compact
  end
end
