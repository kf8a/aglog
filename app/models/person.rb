# A person is both someone who performs activities, and (with an open id) a
# user of the web application.
class Person < ActiveRecord::Base
  attr_accessible :given_name, :sur_name, :openid_identifier

  has_many :observations
  has_many :activities
  belongs_to :company
  has_and_belongs_to_many :hazards

  validates :given_name,
              :presence   => { :unless => :sur_name },
              :uniqueness => { :scope => :sur_name, :case_sensitive => false }
  validates :sur_name,
              :presence   => { :unless => :given_name },
              :uniqueness => { :scope => :given_name, :case_sensitive => false }

  def name
    [given_name, sur_name].join(' ')
  end

end
