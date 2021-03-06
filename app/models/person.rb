# frozen_string_literal: true

# A person is both someone who performs activities, and (with an open id) a
# user of the web application.
class Person < ActiveRecord::Base
  has_many :observations, inverse_of: :person
  has_many :activities
  has_many :memberships
  has_many :companies, through: :memberships
  belongs_to :user, optional: true

  has_many :collaborations
  has_many :projects, through: :collaborations

  validates :given_name, presence: { unless: :sur_name }
  validates :sur_name, presence: { unless: :given_name }

  validate :name_must_be_unique # validates :memberships, presence: true

  scope :by_company, ->(company) { joins(:memberships).where(memberships: { company_id: company }) }

  def self.current
    where(archived: false)
  end

  def self.ordered
    order('sur_name, given_name')
  end

  def self.find_in_company(company, id)
    by_company(company).find(id)
  end

  # Default is always KBS now
  def default_company
    Company.find(1)
  end

  def name_must_be_unique
    person =
      Person.where(['lower(given_name) = ?', given_name.try(:downcase)]).where(
        ['lower(sur_name) = ?', sur_name.try(:downcase)]
      ).to_a - [self]
    errors.add(:base, 'Name must be unique') if person.present?
  end

  def name
    [given_name, sur_name].join(' ')
  end
end
