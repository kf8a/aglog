# A class for working with materials and units together.
class MaterialTransaction < ActiveRecord::Base
  belongs_to :material
  belongs_to :setup
  belongs_to :unit


  validates :material_id, :presence => true
  validates_associated :material

  # find fertilizers  on the main site
  def MaterialTransaction.find_fertilizations(order='obs_date desc')
    study = Study.find_by_name("MAIN")
    material_type = MaterialType.find_by_name("K fertilizer")
    areas = Area.where(:study_id => study).to_a
    transactions = MaterialTransaction.where(['materials.material_type_id = ? and area_id in (?)', material_type, areas]).order(order).joins('join materials on materials.id  = material_transactions.material_id join setups on setups.id = material_transactions.setup_id join activities on setups.activity_id = activities.id  join observations on activities.observation_id = observations.id join areas_observations on areas_observations.observation_id = observations.id join areas on areas_observations.area_id = areas.id join observation_types_observations on observation_types_observations.observation_id  =  observations.id')
#    transactions.uniq
  end

  def convertible?(content)
    content && self.rate && self.unit.conversion_factor
  end

  def n_content_to_kg_ha
    to_kg_ha(self.n_content)
  end

  def p_content_to_kg_ha
    to_kg_ha(self.material.p_content)
  end

  def k_content_to_kg_ha
    to_kg_ha(self.material.k_content)
  end

  def material_name
    self.material.try(:name)
  end

  # @example Wheat: 250 pounds per acre
  def material_with_rate
    material_name + (self.unit ? rate_and_unit : "" )
  end

  def n_content
    self.material.try(:n_content)
  end

  def unit_name
    self.unit.try(:name)
  end

  def seeds_per_square_meter
    #TODO actually do the conversion
    self.rate.to_i
  end

  private##############################

  def to_kg_ha(content)
    return unless convertible?(content)
    kg_ha = conversion_rate * (content / 100.0) # convert from percent 
    kg_ha.round(2)
  end

  def conversion_rate
    rate = self.rate * self.unit.conversion_factor
    rate = self.material.to_mass(rate)  #liters to grams
    rate = rate/1000.0                  #grams to kilograms
    rate = rate * 0.404                 #acres to hectares
  end

  def rate_and_unit
    display_rate = self.rate.to_s
    unit_display = self.unit_name
    unit_display = unit_display.pluralize unless display_rate == '1.0'

    ": #{display_rate} #{unit_display} per acre"
  end

end
