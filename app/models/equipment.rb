class Equipment < ActiveRecord::Base

  has_many                :setups
  has_and_belongs_to_many :materials
  
  validates_uniqueness_of :name, :case_sensitive => false

  def observations
    self.setups.collect {|setup| setup.activity.try(:observation)}.compact
  end
end
