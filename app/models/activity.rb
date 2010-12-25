class Activity < ActiveRecord::Base
  belongs_to :person
  belongs_to :observation
  has_many :setups, :dependent => :destroy
  
  validates :person, :presence => true
  validates_associated :person

  def person_name
    self.person.try(:name)
  end
  
end
