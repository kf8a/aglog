# Divides materials into differnet subgroups.
class MaterialType < ActiveRecord::Base
  attr_accessible :name

  has_many :materials, :order => 'name'
end
