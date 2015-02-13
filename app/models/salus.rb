class Salus
  attr_accessor :area

  def planting_records
    area.observations.joins(:observation_types, setups: [:materials])
      .where("material_type_id = ?", MaterialType.where(name: 'seed').first)
      .where("observation_type_id = ?", ObservationType.where(name: 'Planting').first)
  end

  def harvest_records
    area.observations.joins(:observation_types)
      .where("observation_type_id = ?", ObservationType.where(name: 'Harvest').first)
  end

  def tillage_records
    area.observations.joins(:observation_types)
      .where("observation_type_id = ?", ObservationType.where(name: 'Soil Preparation').first)
  end
end
