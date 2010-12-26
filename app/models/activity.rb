class Activity < ActiveRecord::Base
  attr_accessible :person, :person_id, :observation_id, :operation_type_id,
                  :comment, :hours

  belongs_to :person
  belongs_to :observation
  has_many :setups, :dependent => :destroy
  
  validates :person, :presence => true
  validates_associated :person

  def person_name
    self.person.try(:name)
  end
  
end
