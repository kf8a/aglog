class MaterialType < ActiveRecord::Base
  has_many :materials, :order => 'name'
end
