# A person is both someone who performs activities, and (with an open id) a
# user of the web application.
class Person < ActiveRecord::Base
  attr_accessible :given_name, :sur_name, :openid_identifier

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
    errors.add(:base, "Name cannot be blank") unless given_name? || sur_name?
  end

  def others_with_name? 
    given = self.given_name || ""
    sur =  self.sur_name || ""
    
    others = Person.where(["lower(given_name) = ? and lower(sur_name) = ?",
				  given.downcase, sur.downcase]).first

		others && (others.id != self.id)
  end
end
