class Salus
  attr_accessor :area

  def for_year(year)
    where("date_part('year', obs_date) =?", year)
  end

  def rotation_components_for(year)
    planting_component_for(year)
    fertilizer_component_for(year)
    harvest_component_for(year)
  end

  def planting_component_for(year)
  end

  def fertilizer_component_for(year)
  end

  def tillage_components_for(year)
    results = tillage_records_for(year)
    results.collect do |result|
      next if result.setup.equipment.isTraktor?
      "<Mgt_Tillage_App Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' TDep='6' TImpl='#{result.setup.equipment}'/>"
    end.join("\n")
  end

  def harvest_component_for(year)
    results = harvest_records_for(year)
    results.collect do |result|
      "<Mgt_Harvest_App Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' />"
    end.join("\n")
  end

  def planting_records
    area.observations.joins(:observation_types, setups: [:materials])
      .where("material_type_id = ?", MaterialType.where(name: 'seed').first)
      .where("observation_type_id = ?", ObservationType.where(name: 'Planting').first)
  end

  def harvest_records_for(year)
    area.observations.joins(:observation_types)
      .where("date_part('year', obs_date) =?", year)
      .where("observation_types.name = ?", 'Harvest')
  end

  def tillage_records_for(year)
    area.observations.joins(:observation_types)
      .where("date_part('year', obs_date) =?", year)
      .where("observation_types.name = ?", "Soil Preparation")
  end
end
