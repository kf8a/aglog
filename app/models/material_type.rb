# Divides materials into differnet subgroups.
class MaterialType < ActiveRecord::Base
  has_many :materials, -> { order 'name' }
end
