# A person is both someone who performs activities, and (with an open id) a
# user of the web application.
class Person < ActiveRecord::Base

  has_many :observations, inverse_of: :person
  has_many :activities
  belongs_to :company
  belongs_to :user

#  has_and_belongs_to_many :hazards

  validates :given_name, :presence   => { :unless => :sur_name }
  validates :sur_name, :presence   => { :unless => :given_name }

  validate :name_must_be_unique
  validates_presence_of :company

  scope :by_company, lambda {|company| where(:company_id => company)}

  def self.current
    where(:archived => false)
  end

  def self.ordered
    order('sur_name, given_name')
  end

  def self.ordered_in_company(company)
    by_company(company).ordered
  end

  def self.find_in_company(company, id)
    by_company(company).find(id)
  end

  def to_label
    name
  end

  def name_must_be_unique
    person = Person.where([ "lower(given_name) = ?", given_name.try(:downcase) ]).where([ "lower(sur_name) = ?", sur_name.try(:downcase) ]).to_a - [self]
    errors.add(:base, "Name must be unique") if person.present?
  end

  def name
    [given_name, sur_name].join(' ')
  end
end
