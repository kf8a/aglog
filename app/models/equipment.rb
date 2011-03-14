# Represents equipment used during an activity, like a plow or tractor.
class Equipment < ActiveRecord::Base
  attr_accessible :name, :use_material, :is_tractor, :description, :archived

  has_many                :setups
  has_and_belongs_to_many :materials
  belongs_to :company

  validates_presence_of :company

  validates :name, :uniqueness => { :case_sensitive => false, 
                                    :scope => :company_id }

  scope :current, where(:archive => false)
  scope :by_company, lambda {|company| where(:company_id => company) }

  def observations
    self.setups.collect {|setup| setup.observation}.compact
  end
end
