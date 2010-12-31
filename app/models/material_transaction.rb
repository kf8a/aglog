class MaterialTransaction < ActiveRecord::Base
  attr_accessible :material_id, :unit_id, :setup_id, :rate, :cents,
                  :material_transaction_type_id, :transaction_datetime

  belongs_to :material
  belongs_to :setup
  belongs_to :unit
  

  validates :material_id, :presence => true
  validates_associated :material
  
  # find fertilizers  on the main site
  def MaterialTransaction.find_fertilizations(order='obs_date desc')
    study = Study.find_by_name("MAIN")
    material_type = MaterialType.find_by_name("K fertilizer")
    areas = Area.find_all_by_study_id(study)
    transactions = MaterialTransaction.where(['materials.material_type_id = ? and area_id in (?)', material_type, areas]).order(order).joins('join materials on materials.id  = material_transactions.material_id join setups on setups.id = material_transactions.setup_id join activities on setups.activity_id = activities.id  join observations on activities.observation_id = observations.id join areas_observations on areas_observations.observation_id = observations.id join areas on areas_observations.area_id = areas.id join observation_types_observations on observation_types_observations.observation_id  =  observations.id')
    transactions.uniq
  end

  def n_content_to_kg_ha
    to_kg_ha(self.n_content) if self.n_content
  end

  def p_content_to_kg_ha
    to_kg_ha(self.material.p_content) if self.material.p_content
  end

  def k_content_to_kg_ha
    to_kg_ha(self.material.k_content) if self.material.k_content
  end

  # @example Wheat: 250 pounds per acre
  def material_with_rate
    self.material.try(:name) + (if self.unit then rate_and_unit else "" end)
  end

  def material_name
    self.material.try(:name)
  end

  def n_content
    self.material.try(:n_content)
  end

  def unit_name
    self.unit.try(:name)
  end

  private##############################

  def to_kg_ha(content)
    if self.rate && self.unit.conversion_factor
      rate = self.rate * self.unit.conversion_factor
      rate = self.material.to_mass(rate)  #liters to grams
      rate = rate/1000.0                  #grams to kilograms
      rate = rate / 0.404                 #acres to hectares
      rate = rate * content / 100.0
      rate = (rate * 100).round / 100.0
    end
  end

  def rate_and_unit
    unit_name = self.unit.name
    unit_name = unit_name.pluralize unless self.rate == 1
    
    ": #{self.rate} #{unit_name} per acre"
  end

end
