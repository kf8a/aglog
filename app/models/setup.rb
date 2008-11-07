class Setup < ActiveRecord::Base
  belongs_to :activity
  belongs_to :equipment
  has_many :material_transactions, :dependent => :destroy
  has_many :materials, :through => :material_transactions
  
  validates_associated :equipment
  validates_presence_of :equipment
  
  validates_associated :material_transactions
  
  #   
  # def validate
  #    unless (equipment_id.nil? || Equipment.find(:first, 
  #      :conditions => ["id = ?", equipment_id]))
  #      errors.add(:equipment, 'is invalid') 
  #    end
  #  end
  #  
  #  def equipment_id
  #    equipment ? equipment.id : nil
  #  end
 
end
