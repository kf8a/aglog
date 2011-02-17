# Represents equipment used during an activity, like a plow or tractor.
class Equipment < ActiveRecord::Base
  attr_accessible :name, :use_material, :is_tractor, :description, :archived

  has_many                :setups
  has_and_belongs_to_many :materials

  validates :name, :uniqueness => { :case_sensitive => false }

  def observations
    self.setups.collect {|setup| setup.observation}.compact
  end
end
