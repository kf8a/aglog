class Company < ActiveRecord::Base
  has_many :people
  has_many :equipment
  has_many :materials
  has_many :observations
  has_many :areas
end
