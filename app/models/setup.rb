class Setup < ActiveRecord::Base
  belongs_to :activity
  belongs_to :equipment
  has_many :material_transactions, :dependent => :destroy
  has_many :materials, :through => :material_transactions
  
  validates_associated :equipment
  validates :equipment, :presence => true
  
  validates_associated :material_transactions
  
  def observation
    self.activity.try(:observation)
  end
end
