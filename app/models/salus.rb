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
          # next unless transaction.material.material_type_name == 'seed'
          {type: 'planting', species: transaction.material.salus_code, year: obs.obs_date.year, doy: obs.obs_date.yday,
          ppop: transaction.seeds_per_square_meter, url: url_for(obs), notes: obs.comment, raw: [transaction, setup]}
        end.compact
      end
    end.first
  end

  def tillage_component(obs)
    {type: 'tillage', year: obs.obs_date.year, doy: obs.obs_date.yday, url: url_for(obs), notes: obs.comment}
  end

  def fertilizer_component(obs)
    {type: 'fertilizer', year: obs.obs_date.year, doy: obs.obs_date.yday, url: url_for(obs), notes: obs.comment}
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
end
