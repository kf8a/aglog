class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

#  belongs_to :company
  has_one :person

  # redirect the company to the person so we don't
  # have two places where we keep this info
  def company
    person.company
  end
  
  def company=(company)
    self.person.company = company
  end
end
