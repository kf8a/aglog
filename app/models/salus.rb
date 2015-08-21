class Salus
  attr_accessor :area

  def uuid
    "experiment 1"
  end

  def years
    observations = area.observations
    first = observations.order(:obs_date).first.obs_date.year.to_i
    last = observations.order(:obs_date).last.obs_date.year.to_i
    last...first
  end

  def crop_for(year)
    #TODO this is not true in general
    # records.first.activities.first.setups.first.materials.first.name
    "corn"
  end

  def rotation_components
    rot = []
    result = [rot]
    current_type = nil
    observations = records.sort {|x,y| x.obs_date <=> y.obs_date}
    observations.each do |obs|
      case obs.type
      when 'planting'
        rot = new_rotation(current_type, result,rot)
        rot.push planting_component(obs)
      when 'tillage'
        rot = new_rotation(current_type, result, rot)
        rot.push tillage_component(obs)
      when 'fertilizer'
        rot = new_rotation(current_type, result, rot)
        rot.push fertilizer_component(obs)
      when 'harvest'
        rot.push harvest_component(obs)
      end
      current_type = obs.type
    end
    # p result
    result
  end

  def new_rotation(current_type, result, rot)
    if current_type == 'harvest'
      rot.flatten!
      rot = []
      result.push rot
    end
    rot
  end

  #TODO are there actually more than one?
  def planting_component(obs)
    obs.activities.flat_map do |activity|
      activity.setups.flat_map do |setup|
        setup.material_transactions.flat_map do |transaction|
          next unless transaction.material.material_type_name == 'seed'
          seeds_per_square_meter = transaction.seeds_per_square_meter
          warnings = ""
          if !seeds_per_square_meter
            warnings = "ESTIMATED SEEDING RATE"
            seed_per_square_meter = estimated_seeds_per_square_meter(transaction, warnings)
          end
          {type: 'planting', species: transaction.material.salus_code, year: obs.obs_date.year, doy: obs.obs_date.yday,
            depth: 2, row_spacing: row_spacing(transaction.material.salus_code), warnings: warnings,
          ppop: seeds_per_square_meter, url: url_for(obs), notes: obs.comment, raw: [transaction, setup]}
        end.compact
      end
    end.first
  end

  def row_spacing(code)
  case code
  when "MZ" then 30
  when "SB" then 20
  when "WH" then 19
  end
  end

  def tillage_component(obs)
    obs.activities.flat_map do |activity|
      activity.setups.flat_map do |setup|
        # next unless setup.equipment.equipment_type.try(:name) == 'tillage'
        salus_code = setup.equipment.salus_code || 'TI000'
        {type: 'tillage', year: obs.obs_date.year, doy: obs.obs_date.yday, 
          equipment: salus_code, depth: 6,
          url: url_for(obs), notes: obs.comment}
      end.compact
    end.first
  end

  def fertilizer_component(obs)
    obs.activities.flat_map do |activity|
      activity.setups.flat_map do |setup|
        setup.material_transactions.flat_map do |transaction|
          next unless transaction.material.material_type_name == 'fertilizer'
          code = transaction.material.salus_code || "NOCOD"
          {type: 'fertilizer', year: obs.obs_date.year, doy: obs.obs_date.yday, n_rate: transaction.n_content_to_kg_ha, 
            p_rate: transaction.p_content_to_kg_ha, k_rate: transaction.k_content_to_kg_ha, fertilizer: code,
            url: url_for(obs), notes: obs.comment}
        end.compact
      end
    end.first
  end

  def harvest_component(obs)
    {type: 'harvest', year: obs.obs_date.year, doy: obs.obs_date.yday, url:url_for(obs), notes: obs.comment}
  end

  def records
    tillage_records + harvest_records + planting_records + fertilizer_records
  end

  def fertilizer_records
    area.observations.select("'fertilizer' as type, observations.id, obs_date, observations.comment").joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "fertilizer")
      .where("observation_types.name = ?","Fertilizer application").distinct
  end

  def planting_records
    area.observations.select("'planting' as type, observations.id, obs_date, observations.comment").joins(:observation_types, setups: [:material_transactions, {materials: :material_type} ])
      .where("material_types.name = ?", "seed")
      .where("observation_types.name = ?","Planting").distinct
  end

  def harvest_records
    area.observations.select("'harvest' as type, observations.id, obs_date, observations.comment").joins(:observation_types)
      .where("observation_types.name = ?", 'Harvest').distinct
  end

  def tillage_records
    area.observations.select("'tillage' as type, observations.id, obs_date, observations.comment").joins(:observation_types)
      .where("observation_types.name = ?", "Soil Preparation").distinct
  end

  def url_for(object)
    "https://aglog.kbs.msu.edu/observations/#{object.id}"
  end

  def estimated_seeds_per_square_meter(transaction, warnings)
    if transaction.material.salus_code == 'WH'
      seeds_per_square_meter = 445
      warnings +=  "\n DEFAULT SEEDING RATE of 445 seeds per meter square used"
    elsif transaction.material.salus_code = 'RY'
      if "pounds" == transaction.unit.try(:name)
        seeds_per_square_meter = 19900 * transaction.rate.to_f  * 2.47 / 1000
        warnings += "\n ASSUMEING 19900 seeds per pound"
      elsif "bushels" == transaction.unit.try(:name)
        seeds_per_square_meter = transaction.rate.to_f * 56 * 19900 * 2.47 / 1000
        warnings += "\n ASSUMEING 19900 seeds per pound and 56 lb/bu"
      else 
        #TODO look up the actual default rate
        seeds_per_square_meter = 445
        warnings +=  "\n DEFAULT SEEDING RATE of 445 seeds per meter square used"
      end
    end
    seeds_per_square_meter
  end
end
