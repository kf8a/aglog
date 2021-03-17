# frozen_string_literal: true

# An account in the system
# :timeoutable and :omniauthable
#  :token_authenticatable, :encryptable, :confirmable, :lockable,
#  Include default devise modules. Others available are:
#  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # belongs_to :company
  has_one :person, dependent: :nullify

  delegate :companies, to: :person

  delegate :companies=, to: :person

  delegate :projects, to: :person

  delegate :projects=, to: :person

  delegate :default_company, to: :person
end
