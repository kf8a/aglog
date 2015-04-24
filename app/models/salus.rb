class Salus
  attr_accessor :area

  def years
    observations = area.observations
    first = observations.order(:obs_date).first.obs_date.year.to_i
    last = observations.order(:obs_date).last.obs_date.year.to_i
    last...first
  end

  def crop_for(year)
    records = planting_records_for(year)
    #TODO this is not true in general
    # records.first.activities.first.setups.first.materials.first.name
    "corn"
  end

  def rotation_components
    rot = []
    result = [rot]
    current_type = nil
    area_records = records.sort {|x,y| x.obs_date <=> y.obs_date}
    area_records.each do |obs|
      p obs.observation_type
      p result
      case obs.observation_type
      when 'Planting'
        if current_type == 'Harvest'
          rot = []
          result.push(rot)
        end
        current_type = obs.observation_type
        rot.push('planting')
      when 'Soil Preparation'
        if current_type == 'Harvest'
          rot = []
          result.push(rot)
        end
        current_type = obs.observation_type
        rot.push('tillage')
      when 'Fertilizer application'
        if current_type == 'Harvest'
          rot = []
          result.push(rot)
        end
        current_type = obs.observation_type
        rot.push('fertilizer')
      when 'Harvest'
        current_type = obs.observation_type
        rot.push('harvest')
      end
    end
    result
  end

  def need_new_rotation(current_type)
    if current_type == 'harvest'
      new_rotation_component
    end
  end

  def records
    tillage_records + harvest_records + planting_records + fertilizer_records
  end

  def rotation_components_for(year)
    [planting_components_for(year), 
      fertilizer_components_for(year),
      tillage_components_for(year), 
      harvest_components_for(year)].compact.join("\n")
  end

  def planting_component(obs, activity, setup, transaction)
            "<Mgt_Planting CropMod='S' SpeciesID='#{transaction.material.salus_code}' CultivarID='IB1003' Year='#{obs.obs_date.year}' DOY='#{obs.obs_date.yday}' EYear='0' EDOY='' Ppop='#{transaction.seeds_per_square_meter}' Ppoe='#{transaction.seeds_per_square_meter}' PlMe='S' PlDs='R' RowSpc='10' AziR='' SDepth='4' SdWtPl='20' SdAge='' ATemp='' PlPH='' src='#{url_for(obs)}' notes='#{obs.comment}' />"
  end

  #TODO where should we keep row spacing seed weight and planting depth
  def planting_components_for(year)
    results = planting_records_for(year)
    results.flat_map do |result|
      result.activities.flat_map do |activity|
        activity.setups.flat_map do |setup|
          setup.material_transactions.flat_map do |transaction|
            planting_component(result, activity, setup, transaction)
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
            "<Mgt_Fertilizer_App Year ='#{result.obs_date.year} DOY='#{result.obs_date.yday}' AKFer='' ANFer='#{}' APFer='' src='#{url_for(result)}' notes='#{result.comment}'/>"
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
          "<Mgt_Tillage_App Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' TDep='6' TImpl='#{setup.equipment.salus_code}' src='#{url_for(result)}' notes='#{result.comment}'/>"
        end
      end
    end.join("\n")
  end

  def harvest_components_for(year)
    results = harvest_records_for(year)
    results.flat_map do |result|
    "<Mgt_Harvest_App Year='#{result.obs_date.year}' DOY='#{result.obs_date.yday}' HCom='H' HSiz='A' HPc='100' HBmin='0' HBPc='0' HKnDnPc='0' src='#{url_for(result)}' notes='#{result.comment}'/>"
    end.join("\n")
  end

  def fertilizer_records
    area.observations.joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "fertilizer")
      .where("observation_types.name = ?","Fertilizer application")
  end

  def fertilizer_records_for(year)
    area.observations.joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "fertilizer")
      .where("observation_types.name = ?","Fertilizer application")
      .where("date_part('year', obs_date) =?", year)
  end

  def planting_records
    area.observations.joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "seed")
      .where("observation_types.name = ?","Planting")
  end

  def planting_records_for(year)
    area.observations.joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "seed")
      .where("observation_types.name = ?","Planting")
      .where("date_part('year', obs_date) =?", year)
  end

  def harvest_records
    area.observations.joins(:observation_types)
      .where("observation_types.name = ?", 'Harvest')
  end

  def harvest_records_for(year)
    area.observations.joins(:observation_types)
      .where("date_part('year', obs_date) =?", year)
      .where("observation_types.name = ?", 'Harvest')
  end

  def tillage_records
    area.observations.joins(:observation_types)
      .where("observation_types.name = ?", "Soil Preparation")
  end

  def tillage_records_for(year)
    area.observations.joins(:observation_types)
      .where("date_part('year', obs_date) =?", year)
      .where("observation_types.name = ?", "Soil Preparation")
  end


  def url_for(object)
    "https://aglog.kbs.msu.edu/observations/#{object.id}"
  end
end
