class MaterialTransaction < ActiveRecord::Base
  belongs_to :material
  belongs_to :setup
  belongs_to :unit
  

  validates_presence_of :material_id
  validates_associated :material
  
  # find fertilizers  on the main site
  def MaterialTransaction.find_fertilizations(order='obs_date desc')
    study = Study.find_by_name("MAIN")
    material_type = MaterialType.find_by_name("K fertilizer")
    areas = Area.find_all_by_study_id(study)
    MaterialTransaction.find(:all,
        :conditions => ['materials.material_type_id = ? and area_id in (?)', material_type, areas],
        :order => order,
        :joins => 'join materials on materials.id  = material_transactions.material_id join setups on setups.id = material_transactions.setup_id join activities on setups.activity_id = activities.id  join observations on activities.observation_id = observations.id join areas_observations on areas_observations.observation_id = observations.id join areas on areas_observations.area_id = areas.id join observation_types_observations on observation_types_observations.observation_id  =  observations.id')
  end
  
end
