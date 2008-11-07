class Activity < ActiveRecord::Base
  belongs_to :person
  belongs_to :observation
  has_many :setups, :dependent => :destroy
  
  validates_presence_of :person_id
  validates_associated :person
  
  def validate
  	if person_id.blank? or !Person.find_by_id(person_id)
  	  errors.add(:person, "Invalid")
  	end
  end

  # def setup_sets=(params)
  #     # clear old setups
  #     self.setups.clear
  #     
  #     #add new setups
  #     params.each do |key, attributes|
  #        next if attributes.delete(:deleted) == 'true'
  #        setup = Setup.new(attributes)
  #        self.setups << setup
  #      end    
  #   end
  #   
  #   def person_id
  #     person ? person.id : nil
  #   end
  # 
end
