# A person is both someone who performs activities, and (with an open id) a
# user of the web application.
class Person < ActiveRecord::Base
  attr_accessible :given_name, :sur_name, :openid_identifier, :company_id

  has_many :observations
  has_many :activities
  belongs_to :company

  has_and_belongs_to_many :hazards

  validates :given_name, :presence   => { :unless => :sur_name }
  validates :sur_name, :presence   => { :unless => :given_name }

  validate :name_must_be_unique
  validates_presence_of :company

  scope :by_company, lambda {|company| where(:company_id => company).order('sur_name, given_name')}

  def name_must_be_unique
    person = Person.where([ "lower(given_name) = ?", given_name.try(:downcase) ]).where([ "lower(sur_name) = ?", sur_name.try(:downcase) ]).all - [self]
    errors.add(:base, "Name must be unique") if person.present?

  end

  def name
    [given_name, sur_name].join(' ')
  end

end
