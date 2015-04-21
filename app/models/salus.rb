class Salus
  attr_accessor :area

  def rotation_components_for(year)
    planting_components_for(year) + fertilizer_components_for(year) + tillage_components_for(year) + harvest_components_for(year)
  end

  #TODO where should we keep row spacing seed weight and planting depth
  def planting_components_for(year)
    results = planting_records_for(year)
    results.flat_map do |result|
      result.activities.flat_map do |activity|
        activity.setups.flat_map do |setup|
          setup.material_transactions.flat_map do |transaction|
            "<Mgt_Planting CropMod='S' SpeciesID='#{transaction.material.name}' CultivarID='IB1003' Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' EYear='0' EDOY='' Ppop='#{transaction.seeds_per_square_meter}' Ppoe='#{transaction.seeds_per_square_meter}' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' notes='#{result.comment}' />"
          end
        end
      end
    end.join("\n")
  end

  def fertilizer_components_for(year)
    results = fertilizer_records_for(year)
    results.flat_map do |result|
      result.activities.flat_map do |activity|
        activity.setups.flat_map do |setup|
          setup.material_transactions.flat_map do |transaction|
            #TODO add n p k ca content
            "<Mgt_Fertilizer_App Year ='#{result.obs_date.year} DOY='#{result.obs_date.yday}' AKFer='' ANFer='#{}' APFer=''/>"
          end
        end
      end
    end.join("\n")
  end

  def tillage_components_for(year)
    results = tillage_records_for(year)
    results.flat_map do |result|
      result.activities.flat_map do |activity|
        activity.setups.flat_map do |setup|
          next if setup.equipment.is_tractor?
          "<Mgt_Tillage_App Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' TDep='6' TImpl='#{setup.equipment.name}'/>"
        end
      end
    end.join("\n")
  end

  def harvest_components_for(year)
    results = harvest_records_for(year)
    results.collect do |result|
      "<Mgt_Harvest_App Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' />"
    end.join("\n")
  end

  def fertilizer_records_for(year)
    area.observations.joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "fertilizer")
      .where("observation_types.name = ?","Fertilizer application")
      .where("date_part('year', obs_date) =?", year)
  end

  def planting_records_for(year)
    area.observations.joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "seed")
      .where("observation_types.name = ?","Planting")
      .where("date_part('year', obs_date) =?", year)
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
