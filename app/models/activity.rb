class Activity < ActiveRecord::Base
  belongs_to :person
  belongs_to :observation
  has_many :setups, :dependent => :destroy
  
  validates_presence_of :person
  validates_associated :person
  
end
