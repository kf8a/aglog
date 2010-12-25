class Equipment < ActiveRecord::Base

  has_many                :setups
  has_and_belongs_to_many :materials
  
  validates :name, :uniqueness => { :case_sensitive => false }

  def observations
    self.setups.collect {|setup| setup.observation}.compact
  end
end
