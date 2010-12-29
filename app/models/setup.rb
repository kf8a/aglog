class Setup < ActiveRecord::Base
  attr_accessible :activity_id, :equipment_id, :settings
  
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

  def material_names
    material_transactions.collect { |transaction| transaction.material_name }
  end

  def n_contents
    material_transactions.collect { |transaction| transaction.n_content }
  end

  def rates
    material_transactions.collect { |transaction| transaction.rate }
  end

  def unit_names
    material_transactions.collect { |transaction| transaction.unit_name}
  end
end
