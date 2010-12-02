class Person < ActiveRecord::Base
  acts_as_authentic
  
  has_many :observations
  has_many :activities
  has_and_belongs_to_many :hazards

  validate :must_have_unique_name
  validate :must_have_name
   
  
  def name
    [given_name, sur_name].join(' ')
  end
  
  private##################################

  def must_have_unique_name
    errors.add(:base, "Full Name '#{given_name} #{sur_name}' must be unique") if others_with_name?
  end

  def must_have_name
    errors.add(:base, "Name cannot be blank") if self.given_name.blank? and self.sur_name.blank?
  end

  def others_with_name? 
    given = self.given_name || ""
    sur =  self.sur_name || ""
    
    others = Person.where(["lower(given_name) = ? and lower(sur_name) = ?",
				  given.downcase, sur.downcase]).first
		return false if others.nil?
		others.id != self.id
  end
end
