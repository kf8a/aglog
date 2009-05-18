class Person < ActiveRecord::Base
  acts_as_authentic
  
  has_many :observations
  has_many :activities
  has_and_belongs_to_many :hazards
   
  
  def validate
    errors.add("", "Full Name '#{given_name} #{sur_name}' must be unique") if others_with_name? 
    errors.add("", "Name cannot be blank") if self.given_name.blank? and self.sur_name.blank? 
  end

  def name
    [given_name, sur_name].join(' ')
  end
  
  private
  def others_with_name? 
    given = self.given_name || ""
    sur =  self.sur_name || ""
    
    others = Person.find(:first,
      :conditions => 
				["lower(given_name) = ? and lower(sur_name) = ?", 
				  given.downcase, sur.downcase])
		return false if others.nil?
		others.id != self.id
  end
end
