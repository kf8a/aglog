# A class for working with materials and units together.
class MaterialTransaction < ActiveRecord::Base
  belongs_to :material
  belongs_to :setup
  belongs_to :unit

  validates :material_id, presence: true
  validates_associated :material

  # find fertilizers  on the main site
  def self.find_fertilizations(order = 'obs_date desc')
    study = Study.find_by(name: 'MAIN')
    material_type = MaterialType.find_by(name: 'K fertilizer')
    areas = Area.where(study_id: study).to_a
    transactions =
      MaterialTransaction.where(['materials.material_type_id = ? and area_id in (?)', material_type, areas]).order(
        order
      ).joins(
        'join materials on materials.id  = material_transactions.material_id join setups on setups.id = material_transactions.setup_id join activities on setups.activity_id = activities.id  join observations on activities.observation_id = observations.id join areas_observations on areas_observations.observation_id = observations.id join areas on areas_observations.area_id = areas.id join observation_types_observations on observation_types_observations.observation_id  =  observations.id'
      ) # transactions.uniq
  end

  def convertible?(content)
    content && rate && unit.conversion_factor
  end

  def n_content_to_kg_ha
    to_kg_ha(n_content)
  end

  def p_content_to_kg_ha
    to_kg_ha(material.p_content)
  end

  def k_content_to_kg_ha
    to_kg_ha(material.k_content)
  end

  def material_name
    material.try(:name)
  end

  # @example Wheat: 250 pounds per acre
  def material_with_rate
    material_name + (unit ? rate_and_unit : '')
  end

  def n_content
    material.try(:n_content)
  end

  def unit_name
    unit.try(:name)
  end

  def seeds_per_square_meter
    if ('seeds' == unit.try(:name) || 'plants' == unit.try(:name)) || 'trees' == unit.try(:name)
      (rate.to_i * 2.47 / 10_000).round(2)
    end
  end

  private

  def to_kg_ha(content)
    return unless convertible?(content)
    kg_ha = conversion_rate * (content / 100.0) # convert from percent
    kg_ha.round(2)
  end

  def conversion_rate
    rate = self.rate * unit.conversion_factor
    rate = material.to_mass(rate) # liters to grams
    rate /= 1000.0 # grams to kilograms
    rate *= 2.47 # acres to hectares
    rate
  end

  def rate_and_unit
    display_rate = rate.to_s
    unit_display = unit_name
    unit_display = unit_display.pluralize unless display_rate == '1.0'

    ": #{display_rate} #{unit_display} per acre"
  end
end
